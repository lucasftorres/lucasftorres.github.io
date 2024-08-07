-- Observamos que para um mesmo prefixo pode conter diversas latitudes e longitudes, sempre indicando a mesma cidade e estado, ou seja o prefixo
-- é usado de forma genérica pois está incompleto assim não conseguimos associar a localização exata como bairro e rua, portanto podemos manter somente 1 valor de prefixo já que irá indicar a somente a cidade e o estado.
-- Isso ajudará a diminuir a quantidade de registros e consequentemente o tempo de carregamento e conexão entre os dados no Power BI que não consegue reconhecer o relacionamento entre as tabelas pois há duplicidade.

-- We note that the same prefix can contain different latitudes and longitudes, always indicating the same city and state, that is, the prefix
-- is used generically because it is incomplete so we cannot associate the exact location such as neighborhood and street, so we can only keep 1 prefix value as it will only indicate the city and state.
-- This will help reduce the number of records and consequently the loading and connection time between data in Power BI, which cannot recognize the relationship between tables because there is duplication.

DELETE T
FROM 
(
SELECT 
	*,
	Duplicate = ROW_NUMBER() OVER (PARTITION BY geolocation_zip_code_prefix ORDER BY(SELECT NULL)
		)
FROM dbo.dim_geolocation
) AS T
WHERE Duplicate > 1


-- Criaremos agora as Tabelas Dimensão e Fato, com suas respectivas Natural Keys e Surrogate Keys para a Modelagem Dimensional do DataWarehouse
-- We will now create the Dimension and Fact Tables, with their respective Natural Keys and Surrogate Keys for DataWarehouse Dimensional Modeling

-- Na criação da tabela clientes iremos optar por não utilizar as colunas cidade e estado por questão de normalização pois a partir da coluna zip_code nós iremos obter a informação da tabela geolocation
-- When creating the customers table, we will choose not to use the city and state columns for normalization reasons, as from the zip_code column we will obtain information from the geolocation table

-- Tabela Dimensão Clientes
-- Customers Dimension Table
CREATE TABLE dim_customers (
	sk_customer_id INT NOT NULL IDENTITY PRIMARY KEY,
	nk_customer_id CHAR(32) NOT NULL ,
	nm_customer_city VARCHAR(50) NULL,
	nm_customer_state VARCHAR(30) NULL,
	nr_customer_lat DECIMAL(10,8) NULL,
	nr_customer_lon DECIMAL(11,8) NULL,
	nr_customer_zip_code_prefix INT
)

INSERT INTO dbo.dim_customers (
	nk_customer_id,
	nm_customer_city,
	nm_customer_state,
	nr_customer_lat,
	nr_customer_lon,
	nr_customer_zip_code_prefix
)
SELECT
	c.customer_id,
	c.customer_city,
	c.customer_state,
	g.geolocation_lat,
	g.geolocation_lng,
	c.customer_zip_code_prefix
FROM dbo.olist_customers_dataset AS c LEFT JOIN dbo.olist_geolocation_dataset AS g ON (g.geolocation_zip_code_prefix = c.customer_zip_code_prefix);




---------------------------------
-- Tabela Dimensão Vendedores
-- Sellers Dimension Table
CREATE TABLE dim_sellers (
	sk_seller_id INT NOT NULL IDENTITY PRIMARY KEY,
	nk_seller_id CHAR(32) NOT NULL,
	nm_seller_city VARCHAR(50) NULL,
	nm_seller_state VARCHAR(30) NULL,
	nr_seller_lat DECIMAL(10,8) NULL,
	nr_seller_lon DECIMAL(11,8) NULL,
	nr_seller_zip_code_prefix INT
)
INSERT INTO dbo.dim_sellers (
	nk_seller_id,
	nm_seller_city,
	nm_seller_state,
	nr_seller_lat,
	nr_seller_lon,
	nr_seller_zip_code_prefix
)
SELECT
	s.seller_id,
	s.seller_city,
	s.seller_state,
	g.geolocation_lat,
	g.geolocation_lng,
	s.seller_zip_code_prefix
