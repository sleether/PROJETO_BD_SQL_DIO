-- Algum vendedor também é fornecedor?
SELECT
distinct(vt.razao_nome) as vendedor
,case 
when f.razao_social = vt.razao_nome then 'Também é forncedor' 
else 'Apenas Vendedor' end as 'Vendedor é?'

FROM
e_commerce.fornecedor as f
,e_commerce.vendedor_terceirizado as vt;