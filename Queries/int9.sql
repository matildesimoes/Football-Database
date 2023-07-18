.mode columns
.headers on
.nullvalue NULL

WITH 

AUTO_GOLOS as (
SELECT J.jogadorID as jogadorID, J.nome as NOME, E.nome as EQUIPA, JN.numero as JORNADA
FROM Golo G JOIN Jogador J ON J.jogadorID = G.jogadorID 
Join Jogo JG ON JG.jogoID = G.jogoID
JOIN Jornada JN ON JG.jornadaID = JN.jornadaID
JOIN Equipa E ON J.equipaID = E.equipaID
WHERE baliza = "propria"
ORDER BY J.nome
)

SELECT AG.NOME, AG.EQUIPA, AG.JORNADA
FROM AUTO_GOLOS AG 
GROUP BY AG.jogadorID
HAVING COUNT(*) == (SELECT COUNT(*) 
                    FROM Jogador J JOIN Golo G ON G.jogadorID = J.jogadorID 
                    WHERE AG.jogadorID = J.jogadorID)
ORDER BY nome;