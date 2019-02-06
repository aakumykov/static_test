// ==UserScript==
// @name     Youtube (пауза при открытии)
// @version  1
// @grant    none
// @include  https://www.youtube.com/watch?v=*
// @require  https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js
// ==/UserScript==


var $ = window.jQuery;

$(document).ready(function(){

  $('video.html5-main-video').get(0).pause()

});
