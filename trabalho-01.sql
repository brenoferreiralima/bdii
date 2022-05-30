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

/*
c) Dar baixa em um empréstimo. 
Por fim, o ato de dar baixa no empréstimo consiste em preencher a data de devolução e calcular, quando houver, o valor da multa. 
Considere o valor de R$ 2,50 por dia de atraso e para cada livro. 
Em outras palavras, caso o leitor dê baixa em um empréstimo que possuía um livro com dois dias de atraso, 
o função deveria calcular uma multa no valor de R$ 5,00. 
A função deverá receber apenas o código do empréstimo que será dado baixa.
*/