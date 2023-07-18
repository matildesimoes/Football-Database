.mode columns
.headers on
.nullvalue NULL

PRAGMA foreign_keys = ON;


.print ' '
.print 'Resultado do primeiro jogo entre o Portimonense Sporting Clube e o Belenenses SAD.'
.print ' '

select VSTNT.nome as VISITANTE, R.golosVisitante as GOLOS_VISITANTE, R.golosVisitado as GOLOS_VISITADO, VSTD.nome as VISITADO
from Resultado R JOIN Jogo J ON R.resultadoID = J.resultadoID 
                JOIN Equipa VSTNT ON J.visitanteID  = VSTNT.equipaID
                JOIN EQUIPA VSTD ON J.visitadoID = VSTD.equipaID
where J.jogoID = 94;


.print ' '
.print 'Estatísticas finais.'
.print ' '

SELECT ES.lugar as LUGAR, EQ.nome as NOME, ES.pontosTotais as PONTOS_TOTAIS, 
			ES.numVitorias as NUM_VITORIAS, ES.numEmpates as NUM_EMPATES, ES.numDerrotas as NUM_DERROTAS
FROM Equipa EQ JOIN Estatistica ES ON ES.equipaID = EQ.equipaID
WHERE ES.jornadaID = (SELECT jornadaID 
					  FROM Jornada 
					  ORDER BY numero desc 
					  LIMIT 1)
ORDER BY ES.lugar;


.print ' '
.print 'Vamos agora simular um golo da equipa Portimonense na baliza adversária.'
.print ' '

INSERT INTO Golo VALUES (808,'adversaria',107,94);

select VSTNT.nome as VISITANTE, R.golosVisitante as GOLOS_VISITANTE, R.golosVisitado as GOLOS_VISITADO, VSTD.nome as VISITADO
from Resultado R JOIN Jogo J ON R.resultadoID = J.resultadoID 
                JOIN Equipa VSTNT ON J.visitanteID  = VSTNT.equipaID
                JOIN EQUIPA VSTD ON J.visitadoID = VSTD.equipaID
where J.jogoID = 94;


.print ' '
.print 'Vamos agora simular um golo da equipa Portimonense na própria baliza.'
.print ' '

INSERT INTO Golo VALUES (809,'propria',105,94);

select VSTNT.nome as VISITANTE, R.golosVisitante as GOLOS_VISITANTE, R.golosVisitado as GOLOS_VISITADO, VSTD.nome as VISITADO
from Resultado R JOIN Jogo J ON R.resultadoID = J.resultadoID 
                JOIN Equipa VSTNT ON J.visitanteID  = VSTNT.equipaID
                JOIN EQUIPA VSTD ON J.visitadoID = VSTD.equipaID
where J.jogoID = 94;


.print ' '
.print 'Vamos agora simular um golo da equipa Belenenses na baliza adversária.'
.print ' '

INSERT INTO Golo VALUES (810,'adversaria',216,94);

select VSTNT.nome as VISITANTE, R.golosVisitante as GOLOS_VISITANTE, R.golosVisitado as GOLOS_VISITADO, VSTD.nome as VISITADO
from Resultado R JOIN Jogo J ON R.resultadoID = J.resultadoID 
                JOIN Equipa VSTNT ON J.visitanteID  = VSTNT.equipaID
                JOIN EQUIPA VSTD ON J.visitadoID = VSTD.equipaID
where J.jogoID = 94;


.print ' '
.print 'Vamos agora simular um golo da equipa Belenenses na própria baliza.'
.print ' '

INSERT INTO Golo VALUES (811,'propria',214,94);

select VSTNT.nome as VISITANTE, R.golosVisitante as GOLOS_VISITANTE, R.golosVisitado as GOLOS_VISITADO, VSTD.nome as VISITADO
from Resultado R JOIN Jogo J ON R.resultadoID = J.resultadoID 
                JOIN Equipa VSTNT ON J.visitanteID  = VSTNT.equipaID
                JOIN EQUIPA VSTD ON J.visitadoID = VSTD.equipaID
where J.jogoID = 94;


.print ' '
.print 'Vamos adicionar mais 3 golos à equipa Beleneses para que esta passe a ganhar e assim, alterar o resultado e as estatísticas.'
.print ' '

INSERT INTO Golo VALUES (812,'adversaria',212,94);
INSERT INTO Golo VALUES (813,'adversaria',215,94);
INSERT INTO Golo VALUES (814,'adversaria',216,94);

select VSTNT.nome as VISITANTE, R.golosVisitante as GOLOS_VISITANTE, R.golosVisitado as GOLOS_VISITADO, VSTD.nome as VISITADO
from Resultado R JOIN Jogo J ON R.resultadoID = J.resultadoID 
                JOIN Equipa VSTNT ON J.visitanteID  = VSTNT.equipaID
                JOIN EQUIPA VSTD ON J.visitadoID = VSTD.equipaID
where J.jogoID = 94;

.print ' '
.print 'Estatísticas depois da mudança de resultado a favor do Beleneses.'
.print ' '

SELECT ES.lugar as LUGAR, EQ.nome as NOME, ES.pontosTotais as PONTOS_TOTAIS, 
			ES.numVitorias as NUM_VITORIAS, ES.numEmpates as NUM_EMPATES, ES.numDerrotas as NUM_DERROTAS
FROM Equipa EQ JOIN Estatistica ES ON ES.equipaID = EQ.equipaID
WHERE ES.jornadaID = (SELECT jornadaID 
					  FROM Jornada 
					  ORDER BY numero desc 
					  LIMIT 1)
ORDER BY ES.lugar;