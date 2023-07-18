.mode columns
.headers on
.nullvalue NULL

SELECT DISTINCT lugar as LUGAR, nome as NOME
FROM (SELECT DISTINCT nome, EQ.equipaID as id
	  FROM Equipa EQ JOIN Estatistica ES ON EQ.equipaID = ES.equipaID  
	  WHERE ES.lugar >= (SELECT lugar 
                       FROM Estatistica 
                       ORDER BY LUGAR desc 
                       LIMIT 1) - 1
	  ORDER BY lugar, numVitorias desc)
	JOIN Estatistica ON id = equipaID AND jornadaID = (SELECT jornadaID 
                                                     FROM Jornada 
                                                     ORDER BY numero desc 
                                                     LIMIT 1)
ORDER BY lugar;
