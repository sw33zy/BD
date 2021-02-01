c) σ - Seleção
   π - Projeção
   ⨝ - Junção
   τ - Order by
   γ - Group by

1. SELECT * FROM mercearia.cliente;
   π_nome_(cliente)

2. SELECT cliente.nome FROM cliente 
	WHERE cliente.localidade = "Aguada do Queixo"
   π_nome_(σ_localidade = "Aguada do Queixo"_(cliente))

3. SELECT DISTINCT Profissao from cliente 
   π_profissao_(cliente)

4. SELECT Designacao, Preco FROM produto 
	ORDER BY Designacao ASC;
   γ_designacao,asc_(π_designacao,preco_(produto))

5. SELECT C.nome, SUM(V.Total) AS Total FROM mercearia.venda 	
	AS V JOIN mercearia.cliente  AS C WHERE V.cliente = C.Numero 
	Group By C.Nome ORDER BY V.Total;
   τ_total_(γ_nome_(π_c.nome,sum(v.total)_(cliente ⨝_numero=cliente_ venda)))

6. SELECT V.Numero, P.Designacao, V.Data FROM mercearia.venda AS V 
	INNER JOIN mercearia.vendaproduto AS VP ON V.Numero=VP.Venda 
    INNER JOIN mercearia.produto AS P ON VP.Produto=P.Numero
    WHERE V.data="2017/10/05";

    σ_data="2017/10/05"_(π_v.numero,p.designacao,v.data_((vendaproduto ⨝_numero=venda_ venda) ⨝_produto=numero_ produto))

7. SELECT V.Data, VP.Produto, P.Designacao, SUM(VP.Quantidade) AS QntTotal FROM mercearia.venda AS V 
	INNER JOIN mercearia.vendaproduto AS VP ON V.numero=VP.venda 
	INNER JOIN mercearia.produto AS P ON P.numero=VP.produto
	where WEEK(V.Data)=40
	group by VP.Produto
	order by QntTotal DESC;

	τ_qnttotal_(γ_vp.produto_(π_V.Data, VP.Produto, P.Designacao, SUM(VP.Quantidade)_(σ_WEEK(V.Data)=40_((vp ⨝_vp.venda=v.numero_ v) ⨝_vp.produto=p.numero_ p))))

8. SELECT V.data, SUM(V.total) AS TotalDiário, AVG(V.total) AS Média 
	FROM mercearia.venda AS V 
	group by V.data;

   γ_v.data(π_V.data, SUM(V.total), AVG(V.total)_(venda))

d)
3. SELECT * FROM produto WHERE tipo = 'Peixe';
	UPDATE produto 
	set preco = preco * 1.1 WHERE tipo = 'Peixe';
	SELECT * FROM produto WHERE tipo = 'Peixe';