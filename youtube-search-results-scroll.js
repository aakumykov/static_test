// ==UserScript==
// @name     Youtube (результаты поиска с прокруткой)
// @version  1
// @grant    none
// @include  https://www.youtube.com/results?search_query=*
// @require  https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js
// ==/UserScript==

var $ = window.jQuery;

let scrollCallbackCounter = 0;


// Запуск скрипта
$(window).load(function() {
  
  $("html, body").animate({ scrollTop: $(document).height()*3 }, 5000, 'swing', function(){
  	let resSet = $("A#video-title");
    scrollCallbackCounter += 1;
    
    if (2==scrollCallbackCounter) {
    	processPage();
    }
  });
  
});


// Функции
function processPage() {
  
  // Слова поискового запроса
  // let searchQuery = $('input#masthead-search-term').attr('value').trim();
  let searchQuery = $('input#search').get(0).value;
 
  // Собираю ссылки на результаты
  let resSet = $("A#video-title");
   
 	setTimeout(function(){
    
    // Переделываю страницу
    // 1) подготовка переделки
    $(document.body).empty();
    $(document.body).append("<style>BODY { padding: 20pt; } * { font-family: serif; } A { font-size: 2em; } H1 { text-align:center; padding-bottom: 20pt; }</style>");
    $(document.body).append("<h1>Результаты поиска видео по запросу &laquo;"+searchQuery+"&raquo;</h1>");

    $(document.body).append("<ul id='resultsList'></ul>");

    resSet.each(function(index, element){
      let text = $(element).text();
      let href = "https://www.youtube.com" + $(element).attr('href');
      //$(document.body).append( $("<li><a href='"+href+"' target='_blank'>"+text+"</a></li>") );
      $("ul#resultsList").append( $("<li><a href='"+href+"' target='_blank'>"+text+"</a></li>") );
    });

    //$(document.body).append("</ul>");
    
  }, 3000);
  
}


