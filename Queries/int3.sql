.mode columns
.headers on
.nullvalue NULL

SELECT J.numero as JORNADA
FROM Estatistica E JOIN Jornada J ON E.jornadaID = J.jornadaID
WHERE E.equipaID = (SELECT equipaID
			        FROM Estatistica E 
			        WHERE jornadaID = (SELECT jornadaID 
                                             FROM Jornada 
                                             ORDER BY numero desc 
                                             LIMIT 1)
			        AND lugar = 1 ) 
      AND E.lugar != 1
ORDER by J.numero;