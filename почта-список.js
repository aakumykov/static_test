// ==UserScript==
// @name     mail.yandex.ru (список)
// @version  1
// @grant    none
// @match	   https://mail.yandex.ru/lite
// @require      https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js
// @require  https://raw.githubusercontent.com/aakumykov/static_test/master/date_functions.js
// ==/UserScript==

// Системная настройка JQuery
var $ = window.jQuery;


// Произношение фразы
function playAudio(audioURL){
  var audioTag = document.createElement('audio');
  audioTag.src = audioURL;
  audioTag.play();
}


// ========= Функции обработки почты ========
var schema = 'https://';
var host = 'mail.yandex.ru';
var list = [];

// --- Поиск элементов ---
function fetchDate(element) {
  return $(element).find('.b-messages__date').find('span').first().text();
}

function fetchTitle(element) {
  return $(element).find('.b-messages__subject').first().text();
}

function fetchFrom(element) {
  return $(element).find('.b-messages__from__text').find('span').first().text();
}

function fetchLink(element) {
  return $(element).find('.b-messages__message__link').attr('href');
}

function fetchMessageList() {
  $('.b-messages__message').each( function(index, line) {
    var date = fetchDate(line);
    var title = fetchTitle(line);
    var from = fetchFrom(line);
    var link = fetchLink(line);
    //console.log(from+" - "+date+" - "+title+" ("+schema+host+link+")");
    list.push({
      'date': date,
      'title': title,
      'from': from,
      'link': link
    });
  });
}


// --- Очистка страницы ---
function clearPage() {
  //alert('clearPage');
  //console.log('clearPage()');
  $('body').empty();
}


// --- Создание новых элементов ---
function createMessageLine(date, from, title, link) {
  //console.log("DATE: "+date);
  let linePrefix = "Письмо, получено ";
  let humanDate = humanizeDate(date);
 	return $("<li><a href='"+link+"' target='_blank'>"+linePrefix+" "+humanDate+", прислал "+from+", заголовок: "+title+"</a></li>");
}

function createMessageList() {
  $('body').append("<UL id='messageList'></UL>");

  for(var i=0; i<list.length; i++) {
    var item = list[i];
    //console.log(item.title);
    $('#messageList').append( createMessageLine(item.date, item.from, item.title, item.link) );
  }
}


// ================ Когда страница загружена... =================
$(document).ready(function(){
  playAudio('http://127.0.0.1/yandex.wav');
  fetchMessageList();
  clearPage();
  createMessageList();
});
