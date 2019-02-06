// ==UserScript==
// @name     Youtube (результаты поиска)
// @version  1
// @grant    none
// @include  https://www.youtube.com/results?search_query=*
// @require  https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js
// ==/UserScript==

var $ = window.jQuery;

$(document).ready(function(){
 
  // Слова поискового запроса
  // let searchQuery = $('input#masthead-search-term').attr('value').trim();
  let searchQuery = $('input#search').get(0).value;
 
  // Собираю ссылки на результаты
  let resSet = $("A#video-title");
  let searchPager = $("div.search-pager");
  let pageButtons = $("div.search-pager").find('A');
  pageButtons.splice(-1,1);
 
  //alert(resSet.length);
  $("html, body").animate({ scrollTop: $(document).height()-$(window).height() });
  //return;
  
 	setTimeout(function(){
    
    // Переделываю страницу
    // 1) подготовка переделки
    $(document.body).empty();
    $(document.body).append("<style>BODY { padding: 20pt; } * { font-family: serif; } A { font-size: 2em; } H1 { text-align:center; padding-bottom: 20pt; }</style>");
    $(document.body).append("<h1>Результаты поиска видео по запросу &laquo;"+searchQuery+"&raquo;</h1>");

    $(document.body).append("<ul>");

    resSet.each(function(index, element){
      let text = $(element).text();
      let href = "https://www.youtube.com" + $(element).attr('href');
      //$(document.body).append( $("<li>"+text+"</li>") );
      $(document.body).append( $("<li><a href='"+href+"' target='_blank'>"+text+"</a></li>") );
    });

    $(document.body).append("</ul>");


    $(document.body).append("<H1>Следующие страницы результатов поиска</H1>");
    $(document.body).append("<ul style='text-align:center;'>");
    pageButtons.each(function(index, element){
      let text = $(element).text();
      let href = "https://www.youtube.com" + $(element).attr('href');
      $(document.body).append( $("<li><a href='"+href+"'>Страница результатов "+text+"</a></li>") );
    });
    $(document.body).append("</ul>");
    
  }, 3000);

});
