-- Populación de las tablas
INSERT INTO Socios (id_socio, nombre, direccion)
VALUES
(1, 'Juan Pérez', 'Calle Mayor 1, Madrid'),
(2, 'Ana García', 'Calle Luna 5, Barcelona'),
(3, 'Luis Fernández', 'Avenida del Sol 10, Valencia'),
(4, 'Laura Sánchez', 'Plaza del Mar 3, Alicante'),
(5, 'Carlos López', 'Calle Río 8, Sevilla'),
(6, 'Marta Díaz', 'Calle de la Sierra 12, Zaragoza'),
(7, 'Pedro Gómez', 'Calle Nueva 20, Bilbao'),
(8, 'Lucía Jiménez', 'Calle Real 30, Madrid'),
(9, 'María Torres', 'Calle Verde 15, Málaga'),
(10, 'Fernando Martín', 'Calle Azul 25, Murcia');

INSERT INTO Barcos (matricula, nombre, numero_amarre, cuota, id_socio)
VALUES
('ABC123', 'El Viento', 12, 600.50, 1),
('DEF456', 'La Brisa', 8, 450.00, 2),
('GHI789', 'El Sol', 15, 700.00, 3),
('JKL012', 'El Mar', 10, 550.75, 4),
('MNO345', 'La Luna', 18, 620.30, 5),
('PQR678', 'El Horizonte', 20, 780.90, 6),
('STU901', 'El Amanecer', 5, 400.00, 7),
('VWX234', 'La Estrella', 7, 520.50, 8),
('YZA567', 'La Marea', 14, 480.75, 9),
('BCD890', 'El Océano', 6, 630.80, 10);

INSERT INTO Salidas (id_salida, matricula, fecha_salida, hora_salida, destino, patron_nombre, patron_direccion)
VALUES
(1, 'ABC123', '2023-07-15', '10:30:00', 'Mallorca', 'Patrón 1', 'Calle de la Playa 1, Palma'),
(2, 'DEF456', '2023-07-20', '09:00:00', 'Ibiza', 'Patrón 2', 'Avenida del Puerto 3, Valencia'),
(3, 'GHI789', '2023-07-22', '08:45:00', 'Menorca', 'Patrón 3', 'Calle de la Costa 10, Alicante'),
(4, 'JKL012', '2023-07-25', '11:15:00', 'Mallorca', 'Patrón 4', 'Plaza del Faro 5, Barcelona'),
(5, 'MNO345', '2023-08-01', '14:00:00', 'Formentera', 'Patrón 5', 'Calle del Puerto 20, Ibiza'),
(6, 'PQR678', '2023-08-05', '07:30:00', 'Mallorca', 'Patrón 6', 'Calle de las Olas 15, Palma'),
(7, 'STU901', '2023-08-10', '12:00:00', 'Ibiza', 'Patrón 7', 'Avenida de la Marina 7, Barcelona'),
(8, 'VWX234', '2023-08-12', '09:30:00', 'Cabrera', 'Patrón 8', 'Calle del Mar 12, Alicante'),
(9, 'YZA567', '2023-08-15', '10:00:00', 'Formentera', 'Patrón 9', 'Calle del Sol 4, Ibiza'),
(10, 'BCD890', '2023-08-20', '08:00:00', 'Menorca', 'Patrón 10', 'Plaza del Faro 2, Palma');
