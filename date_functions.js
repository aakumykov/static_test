function humanizeDate(inDate) {
  let newDate = "ошибка обработки даты";
  
  let oldDateParts = inDate.match(/^(\d+)\.(\d+)\.(\d+)$/);
  let recentDateParts = inDate.match(/^(\d+)\s+([а-я]+)\.$/);
  let todayDateParts = inDate.match(/^(\d+):(\d+)$/);
  
//  console.log(oldDateParts);
//  console.log(recentDateParts);
//  console.log(todayDateParts);
  
  if (oldDateParts) {
    //console.log("newDate: "+newDate);
    let year = oldDateParts[3];
    let month = oldDateParts[2];
    let day = oldDateParts[1];
    newDate = day + " " + month_num2string(month) + " " + year_short2long(year) + " года";
  }
  else if (recentDateParts) {
    //console.log("recentDateParts");
    let day = recentDateParts[1];
    let month = recentDateParts[2];
    newDate = day + " " + month_short2long(month);
  }
  else if (todayDateParts) {
    //console.log("todayDateParts");
    newDate = "сегодня в " + inDate;
  }
  
  return newDate;
}

function month_num2string(num) {
  switch(Number(num)) {
    case 1: return "января";
    case 2: return "февраля";
    case 3: return "марта";
    case 4: return "апреля";
    case 5: return "мая";
    case 6: return "июня";
    case 7: return "июля";
    case 8: return "августа";
    case 9: return "сентября";
    case 10: return "октября";
    case 11: return "ноября";
    case 12: return "декабря";
    default: return "ошибка перевода номера месяца в текст";
  }
}

function month_short2long(shortName) {
  switch(shortName) {
    case "янв": return "января";
    case "фев": return "февраля";
    case "мар": return "марта";
    case "апр": return "апреля";
    case "май": return "мая";
    case "июн": return "июня";
    case "июл": return "июля";
    case "авг": return "августа";
    case "сен": return "сентября";
    case "окт": return "октября";
    case "ноя": return "ноября";
    case "дек": return "декабря";
    default: return "ошибка обработки короткого имени месяца";
  }
}

function year_short2long(y) {
  switch (y.length) {
    case 2: return "20" + y;
    case 4: return y;
    default: return "ошибка перевода короткого номера года в длинный";
  }
}

