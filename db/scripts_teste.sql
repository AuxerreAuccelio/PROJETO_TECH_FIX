PRAGMA foreign_keys = ON;

-- Verifica se as chaves estrangeiras estão ativas
PRAGMA foreign_keys;

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
    email TEXT NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1 OR id_funcionario_funcao = 2),
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao)
) STRICT;

-- 4. Cria tabela categoria (somente Gerente cadastra)
CREATE TABLE categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_categoria TEXT NOT NULL COLLATE NOCASE UNIQUE,
    status INTEGER NOT NULL DEFAULT 1,
    data_emissao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1),
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

-- 9. Cria tabela situacao
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
    numero_serie TEXT DEFAULT(NULL) COLLATE NOCASE,
    imei TEXT DEFAULT(NULL) COLLATE NOCASE UNIQUE,
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
    nome_peca TEXT NOT NULL COLLATE NOCASE UNIQUE,
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
    defeito_relatado TEXT NOT NULL COLLATE NOCASE,
    defeito_constatado TEXT DEFAULT('') COLLATE NOCASE,
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

-- 19. Cria tabela saida_peca (baixa de peças registrada pelo Gerente)
--     Situação 4 = Em Reparo (exige OS) | Situação 8 = Descarte por Defeito/Avaria (sem OS)
CREATE TABLE saida_peca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca INTEGER NOT NULL,
    id_ordem INTEGER,                                   -- nulo no descarte
    quantidade_saida INTEGER NOT NULL CHECK (quantidade_saida > 0),
    valor_saida INTEGER NOT NULL CHECK (valor_saida > 0),
    numero_serie TEXT DEFAULT(NULL) COLLATE NOCASE,
    numero_lote TEXT DEFAULT(NULL) COLLATE NOCASE,
    id_funcionario INTEGER NOT NULL,
    id_funcionario_funcao INTEGER NOT NULL CHECK (id_funcionario_funcao = 1),  -- só Gerente
    id_situacao INTEGER NOT NULL,
    data_saida TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    CHECK ((id_situacao = 4 AND id_ordem IS NOT NULL)   -- uso em reparo exige OS
        OR (id_situacao = 8 AND id_ordem IS NULL)),     -- descarte não tem OS
    FOREIGN KEY (id_peca) REFERENCES pecas(id),
    FOREIGN KEY (id_ordem) REFERENCES ordem(id) ON DELETE CASCADE,
    FOREIGN KEY (id_funcionario, id_funcionario_funcao) REFERENCES funcionario(id, id_funcao),
    FOREIGN KEY (id_situacao) REFERENCES situacao(id)
) STRICT;


-- ============================================================================
-- 2. INSERÇÕES (DML)
-- ============================================================================
-- Mapa de funcionários usado nos dados:
--   Gerente   : 1 (Ana)
--   Atendentes: 2 (Bruno), 6 (Fabiana)
--   Técnicos  : 3 (Carlos), 4 (Daniel)

BEGIN TRANSACTION;

-- 2.1. Funções
INSERT INTO funcao (nome_funcao) VALUES ('Gerente');
INSERT INTO funcao (nome_funcao) VALUES ('Atendente');
INSERT INTO funcao (nome_funcao) VALUES ('Técnico');

-- 2.2. Funcionários
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

-- 2.3. Clientes (Atendentes ou Gerente)
INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_funcao) VALUES
('Marcos Vinicius Souza',    'marcos.souza@email.com',      2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Fernanda Maria Oliveira',  'fernanda.oliveira@email.com', 2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Roberto Carlos Andrade',   'roberto.andrade@email.com',   6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Camila de Cassia Martins', 'camila.martins@email.com',    6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Patricia Ferreira Lima',   'patricia.lima@email.com',     2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Lucas Gabriel Barbosa',    'lucas.barbosa@email.com',     1, (SELECT id_funcao FROM funcionario WHERE id = 1));

INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_funcao)
VALUES ('João', 'joao@gmail.com', 2, (SELECT id_funcao FROM funcionario WHERE id = 2));

