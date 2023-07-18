CREATE TRIGGER IF NOT EXISTS ADICIONAR_GOLOS    
AFTER INSERT ON Golo
FOR EACH ROW
BEGIN
  
    UPDATE Resultado
    SET golosVisitante = (SELECT COUNT(*)
                        FROM Jogo JG Join Golo G ON G.jogoID = JG.jogoID JOIN Jogador J ON G.jogadorID = J.jogadorID
                        WHERE NEW.jogoID = G.jogoID AND
                                ((G.baliza = "adversaria" AND JG.visitanteID = J.equipaID)
                                OR
                                (G.baliza = "propria" AND JG.visitadoID = J.equipaID))
                        )
    WHERE resultadoID = (SELECT J.resultadoID FROM Jogo J WHERE J.jogoID = NEW.jogoID);
    
    UPDATE Resultado
    SET golosVisitado = (SELECT COUNT(*)
                        FROM Jogo JG Join Golo G ON G.jogoID = JG.jogoID JOIN Jogador J ON G.jogadorID = J.jogadorID
                        WHERE NEW.jogoID = G.jogoID AND
                                ((G.baliza = "propria" AND JG.visitanteID = J.equipaID)
                                OR
                                (G.baliza = "adversaria" AND JG.visitadoID = J.equipaID))
                        )
    WHERE resultadoID = (SELECT J.resultadoID FROM Jogo J WHERE J.jogoID = NEW.jogoID);

    UPDATE ESTATISTICA
    SET golosMarcados = CASE
                WHEN NEW.baliza = "adversaria"
                        THEN golosMarcados + 1
                ELSE 
                        golosMarcados
        END,

        golosSofridos = CASE
                WHEN NEW.baliza = "propria"
                        THEN golosSofridos + 1
                ELSE 
                        golosSofridos
        END

    WHERE ((equipaID = (SELECT visitanteID FROM Jogo J WHERE J.jogoID = NEW.jogoID) AND
          equipaID = (SELECT equipaID FROM Jogador J WHERE J.jogadorID = NEW.jogadorID)) 
                OR 
          (equipaID = (SELECT visitadoID FROM Jogo J WHERE J.jogoID = NEW.jogoID) AND
          equipaID = (SELECT equipaID FROM Jogador J WHERE J.jogadorID = NEW.jogadorID))) 
          AND
          jornadaID IN (SELECT JN.jornadaID FROM Jornada JN
                            WHERE JN.numero >= (SELECT numero 
                                                FROM Jornada JN JOIN JOGO JG ON JG.jornadaID = JN.jornadaID 
                                                WHERE NEW.jogoID = JG.jogoID));

    UPDATE ESTATISTICA
    SET golosMarcados = CASE
                WHEN NEW.baliza = "propria"
                        THEN golosMarcados + 1
                ELSE 
                        golosMarcados
                END
        ,
        golosSofridos = CASE
                WHEN NEW.baliza = "adversaria"
                        THEN golosSofridos + 1
                ELSE 
                        golosSofridos
                END

    WHERE ((equipaID = (SELECT visitanteID FROM Jogo J WHERE J.jogoID = NEW.jogoID) AND
          (SELECT visitadoID FROM Jogo J WHERE J.jogoID = NEW.jogoID) = (SELECT equipaID FROM Jogador J WHERE J.jogadorID = NEW.jogadorID)) 
                OR 
          (equipaID = (SELECT visitadoID FROM Jogo J WHERE J.jogoID = NEW.jogoID) AND
          (SELECT visitanteID FROM Jogo J WHERE J.jogoID = NEW.jogoID) = (SELECT equipaID FROM Jogador J WHERE J.jogadorID = NEW.jogadorID))) 
          AND
          jornadaID IN (SELECT JN.jornadaID FROM Jornada JN
                            WHERE JN.numero >= (SELECT numero 
                                                FROM Jornada JN JOIN JOGO JG ON JG.jornadaID = JN.jornadaID 
                                                WHERE NEW.jogoID = JG.jogoID));

END; 

