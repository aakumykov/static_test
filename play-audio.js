/** Использование:
 playAudio('http://127.0.0.1/search_complete.mp3');
 playAudio('http://127.0.0.1/what_you_want_to_find.mp3', function() {
    processUserInput();
 });
*/

function playAudio(audioURL, completeCallback){
  var audioTag = document.createElement('audio');
  audioTag.src = audioURL;
  
  if (null != completeCallback) audioTag.addEventListener('ended', function(){completeCallback();}, true);
  else console.log("completeCallback is NULL");
  
  audioTag.play();
}
