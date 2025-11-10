-- Criação do Banco de Dados
CREATE DATABASE cafeteria;
USE cafeteria;

-- Tabela de Produtos
CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0
);

-- Tabela de Pedidos
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    id_produto INT,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Inserção de dados na tabela Produtos
INSERT INTO produtos (nome, descricao, preco, estoque) VALUES
('Café Expresso', 'Café forte e encorpado', 5.50, 50),
('Cappuccino', 'Café com leite vaporizado e espuma', 7.00, 30),
('Pão de Queijo', 'Porção com 5 unidades', 6.00, 40);

-- Inserção de dados na tabela Pedidos
INSERT INTO pedidos (data_pedido, quantidade, valor_total, id_produto) VALUES
('2025-11-10', 2, 11.00, 1),
('2025-11-10', 1, 7.00, 2),
('2025-11-09', 3, 18.00, 3);
