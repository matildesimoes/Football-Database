.mode columns
.headers on
.nullvalue NULL

WITH 

THREE_BEST AS (
	SELECT EQ.equipaID as equipaiD
	FROM Equipa EQ JOIN Estatistica ES ON ES.equipaID = EQ.equipaID
	WHERE ES.jornadaID = (SELECT jornadaID 
                          FROM Jornada 
                          ORDER BY numero desc 
                          LIMIT 1)
	ORDER BY ES.lugar
	LIMIT 3
)

SELECT data as DATA, hora as HORA, E1.nome as NOME_VISITANTE, R.golosVisitante as GOLOS_VISITANTE,
				 R.golosVisitado as GOLOS_VISITADO, E2.nome as NOME_VISITADO
FROM THREE_BEST T1, THREE_BEST T2 
	JOIN Jogo J ON (visitanteID = T1.equipaID AND visitadoID = T2.equipaID) 
	JOIN Resultado R ON J.resultadoID = R.resultadoID
	JOIN Equipa E1 ON T1.equipaID = E1.equipaID
	JOIN Equipa E2 ON T2.equipaID = E2.equipaID
WHERE T1.equipaID != T2.equipaID
ORDER BY data;