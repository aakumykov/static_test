#SingleInstance Force

; Глобальные переменные
readerMode := false
nvdaIsRun := false

; Функции
openSearch() {
	global readerMode
	if (readerMode) {
		;runWebserver()3
		Run, firefox.exe "http://ya.ru"
	}
}

openMail(){
	global readerMode
	if (readerMode) {
		;runWebserver()
		Run, firefox.exe "http://mail.yandex.ru/lite"
	}
}

startNVDA() {
	global nvdaIsRun
	;if (! Process, Exist, nvda.exe ) {
	if (!nvdaIsRun) {
		Run, nvda.exe, "C:\Program Files (x86)\NVDA", UseErrorLevel
			;nvdaIsRun := true
	}
}

stopNVDA() {
	global nvdaIsRun
	Process, Close, nvda.exe
	nvdaIsRun := false
}

focusFirefox(){
	WinActivate, ahk_class MozillaWindowClass
}

nextLink(){
	global readerMode
	if (readerMode) {
		startNVDA()
		focusFirefox()
		Send, `t
	}
}

prevLink(){
	global readerMode
	if (readerMode) {
		startNVDA()
		focusFirefox()
		Send, +`t
	}
}

openLink(){
	global readerMode
	if (readerMode) {
		focusFirefox()
		Send, {Return}
		Sleep, 5000
		
	}
}

closeTab(){
	global readerMode
	if (readerMode) {
		focusFirefox()
		Send, {Ctrl down}w{Ctrl up}
	}
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
if (Process, Exist, nvda.exe) {
	nvdaIsRun := true
} else {
	nvdaIsRun := false
}

ScrollLock::
readerMode := !readerMode
;MsgBox, , readerMode, %readerMode%
return

F1::
nextLink()
return

F2::
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
startNVDA()
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
