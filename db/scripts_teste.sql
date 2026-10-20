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
    preco_sugerido_venda INTEGER NOT NULL,    
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
    defeito_relatado TEXT,
    defeito_constatado TEXT,
    data_abertura TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    data_fechamento TEXT,
    valor_total INTEGER,
    id_forma_pagamento INTEGER NOT NULL,
    id_funcionario_abertura INTEGER NOT NULL,
    id_funcionario_funcao_abertura INTEGER NOT NULL CHECK (id_funcionario_funcao_abertura = 1 OR id_funcionario_funcao_abertura = 2),
    id_tecnico INTEGER NOT NULL,
    id_tecnico_funcao INTEGER NOT NULL CHECK (id_tecnico_funcao = 3),   
    FOREIGN KEY (id_equipamento) REFERENCES equipamento(id),  
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id),
    FOREIGN KEY (id_funcionario_abertura, id_funcionario_funcao_abertura) REFERENCES funcionario(id, id_funcao),
    FOREIGN KEY (id_tecnico, id_tecnico_funcao) REFERENCES funcionario(id, id_funcao)    
) STRICT;

-- 14. Cria tabela ordem_servicos
CREATE TABLE ordem_servicos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_servico INTEGER NOT NULL,
    preco INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    data_execucao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_servico) REFERENCES servicos(id)    
) STRICT;

-- 15. Cria tabela ordem_situacao
CREATE TABLE ordem_situacao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_nova_situacao INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,    
    data_situacao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),   
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
    FOREIGN KEY (id_nova_situacao) REFERENCES situacao(id)    
) STRICT;

-- 16. Cria tabela ordem_pecas
CREATE TABLE ordem_pecas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem INTEGER NOT NULL,
    id_peca INTEGER NOT NULL,    
    preco INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    data_saida TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),    
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_peca) REFERENCES pecas(id)    
) STRICT;



-- 17. Cria tabela entrada_pecas
CREATE TABLE entrada_pecas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_custo INTEGER NOT NULL CHECK (preco_custo >= 0),
    preco_venda_sugerido INTEGER NOT NULL CHECK (preco_venda_sugerido >= 0),
    data_entrada TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1), -- só Gerente
    FOREIGN KEY (id_peca) REFERENCES pecas(id),
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

CREATE TRIGGER trg_entrada_pecas_atualiza_estoque
AFTER INSERT ON entrada_pecas
BEGIN
    UPDATE pecas
    SET estoque_atual = estoque_atual + NEW.quantidade,
        preco_sugerido_venda = NEW.preco_venda_sugerido  -- mantém o último preço sugerido
    WHERE id = NEW.id_peca;
END;



-- 18. Cria tabela motivo_saida
CREATE TABLE motivo_saida (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_motivo TEXT NOT NULL COLLATE NOCASE UNIQUE
) STRICT;

CREATE TABLE saida_pecas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca INTEGER NOT NULL,
    id_motivo INTEGER NOT NULL CHECK (id_motivo IN (1, 2)), -- 1 = Uso em reparo, 2 = Descarte
    id_ordem INTEGER,                                       -- obrigatório só no uso em reparo
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    valor_unitario INTEGER NOT NULL CHECK (valor_unitario >= 0),
    data_saida TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_tecnico INTEGER NOT NULL,
    id_tecnico_funcao INTEGER NOT NULL CHECK (id_tecnico_funcao = 3),
    CHECK ((id_motivo = 1 AND id_ordem IS NOT NULL)
        OR (id_motivo = 2 AND id_ordem IS NULL)),
    FOREIGN KEY (id_peca) REFERENCES pecas(id),
    FOREIGN KEY (id_motivo) REFERENCES motivo_saida(id),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_tecnico, id_tecnico_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- Bloqueia estoque negativo
CREATE TRIGGER trg_saida_pecas_valida_estoque
BEFORE INSERT ON saida_pecas
WHEN NEW.quantidade > (SELECT estoque_atual FROM pecas WHERE id = NEW.id_peca)
BEGIN
    SELECT RAISE(ABORT, 'Estoque insuficiente para a baixa da peça');
END;

-- Dá a baixa
CREATE TRIGGER trg_saida_pecas_atualiza_estoque
AFTER INSERT ON saida_pecas
BEGIN
    UPDATE pecas
    SET estoque_atual = estoque_atual - NEW.quantidade
    WHERE id = NEW.id_peca;
END;



