.mode columns
.headers on
.nullvalue NULL

WITH 

NACIONALIDADES AS (
SELECT E.equipaID as equipa, J.nacionalidade as nacionalidade, COUNT(J.nacionalidade) as counted
FROM Equipa E JOIN Jogador J ON J.equipaID = E.equipaID
GROUP BY E.equipaID, J.nacionalidade
ORDER BY E.equipaID, counted desc, J.nacionalidade
)

SELECT E.nome as NOME, (SELECT SUM(J.valorMercado) 
                        FROM Jogador J 
                        WHERE E.equipaID = J.equipaID) as VALOR_PLANTEL
FROM NACIONALIDADES N JOIN Equipa E ON N.equipa = E.equipaID
WHERE N.nacionalidade = "portugues" AND
	N.counted * 1.0 / (SELECT COUNT(*) 
                       FROM Jogador J 
                       WHERE E.equipaID = J.equipaID) > 0.5
ORDER BY VALOR_PLANTEL desc;