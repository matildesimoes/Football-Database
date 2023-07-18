CREATE TRIGGER IF NOT EXISTS JOGADOR_NUMERO_REPETIDO
BEFORE INSERT ON Jogador
FOR EACH ROW
WHEN 0 < (SELECT COUNT(*) FROM Jogador WHERE equipaID = NEW.equipaID AND numero = NEW.numero)
BEGIN
  
    SELECT RAISE (ABORT, 'Já existe um jogador com o mesmo número nesta equipa.');

END; 

CREATE TRIGGER IF NOT EXISTS JOGADOR_ADICINADO
AFTER INSERT ON Jogador
FOR EACH ROW
BEGIN
  
    UPDATE Equipa
    SET numJogadores = (SELECT COUNT(*) FROM Jogador J JOIN EQUIPA E ON E.equipaID = J.equipaID WHERE E.equipaID = NEW.equipaID)
    WHERE equipaID = NEW.equipaID;

END; 
