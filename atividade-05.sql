/* 
1)	Crie uma tabela chamada Funcionário com os seguintes campos:
		código (int)
		nome (varchar(30))
		salário (int)
		data_última_atualização (timestamp)
		usuário_que_atualizou (varchar(30))
	Na inserção desta tabela, você deve informar apenas o código, nome e salário do funcionário.
	Agora crie um Trigger que não permita o nome nulo, o salário nulo e nem negativo.
	O trigger também será responsável por inserir os valores faltantes na tabela.
	Faça testes que comprovem o funcionamento do Trigger.
	Dica: Você pode usar Raise Exception, ‘now’ e current_user
*/

-- tabela funcionário
CREATE TABLE funcionario(
	codigo INT,
	nome VARCHAR(30),
	salario INT,
	data_ultima_atualizacao TIMESTAMP,
	usuario_que_atualizou VARCHAR(30)
);

-- função valida funcionário
CREATE FUNCTION func_valida_funcionario() 
RETURNS trigger AS $func_valida_funcionario$
BEGIN
	IF NEW.nome IS NULL THEN
		RAISE EXCEPTION 'Nome do funcionário não pode ser nulo!';
	END IF;
	IF NEW.salario IS NULL THEN
		RAISE EXCEPTION 'Salário do funcionário não pode ser nulo!';
	END IF;
	IF NEW.salario < 0 THEN
		RAISE EXCEPTION 'Salário não pode ser menor que ZERO!';
	END IF;
	NEW.data_ultima_atualizacao := NOW();
	NEW.usuario_que_atualizou := CURRENT_USER;
	RETURN NEW;
END;
$func_valida_funcionario$ LANGUAGE plpgsql;

-- trigger valida funcionário
CREATE TRIGGER valida_funcionario 
BEFORE INSERT ON funcionario 
FOR EACH ROW EXECUTE PROCEDURE func_valida_funcionario();


/* 
2)	Crie uma tabela chamada Empregado com os atributos nome e salário.
	Crie também outra tabela chamada Empregado_auditoria com os atributos:
		operação (char(1))
		usuário (varchar)
		data (timestamp)
		nome (varchar)
		salário (integer)
	Agora crie um trigger que registre na tabela Empregado_auditoria a modificação que foi feita na tabela empregado.
	No campo "operação" armazene "E" para exclusão, "A" para alteração e "I" para inclusão, 
	no campo "usuário" armazene o nome do usuário do BD que fez a modificação, 
	em "data" armazene da modificação, em "nome" armazene o nome do empregado que foi alterado e em "salário" o valor do salário dele.
	No caso do trigger ser disparado por um Update, armazene os nomes e salários novos.
	Dica: Você pode usar a variável especial TG_OP
 */

-- tabela empregado
CREATE TABLE empregado(
	nome VARCHAR,
	salario INTEGER
);

-- tabela empregado auditoria
CREATE TABLE empregado_auditoria(
	operacao CHAR(1),
	usuario VARCHAR,
	data TIMESTAMP,
	nome VARCHAR,
	salario INTEGER
);


/* 
3)	Crie a tabela Empregado2 com os atributos:
		código (serial e chave primária)
		nome (varchar)
		salário (integer).
	Crie também a tabela Empregado2_audit com os seguintes atributos:
		usuário (varchar)
		data (timestamp)
		id (integer)
		coluna (text)
		valor_antigo (text)
		valor_novo(text)
	Agora crie um trigger que não permita a alteração da chave primária 
	e insira registros na tabela Empregado2_audit para refletir as alterações de instância realizadas na tabela Empregado2 
	(inserções, remoções ou alterações na tabela Empregado2).
	O atributo "usuário" armazenará o nome do usuário do banco que realizou a modificação na tabela Empregado2, 
	a "data" armazenará a data da modificação, o "id" o código do empregado que foi inserido, removido ou alterado, 
	a "coluna" armazenará o nome da coluna que sofreu um update (no caso de não acontecer um update, esse atributo deverá ficar vazio), 
	o "valor_antigo" armazenará os valores antigos no caso de deleção ou atualização (no caso de inserção, ela deverá ficar em branco) 
	e "valor_novo" armazenará os valores novos no caso de inserções ou atualizações (no caso de deleções, essa coluna deverá ficar vazia).
 */

--  tabela empregado2
CREATE TABLE empregado2(
	codigo SERIAL PRIMARY KEY,
	nome VARCHAR,
	SALARIO INTEGER
);

-- tabela empregado2 audit
CREATE TABLE empregado2_audit(
	usuario VARCHAR,
	data TIMESTAMP,
	id INTEGER,
	coluna TEXT,
	valor_antigo TEXT,
	valor_novo TEXT
);