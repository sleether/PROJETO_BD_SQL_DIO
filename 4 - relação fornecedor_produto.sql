-- Relação de nomes dos fornecedores e nomes dos produtos;
SELECT
f.razao_social as fornecedor
,p.descricao as produto


FROM
e_commerce.fornecedor as f
left join e_commerce.estoque as est on est.idfornecedor = f.idfornecedor
left join e_commerce.produto as p on p.idproduto = est.idproduto

GROUP BY 1,2;