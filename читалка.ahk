#SingleInstance Force

; Глобальные переменные
readerMode := false
readerModeTimeout := 10
nvdaIsRun := false
firefoxReadingIsActive := false

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


say(text){
	Run, c:\windows\balcon.exe -n Aleks -t "%text%", ,Hide
}

readClipboard() {
	Run, c:\windows\balcon.exe -n Aleks -c , ,Hide
}

stopReadClipboard() {
	Process, Close, balcon.exe
}

focusFirefox(){
	WinActivate, ahk_class MozillaWindowClass
}

firefoxIsOpened() {
	Process, Exist, firefox.exe
	return (0 != %ErrorLevel%)
}

firefoxPageIsLoaded() {
	if (firefoxIsOpened()) {
		focusFirefox()
		ImageSearch, imageX, imageY, 76, 47, 100, 72, c:\Users\User\Pictures\firefox-page-load-complete.bmp
		return (imageX and imageY)
	} else {
		;pronounceError "Фаерфокс не запущен!"
		return false
	}
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
		
		while (!firefoxPageIsLoaded()) {
			Sleep, 100
		}
	}
}

closeTab(){
	global readerMode
	if (readerMode) {
		focusFirefox()
		Send, {Ctrl down}w{Ctrl up}
	}
	firefoxReadingIsActive := false
	stopReadClipboard()
}


; Чтение буфера обмена
readThroughClipboard() {
	stopNVDA()
	Sleep, 1500
	Click, 11, 118
	Send, ^a
	Send, ^c
	readClipboard()
}

readingIsActive() {
	return ((Process, Exist, balcon.exe) OR (firefoxReadingIsActive))
}


getWinTitle() {
	WinGetTitle, titleOfActiveWin, A
	return titleOfActiveWin
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



startReaderModeTimeout() {
	while (readerModeTimeout > 0) {
		Sleep, 1000
		readerModeTimeout := readerModeTimeout - 1
	}
	readerMode := false
}

ScrollLock::
readerMode := !readerMode
startReaderModeTimeout()
;while (readerModeTimeout > 0) {
;	Sleep, 1000
;	readerModeTimeout := readerModeTimeout - 1
;}
;readerMode := false
;say("Regim chteniya otkluchen")
;MsgBox "Reader mode is OFF"
return

F1::
nextLink()
;focusFirefox()
;Click, 200, 200
;Send, ^a
;Sleep, 100
;Send, ^c
;say(clipboard)
return

~F2::
prevLink()
return

F3::
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
;alertTitle()
stopReadClipboard()
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

;^#z::
;Process, Close, nvda.exe
;Runwait, taskkill /im firefox.exe /f
;return

; Блоки с метками
WindowTitleCheck:
	WinGetTitle, newWinTitle, ahk_class MozillaWindowClass
	if (titleOfActiveWin != newWinTitle) {
		MsgBox, , 'Заголовок изменился', %newWinTitle%
		SetTimer, WindowTitleCheck, Off
	}
return
