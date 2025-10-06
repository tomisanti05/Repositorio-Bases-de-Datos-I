-- SIN JOIN
-- ¿Qué socios tienen barcos amarrados en un número de amarre mayor que 10?

SELECT nombre, direccion
FROM Socios
WHERE id_socio IN (
    SELECT id_socio
    FROM Barcos
    WHERE numero_amarre > 10
);

-- ¿Cuáles son los nombres de los barcos y sus cuotas de aquellos barcos cuyo socio se llama Juan Pérez?

SELECT nombre, cuota_decimal
FROM Barcos
WHERE id_socio = (
    SELECT id_socio
    FROM Socios
    WHERE nombre = 'Juan Pérez'
);

-- ¿Cuántas salidas ha realizado el barco con matrícula ABC123?

SELECT COUNT(*)
FROM Salidas
WHERE matricula = 'ABC123';

-- Lista los barcos que tienen una cuota mayor a 500 y sus respectivos socios.

SELECT b.nombre, s.nombre, s.direccion
FROM Barcos b
WHERE b.cuota_decimal > 500
AND b.id_socio IN (
    SELECT id_socio
    FROM Socios
);

-- ¿Qué barcos han salido con destino a "Mallorca"?

SELECT DISTINCT matricula
FROM Salidas
WHERE destino = 'Mallorca';

-- ¿Qué patrones (nombre y dirección) han llevado un barco cuyo socio vive en "Barcelona"?

SELECT patron_nombre, patron_direccion
FROM Salidas
WHERE matricula IN (
    SELECT matricula
    FROM Barcos
    WHERE id_socio IN (
        SELECT id_socio
        FROM Socios
        WHERE direccion LIKE '%Barcelona%'
    )
);






