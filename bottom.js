// const head = document.head
const corpo = document.body

const estilo2 = '<link rel="stylesheet" type = "text/css" href="/assets/css/main.css"/>'
// head.innerHTML += estilo

const bottom = document.createElement('div')
bottom.setAttribute('id','bottom')

corpo.append(bottom)

const content = 


"<section id='footer'>"+
"<div class='container'>"+
"<div class='row'>"+
"<div class='col-4 col-6-medium col-12-small'>"+
"<section>"+
									"<header>"+
                                    "<h2>Recently</h2>"+
									"</header>"+
									"<ul class='divided'>"+
                                    "<li><a href='/pages-projects/data-analysis/olist/olist.html'>Data Warehouse Olist</a></li>"+
                                    "<li><a href='/pages-projects/bi/global_AI_salaries/globalAISalaries.html'>Data Professional Salaries - 2024</a></li>"+
                                    "<li><a href='/pages-projects/bi/amazon/amazon.html'>Amazon India Sales</a></li>"+
									"</ul>"+
                                    "</section>"+
                                    "</div>"+
                                    "<div class='col-4 col-6-medium col-12-small'>"+
                                    "<section>"+
                                    "</section>"+
                                    "</div>"+
                                    "<div class='col-4 col-12-medium'>"+
                                    "<section>"+
									"<header>"+
                                    "<h2>Contact</h2>"+
									"</header>"+
									"<ul class='social'>"+
                                    "<li><a class='icon brands linkedin fa-linkedin-in' href='https://www.linkedin.com/in/lucastorresf'><span class='label'>LinkedIn</span></a></li>"+
                                    "<li><a class='icon brands github fa-github' href='https://github.com/lucasftorres'><span class='label'>GitHub</span></a></li>"+
									"</ul>"+
									"<ul class='contact'>"+
                                    "<li>"+
                                    "<h3>Address</h3>"+
                                    "<p>"+
                                    "Recife, Pernambuco, Brasil<br />"+
                                    "</p>"+
                                    "</li>"+
                                    "<li>"+
                                    "<h3>e-mail</h3>"+
                                    "<p><a href='#'>lucaas.torresf192@gmail.com</a></p>"+
                                    "</li>"+
									"</ul>"+
                                    "</section>"+
                                    "</div>"+
                                    "</div>"+
                                    "</div>"+
                                    "</section>"

bottom.innerHTML += content