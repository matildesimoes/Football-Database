
DROP TABLE IF EXISTS Equipa;

CREATE TABLE Equipa(
    equipaID NUMERIC(2,0) CHECK (equipaID >= 1) PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    numJogadores NUMERIC(2,0) CHECK (numJogadores >= 12) NOT NULL,
    estadio VARCHAR(50) UNIQUE
);

DROP TABLE IF EXISTS Jogador;

CREATE TABLE Jogador(
    jogadorID NUMERIC(4,0) CHECK (jogadorID >= 1) PRIMARY KEY,
    nome VARCHAR(30)  NOT NULL,
    idade NUMERIC(2,0) CHECK (idade >= 15),
    valorMercado NUMERIC(9,0),
    numero NUMERIC(2,0) NOT NULL CHECK (1 <= numero AND numero <= 99),
    posicao VARCHAR(20),
    nacionalidade VARCHAR(20),
    equipaID  NOT NULL CHECK (equipaID >= 1),
    FOREIGN KEY (equipaID) REFERENCES Equipa(equipaID)
);

DROP TABLE IF EXISTS Jogo;

CREATE TABLE Jogo(
    jogoID NUMERIC(3,0) CHECK (jogoID >= 1) PRIMARY KEY,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    visitanteID NUMERIC(2,0) NOT NULL CHECK (visitanteID >= 1),
    visitadoID NUMERIC(2,0) NOT NULL CHECK (visitadoID >= 1),
    jornadaID NUMERIC(2,0) NOT NULL CHECK (jornadaID >= 1),
    resultadoID NUMERIC(3,0) UNIQUE NOT NULL CHECK (resultadoID >= 1),
    FOREIGN KEY (visitanteID) REFERENCES Equipa(equipaID),
    FOREIGN KEY (visitadoID) REFERENCES Equipa(equipaID),
    FOREIGN KEY (jornadaID) REFERENCES Jornada(jornadaID),
    FOREIGN KEY (resultadoID) REFERENCES Resultado(resultadoID)
);

DROP TABLE IF EXISTS Resultado;

CREATE TABLE Resultado(
    resultadoID NUMERIC(3,0) CHECK (resultadoID >= 1) PRIMARY KEY,
    golosVisitante NUMERIC(2,0) CHECK (golosVisitante >= 0) DEFAULT 0,
    golosVisitado NUMERIC(2,0) CHECK (golosVisitado >= 0) DEFAULT 0
);

DROP TABLE IF EXISTS Jornada;

CREATE TABLE Jornada(
    jornadaID NUMERIC(2,0) CHECK (jornadaID >= 1) PRIMARY KEY,
    numero NUMERIC(2,0) UNIQUE NOT NULL CHECK (numero >= 1)
);

DROP TABLE IF EXISTS Golo;

CREATE TABLE Golo(
    goloID NUMERIC(5,0) CHECK (goloID >= 1) PRIMARY KEY,
    baliza VARCHAR(50) NOT NULL CHECK (baliza == 'adversaria' OR baliza == 'propria'),
    jogadorID NUMERIC(4,0) NOT NULL CHECK (jogadorID >= 1),
    jogoID NUMERIC(3,0) NOT NULL CHECK (jogoID >= 1),
    FOREIGN KEY (jogadorID) REFERENCES Jogador(jogadorID),
    FOREIGN KEY (jogoID) REFERENCES Jogo(jogoID)
);

DROP TABLE IF EXISTS Estatistica;

CREATE TABLE Estatistica(
    equipaID NUMERIC(2,0) CHECK (equipaID >= 1),
    jornadaID NUMERIC(2,0) CHECK (jornadaID >= 1),
    lugar NUMERIC(2,0) NOT NULL CHECK (1 <= lugar AND lugar <= 18),
    pontosTotais NUMERIC(3,0) DEFAULT 0 CHECK (pontosTotais >= 0),
    numVitorias NUMERIC(2,0) DEFAULT 0 CHECK (numVitorias >= 0),
 	numEmpates NUMERIC(2,0) DEFAULT 0 CHECK (numEmpates >= 0),
 	numDerrotas NUMERIC(2,0) DEFAULT 0 CHECK (numDerrotas >= 0),
 	golosMarcados NUMERIC(3,0) DEFAULT 0 CHECK (golosMarcados >= 0),
 	golosSofridos NUMERIC(3,0) DEFAULT 0 CHECK (golosSofridos >= 0),
 	PRIMARY KEY (equipaID, jornadaID),
 	FOREIGN KEY (equipaID) REFERENCES Equipa(equipaID),
 	FOREIGN KEY (jornadaID) REFERENCES Jornada(jornadaID)
);