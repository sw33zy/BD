CREATE SCHEMA Caderneta1030;
DROP SCHEMA Caderneta1030;
USE Caderneta1030;
-- create tables

CREATE TABLE TipoCromo (
Nr INT ,
Descricao VARCHAR(45),
PRIMARY KEY (Nr)
);

INSERT into TipoCromo (Nr, Descricao) VALUES (1,"Jogador");
INSERT into TipoCromo (Nr, Descricao) VALUES (2,"Emblema");
INSERT into TipoCromo (Nr, Descricao) VALUES (3,"Estádio");

SELECT * from TipoCromo;

DROP TABLE Cromo;
CREATE TABLE Cromo (
Nr INT ,
	PagCadeneta INT,
	Descricao VARCHAR(45),
	Aquirido CHAR(1),
	Jogador INT,
	PRIMARY KEY (Nr),
	CONSTRAINT `fk_cromo_jogador`
		FOREIGN KEY (`Jogador`)
        REFERENCES Jogador (`Nr`)
);

CREATE TABLE Jogador (
	Nr INT NOT NULL,
    Nome VARCHAR(75) NOT NULL,
    Equipa CHAR(30) NOT NULL,
    Posicao INT NOT NULL,
    DataNascimento DATE NULL,
    LocalNascimento CHAR(3) NULL,
    Altura DECIMAL(6,2) NULL,
    Peso DECIMAL(6,2) NULL,
    Observações TEXT NULL,
    PRIMARY KEY (Nr)
);