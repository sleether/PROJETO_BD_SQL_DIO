-- Relação de produtos vendedor e estoques;
SELECT
vt.razao_nome as vendedor
,p.descricao as produto
,esv.quantidade as quantidade
FROM 
e_commerce.vendedor_terceirizado as vt
left join e_commerce.estoque_vendedor as esv on esv.idvendedor = vt.idterceiro
left join e_commerce.produto as p on p.idproduto = esv.idproduto

GROUP BY 1,2
order by 2 asc, 3 desc;