FROM dbo.olist_sellers_dataset AS s LEFT JOIN dbo.olist_geolocation_dataset AS g ON (g.geolocation_zip_code_prefix = s.seller_zip_code_prefix);

-- Iremos criar uma Function reutilizavei para substituir as siglas dos estados por nome completo, pois a abreviação pode ser vinculada a estados de outros países.
-- We will create a reusable Function to replace state acronyms with full names, as the abbreviation can be linked to states in other countries.

CREATE FUNCTION state(@ab_state VARCHAR(30))
RETURNS VARCHAR(30)
AS
	BEGIN
			DECLARE @nm_state VARCHAR(30)
			SET @nm_state = CASE 
								WHEN @ab_state = 'AC' THEN 'Acre'
								WHEN @ab_state = 'AL' THEN 'Alagoas'
								WHEN @ab_state = 'AP' THEN 'Amapa'
								WHEN @ab_state = 'AM' THEN 'Amazonas'
								WHEN @ab_state = 'BA' THEN 'Bahia'
								WHEN @ab_state = 'CE' THEN 'Ceara'
								WHEN @ab_state = 'DF' THEN 'Distrito Federal'
								WHEN @ab_state = 'ES' THEN 'Espirito Santo'
								WHEN @ab_state = 'GO' THEN 'Goias'
								WHEN @ab_state = 'MA' THEN 'Maranhao'
								WHEN @ab_state = 'MT' THEN 'Mato Grosso'
								WHEN @ab_state = 'MS' THEN 'Mato Grosso do Sul'
								WHEN @ab_state = 'MG' THEN 'Minas Gerais'
								WHEN @ab_state = 'PA' THEN 'Para'
								WHEN @ab_state = 'PB' THEN 'Paraiba'
								WHEN @ab_state = 'PR' THEN 'Parana'
								WHEN @ab_state = 'PE' THEN 'Pernambuco'
								WHEN @ab_state = 'PI' THEN 'Piaui'
								WHEN @ab_state = 'RJ' THEN 'Rio de Janeiro'
								WHEN @ab_state = 'RN' THEN 'Rio Grande do Norte'
								WHEN @ab_state = 'RS' THEN 'Rio Grande do Sul'
								WHEN @ab_state = 'RO' THEN 'Rondonia'
								WHEN @ab_state = 'RR' THEN 'Roraima'
								WHEN @ab_state = 'SC' THEN 'Santa Catarina'
								WHEN @ab_state = 'SP' THEN 'Sao Paulo'
								WHEN @ab_state = 'SE' THEN 'Sergipe'
								ELSE 'Tocantins'
							END;
			RETURN @nm_state
	END
UPDATE dim_sellers
	SET nm_seller_state = dbo.state(nm_seller_state);

UPDATE dim_customers
	SET nm_customer_state = dbo.state(nm_customer_state);

---------------------------------
-- Tabela Dimensão Pagamentos
-- Payments Dimension Table
CREATE TABLE dim_payments (
	sk_payment_id INT NOT NULL IDENTITY PRIMARY KEY,
	nk_order_id CHAR(32) NOT NULL,
	nr_payment_sequential INT NOT NULL,
	nm_payment_type VARCHAR(50) NULL,
	nr_payment_installments INT,
	nr_payment_value FLOAT NULL
)

INSERT INTO dbo.dim_payments (
	nk_order_id,
	nr_payment_sequential,
	nm_payment_type,
	nr_payment_installments,
	nr_payment_value
)
SELECT
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
FROM dbo.olist_order_payments_dataset;


----------------------------------
-- Tabela Dimensão Produtos
-- Product Dimension Table
CREATE TABLE dim_products (
	sk_product_id INT NOT NULL IDENTITY PRIMARY KEY,
	nk_product_id CHAR(32) NOT NULL,
	nm_product_category_name VARCHAR(50) NULL
)
INSERT INTO dbo.dim_products (
	nk_product_id,
	nm_product_category_name
)
SELECT 
	p.product_id,
	pe.product_category_name_english
