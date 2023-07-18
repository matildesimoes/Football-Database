.mode columns
.headers on
.nullvalue NULL

SELECT ES.lugar as LUGAR, EQ.nome as NOME, ES.pontosTotais as PONTOS_TOTAIS, 
			ES.numVitorias as NUM_VITORIAS, ES.numEmpates as NUM_EMPATES, ES.numDerrotas as NUM_DERROTAS
FROM Equipa EQ JOIN Estatistica ES ON ES.equipaID = EQ.equipaID
WHERE ES.jornadaID = (SELECT jornadaID 
					  FROM Jornada 
					  ORDER BY numero desc 
					  LIMIT 1)
ORDER BY ES.lugar;
