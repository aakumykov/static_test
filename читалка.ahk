#SingleInstance Force

; Глобальные переменные
isReaderMode := false
isReaderModeTimeout := 10
nvdaIsRun := false
firefoxReadingIsActive := false

; Функции
openSearch() {
	global isReaderMode
	if (isReaderMode) {
		;runWebserver()3
		Run, firefox.exe "http://ya.ru"
	}
}

openMail(){
	global isReaderMode
	if (isReaderMode) {
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
	global isReaderMode
	if (isReaderMode) {
		startNVDA()
		focusFirefox()
		Send, `t
	}
}

prevLink(){
	global isReaderMode
	if (isReaderMode) {
		startNVDA()
		focusFirefox()
		Send, +`t
	}
}

openLink(){
	global isReaderMode
	if (isReaderMode) {
		focusFirefox()
		Send, {Return}
		
		while (!firefoxPageIsLoaded()) {
			Sleep, 100
		}
	}
}

closeTab(){
	global isReaderMode
	if (isReaderMode) {
		focusFirefox()
		Send, {Ctrl down}w{Ctrl up}
	}
	firefoxReadingIsActive := false
	stopReadClipboard()
}


; Работа с режимом чтения Firefox
isReaderModeAvailable() {
	ImageSearch, imageX, imageY, 1132, 46, 1158, 73, c:\Users\User\Pictures\firefox-reader-mode-start-icon.png
	return (imageX and imageY)
}

isReaderModeActivated() {
	ImageSearch, imageX, imageY, 0, 168, 45, 211, c:\Users\User\Pictures\firefox-reader-mode-start-icon.png
	return (imageX and imageY)
}

activateReaderView() {
	Click, 1146, 59
}

clickReadingControls() {
	Click 22, 227
}

clickPlayPause() {
	Click, 204, 222
}

clickReadNextParagraph() {
	Click, 301, 222
}

clickReadPrevParagraph() {
	Click, 102, 222
}

startStopReading() {
	global firefoxReadingIsActive
	if (!firefoxReadingIsActive) {
		focusFirefox()
		clickReadingControls()
		clickPlayPause()
		clickReadingControls()
		firefoxReadingIsActive := true
	} else {
		focusFirefox()
		clickReadingControls()
		clickPlayPause()
		clickReadingControls()
		firefoxReadingIsActive := false
	}
}

skipForward() {
	global firefoxReadingIsActive
	if (firefoxReadingIsActive) {
		clickReadingControls()
		clickReadNextParagraph()
		clickReadingControls()
	}
}

skipBack() {
	global firefoxReadingIsActive
	if (firefoxReadingIsActive) {
		clickReadingControls()
		clickReadPrevParagraph()
		clickReadingControls()
	}
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
	global isReaderMode
	
	if ( isReaderMode ) {
		if ( isYoutubeVideo() ) {
			Click, 65, 529
		}
	}
}

videoSkipForward() {
	global isReaderMode
	
	if ( isReaderMode ) {
		if ( isYoutubeVideo() ) {
			Send, {Right}
		}
	}
}

videoSkipBack() {
	global isReaderMode
	
	if ( isReaderMode ) {
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
	while (isReaderModeTimeout > 0) {
		Sleep, 1000
		isReaderModeTimeout := isReaderModeTimeout - 1
	}
	isReaderMode := false
}

ScrollLock::
isReaderMode := !isReaderMode
startReaderModeTimeout()
;while (isReaderModeTimeout > 0) {
;	Sleep, 1000
;	isReaderModeTimeout := isReaderModeTimeout - 1
;}
;isReaderMode := false
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

F6::
if (isReaderMode) {
	startStopReading()
}
return

~Numpad9::
openMail()
return

~Numpad3::
openSearch()
return

~a::
if (isReaderMode) {
	;videoSkipBack()
	skipBack()
}
return

~s::
if (isReaderMode) {
	startStopReading()
}
;videoPlayPause()
return

~d::
if (isReaderMode) {
	;videoSkipForward()
	skipForward()
}
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
