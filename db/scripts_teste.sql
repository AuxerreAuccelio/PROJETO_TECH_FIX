PRAGMA foreign_keys = ON;

-- 1. Cria as tabelas
CREATE TABLE funcao (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_funcao TEXT NOT NULL COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1
) STRICT;


CREATE TABLE funcionario (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_funcionario TEXT NOT NULL COLLATE NOCASE,
	status INTEGER NOT NULL DEFAULT 1,
	id_funcao INTEGER NOT NULL,
	data_admissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
	FOREIGN KEY (id_funcao) REFERENCES funcao (id) ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE (id, id_funcao)
) STRICT;


-- 2. Insere as funções
INSERT INTO funcao (nome_funcao) VALUES ('Gerente');
INSERT INTO funcao (nome_funcao) VALUES ('Atendente');
INSERT INTO funcao (nome_funcao) VALUES ('Técnico');


CREATE TABLE cliente (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_cliente TEXT NOT NULL COLLATE NOCASE,
	status INTEGER NOT NULL DEFAULT 1,
	email TEXT NOT NULL UNIQUE,	
	id_funcionario INTEGER NOT NULL,
	id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2 ),
	data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),	
	FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;


-- 4. Cria tabela
CREATE TABLE equipamento (
	
) STRICT;



-- 3. Insere funcionários (precisamos garantir que o ID 5 exista!)
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Ana', 1);       -- ID 1
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Bruno', 2);     -- ID 2
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Carlos', 3);    -- ID 3
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Daniel', 3);    -- ID 4
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Eduardo', 3);   -- ID 5 (Este é o que você quer!)
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Fabiana', 2);   -- ID 6 
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Gabriel', 3);   -- ID 7 
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Hector', 1);   	-- ID 8 
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Iago', 3);   	-- ID 9 
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Juarez', 3);  	-- ID 10


INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_funcao) 
VALUES ('João', 'joao@gmail.com', 2, (SELECT id_funcao FROM funcionario WHERE id = 2));

INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_funcao) 
VALUES ('Marie', 'marie@gmail.com', 1, (SELECT id_funcao FROM funcionario WHERE id = 1));



-- let USER = `SELECT id_funcao FROM funcionario WHERE id = ${id_usuario}`; --
DROP TABLE cliente;



