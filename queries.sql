
/* 1 */

SELECT J.nome as NOME, COUNT(*) as GOLOS, E.nome as EQUIPA
FROM Jogador J JOIN Golo G ON J.jogadorID = G.jogadorID JOIN Equipa E ON J.equipaID = E.equipaID
GROUP BY J.jogadorID
ORDER BY GOLOS desc
LIMIT 3;


/* 2 */

SELECT ES.lugar as LUGAR, EQ.nome as NOME, ES.pontosTotais as PONTOS_TOTAIS, 
			ES.numVitorias as NUM_VITORIAS, ES.numEmpates as NUM_EMPATES, ES.numDerrotas as NUM_DERROTAS
FROM Equipa EQ JOIN Estatistica ES ON ES.equipaID = EQ.equipaID
WHERE ES.jornadaID = (SELECT jornadaID FROM Jornada ORDER BY numero desc LIMIT 1)
ORDER BY ES.lugar;


/* 3 */

SELECT J.numero as JORNADA
FROM Estatistica E JOIN Jornada J ON E.jornadaID = J.jornadaID
WHERE E.equipaID = (SELECT equipaID
			FROM Estatistica E 
			WHERE jornadaID = (SELECT jornadaID FROM Jornada ORDER BY numero desc LIMIT 1)
			AND lugar = 1 )
      AND E.lugar != 1
ORDER by J.numero;


/* 4 */

SELECT JG.posicao as POSICAO, ROUND(COUNT(G.goloID) * 1.0 / (SELECT COUNT(*) FROM JOGO), 2) as "MEDIA GOLOS/JOGO"
FROM Jogo J JOIN Golo G ON J.jogoID = G.goloID Join Jogador JG ON G.jogadorID = JG.jogadorID
GROUP BY JG.posicao;


/* 5 */

WITH 

THREE_BEST AS (
	SELECT EQ.equipaID as equipaiD
	FROM Equipa EQ JOIN Estatistica ES ON ES.equipaID = EQ.equipaID
	WHERE ES.jornadaID = (SELECT jornadaID FROM Jornada ORDER BY numero desc LIMIT 1)
	ORDER BY ES.lugar
	LIMIT 3
)

SELECT data, hora, E1.nome, R.golosVisitante, R.golosVisitado, E2.nome
FROM THREE_BEST T1, THREE_BEST T2 
	JOIN Jogo J ON (visitanteID = T1.equipaID AND visitadoID = T2.equipaID) 
	JOIN Resultado R ON J.resultadoID = R.resultadoID
	JOIN Equipa E1 ON T1.equipaID = E1.equipaID
	JOIN Equipa E2 ON T2.equipaID = E2.equipaID
WHERE T1.equipaID != T2.equipaID
ORDER BY data;


/* 6 */ 

WITH

GOLOS_FORA AS (
	SELECT E.equipaID , SUM(R.golosVisitante) as golos
	FROM Equipa E JOIN Jogo J ON E.equipaID = J.visitanteID 
	JOIN Resultado R ON R.resultadoID = J.resultadoID
	GROUP BY E.equipaID
),

GOLOS_CASA AS (
	SELECT E.equipaID, SUM(R.golosVisitado) as golos
	FROM Equipa E JOIN Jogo J ON E.equipaID = J.visitadoID 
	JOIN Resultado R ON R.resultadoID = J.resultadoID
	GROUP BY E.equipaID
)

SELECT E.nome as NOME, GF.golos as FORA, GC.golos as CASA, ABS(GF.golos - GC.golos) as DIFERENÇA
FROM GOLOS_CASA GC JOIN GOLOS_FORA GF ON GC.equipaID = GF.equipaID
JOIN Equipa E ON E.equipaID = GC.equipaID
ORDER BY DIFERENÇA, (FORA + CASA) desc
limit 1;


/* 7 */

WITH 

LUGARES AS (
	SELECT EQ.nome as EQUIPA, ES.lugar as LUGAR, COUNT(*) as NR_DE_JORNADAS
	FROM Estatistica ES JOIN Equipa EQ ON EQ.equipaID = ES.equipaID
	GROUP BY EQ.equipaID, ES.lugar
	ORDER BY NR_DE_JORNADAS desc
)

SELECT *
FROM LUGARES
WHERE NR_DE_JORNADAS = (SELECT MAX(NR_DE_JORNADAS) FROM LUGARES)
ORDER BY lugar; 


/* 8 */

SELECT DISTINCT lugar as LUGAR, nome as NOME
FROM  (SELECT DISTINCT nome, EQ.equipaID as id
	FROM Equipa EQ JOIN Estatistica ES ON EQ.equipaID = ES.equipaID  
	WHERE ES.lugar >= (SELECT lugar FROM Estatistica ORDER BY LUGAR desc LIMIT 1) - 1
	ORDER BY lugar, numVitorias desc)
	JOIN Estatistica ON id = equipaID AND jornadaID = (SELECT jornadaID FROM Jornada ORDER BY numero desc LIMIT 1)
ORDER BY lugar;


/* 9 */

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

SELECT AG.NOME
FROM AUTO_GOLOS AG 
GROUP BY AG.jogadorID
HAVING COUNT(*) == (SELECT COUNT(*) FROM Jogador J JOIN Golo G ON G.jogadorID = J.jogadorID WHERE AG.jogadorID = J.jogadorID)
ORDER BY nome


/* 10 */

WITH 

NACIONALIDADES AS (
SELECT E.equipaID as equipa, J.nacionalidade as nacionalidade, COUNT(J.nacionalidade) as counted
FROM Equipa E JOIN Jogador J ON J.equipaID = E.equipaID
GROUP BY E.equipaID, J.nacionalidade
ORDER BY E.equipaID, counted desc, J.nacionalidade
)

SELECT E.nome as NOME, (SELECT SUM(J.valorMercado) FROM Jogador J WHERE E.equipaID = J.equipaID) as VALOR_PLANTEL
FROM NACIONALIDADES N JOIN Equipa E ON N.equipa = E.equipaID
WHERE N.nacionalidade = "portugues" AND
	N.counted * 1.0 / (SELECT COUNT(*) FROM Jogador J WHERE E.equipaID = J.equipaID) > 0.5
ORDER BY VALOR_PLANTEL desc;





-------------------------------------------------------------------------------------------------------

/* JOGADORES MAL */

SELECT COUNT(*)
FROM Jogador J JOIN Golo G ON J.jogadorID = G.jogadorID Join Jogo JG ON JG.jogoID = G.jogoID
	JOIN Equipa EJ ON J.equipaID = EJ.equipaID 
	JOIN Equipa VSTD ON VSTD.equipaID = visitadoID
	JOIN equipa VSTNT ON VSTNT.equipaID = visitanteID
WHERE visitadoID != J.equipaID AND visitanteID != J.equipaID
ORDER BY J.nome;

SELECT DISTINCT J.nome, VSTD.nome, VSTNT.nome, JG.data, JG.hora
FROM Jogador J JOIN Golo G ON J.jogadorID = G.jogadorID Join Jogo JG ON JG.jogoID = G.jogoID
	JOIN Equipa EJ ON J.equipaID = EJ.equipaID 
	JOIN Equipa VSTD ON VSTD.equipaID = visitadoID
	JOIN equipa VSTNT ON VSTNT.equipaID = visitanteID
WHERE visitadoID != J.equipaID AND visitanteID != J.equipaID
ORDER BY J.nome;

/*______________*/


SELECT COUNT(*) + 1 
FROM Estastica ES
WHERE ES.jornadaID = 
        
