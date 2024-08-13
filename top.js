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
                "<li><a href='/pages-projects/bi/global_AI_salaries/globalAISalaries.html'>EDA - Data Professional Salaries with Python and Power BI</a></li>"+
                "<li><a href='/pages-projects/bi/amazon/amazon.html'>Amazon Dashboard Sales with Python and Power BI</a></li>"+
                "</li>"+
                "</ul>"+
                "</li>"+
                "<li><a href='/page-da.html'>Data Analysis</a>"+
                "<ul>"+
                "<li><a href='/pages-projects/data-analysis/foodgood/foodgood'>Data Warehouse Food-Good with SSIS and SQL Server</a></li>"+
                "<li><a href='/pages-projects/data-analysis/olist/olist.html'>Data Warehouse Olist-Ecommerce with SQL Server and Power BI</a></li>"+
                "</ul>"+
                "<li><a href='#'>Data Science</a>"+
                "<ul>"+
                "<li><a href='#'>Soon</a>"+
                "</ul>"+
                "<li><a href='/page-about.html'>About</a></li>"+
                "</ul>"+
                "</nav>"+
                "<nav>"+
			    "<ul>"+
			    "</ul>"+
		        "</nav>"+
                "</section>"

topo.innerHTML += conteudo