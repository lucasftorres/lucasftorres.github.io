
-- Abaixo estão algumas queries SQL onde os resultados utilizados serão comparados aos obtidos no Power BI, no projeto final pode conter resultados 
-- que não estão nesses scripts.

-- Below are some SQL queries where the results used will be compared to those obtained in Power BI, in the final project it may contain results 
-- which are not in these scripts.


-- CLIENTES / CUSTOMERS

-- Quantidade Total de Clientes / Total Customers = 99441
SELECT
	COUNT(DISTINCT customer_id)
FROM dbo.olist_customers_dataset;


-----------------------------------------
-- Quantidade Total de Vendedores / Total Sellers = 3095
SELECT
	COUNT(DISTINCT seller_id)
FROM dbo.olist_sellers_dataset;


-----------------------------------------
-- Quantidade Total de Produtos / Total Products = 32951

SELECT
	COUNT(DISTINCT product_id)
FROM dbo.olist_products_dataset;


-----------------------------------------
-- Quantidade Total de Categorias / Total Categories = 73
SELECT
	COUNT(DISTINCT product_category_name)
FROM dbo.olist_products_dataset;


-----------------------------------------
-- Quantidade Total de Clientes por Estado / Total by States:
-- SP	41731
-- RJ	12839
-- MG	11624
-- RS	5462
-- PR	5034
SELECT
	g.geolocation_state,
	COUNT(DISTINCT customer_id) AS Qtd
FROM dbo.olist_customers_dataset AS c JOIN dbo.olist_geolocation_dataset AS g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_state
ORDER BY Qtd DESC;

-- Quantidade Total de Clientes por Cidade / Total by Cities:
-- sao paulo		13343
-- rio de janeiro	6882
-- belo horizonte	2773
-- são paulo		2195
-- brasilia			1646
-- curitiba			1521
-- campinas			1444
-- porto alegre		1379
-- salvador			1241
-- guarulhos		1189


SELECT
	g.geolocation_city,
	COUNT(DISTINCT customer_id) AS Qtd
FROM dbo.olist_customers_dataset AS c JOIN dbo.olist_geolocation_dataset AS g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY Qtd DESC;

-- Aqui percebemos a duplicidade de identificação da cidade de são paulo - sao paulo, iremos realizar a substituição na tabela geolocation
-- Here we notice the double identification of the city of são Paulo - são Paulo, we will perform the replacement in the geolocation table


UPDATE dbo.olist_geolocation_dataset
	SET geolocation_city = 'sao paulo'
WHERE geolocation_city = 'são paulo';

-- sao paulo				15538
-- rio de janeiro			6882
-- belo horizonte			2773
-- brasilia					1646
-- curitiba					1521
-- campinas					1444
-- porto alegre				1379
-- salvador					1241
-- guarulhos				1189
-- sao bernardo do campo	861

-------------------------------------------------------------------------------------------------------------------------------------------------
-- VENDEDORES / Sellers

-- Quantidade Total de Vendedores por Cidade / Sellers by City:
SELECT
	g.geolocation_city,
	COUNT(DISTINCT seller_id) AS Qtd
FROM dbo.olist_sellers_dataset AS s JOIN dbo.olist_geolocation_dataset AS g ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY Qtd DESC;



-- Quantidade Total de Vendedores por Estado / Sellers by State: 
-- SP	1814
-- PR	359
-- MG	249
-- SC	197
-- RJ	176
-- RS	131
-- GO	40
-- DF	29
-- ES	24
-- BA	20

SELECT
	g.geolocation_state,
	COUNT(DISTINCT seller_id) AS Qtd
FROM dbo.olist_sellers_dataset AS s JOIN dbo.olist_geolocation_dataset AS g ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_state
ORDER BY Qtd DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------
-- Nesta seção estamos tentando encontrar o número de pedidos, há algumas possibilidade a serem analisadas antes de escolhermos qual o resultado iremos utilizar:
-- A contagem pode ser realizada por 4 tabelas: orders, order_items, order_payments e order_reviews
-- Somente na tabela orders a coluna order_id é chave primária, nas demais tabelas é chave estrangeira, ou seja, alguns registros não estarão presentes nas demais colunas.

-- In this section we are trying to find the number of requests, there are some possibilities to be analyzed before choosing which result we will use:
-- The count can be performed using 4 tables: orders, order_items, order_payments and order_reviews
-- Only in the orders table the order_id column is a primary key, in the other tables it is a foreign key, that is, some records will not be present in the other columns.

-- Quantidade Total de Pedidos / Total Orders = 99441
SELECT
	COUNT(DISTINCT order_id)
