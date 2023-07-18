CREATE TRIGGER IF NOT EXISTS JOGO_REPETIDO_POR_JORNADA_VISITANTE
BEFORE INSERT ON Jogo
FOR EACH ROW
WHEN 1 = (select count(*)
          from Equipa E, Jogo J
          where (E.equipaID = J.visitadoID OR E.equipaID = J.visitanteID) AND E.equipaID = NEW.visitanteID AND J.jornadaID = NEW.jornadaID
          )
BEGIN
    SELECT RAISE (ABORT, 'A equipa visitante já jogou nessa jornada.');
END; 

CREATE TRIGGER IF NOT EXISTS JOGO_REPETIDO_POR_JORNADA_VISITADA
BEFORE INSERT ON Jogo
FOR EACH ROW
WHEN 1  = (select count(*)
          from Equipa E, Jogo J
          where (E.equipaID = J.visitadoID OR E.equipaID = J.visitanteID) AND E.equipaID = NEW.visitadoID AND J.jornadaID = NEW.jornadaID
          )
BEGIN
    SELECT RAISE (ABORT, 'A equipa visitada já jogou nessa jornada.');
END;

CREATE TRIGGER IF NOT EXISTS JOGO_CASA_FORA
BEFORE INSERT ON Jogo
FOR EACH ROW
WHEN 1  = (select count(*)
          from Jogo J
          where NEW.visitadoID = J.visitadoID AND NEW.visitanteID = J.visitanteID
          )
BEGIN
    SELECT RAISE (ABORT, 'As equipas já jogaram.');
END;
