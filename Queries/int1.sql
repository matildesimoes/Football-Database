.mode columns
.headers on
.nullvalue NULL

SELECT J.nome as NOME, COUNT(*) as GOLOS, E.nome as EQUIPA
FROM Jogador J JOIN Golo G ON J.jogadorID = G.jogadorID JOIN Equipa E ON J.equipaID = E.equipaID
GROUP BY J.jogadorID
ORDER BY GOLOS desc
LIMIT 3;