.mode columns
.headers on
.nullvalue NULL

WITH 

LUGARES AS (
	SELECT EQ.nome as NOME, ES.lugar as LUGAR, COUNT(*) as NUM_JORNADAS
	FROM Estatistica ES JOIN Equipa EQ ON EQ.equipaID = ES.equipaID
	GROUP BY EQ.equipaID, ES.lugar
	ORDER BY NUM_JORNADAS desc
)

SELECT *
FROM LUGARES
WHERE NUM_JORNADAS = (SELECT MAX(NUM_JORNADAS) 
                      FROM LUGARES)
ORDER BY lugar; 