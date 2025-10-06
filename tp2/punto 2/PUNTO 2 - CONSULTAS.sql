-- ¿Cuál es el nombre y la dirección de los procuradores que han trabajado en un asunto abierto?

SELECT DISTINCT p.nombre, p.direccion
FROM Procuradores p
JOIN Asuntos_Procuradores ap ON p.dni_del_procurador = ap.id_procurador
JOIN Asuntos a ON ap.numero_de_expediente = a.numero_de_expediente
WHERE a.estado = 'Abierto' AND a.fecha_de_fin IS NULL;

-- ¿Qué clientes han tenido asuntos en los que ha participado el procurador Carlos López?

SELECT DISTINCT c.nombre, c.dni
FROM Clientes c
JOIN Asuntos a ON c.dni = a.dni_del_cliente
JOIN Asuntos_Procuradores ap ON a.numero_de_expediente = ap.numero_de_expediente
JOIN Procuradores p ON ap.id_procurador = p.dni_del_procurador
WHERE p.nombre = 'Carlos López';

-- ¿Cuántos asuntos ha gestionado cada procurador?

SELECT p.nombre, COUNT(ap.numero_de_expediente) as cantidad_asuntos
FROM Procuradores p
LEFT JOIN Asuntos_Procuradores ap ON p.dni_del_procurador = ap.id_procurador
GROUP BY p.nombre;

-- Lista los números de expediente y fechas de inicio de los asuntos de los clientes que viven en Buenos Aires.

SELECT a.numero_de_expediente, a.fecha_de_inicio
FROM Clientes c
JOIN Asuntos a ON c.dni = a.dni_del_cliente
WHERE c.direccion LIKE '%Buenos Aires%';