FROM dbo.olist_orders_dataset

-- Os dados referentes ao total de pedidos por Cidade e Estado para os pedido são informações já levantadas no tópico de clientes.


-----------------------------------------
-- Quantidade de Pedidos por Status / Order by Status
-- approved		2
-- canceled		625
-- created		5
-- delivered	96478
-- invoiced		314
-- processing	301
-- shipped		1107
-- unavailable	609
SELECT
	order_status,
	COUNT(DISTINCT order_id)
FROM dbo.olist_orders_dataset
GROUP BY order_status;

-----------------------------------------
-- Quantidade de Pedidos por Tipo de Pagamento / Order by Payment Type 

-- boleto		19784
-- credit_card	76505
-- debit_card	1528
-- not_defined	3
-- voucher		3866

SELECT
	payment_type,
	COUNT(DISTINCT order_id)
FROM dbo.olist_order_payments_dataset
GROUP BY payment_type;

-- Aqui observamos a diferença de 1 único registro para o dataset orders.
-- Utilizando a query abaixo identificamos o id do pedido e posteriormente a qual categoria pertence.


-- Here we observe the difference of 1 single record for the orders dataset.
-- Using the query below we identify the order id and then which category it belongs to.

SELECT
	*
FROM dbo.olist_orders_dataset AS o LEFT JOIN dbo.olist_order_payments_dataset AS op ON o.order_id = op.order_id 
WHERE op.order_id IS NULL;

-- O pedido consta como entregue.
-- Pesquisando mais a fundo podemos identificar que o produto pertence a categoria beleza_saude, foram vendidos 3 unidades com preço unitário de 44.99 e frete 2.83 totalizando 143.46.

-- The order appears as delivered.
-- Researching further we can identify that the product belongs to the beauty_health category, 3 units were sold with a unit price of 44.99 and shipping 2.83 totaling 143.46.

SELECT
	*
FROM dbo.olist_order_items_dataset AS oi JOIN dbo.olist_products_dataset AS p ON oi.product_id = p.product_id
WHERE order_id = 'bfbd0f9bdef84302105ad712db648a6c';

-- Podemos realizar agora o preenchimento dos dados na tabela order_payments a partir do que descobrimos e imputando os valores de payment_sequential, payment_type e payment_installments como os de maior frequência.

-- We can now fill in the data in the order_payments table based on what we discovered and imputing the values of payment_sequential, payment_type and payment_installments as the most frequent.

INSERT INTO dbo.olist_order_payments_dataset 
(order_id, payment_sequential, payment_type, payment_installments, payment_value) 
VALUES ('bfbd0f9bdef84302105ad712db648a6c', 1, 'credit_card', 1, 143.46)




-------------------------------------------------------------------------------------------------------------------------------------------------
-- Valor médio do Pedidos / Avg. Order = 154,100277994359

SELECT
	AVG(CONVERT(FLOAT, op.payment_value))
FROM dbo.olist_orders_dataset AS o 
JOIN dbo.olist_order_payments_dataset AS op 
ON o.order_id = op.order_id;


-----------------------------------------
-- Pedido de Valor Mais Alto / Max. Order
-- Categiria: 			telefonia_fixa	
-- Unidades: 			8	
-- Valor Unitario: 		1680.00
-- Frete Unitario: 		28.01	
-- Valor Total: 		13664.08	
-- Tipo de pagamento:   credit_card

SELECT TOP 1
	p.product_category_name,
	oi.order_item_id,
	oi.price,
	oi.freight_value,
	op.payment_value,
	op.payment_type
FROM dbo.olist_orders_dataset AS o 
JOIN dbo.olist_order_payments_dataset AS op 
ON o.order_id = op.order_id
JOIN dbo.olist_order_items_dataset AS oi
ON o.order_id = oi.order_id
JOIN dbo.olist_products_dataset AS p
ON oi.product_id = p.product_id
ORDER BY CONVERT(FLOAT, op.payment_value) DESC, CONVERT(INT, oi.order_item_id) DESC;



-----------------------------------------
-- Produto Top 1 Receita Total
-- Telefonia_fixa	109312,64

-- Top 1 Product Total Revenue
-- Fixed_telephony 109312.64

SELECT
	oi.product_id,
	p.product_category_name,
	SUM(CONVERT(FLOAT, op.payment_value)) AS total
FROM dbo.olist_products_dataset AS p 
JOIN dbo.olist_order_items_dataset AS oi
ON p.product_id = oi.product_id
JOIN dbo.olist_order_payments_dataset As op
ON oi.order_id = op.order_id
GROUP BY oi.product_id, p.product_category_name
ORDER BY total DESC;


