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