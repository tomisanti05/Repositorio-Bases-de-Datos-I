CREATE TABLE Socios (
    id_socio INT PRIMARY KEY,
    nombre VARCHAR(108),
    direccion VARCHAR(255)
);

CREATE TABLE Barcos (
    matricula VARCHAR(28) PRIMARY KEY,
    nombre VARCHAR(108),
    cuota_decimal DECIMAL(10, 2),
    id_socio INT,
    FOREIGN KEY (id_socio) REFERENCES Socios(id_socio)
);

CREATE TABLE Salidas (
    id_salida INT PRIMARY KEY,
    matricula VARCHAR(28),
    fecha_salida DATE,
    hora_salida TIME,
    destino VARCHAR(108),
    patron_nombre VARCHAR(108),
    patron_direccion VARCHAR(255),
    FOREIGN KEY (matricula) REFERENCES Barcos(matricula)
);