CREATE TRIGGER IF NOT EXISTS UPDATE_ESTATISTICA    
AFTER UPDATE ON Resultado
FOR EACH ROW
BEGIN

    /* remover os pontos/vitorias/derrotas/empates que o Visitado ganhou do jogo referente a este resultado e todos os outros depois */
    UPDATE ESTATISTICA
    SET pontosTotais = CASE
        WHEN OLD.golosVisitado > OLD.golosVisitante
            THEN pontosTotais - 3
        WHEN OLD.golosVisitado = OLD.golosVisitante
            THEN pontosTotais - 1
        ELSE
            pontosTotais
        END,

        numVitorias = CASE
        WHEN OLD.golosVisitado > OLD.golosVisitante
            THEN numVitorias - 1
        ELSE
            numVitorias
        END,

        numEmpates = CASE
        WHEN OLD.golosVisitado = OLD.golosVisitante
            THEN numEmpates - 1
        ELSE
            numEmpates
        END,

        numDerrotas = CASE
        WHEN OLD.golosVisitado < OLD.golosVisitante
            THEN numDerrotas - 1
        ELSE
            numDerrotas
        END

    WHERE equipaID = (SELECT visitadoID FROM Jogo J WHERE J.resultadoID = OLD.resultadoID) AND
            jornadaID IN (SELECT JN.jornadaID FROM Jornada JN
                            WHERE JN.numero >= (SELECT numero 
                                                FROM Jornada JN JOIN JOGO JG ON JG.jornadaID = JN.jornadaID 
                                                WHERE OLD.resultadoID = JG.resultadoID));
  
    /* remover os pontos/vitorias/derrotas/empates que o Visitante ganhou do jogo referente a este resultado e todos os outros depois */
    UPDATE ESTATISTICA
    SET pontosTotais = CASE
        WHEN OLD.golosVisitante > OLD.golosVisitado
            THEN pontosTotais - 3
        WHEN OLD.golosVisitante = OLD.golosVisitado
            THEN pontosTotais - 1
        ELSE
            pontosTotais
        END,

        numVitorias = CASE
        WHEN OLD.golosVisitante > OLD.golosVisitado
            THEN numVitorias - 1
        ELSE
            numVitorias
        END,

        numEmpates = CASE
        WHEN OLD.golosVisitante = OLD.golosVisitado
            THEN numEmpates - 1
        ELSE
            numEmpates
        END,

        numDerrotas = CASE
        WHEN OLD.golosVisitante < OLD.golosVisitado
            THEN numDerrotas - 1
        ELSE
            numDerrotas
        END
          
    WHERE equipaID = (SELECT visitanteID FROM Jogo J WHERE J.resultadoID = OLD.resultadoID) AND
            jornadaID IN (SELECT JN.jornadaID FROM Jornada JN
                            WHERE JN.numero >= (SELECT numero 
                                                FROM Jornada JN JOIN JOGO JG ON JG.jornadaID = JN.jornadaID 
                                                WHERE OLD.resultadoID = JG.resultadoID));

    /* adicionar os pontos/vitorias/derrotas/empates que o Visitado ganhou do jogo atulizado e todos os outros depois */
    UPDATE ESTATISTICA
    SET pontosTotais = CASE
        WHEN NEW.golosVisitado > NEW.golosVisitante
            THEN pontosTotais + 3
        WHEN NEW.golosVisitado = NEW.golosVisitante
            THEN pontosTotais + 1
        ELSE
            pontosTotais
        END,

        numVitorias = CASE
        WHEN NEW.golosVisitado > NEW.golosVisitante
            THEN numVitorias + 1
        ELSE
            numVitorias
        END,

        numEmpates = CASE
        WHEN NEW.golosVisitado = NEW.golosVisitante
            THEN numEmpates + 1
        ELSE
            numEmpates
        END,

        numDerrotas = CASE
        WHEN NEW.golosVisitado < NEW.golosVisitante
            THEN numDerrotas + 1
        ELSE
            numDerrotas
        END

    WHERE equipaID = (SELECT visitadoID FROM Jogo J WHERE J.resultadoID = NEW.resultadoID) AND
            jornadaID IN (SELECT JN.jornadaID FROM Jornada JN
                            WHERE JN.numero >= (SELECT numero 
                                                FROM Jornada JN JOIN JOGO JG ON JG.jornadaID = JN.jornadaID 
                                                WHERE NEW.resultadoID = JG.resultadoID));
  
    /* adicionar os pontos/vitorias/derrotas/empates que o Visitante ganhou do jogo atualizado e todos os outros depois */
    UPDATE ESTATISTICA
    SET pontosTotais = CASE
        WHEN NEW.golosVisitante > NEW.golosVisitado
            THEN pontosTotais + 3
        WHEN NEW.golosVisitante = NEW.golosVisitado
            THEN pontosTotais + 1
        ELSE
            pontosTotais
        END,

        numVitorias = CASE
        WHEN NEW.golosVisitante > NEW.golosVisitado
            THEN numVitorias + 1
        ELSE
            numVitorias
        END,

        numEmpates = CASE
        WHEN NEW.golosVisitante = NEW.golosVisitado
            THEN numEmpates + 1
        ELSE
            numEmpates
        END,

        numDerrotas = CASE
        WHEN NEW.golosVisitante < NEW.golosVisitado
            THEN numDerrotas + 1
        ELSE
            numDerrotas
        END
          
    WHERE equipaID = (SELECT visitanteID FROM Jogo J WHERE J.resultadoID = NEW.resultadoID) AND
            jornadaID IN (SELECT JN.jornadaID FROM Jornada JN
                            WHERE JN.numero >= (SELECT numero 
                                                FROM Jornada JN JOIN JOGO JG ON JG.jornadaID = JN.jornadaID 
                                                WHERE NEW.resultadoID = JG.resultadoID));

    UPDATE Estatistica
    SET lugar = (SELECT COUNT(*) + 1 
                FROM Estatistica ES
                WHERE ES.jornadaID = Estatistica.jornadaID AND
                        (Estatistica.pontosTotais < ES.pontosTotais OR
                        (Estatistica.pontosTotais = ES.pontosTotais AND (Estatistica.golosMarcados - Estatistica.golosSofridos) < (ES.golosMarcados - ES.golosSofridos)) OR 
                        (Estatistica.pontosTotais = ES.pontosTotais AND (Estatistica.golosMarcados - Estatistica.golosSofridos) = (ES.golosMarcados - ES.golosSofridos) 
                                AND Estatistica.numVitorias < ES.numVitorias) OR
                        (Estatistica.pontosTotais = ES.pontosTotais AND (Estatistica.golosMarcados - Estatistica.golosSofridos) = (ES.golosMarcados - ES.golosSofridos) 
                                AND Estatistica.numVitorias = ES.numVitorias AND Estatistica.golosMarcados < ES.golosMarcados))
                )
    WHERE jornadaID IN (SELECT JN.jornadaID FROM Jornada JN
                            WHERE JN.numero >= (SELECT numero 
                                                FROM Jornada JN JOIN JOGO JG ON JG.jornadaID = JN.jornadaID 
                                                WHERE NEW.resultadoID = JG.resultadoID));

END; 