-----------------------------------------
-- Receita Total / Total Revenue = 16009015,58
SELECT
	SUM(CONVERT(FLOAT, op.payment_value))
FROM dbo.olist_orders_dataset AS o JOIN dbo.olist_order_payments_dataset AS op ON o.order_id =  op.order_id;


-----------------------------------------
-- Receita Total por Tipo de Pagamento / Total Revenue by Payment Type
-- credit_card	12542227,6499993
-- not_defined	0
-- debit_card	217989,79
-- boleto	2869361,26999998
-- voucher	379436,870000001

SELECT
	payment_type,
	SUM(CONVERT(FLOAT, payment_value))
FROM dbo.olist_order_payments_dataset
GROUP BY payment_type;


-----------------------------------------
-- Receita Total por Tipo de Status / Total Revenue by Status
-- approved			241,08
-- canceled			143255,6
-- created			688,1
-- delivered		15422605,23
-- invoiced			69137,99
-- processing		69394,11
-- shipped			177213,96
-- unavailable		126479,51

SELECT
	o.order_status,
	SUM(CONVERT(FLOAT, op.payment_value))
FROM dbo.olist_orders_dataset AS o JOIN dbo.olist_order_payments_dataset AS op ON o.order_id = op.order_id
GROUP BY o.order_status;

-- Nesse ponto observamos a receita associada a pedidos com status unavailable, e seria importante entender o porque desse status.

-- At this point we observe the revenue associated with orders with an unavailable status, and it would be important to understand the reason for this status.

-----------------------------------------
-- Rank Receita por Categoria de Produtos / Rank Revenue by Product Category
-- Cama_mesa_banho					1712553,67
-- Beleza_saude						1657803,5
-- Informatica_acessorios			1585330,45
-- Moveis_decoracao					1430176,39
-- Relogios_presentes				1429216,68
-- Esporte_lazer					1392127,56
-- Utilidades_domesticas			1094758,13
-- Automotivo						852294,33
-- Ferramentas_jardim				838280,75
-- Cool_stuff						779698


SELECT
	product_category_name,
	SUM(CONVERT(FLOAT, op.payment_value)) AS total
FROM dbo.olist_products_dataset AS p 
JOIN dbo.olist_order_items_dataset AS oi
ON p.product_id = oi.product_id
JOIN dbo.olist_order_payments_dataset As op
ON oi.order_id = op.order_id
GROUP BY product_category_name
ORDER BY total DESC;



-----------------------------------------
-- Rank Cidades com maior Receita / Rank Cities with highest Revenue
-- sao paulo			2203009,30000001
-- rio de janeiro		1161927,35999999
-- belo horizonte		421765,12
-- brasilia				276610,22
-- curitiba				247392,48
-- porto alegre			224731,42
-- salvador				217386,88
-- campinas				216248,43
-- guarulhos			165121,99
-- niteroi				126275,03

SELECT
	g.geolocation_city,
	SUM(CONVERT(FLOAT, op.payment_value)) AS total
FROM dbo.olist_orders_dataset AS o 
JOIN dbo.olist_customers_dataset AS c 
ON o.customer_id = c.customer_id
JOIN dbo.olist_order_payments_dataset AS op 
ON o.order_id = op.order_id
JOIN dbo.olist_geolocation_dataset AS g
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY total DESC;


-----------------------------------------
-- Rank Estados com maior Receita / Rank States with highest Revenue
-- SP	5996193,87000002
-- RJ	2142349,25
-- MG	1871072,52
-- RS	890584,82
-- PR	810280,15
-- SC	623086,43
-- BA	615203,62
-- GO	349377,13
-- DF	326095,81
-- ES	325490,67

SELECT
	g.geolocation_state,
	SUM(CONVERT(FLOAT, op.payment_value)) AS total
FROM dbo.olist_orders_dataset AS o 
JOIN dbo.olist_customers_dataset AS c 
ON o.customer_id = c.customer_id
JOIN dbo.olist_order_payments_dataset AS op 
ON o.order_id = op.order_id
JOIN dbo.olist_geolocation_dataset AS g
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_state
ORDER BY total DESC;


-----------------------------------------
-- Concentração do período de compra (Hora) / Concentration of the purchase period (Time)
-- 0	2394
-- 1	1170
-- 2	510
-- 3	272
-- 4	206
-- 5	188
-- 6	502
-- 7	1231
-- 8	2967
-- 9	4785
-- 10	6177
-- 11	6578
-- 12	5995
-- 13	6518
-- 14	6569
-- 15	6454
-- 16	6675
-- 17	6150
-- 18	5769
-- 19	5982
-- 20	6193
-- 21	6217
-- 22	5816
-- 23	4123


