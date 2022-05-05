/*
Crie as tabelas de acordo com o diagrama em anexo. 
Os domínios de cada atributo ficará a sua escolha, desde que utilize os mais adequados. 
Nenhum atributo deverá ser "auto-incrementável".

A seguir, responda as questões abaixo:
*/

-- tabela titulo
CREATE TABLE titulo(
	cod_titulo INT,
	descr_titulo VARCHAR
);

-- tabela livro
CREATE TABLE livro(
	cod_livro INT,
	cod_titulo INT,
	valor_unitario INT,
	quant_estoque INT
);

-- tabela item_pedido
CREATE TABLE item_pedido(
	cod_livro INT,
	cod_pedido INT,
	quantidade_pedido INT,
	valor_total_item INT
);

-- tabela pedido
CREATE TABLE pedido(
	cod_pedido INT,
	cod_fornecedor INT,
	quant_itens_pedidos INT,
	valor_total_pedido INT,
	data_pedido DATE,
	hora_pedito TIME,
);

-- tabela fornecedor
CREATE TABLE fornecedor(
	cod_fornecedor INT,
	nome_fornecedor VARCHAR,
	endereco_fornecedor VARCHAR
);


/*
1) Crie uma função que realiza venda de um único livro e que possui estoque suficiente. 
O ato de realizar venda consiste em inserir registros nas tabelas Venda e Item_venda, 
além de decrementar a quantidade em estoque na tabela Livro. 
Essa função deve receber apenas os seguintes parâmetros: 
	Código da venda, código do livro, nome do cliente (imagine que não existam dois clientes com o mesmo nome) e quantidade vendida.
*/


/*
2) Crie uma função que realiza a venda como ela deve realmente acontecer, ou seja, 
a função deverá ser capaz de vender vários produtos. 
Para isso, a função poderá ser executada mais de uma vez pois, para cada execução, ela venderá um produto diferente da mesma venda. 
No primeiro produto, devem ocorrer inserções nas duas tabelas. 
A partir do segundo, caso o código da venda já exista na tabela venda, as inserções devem ocorrer apenas na tabela Item_venda. 
Não esqueça de decrementar a quantidade em estoque da tabela Livro, de atualizar o valor total da venda e a quantidade de itens da tabela venda. 
Os parâmetros passados para a função são os mesmos da questão anterior.
*/