FROM dbo.olist_products_dataset AS p JOIN dbo.olist_product_category_name_translation AS pe ON p.product_category_name = pe.product_category_name;



----------------------------------
-- Para este projeto não estamos interessando no conteúdo da avaliação portanto não utilizarmos as colunas que se referem a conteudo e mensagem assim como não iremos avaliar a temporalidade das avaliações.
-- For this project we are not interested in the content of the review, so we will not use the columns that refer to content and message, nor will we evaluate the temporality of the review.

-- Tabela Dimensão de Avaliações
-- Review Dimension Table
CREATE TABLE dim_reviews (
	sk_order_id INT NOT NULL IDENTITY PRIMARY KEY,
	nk_review_id CHAR(32) NOT NULL,
	nk_order_id CHAR(32) NOT NULL,
	nr_review_score INT
)

INSERT INTO dbo.dim_reviews (
	nk_review_id,
	nk_order_id,
	nr_review_score
)
SELECT 
	review_id,
	order_id,
	review_score
FROM dbo.olist_order_reviews_dataset;


----------------------------------
-- Tabela Dimensão Calendário
-- Calendar Dimension Table
CREATE TABLE dim_time ( 
	sk_date              INT NOT NULL PRIMARY KEY,
	dt_date            	 DATE,
	nr_year              INT,
	nr_month             INT,
	nm_month			 VARCHAR(15) NOT NULL,	
	nr_day               INT,
	nr_quarter           INT,
	nr_week              INT,
	nm_weekday           VARCHAR(15) NOT NULL,
	nr_weekday           INT,
	nr_isBusDay		     INT NOT NULL
 );


DECLARE @startdate DATE;
DECLARE @stopdate DATE;

SET @startdate = '2016-01-01'
SET @stopdate =  '2020-01-01'

WHILE @startdate <= @stopdate
    BEGIN
        INSERT INTO dbo.dim_time
            SELECT
                YEAR(@startdate)*10000 + MONTH(@startdate)*100 + DAY(@startdate),
                @startdate,
                YEAR(@startdate),
                MONTH(@startdate),
				DATENAME(MONTH, @startdate),
                DAY(@startdate),
                DATEPART(QUARTER, @startdate),
                DATEPART(WEEK, @startdate),
                DATENAME(WEEKDAY, @startdate),
                DATEPART(WEEKDAY, @startdate),
                isBusDay = 
                    CASE 
                        WHEN DATEPART(WEEKDAY, @startdate) IN (1, 7)
                            THEN 0
                        ELSE 1
                    END
				SET @startdate = DATEADD(dd, 1, @startdate)
    END

----------------------------------
-- Tabela Dimensão Itens do Pedido
-- Order Items Dimension Table
CREATE TABLE dim_order_items (
	sk_order_item_id			INT NOT NULL PRIMARY KEY IDENTITY,
	nk_order_id 				CHAR(32) NOT NULL,
	nk_order_item_id 			INT NOT NULL,
	nk_product_id				CHAR(32) NOT NULL,
	nm_order_status				VARCHAR(20) NOT NULL,
	nr_price 					FLOAT,
	nr_freight_value			FLOAT,
	nk_customer_id				CHAR(32) NOT NULL,
	nk_seller_id				CHAR(32) NOT NULL,
	nr_date_purchase			DATE NULL,
	nr_hour_purchase			INT NULL,
	nr_date_carrier				DATE NULL,
	nr_date_delivered			DATE NULL,
	nr_date_estimated			DATE NULL,
)
INSERT INTO dim_order_items (
		nk_order_id,
		nk_order_item_id,
		nk_product_id,
		nm_order_status,
		nr_price,
		nr_freight_value,
		nk_customer_id,
		nk_seller_id,
		nr_date_purchase,
		nr_hour_purchase,
		nr_date_carrier,
		nr_date_delivered,
		nr_date_estimated
	)

	SELECT
		oi.order_id,
		oi.order_item_id,
		oi.product_id,
		o.order_status,
		oi.price,
		oi.freight_value,
		o.customer_id,
		oi.seller_id,
		o.order_purchase_timestamp,
		DATEPART(HOUR, o.order_purchase_timestamp),
		o.order_delivered_carrier_date,
		o.order_delivered_customer_date,
		o.order_estimated_delivery_date
	FROM dbo.olist_order_items_dataset AS oi 
	LEFT JOIN dbo.olist_orders_dataset AS o
	ON (oi.order_id = o.order_id)



