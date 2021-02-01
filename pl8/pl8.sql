   σ - Seleção
   π - Projeção
   ⨝ - Junção
   τ - Order by
   γ - Group by

1. SELECT * FROM cliente AS C INNER JOIN venda AS V ON C.numero=V.cliente
	WHERE MONTH(V.data) = 2 AND YEAR(V.data) = 2018 AND (C.numero) IN ('1','2','3');

   σ_MONTH(V.data) = 2 ∧ YEAR(V.data) = 2018 ∧ (C.numero) IN ('1','2','3')(cliente ⨝_C.numero=V.cliente_ venda)

2. SELECT DISTINCT VP.valor AS Total,P.designacao FROM cliente AS C INNER JOIN venda AS V ON C.numero=V.cliente
	INNER JOIN vendaproduto AS VP ON VP.venda=V.numero
		INNER JOIN produto as P ON P.numero=VP.produto
			WHERE C.localidade='Aguada do Queixo'; 

   σ_localidade='Aguada do Queixo' (cliente) ⨝ (venda) ⨝ (vendaproduto) ⨝ (produto)

3. SELECT P.designacao,SUM(VP.quantidade) AS QNT FROM venda as V INNER JOIN vendaproduto AS VP on V.numero=VP.venda
	INNER JOIN produto as P ON P.numero=VP.produto 
		WHERE WEEK(V.data)='40' AND YEAR(V.data)=2017
			GROUP BY P.tipo
				ORDER BY QNT DESC
					LIMIT 3;

4. SELECT P.numero,P.designacao FROM vendaproduto as VP RIGHT JOIN produto AS P ON P.numero=VP.produto 
	WHERE VP.venda IS NULL;
  
  σ_vp.venda=NULL_ (produto ⟕ vendaproduto)

5. SELECT P.designacao, SUM(VP.quantidade) AS QNT, V.data FROM mercearia.vendaproduto AS VP INNER JOIN produto AS P ON VP.produto=P.numero
	INNER JOIN venda AS V ON V.numero=VP.venda
	GROUP BY P.designacao, week(V.data)
		ORDER BY QNT DESC;

6. DROP view datas_idades;

	CREATE VIEW datas_idades as
	SELECT cliente.datanascimento, FLOOR(DATEDIFF(CURDATE(),cliente.DataNascimento)/365) AS Idade FROM cliente;

7. DROP VIEW totalPorLocal;
	
	CREATE VIEW totalPorLocal as
	SELECT COUNT(*) AS NrVendas, SUM(V.Total) as Total,C.localidade FROM cliente AS C INNER JOIN venda AS V ON V.cliente=C.numero
		GROUP BY C.localidade
        ORDER BY Total DESC;

8. drop procedure `aniversário`;

DELIMITER $$
CREATE PROCEDURE  `aniversário` (IN dataAniversario DATE)
BEGIN
	SELECT C.nome, count(*) as results from cliente as C
		WHERE C.datanascimento = dataAniversario;
END
$$

SELECT datanascimento from cliente;

call aniversario('1983-12-31 00:00:00');

9. drop procedure `vendasProdutosDia`;

DELIMITER $$
CREATE PROCEDURE  `vendasProdutosDia` (IN data DATE)
BEGIN
		SELECT P.designacao, SUM(VP.Quantidade) AS QNT , SUM(VP.valor) AS ValorTotal FROM vendaproduto AS VP INNER JOIN produto AS P ON P.numero=VP.produto
			INNER JOIN venda AS V ON VP.venda=V.numero
				WHERE V.data=data
					GROUP BY VP.produto
						ORDER BY ValorTotal DESC;
END
$$

call vendasProdutosDia('2017-10-05 00:00:00');

10. drop function prodPrefCliente;
DELIMITER $$
CREATE FUNCTION `prodPrefCliente` (c INT)
	RETURNS(VARCHAR(75))
BEGIN 
	DECLARE prod VARCHAR(75);
	prod = (SELECT P.designacao FROM cliente AS C INNER JOIN venda AS V ON C.numero=V.cliente
			INNER JOIN vendaproduto AS VP ON VP.venda=V.numero
			INNER JOIN produto as P ON P.numero=VP.produto
			WHERE C.numero=c
			GROUP BY VP.quantidade
			ORDER BY VP.quantidade DESC
			LIMIT 1);
	RETURN prod;
END
%%

SELECT prodPrefCliente(1);

12. CREATE TABLE IF NOT EXISTS logProdutosVendidos(
			data DATETIME,
			produto INT,
			cliente INT);
DROP TABLE logProdutosVendidos;
DROP TRIGGER log;
DELIMITER $$
CREATE TRIGGER log AFTER INSERT ON vendaproduto
	FOR EACH ROW
	BEGIN
		DECLARE Prod VARCHAR(75);
        DECLARE Cli VARCHAR(75);
        DECLARE dat DATETIME;
		SET prod = (SELECT P.designacao FROM vendaproduto as VP INNER JOIN produto AS P ON P.numero=NEW.produto
					LIMIT 1);
		SET cli = (SELECT C.nome FROM vendaproduto as VP INNER JOIN venda AS V ON NEW.venda=V.numero
			INNER JOIN cliente AS C ON C.numero=V.cliente
            LIMIT 1);
		SET dat = (SELECT V.data FROM vendaproduto as VP INNER JOIN venda AS V ON NEW.venda=V.numero
			INNER JOIN cliente AS C ON C.numero=V.cliente
            LIMIT 1);
		INSERT INTO logProdutosVendidos(data,produto,cliente) VALUES (dat,prod,cli);
	END
$$