INSERT INTO cliente (nome_cliente, email, id_funcionario, id_funcionario_funcao)
VALUES ('Marie', 'marie@gmail.com', 1, (SELECT id_funcao FROM funcionario WHERE id = 1));

-- 2.4. Categorias (somente Gerente) - mesma ordem/ids do modelo do professor
INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_funcao) VALUES
('acessórios',           1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('áudio',                1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('baterias',             1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('carcaças',             1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('celulares',            1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('componentes',          1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('computadores',         1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('eletrônica avançada',  1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('informática',          1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('insumos',              1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('recuperação de dados', 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('redes',                1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('smart tvs',            1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('telas',                1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('tvs',                  1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('videogames',           1, (SELECT id_funcao FROM funcionario WHERE id = 1));

-- 2.5. Serviços (mesma ordem/ids do modelo do professor)
INSERT INTO servicos (nome_servicos, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_funcao) VALUES
('Formatação e Instalação de Sistema Operacional', 1, 12000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Limpeza Interna e Troca de Pasta Térmica', 1, 15000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Upgrade de Hardware (RAM/SSD)', 1, 8000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Remoção de Vírus e Malwares', 1, 10000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Troca de Tela de Notebook', 1, 18000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Troca de Display/Frontal de Celular', 2, 15000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Troca de Bateria de Smartphone', 2, 9000, 0.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Desoxidação após Contato com Líquido', 2, 20000, 3.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Reparo em Conector de Carga (Micro USB / Type-C)', 2, 11000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Troca de Barra de LED de Smart TV', 13, 35000, 3.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Reparo na Placa Principal de Smart TV', 13, 28000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Conserto de Fonte de Alimentação Interna (TV)', 13, 22000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Configuração de Rede e Roteador Wi-Fi', 12, 9000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Higienização e Troca de Metal Líquido / Pasta Térmica (Console)', 16, 22000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)', 16, 8000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Substituição de HDMI / Conector de Vídeo (Console)', 16, 25000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Troca de Bateria de Caixa de Som Portátil (Bluetooth)', 4, 12000, 1.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Troca de Almofadas / Reparo de Cabo de Headset Gamer', 4, 7000, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Recuperação de Dados de HD / SSD / Pendrive Danificado', 11, 30000, 4.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo', 8, 45000, 5.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)', 8, 16000, 2.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Troca de Vidro Traseiro de Smartphone a Laser / Manual', 2, 18000, 2.5, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador', 4, 9500, 1.0, 1, (SELECT id_funcao FROM funcionario WHERE id = 1));

-- 2.6. Peças (estoque zerado; o estoque entra via entrada_pecas)
INSERT INTO pecas (nome_peca, id_categoria, preco_sugerido_venda, estoque_atual, id_funcionario, id_funcionario_funcao) VALUES
-- Informática / Computadores
('SSD NVMe 512GB M.2', 9, 26000, 0, 1, 1),
('SSD SATA III 480GB 2.5"', 9, 21000, 0, 1, 1),
('Memória RAM DDR4 8GB 2666MHz (Notebook)', 9, 17000, 0, 1, 1),
('Memória RAM DDR4 16GB 3200MHz (Desktop)', 9, 32000, 0, 1, 1),
('Pasta Térmica de Alta Performance (Bisnaga 4g)', 10, 6000, 0, 1, 1),
('Fonte ATX 500W 80 Plus Bronze', 9, 34000, 0, 1, 1),
('Bateria Célula Moeda CR2032 (Cartela c/ 5)', 10, 2500, 0, 1, 1),
('Cooler para Processador Socket Universal', 9, 9500, 0, 1, 1),
('Cabo SATA III 6Gbps 50cm', 3, 1500, 0, 1, 1),
('Tela LED 15.6" Slim 30 Pinos Full HD', 14, 48000, 0, 1, 1),
-- Smartphones / Celulares
('Display Frontal Completo iPhone 11', 14, 35000, 0, 1, 1),
('Display Frontal Completo Samsung Galaxy A54', 14, 31000, 0, 1, 1),
('Display Frontal Completo Motorola Moto G84', 14, 28000, 0, 1, 1),
('Bateria Compatível iPhone 11 (3110mAh)', 5, 16000, 0, 1, 1),
('Bateria Compatível Samsung Galaxy A32', 5, 13000, 0, 1, 1),
('Bateria Compatível Moto G30', 5, 12000, 0, 1, 1),
('Conector de Carga Type-C Universal (Unidade)', 7, 2000, 0, 1, 1),
('Conector de Carga Micro USB V8', 7, 1500, 0, 1, 1),
('Flex de Carga e Microfone Moto G9 Play', 7, 5500, 0, 1, 1),
('Tampa Traseira de Vidro iPhone 12', 6, 11000, 0, 1, 1),
('Câmera Traseira Principal Redmi Note 11', 7, 14000, 0, 1, 1),
('Alto-Falante Auricular Universal', 7, 2500, 0, 1, 1),
-- Smart TVs
('Barra de LED TV Samsung 50" (Kit com 3 barras)', 15, 23000, 0, 1, 1),
('Barra de LED TV LG 43" (Kit com 3 barras)', 15, 19500, 0, 1, 1),
('Placa Fonte TV Samsung UN50TU8000', 15, 31000, 0, 1, 1),
('Placa Principal TV LG 43UP7500', 15, 42000, 0, 1, 1),
('Cabo Flat T-Con para Display TV 55"', 15, 6500, 0, 1, 1),
('Receptor Infravermelho para Controle Remoto TV', 7, 2000, 0, 1, 1),
-- Insumos e Componentes Genéricos
('Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)', 10, 15000, 0, 1, 1),
('Álcool Isopropílico 99.8% 1 Litro', 10, 4500, 0, 1, 1),
('Fita Kapton Térmica 10mm x 33m', 10, 3000, 0, 1, 1),
('Fita Dupla Face Fixação de Telas (3mm x 50m)', 10, 3500, 0, 1, 1),
('Fusível de Louça 5A 250V (Pacote c/ 10)', 7, 1800, 0, 1, 1),
('Capacitor Eletrolítico 1000uF x 25V', 7, 500, 0, 1, 1);

-- 2.7. Situações da Ordem de Serviço e Saída de Peças
-- (Aberto, Em Diagnóstico, Orçamento Aprovado, Em Reparo, Pronto, Entregue, Cancelado, Descarte)
INSERT INTO situacao (nome_situacao) VALUES
('Aberto'),
('Em Diagnóstico'),
('Orçamento Aprovado'),
('Em Reparo'),
('Pronto'),
('Entregue'),
('Cancelado'),
('Descarte por Defeito/Avaria');

-- 2.8. Motivos de saída (usados por saida_pecas)
INSERT INTO motivo_saida (nome_motivo) VALUES
('Uso em reparo'),
('Descarte');

-- 2.9. Formas de pagamento (somente Gerente)
INSERT INTO forma_pagamento (nome_forma_pagamento, id_funcionario, id_funcionario_funcao) VALUES
('Dinheiro',                      1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('PIX',                           1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Cartão de Débito',              1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Cartão de Crédito - À Vista',   1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Cartão de Crédito - Parcelado', 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Boleto Bancário',               1, (SELECT id_funcao FROM funcionario WHERE id = 1));

-- 2.10. Marcas (Atendentes ou Gerente)
INSERT INTO marca (nome_marca, id_funcionario, id_funcionario_funcao) VALUES
('Apple',    1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Samsung',  1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Motorola', 2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Xiaomi',   2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Dell',     6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Lenovo',   6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('LG',       1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Sony',     2, (SELECT id_funcao FROM funcionario WHERE id = 2));

-- 2.11. Modelos (Atendentes ou Gerente)
INSERT INTO modelo (nome_modelo, id_funcionario, id_funcionario_funcao) VALUES
('iPhone 11',              2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('iPhone 12',              2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Galaxy A54',             2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Galaxy A32',             6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Moto G84',               6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Moto G30',               6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Redmi Note 11',          2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Inspiron 15 3000',       1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('IdeaPad 3',              2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Smart TV 50 UN50TU8000', 6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Smart TV 43 43UP7500',   2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('PlayStation 5',          1, (SELECT id_funcao FROM funcionario WHERE id = 1));

-- 2.12. Tipos de equipamento (Atendentes ou Gerente)
INSERT INTO tipo (nome_tipo, id_funcionario, id_funcionario_funcao) VALUES
('Smartphone',             1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Notebook',               1, (SELECT id_funcao FROM funcionario WHERE id = 1)),
('Desktop',                2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Smart TV',               2, (SELECT id_funcao FROM funcionario WHERE id = 2)),
('Console de Videogame',   6, (SELECT id_funcao FROM funcionario WHERE id = 6)),
('Caixa de Som Bluetooth', 2, (SELECT id_funcao FROM funcionario WHERE id = 2));

-- 2.13. Equipamentos (Atendentes ou Gerente)
INSERT INTO equipamento (nome_equipamento, id_marca, id_modelo, id_tipo, id_cliente, id_funcionario, id_funcionario_funcao, numero_serie, imei) VALUES
('iPhone 11',                      1, 1,  1, 1, 2, (SELECT id_funcao FROM funcionario WHERE id = 2), NULL, '356789012345671'),
('Galaxy A54',                     2, 3,  1, 2, 2, (SELECT id_funcao FROM funcionario WHERE id = 2), NULL, '356789012345672'),
('Notebook Dell Inspiron 15 3000', 5, 8,  2, 3, 6, (SELECT id_funcao FROM funcionario WHERE id = 6), 'DELL-INSP-2023-998', NULL),
('Smart TV LG 43"',                7, 10, 4, 4, 6, (SELECT id_funcao FROM funcionario WHERE id = 6), 'LG-TV43-77612', NULL),
('PlayStation 5',                  8, 12, 5, 5, 2, (SELECT id_funcao FROM funcionario WHERE id = 2), 'PS5-SONY-009182', NULL),
('Moto G84',                       3, 5,  1, 6, 1, (SELECT id_funcao FROM funcionario WHERE id = 1), NULL, '356789012345673');

-- 2.14. Entradas de peças (somente Gerente) - o trigger atualiza o estoque
INSERT INTO entrada_pecas (id_peca, quantidade, preco_custo, preco_venda_sugerido, id_funcionario, id_funcionario_funcao) VALUES
(1,  20, 18000, 26000, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),  -- SSD NVMe
(3,  15, 11000, 17000, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),  -- RAM DDR4
(11, 10, 22000, 35000, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),  -- Tela iPhone 11
(14, 12,  9000, 16000, 1, (SELECT id_funcao FROM funcionario WHERE id = 1)),  -- Bateria iPhone 11
(23,  8, 14000, 23000, 1, (SELECT id_funcao FROM funcionario WHERE id = 1));  -- Barra LED TV Samsung

-- 2.15. Ordens de serviço
INSERT INTO ordem (id_equipamento, defeito_relatado, defeito_constatado, data_abertura, data_fechamento, valor_total,
                   id_forma_pagamento, id_funcionario_abertura, id_funcionario_funcao_abertura, id_tecnico, id_tecnico_funcao) VALUES
-- OS 1: Troca de tela do iPhone 11 (Entregue)
(1, 'Tela quebrada após queda.', 'Display frontal danificado, toque não responde.',
 '2026-09-01 09:30:00', '2026-09-02 16:00:00', 50000, 2,
 2, (SELECT id_funcao FROM funcionario WHERE id = 2), 3, (SELECT id_funcao FROM funcionario WHERE id = 3)),
-- OS 2: Upgrade de SSD em Notebook Dell (Pronto)
(3, 'Notebook muito lento para ligar.', 'Lentidão provocada por HD mecânico antigo.',
 '2026-09-10 10:15:00', '2026-09-11 14:30:00', 38000, 1,
 6, (SELECT id_funcao FROM funcionario WHERE id = 6), 4, (SELECT id_funcao FROM funcionario WHERE id = 4)),
-- OS 3: Smart TV em diagnóstico
(4, 'TV com som, mas imagem não aparece.', 'Barra de LED queimada.',
 '2026-09-15 11:00:00', NULL, NULL, 1,
 2, (SELECT id_funcao FROM funcionario WHERE id = 2), 3, (SELECT id_funcao FROM funcionario WHERE id = 3)),
-- OS 4: Console PS5 (Em Reparo)
(5, 'Desligando por aquecimento.', 'Acúmulo severo de poeira e necessidade de troca de pasta térmica.',
 '2026-09-20 14:20:00', NULL, NULL, 4,
 2, (SELECT id_funcao FROM funcionario WHERE id = 2), 4, (SELECT id_funcao FROM funcionario WHERE id = 4));

-- 2.16. Histórico de situações das OS
-- (Aberto = funcionário de abertura | demais mudanças = técnico responsável)
INSERT INTO ordem_situacao (id_ordem, id_nova_situacao, id_funcionario, data_situacao) VALUES
-- OS 1 (Aberto -> Em Diagnóstico -> Orçamento Aprovado -> Em Reparo -> Pronto -> Entregue)
(1, 1, 2, '2026-09-01 09:30:00'),
(1, 2, 3, '2026-09-01 10:00:00'),
(1, 3, 3, '2026-09-01 11:30:00'),
(1, 4, 3, '2026-09-01 14:00:00'),
(1, 5, 3, '2026-09-02 15:30:00'),
(1, 6, 2, '2026-09-02 16:00:00'),
-- OS 2 (Aberto -> Orçamento Aprovado -> Em Reparo -> Pronto)
(2, 1, 6, '2026-09-10 10:15:00'),
(2, 3, 4, '2026-09-10 10:45:00'),
(2, 4, 4, '2026-09-10 11:00:00'),
(2, 5, 4, '2026-09-11 14:30:00'),
-- OS 3 (Aberto -> Em Diagnóstico)
(3, 1, 2, '2026-09-15 11:00:00'),
(3, 2, 3, '2026-09-15 15:00:00'),
-- OS 4 (Aberto -> Orçamento Aprovado -> Em Reparo)
(4, 1, 2, '2026-09-20 14:20:00'),
(4, 3, 4, '2026-09-20 15:00:00'),
(4, 4, 4, '2026-09-20 16:00:00');

-- 2.17. Peças utilizadas nas OS (preço congelado na data do vínculo)
INSERT INTO ordem_pecas (id_ordem, id_peca, preco, quantidade, data_saida) VALUES
(1, 11, 35000, 1, '2026-09-01 14:30:00'),  -- Tela iPhone 11 para OS 1
(2, 1,  26000, 1, '2026-09-10 11:30:00');  -- SSD NVMe 512GB para OS 2

-- 2.18. Serviços executados nas OS (preço congelado na data da execução)
INSERT INTO ordem_servicos (id_ordem, id_servico, preco, quantidade, data_execucao) VALUES
(1, 6,  15000, 1, '2026-09-01 15:00:00'),  -- Troca de Display Frontal
(2, 1,  12000, 1, '2026-09-10 13:00:00'),  -- Formatação e Instalação
(3, 10, 35000, 1, '2026-09-15 16:00:00'),  -- Troca Barra de LED TV
(4, 14, 22000, 1, '2026-09-20 16:30:00');  -- Higienização PS5

-- 2.19. Baixa/Saída de peças (Gerente)
-- Situação 4 = Em Reparo (uso na OS) | Situação 8 = Descarte por Defeito/Avaria
INSERT INTO saida_peca (id_peca, id_ordem, quantidade_saida, valor_saida, id_funcionario, id_funcionario_funcao, id_situacao) VALUES
(11, 1,    1, 35000, 1, (SELECT id_funcao FROM funcionario WHERE id = 1), 4),  -- baixada para uso na OS 1
(1,  2,    1, 26000, 1, (SELECT id_funcao FROM funcionario WHERE id = 1), 4),  -- baixada para uso na OS 2
(5,  NULL, 1, 6000,  1, (SELECT id_funcao FROM funcionario WHERE id = 1), 8);  -- descarte por defeito/avaria

COMMIT;


-- ============================================================================
-- 3. VIEWS E CONSULTAS DE TESTE
-- ============================================================================

CREATE VIEW vw_preco_venda_maior_100 AS
SELECT
    id,
    nome_peca,
    preco_sugerido_venda AS 'preço',
    estoque_atual
FROM pecas
WHERE preco_sugerido_venda >= 10000;

CREATE VIEW vw_estoque_baixo AS
SELECT
    id,
    nome_peca,
    estoque_atual
FROM pecas
WHERE estoque_atual <= 20
ORDER BY estoque_atual DESC;

-- Execução das consultas
SELECT * FROM pecas WHERE preco_sugerido_venda <= 10000;

SELECT * FROM vw_preco_venda_maior_100;

SELECT * FROM vw_estoque_baixo;

SELECT
    f.nome_funcionario AS 'nome',
    fu.nome_funcao AS 'funcao'
FROM funcionario f
JOIN funcao fu ON f.id_funcao = fu.id;

SELECT * FROM ordem;

-- Informação consolidada das OS abertas
SELECT
    o.id AS 'ordem_serviço',
    m.nome_modelo AS 'modelo',
    o.defeito_constatado,
    o.defeito_relatado,
    fp.nome_forma_pagamento AS 'forma_pagto',
    f.nome_funcionario AS 'aberto_por',
    f2.nome_funcionario AS 'atendido_por'
FROM ordem o
JOIN equipamento e ON o.id_equipamento = e.id
JOIN modelo m ON e.id_modelo = m.id
JOIN forma_pagamento fp ON o.id_forma_pagamento = fp.id
JOIN funcionario f ON o.id_funcionario_abertura = f.id
JOIN funcionario f2 ON o.id_tecnico = f2.id;

-- SELECT E JOIN PARA VERIFICAR O STATUS DE REPARO DE UM EQUIPAMENTO, COM FILTRO POR OS
SELECT
    os.id_ordem AS 'OS',
    m.nome_modelo AS 'Modelo',
    s.nome_situacao AS 'Situação',
    os.data_situacao AS 'Data'
FROM ordem_situacao os
JOIN ordem o ON os.id_ordem = o.id
JOIN situacao s ON os.id_nova_situacao = s.id
JOIN equipamento e ON o.id_equipamento = e.id
JOIN modelo m ON e.id_modelo = m.id
WHERE os.id_ordem = 1;


-- ============================================================================
-- 4. TRIGGERS DE VALOR TOTAL DA ORDEM
-- ============================================================================

CREATE TRIGGER trg_ai_ordem_servicos_atualiza_valor_total_ordem
AFTER INSERT ON ordem_servicos
FOR EACH ROW
BEGIN
    UPDATE ordem
    SET valor_total = COALESCE(valor_total, 0) + (NEW.preco * NEW.quantidade)
    WHERE id = NEW.id_ordem;
END;

-- Exemplo de inserção funcionando perfeitamente
INSERT INTO ordem_servicos (id_ordem, id_servico, preco, quantidade)
VALUES (1, 6, (SELECT preco FROM servicos WHERE id = 6), 1);

CREATE TRIGGER trg_ad_ordem_servicos_atualiza_valor_total_ordem
AFTER DELETE ON ordem_servicos
FOR EACH ROW
BEGIN
    UPDATE ordem
    SET valor_total = COALESCE(valor_total, 0) - (OLD.preco * OLD.quantidade)
    WHERE id = OLD.id_ordem;
END;

DELETE FROM ordem_servicos WHERE id = 1;
