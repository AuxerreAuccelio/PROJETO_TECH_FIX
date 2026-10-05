PRAGMA foreign_keys = ON;

-- ============================================================================
-- 1. ESTRUTURA (DDL)
-- ============================================================================

-- 1. Cria a tabela funcao
CREATE TABLE funcao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_funcao TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1
) STRICT;

-- 2. Cria a tabela funcionario
CREATE TABLE funcionario (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_funcionario TEXT NOT NULL COLLATE NOCASE,
    status INTEGER NOT NULL DEFAULT 1,
    id_funcao INTEGER NOT NULL,
    data_admissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    FOREIGN KEY (id_funcao) REFERENCES funcao (id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (id, id_funcao)
) STRICT;

-- 3. Cria tabela cliente
CREATE TABLE cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_cliente TEXT NOT NULL COLLATE NOCASE,
    status INTEGER NOT NULL DEFAULT 1,
    email TEXT NOT NULL UNIQUE,	
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2),
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),	
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 4. Cria tabela categoria
CREATE TABLE categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_categoria TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1,
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),	
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2),
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)	
) STRICT;

-- 5. Cria tabela marca
CREATE TABLE marca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_marca TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1,
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2),
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 6. Cria tabela modelo
CREATE TABLE modelo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_modelo TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1,
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2),
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 7. Cria tabela tipo
CREATE TABLE tipo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_tipo TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1,
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2),
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 8. Cria tabela forma_pagamento
CREATE TABLE forma_pagamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_forma_pagamento TEXT NOT NULL COLLATE NOCASE UNIQUE, 
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1),
    status INTEGER NOT NULL DEFAULT 1,
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),	
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 9. Cria tabela situacao (ADICIONADA PARA EVITAR ERRO DE FK)
CREATE TABLE situacao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_situacao TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1
) STRICT;

-- 10. Cria tabela equipamento
CREATE TABLE equipamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_equipamento TEXT NOT NULL COLLATE NOCASE,
    status INTEGER NOT NULL DEFAULT 1,
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_marca INTEGER NOT NULL,
    id_modelo INTEGER NOT NULL,
    id_tipo INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2),
    numero_serie TEXT NOT NULL COLLATE NOCASE,
    imei TEXT COLLATE NOCASE UNIQUE,
    FOREIGN KEY (id_marca) REFERENCES marca(id),
    FOREIGN KEY (id_modelo) REFERENCES modelo(id),
    FOREIGN KEY (id_tipo) REFERENCES tipo(id),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 11. Cria tabela servicos
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

-- 12. Cria tabela pecas
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

-- 13. Cria tabela ordem
CREATE TABLE ordem (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_equipamento INTEGER NOT NULL,
    id_funcionario_abertura INTEGER NOT NULL,
    id_funcionario_funcao_abertura INTEGER NOT NULL CHECK (id_funcionario_funcao_abertura = 1 OR id_funcionario_funcao_abertura = 2),
    data_abertura TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    data_fechamento TEXT,
    id_forma_pagamento INTEGER NOT NULL,
    id_situacao_atual INTEGER NOT NULL,
    descricao_defeito TEXT NOT NULL,
    defeito_constatado TEXT,
    valor_total INTEGER,
    id_tecnico INTEGER NOT NULL,
    id_tecnico_funcao INTEGER NOT NULL CHECK (id_tecnico_funcao = 3),
    FOREIGN KEY (id_equipamento) REFERENCES equipamento(id),
    FOREIGN KEY (id_funcionario_abertura, id_funcionario_funcao_abertura) REFERENCES funcionario(id, id_funcao),
    FOREIGN KEY (id_tecnico, id_tecnico_funcao) REFERENCES funcionario(id, id_funcao),
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id),
    FOREIGN KEY (id_situacao_atual) REFERENCES situacao(id)
) STRICT;

