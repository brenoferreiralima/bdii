/* 

Baseando-se no banco de dados do hotel e usando a linguagem SQL, responda as questões abaixo.

Obtenha: 
1) O nome dos hóspedes que nasceram no ano 2000 ou que se hospedaram na data xx/yy/zzzz.
2) O nome e a data de nascimento dos hóspedes que se hospedaram em apartamentos da categoria de código x.
3) O nome e a data de nascimento dos hóspedes que se hospedaram em apartamentos da categoria de nome y.
4) O código das hospedagens realizadas pelo João ou em apartamentos da categoria luxo.

*/

-- 1)
SELECT NOME FROM HOSPEDE WHERE 
    DATE_PART('YEAR', DT_NASC) = 2000 OR 
    COD_HOSP = (SELECT COD_HOSP FROM HOSPEDAGEM WHERE DT_ENT = '2021-07-13');

-- 2)
SELECT NOME, DT_NASC FROM HOSPEDE WHERE
	COD_HOSP IN (SELECT COD_HOSP FROM HOSPEDAGEM WHERE
		NUM IN (SELECT NUM FROM APARTAMENTO WHERE COD_CAT = 1));

-- 3)
SELECT NOME, DT_NASC FROM HOSPEDE WHERE
	COD_HOSP IN (SELECT COD_HOSP FROM HOSPEDAGEM WHERE
		NUM IN (SELECT NUM FROM APARTAMENTO WHERE 
            COD_CAT = (SELECT COD_CAT FROM CATEGORIA WHERE NOME = 'LUXO')));

-- 4)

