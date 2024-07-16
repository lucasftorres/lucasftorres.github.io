In this project we will use the Brazilian ecommerce public data set, made available by Olist, a Startup that operates in the retail technology segment.

Olist connects small businesses in Brazil to communication channels so that merchants can sell their products via the web and ship them directly to customers using logistics partners.

The data was obtained from the Kaggle platform in CSV format, we used SQL Server 2022 as the DBMS and SQL Server Management Studio to carry out the necessary queries.

The first step was to configure the necessary instance on SQL Server.

Then we started importing the CSV files.

We create the necessary tables to better select and manage the data needed for the project.

We can now define the objectives:


Main page:
	Segmentation Filter (State)

	Olist(Logo) descriptive table

	Header															 
	- Total Number of Customers - Card	
	- Total Number of Sellers - Card	
	- General Rating Average - Card									
	- Total Quantity of Products - Card	 									
	- Total Quantity of Categories - Card	

	Table 1
	- Number of Orders by Status									

	Table 2
	- Average Rating by Category

	Chart 1 - Horizontal Bar Chart
	- Total Number of Customers per City

	Chart 2 - Horizontal Bar Chart						
	- Total Number of Customers by State 											

	Chart 3 - Vertical Bar Chart 	
	- Number of Orders by Payment Type					



Financial Page:
	Year and State Segmentation Filter)

	Header
	- Average Order Value - Card	
	- Higher Value Order - Card	 
	- Total Revenue - Card	

	Table
	- Total Revenue by Status Type

	Chart 4 - Funnel
	- Rank States with the highest Revenue

	Chart 5 - Bar Chart
	- Total Revenue by Payment Type

	Chart 6 - Horizontal Bar Chart
	- Revenue Rank by Product Category


Historical Page:
	Segmentation Filter (State)
	Segmentation Filter (Year)

	Chart 7 - Line Chart
	- Concentration of purchasing volume (Day of the Week)

	Chart 8 - Area Chart
	- Concentration of purchase volume (Day)

	Chart 9 - Area Chart
	- Concentration of purchasing volume (Time)

	Chart 10 - Area Chart
	- Concentration of purchase volume (Month)
