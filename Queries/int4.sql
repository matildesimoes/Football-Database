.mode columns
.headers on
.nullvalue NULL

SELECT JG.posicao as POSICAO, ROUND(COUNT(G.goloID) * 1.0 / (SELECT COUNT(*) FROM JOGO), 2) as "MEDIA GOLOS/JOGO"
FROM Jogo J JOIN Golo G ON J.jogoID = G.goloID Join Jogador JG ON G.jogadorID = JG.jogadorID
GROUP BY JG.posicao;