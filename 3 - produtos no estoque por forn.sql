-- Relação de produtos fornecedores e estoques;
SELECT
f.razao_social as fornecedor
,p.descricao as produto
,est.quantidade as quantidade
FROM 
e_commerce.fornecedor as f
left join e_commerce.estoque as est on est.idfornecedor = f.idfornecedor
left join e_commerce.produto as p on p.idproduto = est.idproduto

GROUP BY 1,2
order by 2 asc, 3 desc;