#SingleInstance Force

; Глобальные переменные
readerMode := false

; Функции
;checkWindow(initialTitle){
;	WinGetTitle, winTitle, ahk_class MozillaWindowClass
;	
;}

openSearch() {
	Run, firefox.exe "http://ya.ru"
}

openMail(){
	Run, firefox.exe "http://mail.yandex.ru/lite"
}

focusFirefox(){
	WinActivate, ahk_class MozillaWindowClass
}

nextLink(){
	global readerMode
	if (readerMode) {
		
		focusFirefox()
		Send, `t
	}
}

prevLink(){
	global readerMode
	if (readerMode) {
		focusFirefox()
		Send, +`t
	}
}

openLink(){
	focusFirefox()
    Send, {Return}
	;Click
	;Sleep, 1000
	;WinGetTitle, currentWinTitle, ahk_class MozillaWindowClass
    ;SetTimer, WindowTitleCheck, 100
}

closeTab(){
	;alertTitle()
	focusFirefox()
    Send, {Ctrl down}w{Ctrl up}
}

getWinTitle() {
	WinGetTitle, currentWinTitle, A
	return currentWinTitle
}

isYoutubeVideo() {
	winTitle := getWinTitle()
    videoPattern := " - YouTube - Mozilla Firefox"
	foundPos := RegExMatch(winTitle, videoPattern)
	return (0 != foundPos)
}

videoPlayPause() {
	global readerMode
	
	if ( readerMode ) {
		if ( isYoutubeVideo() ) {
			Click, 65, 529
		}
	}
}

videoSkipForward() {
	global readerMode
	
	if ( readerMode ) {
		if ( isYoutubeVideo() ) {
			Send, {Right}
		}
	}
}

videoSkipBack() {
	global readerMode
	
	if ( readerMode ) {
		if ( isYoutubeVideo() ) {
			Send, {Left}
		}
	}
}


; Временные отладочные функции
alertTitle() {
	if ( isYoutubeVideo() ) {
		title := getWinTitle()
		MsgBox,,, "TRUE"
	} else {
		MsgBox,,, "FALSE"
	}
}



; Логика
ScrollLock::
readerMode := !readerMode
;MsgBox, , readerMode, %readerMode%
return

~F1::
nextLink()
return

~F2::
prevLink()
return

~F3::
openLink()
return

~F4::
closeTab()
return

~Numpad9::
openMail()
return

~Numpad3::
openSearch()
return

~F6::
alertTitle()
return

~s::
videoPlayPause()
return

~d::
videoSkipForward()
return

~a::
videoSkipBack()
return

~F7::
Run, "C:\Program Files (x86)\NVDA\nvda.exe",, Hide
;Sleep, 3000
;MsgBox,, "NVDA", %nvdaPID%
return

^z::
Process, Close, nvda.exe
;Runwait, taskkill /im firefox.exe /f
return

; Блоки с метками
WindowTitleCheck:
	WinGetTitle, newWinTitle, ahk_class MozillaWindowClass
	if (currentWinTitle != newWinTitle) {
		MsgBox, , 'Заголовок изменился', %newWinTitle%
		SetTimer, WindowTitleCheck, Off
	}
return