---------------------------------
-- Para realizar a carga de dados na tabela precisaremos utilizar as Natural Keys para obter as Surrogate Keys, e posteriormente iremos retirar as NK da tabela.
-- To load data into the table we will need to use the Natural Keys to obtain the Surrogate Keys, and later we will remove the NK from the table.

-- Tabela Fato Pedidos
-- Order Fact Table
CREATE TABLE fct_orders (
	sk_date 					INT NOT NULL,
	sk_order_item_id 			INT NOT NULL,
	sk_product_id 				INT NOT NULL,
	sk_customer_id 				INT NOT NULL,
	sk_payment_id				INT NULL,
	sk_seller_id 				INT NOT NULL,
	sk_order_id 				INT NULL,
	nk_order_id 				CHAR(32) NOT NULL,
	nk_product_id 				CHAR(32) NOT NULL,
	nk_customer_id 				CHAR(32) NOT NULL,
	nk_seller_id 				CHAR(32) NOT NULL,
	CONSTRAINT fk_fact_time 		FOREIGN KEY (sk_date)							REFERENCES dim_time (sk_date),
	CONSTRAINT fk_fact_customers 	FOREIGN KEY (sk_customer_id)					REFERENCES dim_customers(sk_customer_id),
	CONSTRAINT fk_fact_payments 	FOREIGN KEY (sk_payment_id) 					REFERENCES dim_payments(sk_payment_id),
	CONSTRAINT fk_fact_products 	FOREIGN KEY (sk_product_id) 					REFERENCES dim_products(sk_product_id),
	CONSTRAINT fk_fact_order_item 	FOREIGN KEY (sk_order_item_id) 					REFERENCES dim_order_items(sk_order_item_id),
	CONSTRAINT fk_fact_sellers 		FOREIGN KEY (sk_seller_id) 						REFERENCES dim_sellers(sk_seller_id),
	CONSTRAINT fk_fact_reviews 		FOREIGN KEY (sk_order_id) 						REFERENCES dim_reviews(sk_order_id)
)
INSERT INTO dbo.fct_orders (
	sk_date,
	sk_customer_id,
	sk_payment_id,
	sk_product_id,
	sk_order_item_id,
	sk_seller_id,
	sk_order_id,
	nk_order_id,
	nk_product_id,
	nk_customer_id,
	nk_seller_id
)
SELECT
	YEAR(oi.nr_date_purchase)*10000+MONTH(oi.nr_date_purchase)*100 + DAY(oi.nr_date_purchase),
	c.sk_customer_id,
	pay.sk_payment_id,
	p.sk_product_id,
	oi.sk_order_item_id,
	s.sk_seller_id,
	re.sk_order_id,
	oi.nk_order_id,
	p.nk_product_id,
	c.nk_customer_id,
	s.nk_seller_id
FROM dbo.dim_order_items AS oi 
LEFT JOIN dbo.dim_products AS p
ON oi.nk_product_id = p.nk_product_id
LEFT JOIN dbo.dim_customers AS c 
ON oi.nk_customer_id = c.nk_customer_id
LEFT JOIN dbo.dim_sellers AS s 
ON oi.nk_seller_id = s.nk_seller_id 
LEFT JOIN dbo.dim_payments AS pay
ON oi.nk_order_id = pay.nk_order_id 
LEFT JOIN dbo.dim_reviews AS re 
ON oi.nk_order_id = re.nk_order_id



ALTER TABLE fct_orders DROP COLUMN nk_order_id;
ALTER TABLE fct_orders DROP COLUMN nk_product_id;
ALTER TABLE fct_orders DROP COLUMN nk_customer_id;
ALTER TABLE fct_orders DROP COLUMN nk_seller_id;