-- Quantos pedidos foram feitos por cada cliente?
SELECT
c.nome AS cliente
,count(pd.idpedido) as qtdpedido

FROM 
e_commerce.cliente as c
left join e_commerce.pedido as pd on pd.idcliente = c.idcliente

GROUP BY 1
HAVING count(pd.idpedido) > 0
ORDER BY 2 DESC;