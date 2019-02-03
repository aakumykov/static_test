function attachmentsCount() {
  let attNodes = $('div.b-message-attach.js-attachments');
  let count = (attNodes.size() > 1) ? attNodes.last().children().length : attNodes.length;
  return count;
}
