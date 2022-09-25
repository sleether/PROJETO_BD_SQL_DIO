-- Relação de nomes dos vendedores e nomes dos produtos;
SELECT
vt.razao_nome as vendedor
,p.descricao as produto


FROM
e_commerce.vendedor_terceirizado as vt
left join e_commerce.estoque_vendedor as esv on esv.idvendedor = vt.idterceiro
left join e_commerce.produto as p on p.idproduto = esv.idproduto

GROUP BY 1,2;