SELECT
	DATEPART(HOUR, order_purchase_timestamp) AS hour_purchase,
	COUNT(DATEPART(HOUR, order_purchase_timestamp))
FROM dbo.olist_orders_dataset
GROUP BY DATEPART(HOUR, order_purchase_timestamp)
ORDER BY hour_purchase;


-----------------------------------------
-- Concentração do período de compra (Dia da Semana) / Concentration of the purchase period (Day of the Week)
-- Domingo				11960
-- Quarta-Feira			15552
-- Quinta-Feira			14761
-- Sábado				10887
-- Segunda-Feira		16196
-- Sexta-Feira			14122
-- Terça-Feira			15963

SELECT
	DATENAME(WEEKDAY, order_purchase_timestamp) AS weekday_purchase,
	COUNT(DATENAME(WEEKDAY, order_purchase_timestamp))
FROM dbo.olist_orders_dataset
GROUP BY DATENAME(WEEKDAY, order_purchase_timestamp)
ORDER BY weekday_purchase;


-----------------------------------------
-- Concentração do período de compra (Dia) / Concentration of the purchase period (Day)
-- 1	3101
-- 2	3213
-- 3	3283
-- 4	3483
-- 5	3445
-- 6	3468
-- 7	3363
-- 8	3326
-- 9	3271
-- 10	3168
-- 11	3308
-- 12	3202
-- 13	3277
-- 14	3387
-- 15	3524
-- 16	3581
-- 17	3200
-- 18	3430
-- 19	3364
-- 20	3261
-- 21	3116
-- 22	3181
-- 23	3128
-- 24	3877
-- 25	3290
-- 26	3290
-- 27	3122
-- 28	3011
-- 29	2557
-- 30	2534
-- 31	1680

SELECT
	DATEPART(DAY, order_purchase_timestamp) AS day_purchase,
	COUNT(DATEPART(DAY, order_purchase_timestamp))
FROM dbo.olist_orders_dataset
GROUP BY DATEPART(DAY, order_purchase_timestamp)
ORDER BY day_purchase;


-----------------------------------------
-- Concentração do período de compra (Mês) / Concentration of the purchase period (Month)
-- 1	8069
-- 2	8508
-- 3	9893
-- 4	9343
-- 5	10573
-- 6	9412
-- 7	10318
-- 8	10843
-- 9	4305
-- 10	4959
-- 11	7544
-- 12	5674

SELECT
	DATEPART(MONTH, order_purchase_timestamp) AS nm_month_purchase,
	COUNT(DATEPART(MONTH, order_purchase_timestamp))
FROM dbo.olist_orders_dataset
GROUP BY DATEPART(MONTH, order_purchase_timestamp)
ORDER BY nm_month_purchase;


-----------------------------------------
-- Concentração de Receitas (Hora) / Revenue Concentration (Time)
-- 0	374429,87
-- 1	175968,42
-- 2	66206,97
-- 3	41914,04
-- 4	28583,21
-- 5	26216,23
-- 6	67684,37
-- 7	182607,59
-- 8	463172,92
-- 9	799881,96
-- 10	993466,13
-- 11	1034498
-- 12	995998,25
-- 13	1029882,85
-- 14	1109777,98
-- 15	1063015,78
-- 16	1100540,43
-- 17	987826,22
-- 18	961676,61
-- 19	969475,12
-- 20	1006763,35
-- 21	984404,18
-- 22	921667,28
-- 23	623357,82

SELECT
	DATEPART(HOUR, o.order_purchase_timestamp) AS hour_purchase,
	SUM(CONVERT(FLOAT, op.payment_value))
FROM dbo.olist_orders_dataset AS o JOIN dbo.olist_order_payments_dataset AS op ON o.order_id = op.order_id
GROUP BY DATEPART(HOUR, o.order_purchase_timestamp)
ORDER BY hour_purchase;


-----------------------------------------
-- Concentração de Receitas (Dia da Semana) / Revenue Concentration (Day of the Week)
-- 1	1872456,36
-- 2	2622457,97
-- 3	2560743,03
-- 4	2493114,66
-- 5	2384687,68
-- 6	2307128,2
-- 7	1768427,68


SELECT
	DATEPART(WEEKDAY, o.order_purchase_timestamp) AS weekday_purchase,
	SUM(CONVERT(FLOAT, op.payment_value))
FROM dbo.olist_orders_dataset AS o JOIN dbo.olist_order_payments_dataset AS op ON o.order_id = op.order_id
GROUP BY DATEPART(WEEKDAY, o.order_purchase_timestamp)
ORDER BY weekday_purchase;


