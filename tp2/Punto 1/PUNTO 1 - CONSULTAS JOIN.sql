-- CON JOIN
-- ¿Qué socios tienen barcos amarrados en un número de amarre mayor que 10?

SELECT DISTINCT s.nombre, s.direccion
FROM Socios s
JOIN Barcos b ON s.id_socio = b.id_socio
WHERE b.numero_amarre > 10;

-- ¿Cuáles son los nombres de los barcos y sus cuotas de aquellos barcos cuyo socio se llama Juan Pérez?

SELECT b.nombre, b.cuota_decimal
FROM Socios s
JOIN Barcos b ON s.id_socio = b.id_socio
WHERE s.nombre = 'Juan Pérez';

-- ¿Cuántas salidas ha realizado el barco con matrícula ABC123?

SELECT COUNT(*)
FROM Salidas s
JOIN Barcos b ON s.matricula = b.matricula
WHERE s.matricula = 'ABC123';

-- Lista los barcos que tienen una cuota mayor a 500 y sus respectivos socios.

SELECT b.nombre, s.nombre, s.direccion
FROM Barcos b
JOIN Socios s ON b.id_socio = s.id_socio
WHERE b.cuota_decimal > 500;

-- ¿Qué barcos han salido con destino a "Mallorca"?

SELECT DISTINCT b.matricula
FROM Barcos b
JOIN Salidas s ON b.matricula = s.matricula
WHERE s.destino = 'Mallorca';

-- ¿Qué patrones (nombre y dirección) han llevado un barco cuyo socio vive en "Barcelona"?

SELECT DISTINCT s.patron_nombre, s.patron_direccion
FROM Salidas s
JOIN Barcos b ON s.matricula = b.matricula
JOIN Socios so ON b.id_socio = so.id_socio
WHERE so.direccion LIKE '%Barcelona%';