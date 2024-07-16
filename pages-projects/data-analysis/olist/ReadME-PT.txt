Neste projeto utilizaremos o conjunto de dados públicos do ecommerce brasileiro, disponibilizado pela Olist, Startup que atua no segmento de tecnologia para o varejo.

A Olist conecta pequenas empresas do Brasil a canais de comunicação para que os comerciantes possam vender seus produtos através da web e enviá-los diretamente para os clientes usando os parceiros logísticos.

Os dados foram obtidos na plataforma Kaggle no formato CSV, utilizamos o SQL Server 2022 como SGBD e SQL Server Management Studio para realizar as consultas necessárias.

O primeiro passo foi configurar a instância necessária no SQL Server.

Depois partimos para a importação dos arquivos CSV.

Criamos as tabelas necessárias para melhor seleção e gerenciamento dos dados necessários para o projeto.

Podemos agora definir os objetivos:



Página Principal:
	Filtro Segmentação (Estado)

	Quadro descritivo Olist(Logo)

	Cabeçalho															 
	- Quantidade Total de Clientes - Cartão	
	- Quantidade Total de Vendedores - Cartão	
	- Média Geral de Avaliação - Cartão									
	- Quantidade Total de Produtos - Cartão	 									
	- Quantidade Total de Categorias - Cartão	

	Tabela 1
	- Quantidade de Pedidos por Status									

	Tabela 2
	- Média de Avaliação por Categoria

	Gráfico 1 - Gráfico de Barras Horizontal
	- Quantidade Total de Clientes por Cidade

	Gráfico 2 - Gráfico de Barras Horizontal						
	- Quantidade Total de Clientes por Estado 											

	Gráfico 3 - Gráfico de Barras Vertical 	
	- Quantidade de Pedidos por Tipo de Pagamento 					



Página Financeira:
	Filtro Segmentação Ano e Estado

	Cabeçalho
	- Valor médio do Pedidos - Cartão	
	- Pedido de Valor mais Alto - Cartão	 
	- Receita Total - Cartão	

	Tabela 3
	- Receita Total por Tipo de Status

	Gráfico 4 - Funil
	- Rank Estados com maior Receita

	Gráfico 5 - Gráfico de Barras
	- Receita Total por Tipo de Pagamento

	Gráfico 6 - Gráfico de Barras Horizontal
	- Rank Receita por Categoria de Produtos	


Página Histórico:
	Filtro Segmentação (Estado)
	Filtro Segmentação (Ano)

	Gráfico 7 - Gráfico de Linha
	- Concentração do volume de compras (Dia da Semana)

	Gráfico 8 - Gráfico de Área
	- Concentração do volume de compras (Dia)

	Gráfico 9 - Gráfico de Área
	- Concentração do volume de compras (Hora)

	Gráfico 10 - Gráfico de Área
	- Concentração do volume de compras (Mês)