-----------------------------------------
-- Concentração de Receitas (Dia) / Revenue Concentration (Day)
-- 1	528934,76
-- 2	516503,61
-- 3	530101,63
-- 4	574211,06
-- 5	559099,03
-- 6	580254,32
-- 7	553620,73
-- 8	514764,87
-- 9	538884,31
-- 10	520830,02
-- 11	551625,09
-- 12	525348,64
-- 13	530667,06
-- 14	537898,5
-- 15	559704,95
-- 16	577621,81
-- 17	506537,88
-- 18	577794,29
-- 19	527258,04
-- 20	526804,62
-- 21	465244,71
-- 22	479010,41
-- 23	489492,41
-- 24	604375,62
-- 25	516652,32
-- 26	506724,17
-- 27	497197,89
-- 28	496992,51
-- 29	433269,35
-- 30	399223,13
-- 31	282367,84

SELECT
	DATEPART(DAY, o.order_purchase_timestamp) AS day_purchase,
	SUM(CONVERT(FLOAT, op.payment_value))
FROM dbo.olist_orders_dataset AS o JOIN dbo.olist_order_payments_dataset AS op ON o.order_id = op.order_id
GROUP BY DATEPART(DAY, o.order_purchase_timestamp)
ORDER BY day_purchase;


-----------------------------------------
-- Concentração de Receitas (Mês) / Revenue Concentration (Month)
-- 1	1253492,22
-- 2	1284371,35
-- 3	1609515,72
-- 4	1578573,51
-- 5	1746900,97
-- 6	1535156,88
-- 7	1658923,67
-- 8	1696821,64
-- 9	732597,69
-- 10	839358,029999999
-- 11	1194882,8
-- 12	878421,1

SELECT
	DATEPART(MONTH, o.order_purchase_timestamp) AS month_purchase,
	SUM(CONVERT(FLOAT, op.payment_value))
FROM dbo.olist_orders_dataset AS o JOIN dbo.olist_order_payments_dataset AS op ON o.order_id = op.order_id
GROUP BY DATEPART(MONTH, o.order_purchase_timestamp)
ORDER BY month_purchase;



-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------
-- Avaliação Média Geral / Avg. Score Review = 4,08642062404257

SELECT
	AVG(CONVERT(FLOAT, review_score))
FROM dbo.olist_order_reviews_dataset;


-----------------------------------------
-- Quantidade Total de Produtos por Categoria / Total Quantity of Products per Category
-- cama_mesa_banho				3029
-- esporte_lazer				2867
-- moveis_decoracao				2657
-- beleza_saude					2444
-- utilidades_domesticas		2335
-- automotivo					1900
-- informatica_acessorios		1639
-- brinquedos					1411
-- relogios_presentes			1329
-- telefonia					1134


SELECT
	product_category_name,
	COUNT(DISTINCT product_id) AS total
FROM dbo.olist_products_dataset
GROUP BY product_category_name
ORDER BY total DESC;


-- Observamos alguns produtos sem valor para categoria, iremos realizar a imputação com a categoria outros.

-- We observed some products with no value for the category, we will carry out the imputation with the other category.

UPDATE dbo.olist_products_dataset
	SET product_category_name = 'Outros'
WHERE product_category_name IS NULL


-- Iremos agora realizar modificações para que a primeira letra fique em maíusculo e as demais em minúsculo.

-- We will now make changes so that the first letter is capitalized and the rest are lowercase.

UPDATE dbo.olist_products_dataset
	SET product_category_name = CONCAT(
										UPPER(SUBSTRING(product_category_name, 1,1)),
										LOWER(SUBSTRING(product_category_name, 2, LEN(product_category_name))))


-----------------------------------------
-- Rank Média Avaliação por Categorias / Rank Average Rating by Categories
-- Cds_dvds_musicais						4,64285714285714
-- Fashion_roupa_infanto_juvenil			4,5
-- Livros_interesse_geral					4,44626593806922
-- Construcao_ferramentas_ferramentas		4,44444444444444
-- Flores									4,41935483870968
-- Livros_importados						4,4
-- Livros_tecnicos							4,36842105263158
-- Alimentos_bebidas						4,31541218637993
-- Malas_acessorios							4,31525735294118
-- Portateis_casa_forno_e_cafe				4,30263157894737


SELECT
	p.product_category_name,
	AVG(CONVERT(FLOAT, review_score)) AS avg_score
FROM dbo.olist_order_reviews_dataset AS re 
JOIN dbo.olist_order_items_dataset oi 
ON re.order_id = oi.order_id
JOIN dbo.olist_products_dataset AS p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_score DESC;