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
                "<li><a href='/page-da.html'>Projects</a>"+
                "<ul>"+
                "<li><a href='/pages-projects/foodgood/foodgood.html'>Data Warehouse Food-Good with SSIS and SQL Server</a></li>"+
                "<li><a href='/pages-projects/olist/olist.html'>Data Warehouse Olist-Ecommerce with SQL Server and Power BI</a></li>"+
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