const head = document.head
const body = document.body

const estilo = '<link rel="stylesheet" type = "text/css" href="/assets/css/main.css"/>'
head.innerHTML += estilo

const topo = document.createElement('div')
topo.setAttribute('id','topo')

body.prepend(topo)

const conteudo = 

"<section id='header'>"+

        "<h1><a href='/index.html'>Portfolio - Lucas Torres</a></h1>"+

       "<nav id='nav'>"+
            "<ul>"+
                "<li class='current'><a href='/index.html'>Home</a></li>"+
                "<li>"+
                "<a href='/page-bi.html'>Business Intelligence</a>"+
                "<ul>"+
                "<li><a href='/pages-projects/bi/foodgood/foodgood.html'>Food Good</a></li>"+
                "<li><a href='/pages-projects/bi/global_AI_Salaries/globalAISalaries.html'>Global AI Salaries</a></li>"+
                "<li><a href='/pages-projects/bi/olist/olist.html'>Olist</a></li>"+
                "<li><a href='/pages-projects/bi/waze/waze.html'>Waze</a></li>"+
                "<li><a href='/pages-projects/bi/amazon/amazon.html'>Amazon</a></li>"+
                "<li><a href='/pages-projects/bi/popular_market/popularMarket.html'>Popular Market</a></li>"+
                "<li><a href='/pages-projects/bi/bikesales/bikeSales.html'>Bike Sales</a></li>"+
                "<li><a href='/pages-projects/bi/coffee/coffee.html'>Coffee</a></li>"+
                "<li><a href='/pages-projects/bi/covid19/covid19.html'>Covid 19</a></li>"+
                "<li><a href='/pages-projects/bi/house_sales/house_sales.html'>Washington House Sales</a></li>"+
                "</li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='/page-da.html'>Data Analysis</a>"+
                "<ul>"+
                "<li><a href='#'>Análise Descritiva</a>"+
                "<ul>"+
                "<li><a href='#'>Projeto 1</a></li>"+
                "<li><a href='#'>Projeto 2</a></li>"+
                "<li><a href='#'>Projeto 3</a></li>"+
                "<li><a href='#'>Projeto 4</a></li>"+
                "<li><a href='#'>Projeto 5</a></li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='/#'>Análise Diagnóstica</a>"+
                "<ul>"+
                "<li><a href='/pages-projects/data-analysis/dg/varejistas.html'>Varejistas Ecommerce</a></li>"+
                "<li><a href='#'>Projeto 2</a></li>"+
                "<li><a href='#'>Projeto 3</a></li>"+
                "<li><a href='#'>Projeto 4</a></li>"+
                "<li><a href='#'>Projeto 5</a></li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='#'>Análise Estatística</a>"+
                "<ul>"+
                "<li><a href='#'>Projeto 1</a></li>"+
                "<li><a href='#'>Projeto 2</a></li>"+
                "<li><a href='#'>Projeto 3</a></li>"+
                "<li><a href='#'>Projeto 4</a></li>"+
                "<li><a href='#'>Projeto 5</a></li>"+
                "</ul>"+
                "</li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='/page-ds.html'>Data Science</a>"+
                "<ul>"+
                "<li><a href='#'>Análise Preditiva</a>"+
                "<ul>"+
                "<li><a href='#'>Projeto 1</a></li>"+
                "<li><a href='#'>Projeto 2</a></li>"+
                "<li><a href='#'>Projeto 3</a></li>"+
                "<li><a href='#'>Projeto 4</a></li>"+
                "<li><a href='#'>Projeto 5</a></li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='#'>Análise Prescritiva</a>"+
                "<ul>"+
                "<li><a href='#'>Projeto 1</a></li>"+
                "<li><a href='#'>Projeto 2</a></li>"+
                "<li><a href='#'>Projeto 3</a></li>"+
                "<li><a href='#'>Projeto 4</a></li>"+
                "<li><a href='#'>Projeto 5</a></li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='#'>Análise Inferêncial</a>"+
                "<ul>"+
                "<li><a href='#'>Projeto 1</a></li>"+
                "<li><a href='#'>Projeto 2</a></li>"+
                "<li><a href='#'>Projeto 3</a></li>"+
                "<li><a href='#'>Projeto 4</a></li>"+
                "<li><a href='#'>Projeto 5</a></li>"+
                "</ul>"+
                "</li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='/page-about.html'>About</a></li>"+
                "</ul>"+
                "</nav>"+
                "<nav>"+
			    "<ul>"+
			    "</ul>"+
		        "</nav>"+
                "</section>"

topo.innerHTML += conteudo