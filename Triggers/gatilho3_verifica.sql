.mode columns
.headers on
.nullvalue NULL

PRAGMA foreign_keys = ON;

.print ' '
.print 'Criar novas equipas, jornadas e resultados para testar.'
.print ' '

INSERT INTO Equipa VALUES (19,'Equipa de Teste1',20,'Estadio Teste1');
INSERT INTO Equipa VALUES (20,'Equipa de Teste2',20,'Estadio Teste2');
INSERT INTO Jornada VALUES (35, 35);
INSERT INTO Jornada VALUES (36, 36);
INSERT INTO Resultado VALUES (307,0,0);
INSERT INTO Resultado VALUES (308,0,0);



.print ' '
.print 'Vamos agora simular a adição de um jogo Benfica vs Equipa Teste1 na Jornada 35.'
.print ' '

INSERT INTO Jogo VALUES(307,'2022/05/21','20:00',1,19,35,307);


.print ' '
.print 'Vamos agora simular a adição de um jogo Porto vs Equipa Teste1 na Jornada 35.'
.print ' '

INSERT INTO Jogo VALUES(308,'2022/05/22','18:00',2,19,35,307);


.print ' '
.print 'Vamos agora simular a adição de um jogo BEnfica vs Equipa Teste2 na Jornada 35.'
.print ' '

INSERT INTO Jogo VALUES(309,'2022/05/22','18:00',1,20,35,307);


.print ' '
.print 'Vamos agora simular a adição de um jogo Benfica vs Equipa Teste1 na Jornada 36.'
.print ' '

INSERT INTO Jogo VALUES(310,'2022/05/22','18:00',1,19,36,307);


.print ' '
.print 'Vamos agora simular a adição de um jogo que respeite as regras, entre a Equipa Teste1 e o Benfica, na jornada 36.'
.print ' '

INSERT INTO Jogo VALUES(311,'2022/05/22','18:00',19,1,36,308);