-- 14. Cria tabela ordem_servicos
CREATE TABLE ordem_servicos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_servico INTEGER NOT NULL,
    valor_unitario INTEGER NOT NULL,
    id_tecnico INTEGER NOT NULL,
    id_tecnico_funcao INTEGER NOT NULL CHECK (id_tecnico_funcao = 3),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_servico) REFERENCES servicos(id),
    FOREIGN KEY (id_tecnico, id_tecnico_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 15. Cria tabela ordem_situacao
CREATE TABLE ordem_situacao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_nova_situacao INTEGER NOT NULL,
    id_tecnico INTEGER NOT NULL,
    id_tecnico_funcao INTEGER NOT NULL CHECK (id_tecnico_funcao = 3),
    data_situacao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),   
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_nova_situacao) REFERENCES situacao(id),
    FOREIGN KEY (id_tecnico, id_tecnico_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 16. Cria tabela ordem_pecas
CREATE TABLE ordem_pecas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_peca INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    valor_unitario INTEGER NOT NULL,
    data_saida TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_tecnico INTEGER NOT NULL,
    id_tecnico_funcao INTEGER NOT NULL CHECK (id_tecnico_funcao = 3),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_peca) REFERENCES pecas(id),
    FOREIGN KEY (id_tecnico, id_tecnico_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- ============================================================================
-- 2. INSERÇÕES (DML)
-- ============================================================================

BEGIN TRANSACTION;

-- Insere as funções
INSERT INTO funcao (nome_funcao) VALUES ('Gerente');
INSERT INTO funcao (nome_funcao) VALUES ('Atendente');
INSERT INTO funcao (nome_funcao) VALUES ('Técnico');

-- Insere funcionários 
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Ana', 1);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Bruno', 2);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Carlos', 3);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Daniel', 3);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Eduardo', 3);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Fabiana', 2);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Gabriel', 3);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Hector', 1);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Iago', 3);
INSERT INTO funcionario (nome_funcionario, id_funcao) VALUES ('Juarez', 3);

-- Insere clientes
INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_funcao) 
VALUES ('João', 'joao@gmail.com', 2, (SELECT id_funcao FROM funcionario WHERE id = 2));

INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_funcao) 
VALUES ('Marie', 'marie@gmail.com', 1, (SELECT id_funcao FROM funcionario WHERE id = 1));