-- 19. Cria tabela saida_peca
CREATE TABLE saida_peca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca INTEGER NOT NULL,
    id_ordem INTEGER,                                   -- nulo no descarte
    quantidade_saida INTEGER NOT NULL CHECK (quantidade_saida > 0),
    valor_saida INTEGER NOT NULL CHECK (valor_saida > 0),
    numero_serie TEXT NOT NULL COLLATE NOCASE,
    numero_lote TEXT NOT NULL COLLATE NOCASE,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 3),  -- só Técnico
    id_situacao INTEGER NOT NULL,
    data_saida TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    CHECK ((id_situacao = 9 AND id_ordem IS NOT NULL)   -- uso em reparo exige OS
        OR (id_situacao = 8 AND id_ordem IS NULL)),     -- descarte não tem OS
    FOREIGN KEY (id_peca) REFERENCES pecas(id),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao),
    FOREIGN KEY (id_situacao) REFERENCES situacao(id)
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

-- Insere peças (estoque zerado; o estoque entra via entrada_pecas)
INSERT INTO pecas (nome_peca, id_categoria, preco_sugerido_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES
('SSD NVMe 512GB M.2', 8, 26000, 0, 1, 1),
('SSD SATA III 480GB 2.5"', 8, 21000, 0, 1, 1),
('Memória RAM DDR4 8GB 2666MHz (Notebook)', 8, 17000, 0, 1, 1),
('Memória RAM DDR4 16GB 3200MHz (Desktop)', 8, 32000, 0, 1, 1),
('Pasta Térmica de Alta Performance (Bisnaga 4g)', 9, 6000, 0, 1, 1),
('Fonte ATX 500W 80 Plus Bronze', 8, 34000, 0, 1, 1),
('Bateria Célula Moeda CR2032 (Cartela c/ 5)', 9, 2500, 0, 1, 1),
('Cooler para Processador Socket Universal', 8, 9500, 0, 1, 1),
('Cabo SATA III 6Gbps 50cm', 10, 1500, 0, 1, 1),
('Tela LED 15.6" Slim 30 Pinos Full HD', 11, 48000, 0, 1, 1),
('Display Frontal Completo iPhone 11', 11, 35000, 0, 1, 1),
('Display Frontal Completo Samsung Galaxy A54', 11, 31000, 0, 1, 1),
('Display Frontal Completo Motorola Moto G84', 11, 28000, 0, 1, 1),
('Bateria Compatível iPhone 11 (3110mAh)', 12, 16000, 0, 1, 1),
('Bateria Compatível Samsung Galaxy A32', 12, 13000, 0, 1, 1),
('Bateria Compatível Moto G30', 12, 12000, 0, 1, 1),
('Conector de Carga Type-C Universal (Unidade)', 13, 2000, 0, 1, 1),
('Conector de Carga Micro USB V8', 13, 1500, 0, 1, 1),
('Flex de Carga e Microfone Moto G9 Play', 13, 5500, 0, 1, 1),
('Tampa Traseira de Vidro iPhone 12', 14, 11000, 0, 1, 1),
('Câmera Traseira Principal Redmi Note 11', 13, 14000, 0, 1, 1),
('Alto-Falante Auricular Universal', 13, 2500, 0, 1, 1),
('Barra de LED TV Samsung 50" (Kit com 3 barras)', 15, 23000, 0, 1, 1),
('Barra de LED TV LG 43" (Kit com 3 barras)', 15, 19500, 0, 1, 1),
('Placa Fonte TV Samsung UN50TU8000', 15, 31000, 0, 1, 1),
('Placa Principal TV LG 43UP7500', 15, 42000, 0, 1, 1),
('Cabo Flat T-Con para Display TV 55"', 15, 6500, 0, 1, 1),
('Receptor Infravermelho para Controle Remoto TV', 13, 2000, 0, 1, 1),
('Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)', 9, 15000, 0, 1, 1),
('Álcool Isopropílico 99.8% 1 Litro', 9, 4500, 0, 1, 1),
('Fita Kapton Térmica 10mm x 33m', 9, 3000, 0, 1, 1),
('Fita Dupla Face Fixação de Telas (3mm x 50m)', 9, 3500, 0, 1, 1),
('Fusível de Louça 5A 250V (Pacote c/ 10)', 13, 1800, 0, 1, 1),
('Capacitor Eletrolítico 1000uF x 25V', 13, 500, 0, 1, 1);





COMMIT;

-- ============================================================================
-- 3. CONSULTAS E VIEWS
-- ============================================================================

CREATE VIEW vw_preco_venda_maior_100 AS 
SELECT id, nome_peca, preco_venda, estoque_atual 
FROM pecas 
WHERE preco_venda >= 10000;

SELECT * FROM vw_preco_venda_maior_100;














aberto
em diagnóstico
orçamento aprovado
em Reparo
pronto
entregue
cancelado
descarte por defeito/avaria
uso em reparo ordem_servicos

deve se conectar com a tabela pecas
