--  crie a tabela venda com os seguintes atributos: cod_venda, nome_vendedor, data_venda, valor_vendido
	
	CREATE TABLE IF NOT EXISTS venda (
		cod_venda SERIAL PRIMARY KEY,
		nome_vendedor VARCHAR(50) NOT NULL,
		data_venda DATE NOT NULL,
		valor_vendido INTEGER NOT NULL
	);


--  1) Povoe a tabela venda com 10 vendas, considerando que existam apenas 4 vendedores na loja.
--	   Faça com que, pelo menos, 2 vendedores empatem no somatório dos valores vendidos.

	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (1, 'João', '2020-03-06', 200);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (2, 'João', '2020-03-18', 100);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (3, 'José', '2020-03-05', 50);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (4, 'José', '2020-03-11', 50);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (5, 'José', '2020-03-02', 50);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (6, 'José', '2020-03-30', 50);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (7, 'José', '2020-03-01', 50);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (8, 'José', '2020-03-26', 50);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (9, 'Maria', '2020-03-05', 150);
	insert into venda (cod_venda, nome_vendedor, data_venda, valor_vendido) values (10, 'Pedro', '2020-03-28', 25);


--  2.1) Mostre o nome dos vendedores que venderam mais que X reais no mês de março de 2020.
	
	-- View com o valor total em vendas no mês de março de 2020 por vendedor.
	-- CREATE VIEW total_vendedor AS
	-- SELECT nome_vendedor AS vendedor, SUM(valor_vendido) AS total 
	-- FROM venda 
	-- WHERE data_venda BETWEEN '2020-03-01' AND '2020-03-31'
	-- GROUP BY nome_vendedor;

	-- SELECT vendedor FROM total_vendedor WHERE total >= 200;

	SELECT nome_vendedor 
	FROM (SELECT nome_vendedor, SUM(valor_vendido) AS total 
		  FROM venda 
		  WHERE data_venda BETWEEN '2020-03-01' AND '2020-03-31'
		  GROUP BY nome_vendedor) AS total_vendedor
	WHERE total >= 200;


--  2.2) Mostre o nome de apenas um dos vendedores que mais vendeu no mês de março de 2020.
	
	-- SELECT vendedor FROM total_vendedor ORDER BY total DESC LIMIT 1;

	SELECT nome_vendedor 
	FROM (SELECT nome_vendedor, SUM(valor_vendido) AS total 
		FROM venda 
		WHERE data_venda BETWEEN '2020-03-01' AND '2020-03-31'
		GROUP BY nome_vendedor) AS total_vendedor
	ORDER BY total DESC
	LIMIT 1;


--  3) Mostre o nome do(s) vendedor(es) que mais vendeu no mês de março de 2020.

	-- View com o valor total em vendas no mês de março de 2020 por vendedor.
	CREATE VIEW total_vendedor AS
	SELECT nome_vendedor AS vendedor, SUM(valor_vendido) AS total 
	FROM venda 
	WHERE data_venda BETWEEN '2020-03-01' AND '2020-03-31'
	GROUP BY nome_vendedor;

	-- View com os melhores vendedores em março de de 2020 por valor total em vendas.
	CREATE VIEW melhor_vendedor AS
	SELECT * 
	FROM total_vendedor WHERE total = (SELECT MAX(total) FROM total_vendedor);

	SELECT vendedor FROM melhor_vendedor;