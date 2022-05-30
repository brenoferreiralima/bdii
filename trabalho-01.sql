/* 
Considerando o banco de dados de uma biblioteca, responda as questões abaixo usando a linguagem SQL.
O script de criação do banco de dados e o diagrama encontram-se em anexo.
O diagrama foi criado incompleto, sem muitos atributos, 
pois o objetivo era apenas evidenciar a ligação entre as tabelas.
*/

/*
1) Crie um trigger que não permita a existência de dois ou mais itens (tabela ITEM_EMPRÉSTIMO) 
do mesmo empréstimo com o mesmo código de livro.
*/

-- funcão checa duplicidade empréstimo
CREATE FUNCTION  checa_duplicidade_emprestimo()
RETURNS trigger AS $$
BEGIN
    IF EXISTS(SELECT * FROM item_emprestimo WHERE cod_emprestimo = NEW.cod_emprestimo AND cod_livro = NEW.cod_livro) THEN
        RAISE EXCEPTION 'Você já possui uma cópia desse livro!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger checa duplicidade empréstimo
CREATE TRIGGER checa_duplicidade_emprestimo
BEFORE INSERT OR UPDATE ON item_emprestimo
FOR EACH ROW EXECUTE PROCEDURE checa_duplicidade_emprestimo();


/*
2) Crie um trigger que altere o status da reserva de um leitor para I (Inativo) 
sempre que ele tomar emprestado o livro do título que ele reservou.
*/

-- funcão inativa reserva
CREATE FUNCTION  inativa_reserva()
RETURNS trigger AS $$
DECLARE
    titulo INTEGER := (SELECT cod_tit FROM livro WHERE cod_livro = NEW.cod_livro);
    leitor INTEGER := (SELECT cod_leitor FROM emprestimo WHERE cod_emprestimo = NEW.cod_emprestimo);
BEGIN
    IF EXISTS(SELECT * FROM reserva WHERE cod_leitor = leitor AND cod_tit = titulo) THEN
        UPDATE reserva SET status = 'I' WHERE cod_leitor = leitor AND cod_tit = titulo;
        RETURN NEW;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger inativa reserva
CREATE TRIGGER inativa_reserva
AFTER INSERT OR UPDATE ON item_emprestimo
FOR EACH ROW EXECUTE PROCEDURE inativa_reserva();


/*
3) Crie funções que realizem as seguintes operações:
a) Reservar um título de livro. 
Na reserva, o leitor não poderá reservar um título, 
caso haja algum livro daquele título disponível para empréstimo. 
A função receberá o nome do leitor, o nome do título e o nome do funcionário. 
Imagine que não existam dois nomes iguais na mesma tabela. 
Para a data e hora da reserva, sugere-se usar a função now(). 
Mensagens devem ser enviadas para o leitor informando-o do resultado do processamento da função. 
Para isso, sugere-se usar "raise notice".
*/

-- função reserva titulo
CREATE FUNCTION reserva_titulo(pleitor VARCHAR, ptitulo VARCHAR, pfuncionario VARCHAR)
RETURNS void AS $$
DECLARE
	vcod_leitor INT := (SELECT cod_leitor FROM leitor WHERE nome_l = pleitor);
	vcod_tit INT := (SELECT cod_tit FROM titulo WHERE nome_t = ptitulo);
    vcod_func INT := (SELECT cod_func FROM funcionario WHERE nome_f = pfuncionario);
    vcod_res INT := (SELECT MAX(cod_res) FROM reserva) + 1;
    vquant_tit INT := (SELECT COUNT(cod_livro) FROM livro WHERE cod_tit = (SELECT cod_tit FROM titulo WHERE nome_t = ptitulo));
    vquant_emp INT := (SELECT COUNT(cod_item) FROM item_emprestimo 
                  INNER JOIN (SELECT cod_livro FROM livro WHERE cod_tit = (SELECT cod_tit FROM titulo WHERE nome_t = ptitulo)) AS cl ON
                  item_emprestimo.cod_livro = cl.cod_livro 
                  INNER JOIN emprestimo ON item_emprestimo.cod_emprestimo = emprestimo.cod_emprestimo
                  WHERE dt_devolucao IS NULL);
BEGIN
    IF vcod_res IS NULL THEN 
        vcod_res := 1; 
    END IF;
    IF vquant_emp = vquant_tit THEN
        INSERT INTO reserva VALUES(vcod_res, vcod_leitor, vcod_tit, vcod_func, NOW(), 'A');
        RAISE NOTICE 'Reserva realizada com sucesso!';
    ELSEIF vquant_emp < vquant_tit THEN
        RAISE NOTICE 'Esse títuto está diponível! Pegue agora mesmo.';
    END IF;
END;
$$ LANGUAGE plpgsql;


