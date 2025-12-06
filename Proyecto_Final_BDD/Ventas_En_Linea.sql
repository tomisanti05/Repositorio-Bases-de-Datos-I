
CREATE TABLE cliente(
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(40) NOT NULL,
apellido VARCHAR(40) NOT NULL,
email VARCHAR(30) NOT NULL,
direccion VARCHAR (30) NOT NULL	
);

CREATE TABLE producto(
cod_producto INT PRIMARY KEY,
nombre VARCHAR(40) NOT NULL,
categoria VARCHAR(30) NOT NULL,
stock INT NOT NULL
);

CREATE TABLE orden(
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    cod_producto INT NOT NULL,
    id_cliente INT NOT NULL,
    cant_unidades INT NOT NULL,
    fecha DATE,
    FOREIGN KEY (cod_producto)
        REFERENCES producto(cod_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- Inserts

INSERT INTO cliente (nombre, apellido, email, direccion) VALUES
('Ana', 'García', 'ana.g@mail.com', 'Av. Libertad 123'),
('Juan', 'Martínez', 'juan.m@mail.com', 'Calle 5 #456'),
('Sofía', 'López', 'sofia.l@mail.com', 'Paseo de la Reforma'),
('Pedro', 'Rodríguez', 'pedro.r@mail.com', 'Boulevard Tecnológico'),
('Laura', 'Pérez', 'laura.p@mail.com', 'Ruta 9 KM 5'),
('Carlos', 'Sánchez', 'carlos.s@mail.com', 'Av. Central 202'),
('Marta', 'Gómez', 'marta.g@mail.com', 'Carrera 7 #303'),
('Javier', 'Díaz', 'javier.d@mail.com', 'Callejón del Sol'),
('Elena', 'Vázquez', 'elena.v@mail.com', 'Diagonal Norte'),
('Ricardo', 'Ruiz', 'ricardo.r@mail.com', 'Avenida de los Lagos');

-- INSERT PRODUCTOS
INSERT INTO producto (cod_producto, nombre, categoria, stock) VALUES
(1, 'Laptop Pro X', 'Electrónica', 30),
(2, 'Mouse Inalámbrico', 'Electrónica', 150),
(3, 'Teclado Mecánico', 'Electrónica', 50),
(4, 'Taza Programador', 'Hogar', 200),
(5, 'Agenda 2024', 'Oficina', 80),
(6, 'Libro SQL', 'Libros', 120),
(7, 'Silla Ergonómica', 'Oficina', 15),
(8, 'Monitor Curvo', 'Electrónica', 20),
(9, 'Audífonos', 'Electrónica', 75),
(10, 'Mochila', 'Accesorios', 90);

INSERT INTO orden (id_cliente, cod_producto, cant_unidades, fecha) VALUES 
(1, 1, 2, '2024-03-01'),
(1, 2, 1, '2024-03-02'),
(2, 3, 5, '2024-03-03'),
(3, 4, 1, '2024-03-04'),
(4, 5, 2, '2024-03-05'),
(5, 1, 3, '2024-03-06'),
(2, 2, 1, '2024-03-07'),
(6, 6, 4, '2024-03-08'),
(7, 3, 2, '2024-03-09'),
(8, 8, 1, '2024-03-10');


-- Procedimiento almacenado para mostrar las ordenes de un cliente dado

DELIMITER $$

CREATE PROCEDURE ver_ordenes_por_cliente(IN p_id_cliente INT)
BEGIN
    SELECT o.id_orden,
           p.nombre AS producto,
           o.cant_unidades,
           o.fecha
    FROM orden o
    JOIN producto p ON o.cod_producto = p.cod_producto
    WHERE o.id_cliente = p_id_cliente;
END $$

DELIMITER ;

-- Buscar producto por categoria

DELIMITER $$

CREATE PROCEDURE buscar_producto_por_categoria(IN p_categoria VARCHAR(30))
BEGIN
	SELECT * FROM producto 
    WHERE categoria = p_categoria;
END $$

DELIMITER ;

-- Buscar cliente por apellido

DELIMITER $$

CREATE PROCEDURE buscar_cliente_por_apellido(IN p_apellido VARCHAR(40))
BEGIN
	SELECT * FROM cliente
    WHERE apellido LIKE CONCAT('%', p_apellido, '%');
END $$

DELIMITER ;
-- Productos mas vendidos

DELIMITER $$

CREATE PROCEDURE productos_mas_vendidos()
BEGIN
	SELECT p.cod_producto,
       p.nombre,
       SUM(o.cant_unidades) AS total_vendido
	FROM orden o
	JOIN producto p ON o.cod_producto = p.cod_producto
	GROUP BY p.cod_producto, p.nombre
	ORDER BY total_vendido DESC;
END $$

DELIMITER $$

-- Ver cantidad de pedidos por producto

DELIMITER $$

CREATE PROCEDURE ver_pedidos_por_producto(IN p_producto INT)
BEGIN
	SELECT o.*, c.nombre, c.apellido
    FROM orden o
    JOIN cliente c ON o.id_cliente = c.id_cliente
    WHERE o.cod_producto = p_producto;
END $$

DELIMITER ;

-- Registrar cliente

DELIMITER //
CREATE PROCEDURE sp_registrar_cliente(
    IN _nombre VARCHAR(40),
    IN _apellido VARCHAR(40),
    IN _email VARCHAR(30),
    IN _direccion VARCHAR(30)
)
BEGIN
    INSERT INTO cliente (nombre, apellido, email, direccion) 
    VALUES (_nombre, _apellido, _email, _direccion);
END //
DELIMITER ;

CALL sp_registrar_cliente('Lionel', 'Messi', 'lio@argentina.com', 'Miami 10');


-- Ver detalle de clientes:
-- 1. Ver todos los clientes:
DELIMITER //
CREATE PROCEDURE sp_listar_clientes()
BEGIN
    SELECT * FROM cliente;
END //
DELIMITER ;

CALL sp_listar_clientes();

-- 2. Ver un cliente especifico:
DELIMITER //
CREATE PROCEDURE sp_buscar_cliente(
    IN _id_cliente INT
)
BEGIN
    SELECT nombre, apellido, email, direccion 
    FROM cliente 
    WHERE id_cliente = _id_cliente;
END //
DELIMITER ;

CALL sp_buscar_cliente(1); # cambiar numero por id buscado

-- Actualizar y gestionar contactos

DELIMITER //
CREATE PROCEDURE sp_modificar_cliente(
    IN _id_cliente INT,
    IN _nuevo_email VARCHAR(30),
    IN _nueva_direccion VARCHAR(30)
)
BEGIN
    UPDATE cliente 
    SET email = _nuevo_email, 
        direccion = _nueva_direccion
    WHERE id_cliente = _id_cliente;
END //
DELIMITER ;

-- Reporte de producto mas vendido

DELIMITER //
CREATE PROCEDURE sp_reporte_mas_vendido()
BEGIN
    SELECT 
        p.nombre AS "Producto Mas Vendido",
        SUM(o.cant_unidades) AS "Cantidad Total Vendida"
    FROM producto p
    JOIN orden o 
        ON p.cod_producto = o.cod_producto
    GROUP BY 
        p.cod_producto, p.nombre
    ORDER BY 
        SUM(o.cant_unidades) DESC
    LIMIT 1;
END //
DELIMITER ;

CALL sp_reporte_mas_vendido();

-- ver productos

DELIMITER //
CREATE PROCEDURE sp_ver_productos()
BEGIN
	SELECT * FROM producto;
END //

-- agregar productos

DELIMITER //
CREATE PROCEDURE sp_agregar_producto(
    IN _cod_producto INT,
    IN _nombre VARCHAR(40),
    IN _categoria VARCHAR(30),
    IN _stock INT
)
BEGIN
    INSERT INTO producto (cod_producto, nombre, categoria, stock)
    VALUES (_cod_producto, _nombre, _categoria, _stock);
END //


-- actualizar productos

DELIMITER //
CREATE PROCEDURE sp_actualizar_producto(
    IN _cod_producto INT,
    IN _nombre VARCHAR(40),
    IN _categoria VARCHAR(30),
    IN _stock INT
)
BEGIN
    UPDATE producto
    SET nombre = _nombre,
        categoria = _categoria,
        stock = _stock
    WHERE cod_producto = _cod_producto;
END //


-- eliminar productos

DELIMITER //
CREATE PROCEDURE sp_eliminar_producto(
    IN _cod_producto INT
)
BEGIN
    DELETE FROM producto WHERE cod_producto = _cod_producto;
END //


# PUNTO 6
-- modificacion de orden si sobrepasa stock

DELIMITER //
CREATE PROCEDURE sp_modificar_orden(
    IN _id_orden INT,
    IN _nueva_cantidad INT
)
BEGIN
    DECLARE _cod_producto INT;
    DECLARE _cantidad_actual INT;
    DECLARE _stock_disponible INT;
    DECLARE _diferencia INT;

    SELECT cod_producto, cant_unidades 
    INTO _cod_producto, _cantidad_actual
    FROM orden 
    WHERE id_orden = _id_orden;

    SET _diferencia = _nueva_cantidad - _cantidad_actual;

    SELECT stock INTO _stock_disponible 
    FROM producto 
    WHERE cod_producto = _cod_producto;

    IF _diferencia > 0 AND _stock_disponible < _diferencia THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERROR: Stock insuficiente';
    ELSE
        UPDATE orden 
        SET cant_unidades = _nueva_cantidad 
        WHERE id_orden = _id_orden;

        UPDATE producto 
        SET stock = stock - _diferencia 
        WHERE cod_producto = _cod_producto;
    END IF;
END //