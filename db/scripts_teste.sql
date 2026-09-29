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



CREATE TABLE categoria (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_categoria TEXT NOT NULL COLLATE NOCASE UNIQUE,
	status INTEGER NOT NULL DEFAULT 1,
	data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),	
	id_funcionario INTEGER NOT NULL,
	id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2 ),
	FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)	
) STRICT;



INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('celulares', 1, (SELECT id_funcao FROM funcionario WHERE id=1));


-- Categorias dos serviços
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('smart tvs', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('redes', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('videogames', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('áudio', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('recuperação de dados', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('eletrônica avançada', 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Categorias das peças
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('informática', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('insumos', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('acessórios', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('telas', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('baterias', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('componentes', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('carcaças', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('tvs', 1, (SELECT id_funcao FROM funcionario WHERE id=1));







CREATE TABLE servicos (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_servicos TEXT NOT NULL COLLATE NOCASE UNIQUE,
	preco INTEGER NOT NULL,
	horas_trabalho REAL NOT NULL,
	id_categoria INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1),
	status INTEGER NOT NULL DEFAULT 1,
	data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),	
	FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao),
	FOREIGN KEY (id_categoria) REFERENCES categoria(id)
) STRICT;



-- Computadores (1)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Formatação e Instalação de Sistema Operacional', 1, 12000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Limpeza Interna e Troca de Pasta Térmica', 1, 15000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Upgrade de Hardware (RAM/SSD)', 1, 8000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Remoção de Vírus e Malwares', 1, 10000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Tela de Notebook', 1, 18000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Celulares (2)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Display/Frontal de Celular', 2, 15000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Bateria de Smartphone', 2, 9000, 0.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Desoxidação após Contato com Líquido', 2, 20000, 3.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo em Conector de Carga (Micro USB / Type-C)', 2, 11000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Vidro Traseiro de Smartphone a Laser / Manual', 2, 18000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Smart TVs (3)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Barra de LED de Smart TV', 3, 35000, 3.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo na Placa Principal de Smart TV', 3, 28000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Conserto de Fonte de Alimentação Interna (TV)', 3, 22000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Redes (4)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Configuração de Rede e Roteador Wi-Fi', 4, 9000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Videogames (5)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Higienização e Troca de Metal Líquido / Pasta Térmica (Console)', 5, 22000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)', 5, 8000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Substituição de HDMI / Conector de Vídeo (Console)', 5, 25000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Áudio (6)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Bateria de Caixa de Som Portátil (Bluetooth)', 6, 12000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Almofadas / Reparo de Cabo de Headset Gamer', 6, 7000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador', 6, 9500, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Recuperação de Dados (7)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Recuperação de Dados de HD / SSD / Pendrive Danificado', 7, 30000, 4.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Eletrônica Avançada (8)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo', 8, 45000, 5.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)', 8, 16000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));





CREATE TABLE pecas (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_peca TEXT NOT NULL COLLATE NOCASE,
	id_categoria INTEGER NOT NULL,
	preco_compra INTEGER NOT NULL,
	preco_venda INTEGER NOT NULL,
	estoque_atual INTEGER NOT NULL,
	id_funcionario INTEGER NOT NULL,
	id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1),
	status INTEGER NOT NULL DEFAULT 1,
	data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),	
	FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao),
	FOREIGN KEY (id_categoria) REFERENCES categoria(id)
) STRICT;

DROP TABLE pecas;


PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- Informática / Computadores
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('SSD NVMe 512GB M.2', 9, 14000, 26000, 15, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('SSD SATA III 480GB 2.5"', 9, 11000, 21000, 20, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Memória RAM DDR4 8GB 2666MHz (Notebook)', 9, 9000, 17000, 12, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Memória RAM DDR4 16GB 3200MHz (Desktop)', 9, 18000, 32000, 8, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Pasta Térmica de Alta Performance (Bisnaga 4g)', 10, 2500, 6000, 25, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fonte ATX 500W 80 Plus Bronze', 9, 19000, 34000, 6, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Célula Moeda CR2032 (Cartela c/ 5)', 10, 800, 2500, 30, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Cooler para Processador Socket Universal', 9, 4500, 9500, 10, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Cabo SATA III 6Gbps 50cm', 11, 300, 1500, 50, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Tela LED 15.6" Slim 30 Pinos Full HD', 12, 28000, 48000, 5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Smartphones / Celulares
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Display Frontal Completo iPhone 11', 12, 18000, 35000, 4, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Display Frontal Completo Samsung Galaxy A54', 12, 16000, 31000, 6, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Display Frontal Completo Motorola Moto G84', 12, 14000, 28000, 5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Compatível iPhone 11 (3110mAh)', 13, 7500, 16000, 8, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Compatível Samsung Galaxy A32', 13, 6000, 13000, 7, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Compatível Moto G30', 13, 5500, 12000, 6, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Conector de Carga Type-C Universal (Unidade)', 14, 250, 2000, 100, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Conector de Carga Micro USB V8', 14, 150, 1500, 100, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Flex de Carga e Microfone Moto G9 Play', 14, 1800, 5500, 10, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Tampa Traseira de Vidro iPhone 12', 15, 4000, 11000, 4, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Câmera Traseira Principal Redmi Note 11', 14, 6500, 14000, 3, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Alto-Falante Auricular Universal', 14, 500, 2500, 40, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Smart TVs
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Barra de LED TV Samsung 50" (Kit com 3 barras)', 16, 11000, 23000, 4, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Barra de LED TV LG 43" (Kit com 3 barras)', 16, 9500, 19500, 5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Placa Fonte TV Samsung UN50TU8000', 16, 16000, 31000, 2, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Placa Principal TV LG 43UP7500', 16, 21000, 42000, 2, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Cabo Flat T-Con para Display TV 55"', 16, 2200, 6500, 8, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Receptor Infravermelho para Controle Remoto TV', 14, 400, 2000, 15, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Insumos e Componentes Genéricos
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)', 10, 8500, 15000, 3, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Álcool Isopropílico 99.8% 1 Litro', 10, 2200, 4500, 12, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fita Kapton Térmica 10mm x 33m', 10, 1200, 3000, 15, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fita Dupla Face Fixação de Telas (3mm x 50m)', 10, 1500, 3500, 10, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fusível de Louça 5A 250V (Pacote c/ 10)', 14, 500, 1800, 20, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Capacitor Eletrolítico 1000uF x 25V', 14, 80, 500, 150, 1, (SELECT id_funcao FROM funcionario WHERE id=1));



SELECT * FROM pecas WHERE preco_venda >= 10000;

CREATE VIEW vw_preco_venda_maior_100 AS SELECT id, nome_peca, preco_venda, estoque_atual FROM pecas WHERE preco_venda >= 10000;

SELECT * FROM vw_preco_venda_maior_100 vpvm;












































