/*
b) Emprestar um único livro. 
No caso do empréstimo, a função receberá o código do empréstimo, 
o código do livro, a data do empréstimo, o nome do leitor e o nome do funcionário. 
Assim como na reserva, imagine que não existam dois nomes iguais na mesma tabela. 
Para inserção na tabela empréstimo, a data de devolução deve ser nula 
(ela só será preenchida quando o empréstimo for dado baixa) 
e a data prevista de devolução deve ser dois dias após a data do empréstimo. 
O empréstimo de um dado livro só poderá ser efetivado se não existir nenhuma reserva ATIVA para o título daquele livro 
ou se a reserva mais ANTIGA for do mesmo leitor que está efetuando o empréstimo. 
Como sabemos, o ato de emprestar consiste em inserir registros nas tabelas Empréstimo e Item_empréstimo 
ou simplesmente inserir registros na tabela Item_empréstimo e atualizar a tabela empréstimo (quantidade de livros). 
Porém, para essa questão, consideraremos que apenas um livro será emprestado em cada empréstimo. 
Assim, você não se preocupará se já existe o mesmo código de empréstimo na tabela empréstimo. 
Da mesma forma que na função anterior, 
mensagens devem ser enviadas para o leitor informando-o do resultado do processamento da função.
*/

-- função emprestar livro
CREATE FUNCTION empresta_livro(pcod_emprestimo INT, pcod_livro INT, pdt_emprestimo DATE, pleitor VARCHAR, pfuncionario VARCHAR)
RETURNS void AS $$
DECLARE
    vcod_leitor INT := (SELECT cod_leitor FROM leitor WHERE nome_l = pleitor);
    vcod_func INT := (SELECT cod_func FROM funcionario WHERE nome_f = pfuncionario);
    vdt_prev_devolucao DATE := pdt_emprestimo + 2;
    vcod_item INT := (SELECT MAX(cod_item) FROM item_emprestimo);
    vquant_res INT := (SELECT COUNT(cod_res) FROM reserva WHERE status = 'A' AND cod_tit IN (SELECT cod_tit FROM livro WHERE cod_livro = pcod_livro));
    vleitor_res VARCHAR := (SELECT nome_l FROM leitor INNER JOIN
                           (SELECT * FROM reserva WHERE status = 'A' AND cod_tit IN (SELECT cod_tit FROM livro WHERE cod_livro = pcod_livro)) AS r
                           ON leitor.cod_leitor = r.cod_leitor
                           ORDER BY data_hora
                           LIMIT 1);
BEGIN
    IF vquant_res = 0 OR vleitor_res = pleitor THEN
        IF vcod_item IS NULL THEN 
            vcod_item := 1; 
        ELSE vcod_item := vcod_item + 1;
        END IF;
        INSERT INTO emprestimo VALUES(pcod_emprestimo, vcod_leitor, vcod_func, pdt_emprestimo, vdt_prev_devolucao, NULL, 1, NULL);
        INSERT INTO item_emprestimo VALUES(vcod_item, pcod_emprestimo, pcod_livro);
        RAISE NOTICE 'Boa leitura!';
    ELSE RAISE NOTICE 'Este título está reservado para outra pessoa :(';
    END IF;
END;
$$ LANGUAGE plpgsql;


/*
c) Dar baixa em um empréstimo. 
Por fim, o ato de dar baixa no empréstimo consiste em preencher a data de devolução e calcular, quando houver, o valor da multa. 
Considere o valor de R$ 2,50 por dia de atraso e para cada livro. 
Em outras palavras, caso o leitor dê baixa em um empréstimo que possuía um livro com dois dias de atraso, 
o função deveria calcular uma multa no valor de R$ 5,00. 
A função deverá receber apenas o código do empréstimo que será dado baixa.
*/

-- função dar baixa
CREATE FUNCTION dar_baixa(pcod_emprestimo INT)
RETURNS void AS $$
DECLARE
    vdt_prev_devolucao DATE := (SELECT dt_prev_devolucao FROM emprestimo WHERE cod_emprestimo = pcod_emprestimo);
    vquant_livro INT := (SELECT quant_livro FROM emprestimo WHERE cod_emprestimo = pcod_emprestimo);
    vdias_atraso INT := (SELECT DATE(NOW()) - vdt_prev_devolucao);
    vvalor_multa FLOAT := vquant_livro * vdias_atraso * 2.50;
BEGIN
    UPDATE emprestimo SET(dt_devolucao, valor_multa) = (NOW(), vvalor_multa) WHERE cod_emprestimo = pcod_emprestimo;
    IF vvalor_multa <= 0 THEN
        RAISE NOTICE 'Devolução realizada com sucesso!';
    ELSE
        RAISE NOTICE 'Devolução realizada com sucesso! O Valor de sua multa por atraso é R$% reais!', vvalor_multa;
    END IF;
END;
$$ LANGUAGE plpgsql;
