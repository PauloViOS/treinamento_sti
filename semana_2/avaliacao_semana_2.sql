-- Criação das tabelas conforme imagem do arquivo "Avaliação 2"
CREATE TABLE Identificacao(
  idIdentificacao INTEGER PRIMARY KEY,
  nome TEXT,
  cpf CHAR(11)
  );

CREATE TABLE Usuario(
  idUsuario INTEGER PRIMARY KEY, 
  idIdentificacao INTEGER REFERENCES Identificacao(idIdentificacao) UNIQUE,
  admin BOOL
  );

CREATE TABLE Carona(
  idCarona INTEGER PRIMARY KEY, 
  idUsuario INTEGER REFERENCES Usuario(idUsuario), 
  partida TEXT, 
  destino TEXT, 
  data_hora TIMESTAMP, 
  passageiros INTEGER
  );

CREATE TABLE Parada(
  idParada INTEGER PRIMARY KEY,
  idCarona INTEGER REFERENCES Carona(idCarona),
  descricao TEXT
  );


-- 1 - Quais as caronas com destino Praia Vermelha a partir do dia 01/07/2022?
SELECT COUNT(*) 
FROM Carona 
WHERE destino = 'Praia Vermelha'
AND data_hora >= '2022-07-01'


-- 2 - Quais os nomes dos usuários que disponibilizam caronas com partida em São Gonçalo?
SELECT nome FROM Identificacao i
JOIN Usuario u
ON u.idIdentificacao = i.idIdentificacao
JOIN Carona c
ON u.idUsuario = c.idUsuario
WHERE partida = 'São Gonçalo'


-- 3 - Quais os nomes dos usuários que disponibilizam caronas com pelo menos 2 passageiros e com parada no Plaza Shopping?
SELECT nome FROM Identificacao i
JOIN Usuario u
ON u.idIdentificacao = i.idIdentificacao
JOIN Carona c
ON u.idUsuario = c.idUsuario
JOIN Parada p
ON c.idCarona = p.idCarona
WHERE passageiros >= 2 
-- Deixei com LIKE embaixo pra pegar descrições do tipo "Em frente ao Plaza Shopping"
AND descricao LIKE '%Plaza Shopping%'