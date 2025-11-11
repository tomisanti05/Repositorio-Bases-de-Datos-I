-- Base de Datos I - Trabajo Practico N°4

-- 1) Crear la base de datos y sus tablas
DROP DATABASE IF EXISTS banco;
CREATE DATABASE banco;
USE banco;

-- Tabla CLIENTES
CREATE TABLE clientes (
  numero_cliente INT PRIMARY KEY,
  dni INT NOT NULL,
  apellido VARCHAR(60) NOT NULL,
  nombre VARCHAR(60) NOT NULL
);

-- Tabla CUENTAS
CREATE TABLE cuentas (
  numero_cuenta INT PRIMARY KEY,
  numero_cliente INT NOT NULL,
  saldo DECIMAL(10,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (numero_cliente) REFERENCES clientes(numero_cliente)
);

-- Tabla MOVIMIENTOS
CREATE TABLE movimientos (
  numero_movimiento INT PRIMARY KEY AUTO_INCREMENT,
  numero_cuenta INT NOT NULL,
  fecha DATE NOT NULL,
  tipo ENUM('CREDITO', 'DEBITO') NOT NULL,
  importe DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta)
);

-- Tabla HISTORIAL_MOVIMIENTOS
CREATE TABLE historial_movimientos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  numero_cuenta INT NOT NULL,
  numero_movimiento INT NOT NULL,
  saldo_anterior DECIMAL(10,2),
  saldo_actual DECIMAL(10,2),
  FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta),
  FOREIGN KEY (numero_movimiento) REFERENCES movimientos(numero_movimiento)
);

-- 2) Cargar los datos
-- Ejecutar el archivo inserts.sql

-- 3) Procedimiento VerCuentas
DELIMITER //
CREATE PROCEDURE VerCuentas()
BEGIN
  SELECT numero_cuenta, saldo
  FROM cuentas;
END //
DELIMITER ;

-- 4) Procedimiento CuentasConSaldoMayorQue
DELIMITER //
CREATE PROCEDURE CuentasConSaldoMayorQue(IN limite DECIMAL(10,2))
BEGIN
  SELECT numero_cuenta, saldo
  FROM cuentas
  WHERE saldo > limite;
END //
DELIMITER ;

-- 5) Procedimiento TotalMovimientosDelMes (sin cursor)
DELIMITER //
CREATE PROCEDURE TotalMovimientosDelMes(IN cuenta INT, OUT total DECIMAL(10,2))
BEGIN
  SELECT 
    IFNULL(SUM(
      CASE tipo
        WHEN 'CREDITO' THEN importe
        WHEN 'DEBITO' THEN -importe
      END), 0)
  INTO total
  FROM movimientos
  WHERE numero_cuenta = cuenta
  AND MONTH(fecha) = MONTH(CURDATE())
  AND YEAR(fecha) = YEAR(CURDATE());
END //
DELIMITER ;

-- 6) Procedimiento Depositar
DELIMITER //
CREATE PROCEDURE Depositar(IN cuenta INT, IN monto DECIMAL(10,2))
BEGIN
  INSERT INTO movimientos(numero_cuenta, fecha, tipo, importe)
  VALUES (cuenta, CURDATE(), 'CREDITO', monto);
END //
DELIMITER ;

-- 7) Procedimiento Extraer
DELIMITER //
CREATE PROCEDURE Extraer(IN cuenta INT, IN monto DECIMAL(10,2))
BEGIN
  DECLARE saldo_actual DECIMAL(10,2);

  SELECT saldo INTO saldo_actual FROM cuentas WHERE numero_cuenta = cuenta;

  IF saldo_actual >= monto THEN
    INSERT INTO movimientos(numero_cuenta, fecha, tipo, importe)
    VALUES (cuenta, CURDATE(), 'DEBITO', monto);
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Fondos insuficientes para realizar la extraccion.';
  END IF;
END //
DELIMITER ;

-- 8) Trigger que actualiza saldo luego de un movimiento
DELIMITER //
CREATE TRIGGER actualizar_saldo
AFTER INSERT ON movimientos
FOR EACH ROW
BEGIN
  DECLARE saldo_anterior DECIMAL(10,2);
  DECLARE saldo_nuevo DECIMAL(10,2);

  SELECT saldo INTO saldo_anterior FROM cuentas WHERE numero_cuenta = NEW.numero_cuenta;

  IF NEW.tipo = 'CREDITO' THEN
    UPDATE cuentas SET saldo = saldo + NEW.importe WHERE numero_cuenta = NEW.numero_cuenta;
  ELSEIF NEW.tipo = 'DEBITO' THEN
    UPDATE cuentas SET saldo = saldo - NEW.importe WHERE numero_cuenta = NEW.numero_cuenta;
  END IF;
END //
DELIMITER ;

-- 9) Trigger modificado para registrar tambien en historial
DELIMITER //
DROP TRIGGER IF EXISTS actualizar_saldo;
CREATE TRIGGER actualizar_saldo
AFTER INSERT ON movimientos
FOR EACH ROW
BEGIN
  DECLARE saldo_anterior DECIMAL(10,2);
  DECLARE saldo_nuevo DECIMAL(10,2);

  SELECT saldo INTO saldo_anterior FROM cuentas WHERE numero_cuenta = NEW.numero_cuenta;

  IF NEW.tipo = 'CREDITO' THEN
    SET saldo_nuevo = saldo_anterior + NEW.importe;
  ELSEIF NEW.tipo = 'DEBITO' THEN
    SET saldo_nuevo = saldo_anterior - NEW.importe;
  END IF;

  UPDATE cuentas SET saldo = saldo_nuevo WHERE numero_cuenta = NEW.numero_cuenta;

  INSERT INTO historial_movimientos(numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual)
  VALUES (NEW.numero_cuenta, NEW.numero_movimiento, saldo_anterior, saldo_nuevo);
END //
DELIMITER ;

-- 10) Procedimiento TotalMovimientosDelMes (con cursor)
DELIMITER //
CREATE PROCEDURE TotalMovimientosDelMes_cursor(IN cuenta INT, OUT total DECIMAL(10,2))
BEGIN
  DECLARE fin INT DEFAULT 0;
  DECLARE tipo_movimiento ENUM('CREDITO', 'DEBITO');
  DECLARE importe_movimiento DECIMAL(10,2);

  DECLARE cursor_movimientos CURSOR FOR
    SELECT tipo, importe FROM movimientos
    WHERE numero_cuenta = cuenta
    AND MONTH(fecha) = MONTH(CURDATE())
    AND YEAR(fecha) = YEAR(CURDATE());

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

  SET total = 0;
  OPEN cursor_movimientos;

  repetir: LOOP
    FETCH cursor_movimientos INTO tipo_movimiento, importe_movimiento;
    IF fin = 1 THEN
      LEAVE repetir;
    END IF;
    IF tipo_movimiento = 'CREDITO' THEN
      SET total = total + importe_movimiento;
    ELSE
      SET total = total - importe_movimiento;
    END IF;
  END LOOP;

  CLOSE cursor_movimientos;
END //
DELIMITER ;

-- 11) Procedimiento AplicarInteres
DELIMITER //
CREATE PROCEDURE AplicarInteres(IN porcentaje DECIMAL(5,2), IN minimo DECIMAL(10,2))
BEGIN
  UPDATE cuentas
  SET saldo = saldo + (saldo * porcentaje / 100)
  WHERE saldo > minimo;
END //
DELIMITER ;