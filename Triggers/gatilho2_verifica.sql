.mode columns
.headers on
.nullvalue NULL

PRAGMA foreign_keys = ON;

.print ' '
.print 'Jogadores do Sporting Clube de Portugal.'
.print ' '

select E.nome as NOME, E.numJogadores as NUM_JOGADORES
from Equipa E
where E.equipaID = 3;

select J.nome as JOGADOR, J.numero as NUMERO
from Equipa E join Jogador J on E.equipaID = J.equipaID
where E.equipaID = 3
order by numero;


.print ' '
.print 'Vamos agora simular a transferência do André Vinagre para o Sporting.'
.print ' '

INSERT INTO Jogador VALUES (338,'Andre Vinagre',23,10000000,29,'Defesa','portugues',3);

select E.nome as NOME, E.numJogadores as NUM_JOGADORES
from Equipa E
where E.equipaID = 3;

select J.nome as JOGADOR, J.numero as NUMERO
from Equipa E join Jogador J on E.equipaID = J.equipaID
where E.equipaID = 3
order by numero;


.print ' '
.print 'Vamos agora simular a transferência do um jogador com o mesmo número de um que já exista na equipa.'
.print ' '

INSERT INTO Jogador VALUES (339,'Sotiris Alexandropoulos',20,4500000,26,'Medio','grego',3);

select E.nome as NOME, E.numJogadores as NUM_JOGADORES
from Equipa E
where E.equipaID = 3;

select J.nome as JOGADOR, J.numero as NUMERO
from Equipa E join Jogador J on E.equipaID = J.equipaID
where E.equipaID = 3
order by numero;

.print ' '
.print 'Ocorreu um erro, porque dentro da mesma equipa, todos os jogadores têm que ter números diferentes, logo não é adicionado.'
.print ' '