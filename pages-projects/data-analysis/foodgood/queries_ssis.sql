
-- Channel

SELECT
	[channel_id],
	[channel_name],
	[channel_type]
FROM [Relational_foodgood].[dbo].[channels];


CREATE TABLE [dbo].[dim_channel] (	
	[nk_channel_id]									INT NOT NULL,
	[nm_channel_name]								NVARCHAR(50) NOT NULL,
	[nm_channel_type]								NVARCHAR(50) NOT NULL
)




---------------------------------------------------------------------------------
-- Store

SELECT
	[store_id],
	st.[hub_id],
	[hub_name],
	[hub_city],
	[hub_state],
	[store_name],
    [store_segment],
    [store_plan_price],
    [store_latitude],
    [store_longitude]
FROM [Relational_foodgood].[dbo].[hubs] AS hb 
	LEFT JOIN [Relational_foodgood].[dbo].[stores] AS st 
ON (hb.hub_id = st.hub_id)


CREATE TABLE [dbo].[dim_store] (
	[nk_store_id]									INT NOT NULL,
	[nk_hub_id]										INT NOT NULL,
	[nm_hub_name]									NVARCHAR(50) NULL,
	[nm_hub_city]									NVARCHAR(50) NULL,
	[nm_hub_state]									CHAR(2) NULL,
	[nm_store_name]									NVARCHAR(50) NULL,
	[nm_store_segment]								NVARCHAR(50) NULL,
	[nr_store_plan_price]							FLOAT NULL,
	[nr_store_latitude]								DECIMAL(10,8) NULL,
	[nr_store_longitude]							DECIMAL(11,8) NULL
)


---------------------------------------------------------------------------------
-- Payments

SELECT 
	[payment_id],
	p.[payment_order_id],
	[payment_amount],
	[payment_fee],
	[payment_method],
	[payment_status],
	[order_delivery_cost]
FROM [Relational_foodgood].[dbo].[payments] AS p
LEFT JOIN [Relational_foodgood].[dbo].[orders] AS o
	ON 	(o.order_id = p.payment_order_id)


CREATE TABLE [dbo].[dim_payments] (
	[nk_payment_id]									INT NOT NULL,
	[nk_payment_order_id]							INT NOT NULL,
	[nr_payment_amount]								NVARCHAR(50) NULL,
	[nr_payment_fee]								NVARCHAR(50) NULL,
	[nm_payment_method]								NVARCHAR(50) NULL,
	[nm_payment_status]								NVARCHAR(50) NULL,
	[nr_order_delivery_cost]						NVARCHAR(50) NULL
)


---------------------------------------------------------------------------------
-- Deliveries

SELECT
	[delivery_id],
	[delivery_order_id],
	dlv.[driver_id],
	[driver_modal],
	[driver_type],
	[delivery_distance_meters],
	[delivery_status]
FROM [Relational_foodgood].[dbo].[deliveries] AS dlv 
LEFT JOIN [Relational_foodgood].[dbo].[drivers] AS drv 
	ON (dlv.driver_id = drv.driver_id)


CREATE TABLE [dbo].[dim_deliveries] (
	[nk_delivery_id]								INT NOT NULL,
	[nk_delivery_order_id]     						INT NOT NULL,
	[nk_driver_id]									INT NULL,
	[nm_driver_modal]								NVARCHAR(50) NULL,
	[nm_driver_type]								NVARCHAR(50) NULL,
	[nr_delivery_distance_meters]					INT NULL,
	[nm_delivery_status]							NVARCHAR(50) NULL
)




---------------------------------------------------------------------------------
-- Orders

SELECT
	o.[order_id],
	s.[store_id],
	c.[channel_id],
	o.[order_moment_created],
	o.[order_moment_finished]
FROM [Relational_foodgood].[dbo].[orders] AS o 
	LEFT JOIN [Relational_foodgood].[dbo].[stores] AS s 				
ON (o.store_id = s.store_id)
	LEFT JOIN [Relational_foodgood].[dbo].[channels] AS c 			
ON (o.channel_id = c.channel_id)


CREATE TABLE [dbo].[fact_orders]
(
	[nk_order_id]    								INT NULL,
	[nk_store_id]     								INT NULL,
	[nk_channel_id]     							INT NULL,
	[nk_order_moment_created]     					DATETIME NULL,
	[nk_order_moment_finished]     					DATETIME NULL
)