-- Insere categorias
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('celulares', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('smart tvs', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('redes', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('videogames', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('áudio', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('recuperação de dados', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('eletrônica avançada', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('informática', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('insumos', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('acessórios', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('telas', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('baterias', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('componentes', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('carcaças', 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES ('tvs', 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Insere serviços
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Formatação e Instalação de Sistema Operacional', 1, 12000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Limpeza Interna e Troca de Pasta Térmica', 1, 15000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Upgrade de Hardware (RAM/SSD)', 1, 8000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Remoção de Vírus e Malwares', 1, 10000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Tela de Notebook', 1, 18000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Display/Frontal de Celular', 2, 15000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Bateria de Smartphone', 2, 9000, 0.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Desoxidação após Contato com Líquido', 2, 20000, 3.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo em Conector de Carga (Micro USB / Type-C)', 2, 11000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Vidro Traseiro de Smartphone a Laser / Manual', 2, 18000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Barra de LED de Smart TV', 3, 35000, 3.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo na Placa Principal de Smart TV', 3, 28000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Conserto de Fonte de Alimentação Interna (TV)', 3, 22000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Configuração de Rede e Roteador Wi-Fi', 4, 9000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Higienização e Troca de Metal Líquido / Pasta Térmica (Console)', 5, 22000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)', 5, 8000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Substituição de HDMI / Conector de Vídeo (Console)', 5, 25000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Bateria de Caixa de Som Portátil (Bluetooth)', 6, 12000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Troca de Almofadas / Reparo de Cabo de Headset Gamer', 6, 7000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador', 6, 9500, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Recuperação de Dados de HD / SSD / Pendrive Danificado', 7, 30000, 4.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo', 8, 45000, 5.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES ('Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)', 8, 16000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

-- Insere peças
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('SSD NVMe 512GB M.2', 8, 14000, 26000, 15, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('SSD SATA III 480GB 2.5"', 8, 11000, 21000, 20, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Memória RAM DDR4 8GB 2666MHz (Notebook)', 8, 9000, 17000, 12, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Memória RAM DDR4 16GB 3200MHz (Desktop)', 8, 18000, 32000, 8, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Pasta Térmica de Alta Performance (Bisnaga 4g)', 9, 2500, 6000, 25, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fonte ATX 500W 80 Plus Bronze', 8, 19000, 34000, 6, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Célula Moeda CR2032 (Cartela c/ 5)', 9, 800, 2500, 30, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Cooler para Processador Socket Universal', 8, 4500, 9500, 10, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Cabo SATA III 6Gbps 50cm', 10, 300, 1500, 50, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Tela LED 15.6" Slim 30 Pinos Full HD', 11, 28000, 48000, 5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Display Frontal Completo iPhone 11', 11, 18000, 35000, 4, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Display Frontal Completo Samsung Galaxy A54', 11, 16000, 31000, 6, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Display Frontal Completo Motorola Moto G84', 11, 14000, 28000, 5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Compatível iPhone 11 (3110mAh)', 12, 7500, 16000, 8, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Compatível Samsung Galaxy A32', 12, 6000, 13000, 7, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Bateria Compatível Moto G30', 12, 5500, 12000, 6, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Conector de Carga Type-C Universal (Unidade)', 13, 250, 2000, 100, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Conector de Carga Micro USB V8', 13, 150, 1500, 100, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Flex de Carga e Microfone Moto G9 Play', 13, 1800, 5500, 10, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Tampa Traseira de Vidro iPhone 12', 14, 4000, 11000, 4, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Câmera Traseira Principal Redmi Note 11', 13, 6500, 14000, 3, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Alto-Falante Auricular Universal', 13, 500, 2500, 40, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Barra de LED TV Samsung 50" (Kit com 3 barras)', 15, 11000, 23000, 4, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Barra de LED TV LG 43" (Kit com 3 barras)', 15, 9500, 19500, 5, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Placa Fonte TV Samsung UN50TU8000', 15, 16000, 31000, 2, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Placa Principal TV LG 43UP7500', 15, 21000, 42000, 2, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Cabo Flat T-Con para Display TV 55"', 15, 2200, 6500, 8, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Receptor Infravermelho para Controle Remoto TV', 13, 400, 2000, 15, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)', 9, 8500, 15000, 3, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Álcool Isopropílico 99.8% 1 Litro', 9, 2200, 4500, 12, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fita Kapton Térmica 10mm x 33m', 9, 1200, 3000, 15, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fita Dupla Face Fixação de Telas (3mm x 50m)', 9, 1500, 3500, 10, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Fusível de Louça 5A 250V (Pacote c/ 10)', 13, 500, 1800, 20, 1, (SELECT id_funcao FROM funcionario WHERE id=1));
INSERT INTO pecas (nome_peca, id_categoria, preco_compra, preco_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES ('Capacitor Eletrolítico 1000uF x 25V', 13, 80, 500, 150, 1, (SELECT id_funcao FROM funcionario WHERE id=1));

COMMIT;

-- ============================================================================
-- 3. CONSULTAS E VIEWS
-- ============================================================================

CREATE VIEW vw_preco_venda_maior_100 AS 
SELECT id, nome_peca, preco_venda, estoque_atual 
FROM pecas 
WHERE preco_venda >= 10000;

SELECT * FROM vw_preco_venda_maior_100;






-- let USER = `SELECT id_funcao FROM funcionario WHERE id = ${id_usuario}`; --
DROP TABLE cliente;

DROP TABLE pecas;


















































































