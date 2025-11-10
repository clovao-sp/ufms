-- ============================
-- Script: banco_cafeteria.sql
-- Data: 2025-11-10
-- SGBD alvo: MySQL / MariaDB (pequenos ajustes para PostgreSQL)
-- ============================

-- 1. Criação do banco
CREATE DATABASE IF NOT EXISTS cafeteria;
USE cafeteria;

-- 2. Tabela produtos
CREATE TABLE IF NOT EXISTS produtos (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
  estoque INT NOT NULL DEFAULT 0 CHECK (estoque >= 0),
  categoria VARCHAR(50),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabela pedidos
CREATE TABLE IF NOT EXISTS pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE'
);

-- 4. Tabela itens_pedido (associação)
CREATE TABLE IF NOT EXISTS itens_pedido (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
  subtotal DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
  FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- 5. Inserção de produtos (exemplos)
INSERT INTO produtos (nome, descricao, preco, estoque, categoria) VALUES
('Café Expresso', 'Café forte e encorpado - 50ml', 5.50, 50, 'Bebida'),
('Cappuccino', 'Café com leite vaporizado e espuma', 7.00, 30, 'Bebida'),
('Pão de Queijo', 'Porção com 5 unidades', 6.00, 40, 'Comida');

-- 6. Inserção de pedidos e itens (exemplos)
-- Inserir pedido 1
INSERT INTO pedidos (data_pedido, valor_total, status) VALUES
('2025-11-10 09:30:00', 11.00, 'CONCLUIDO');
SET @last_pedido = LAST_INSERT_ID();

-- Se preferir inserir com id conhecido, exemplo direto:
INSERT INTO pedidos (data_pedido, valor_total, status) VALUES
('2025-11-10 10:00:00', 7.00, 'CONCLUIDO');

-- Para demonstrar itens (usando ids de produtos já inseridos):
-- Pedido 1 (supondo id_pedido = 1)
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal)
VALUES (1, 1, 2, 5.50, 11.00);

-- Pedido 2 (id_pedido = 2)
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal)
VALUES (2, 2, 1, 7.00, 7.00);

-- 7. Consultas de exemplo
-- 7.1 Ver todos os produtos
SELECT * FROM produtos ORDER BY nome;

-- 7.2 Ver pedidos com seus itens (join)
SELECT p.id_pedido, p.data_pedido, p.valor_total, p.status,
       ip.id_item, ip.id_produto, pr.nome AS produto, ip.quantidade, ip.preco_unitario, ip.subtotal
FROM pedidos p
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produtos pr ON pr.id_produto = ip.id_produto
ORDER BY p.data_pedido DESC;

-- 7.3 Total vendido por produto
SELECT pr.id_produto, pr.nome,
       SUM(ip.quantidade) AS total_vendido,
       SUM(ip.subtotal) AS receita
FROM itens_pedido ip
JOIN produtos pr ON pr.id_produto = ip.id_produto
GROUP BY pr.id_produto, pr.nome
ORDER BY receita DESC;

-- 8. Atualização e remoção (exemplos)
-- Atualizar preço de um produto
UPDATE produtos SET preco = 5.75 WHERE id_produto = 1;

-- Reduzir estoque após venda (exemplo para pedido id 1)
UPDATE produtos p
JOIN itens_pedido ip ON p.id_produto = ip.id_produto
SET p.estoque = p.estoque - ip.quantidade
WHERE ip.id_pedido = 1;

-- Remover um pedido (e seus itens devido a ON DELETE CASCADE)
DELETE FROM pedidos WHERE id_pedido = 2;

-- 9. Índices recomendados (exemplo)
CREATE INDEX idx_produtos_nome ON produtos(nome);
CREATE INDEX idx_itens_pedido_pedido ON itens_pedido(id_pedido);
