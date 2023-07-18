.mode columns
.headers on
.nullvalue NULL

WITH

GOLOS_FORA AS (
	SELECT E.equipaID , SUM(R.golosVisitante) as GOLOS
	FROM Equipa E JOIN Jogo J ON E.equipaID = J.visitanteID 
	JOIN Resultado R ON R.resultadoID = J.resultadoID
	GROUP BY E.equipaID
),

GOLOS_CASA AS (
	SELECT E.equipaID, SUM(R.golosVisitado) as GOLOS
	FROM Equipa E JOIN Jogo J ON E.equipaID = J.visitadoID 
	JOIN Resultado R ON R.resultadoID = J.resultadoID
	GROUP BY E.equipaID
)

SELECT E.nome as NOME, GF.golos as GOLOS_FORA, GC.golos as GOLOS_CASA, ABS(GF.golos - GC.golos) as DIFERENÇA
FROM GOLOS_CASA GC JOIN GOLOS_FORA GF ON GC.equipaID = GF.equipaID
JOIN Equipa E ON E.equipaID = GC.equipaID
ORDER BY DIFERENÇA, (GOLOS_FORA + GOLOS_CASA) desc
limit 1;