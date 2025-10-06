-- Creacion de tablas

CREATE TABLE Clientes (
    dni VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL
);

CREATE TABLE Procuradores (
    dni_del_procurador VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL
);

CREATE TABLE Asuntos (
    numero_de_expediente VARCHAR(20) PRIMARY KEY,
    dni_del_cliente VARCHAR(20) NOT NULL,
    fecha_de_inicio DATE NOT NULL,
    fecha_de_fin DATE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Abierto', 'Cerrado', 'Archivado')),
    CONSTRAINT fk_cliente FOREIGN KEY (dni_del_cliente) REFERENCES Clientes(dni),
    CONSTRAINT chk_estado_fecha CHECK ((estado = 'Abierto' AND fecha_de_fin IS NULL) OR (estado != 'Abierto'))
);

CREATE TABLE Asuntos_Procuradores (
    numero_de_expediente VARCHAR(20),
    dni_del_procurador VARCHAR(20),
    PRIMARY KEY (numero_de_expediente, dni_del_procurador),
    FOREIGN KEY (numero_de_expediente) REFERENCES Asuntos(numero_de_expediente),
    FOREIGN KEY (dni_del_procurador) REFERENCES Procuradores(dni_del_procurador)
);