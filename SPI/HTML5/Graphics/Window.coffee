
Dom = require 'Utility/Dom'
EventEmitter = require 'Utility/EventEmitter'
Image = require('Graphics').Image
Mixin = require 'Utility/Mixin'
Rectangle = require 'Extension/Rectangle'

Window = module.exports = class
	
	constructor: ->
		
		Mixin this, EventEmitter
		
		@Canvas = document.createElement 'canvas'
		@Canvas.setAttribute 'tabIndex', 1
		
		@Canvas.onkeydown = (event) =>
			@emit 'keyDown', code: keyCodeMap (event ? window.event).keyCode

		document.onkeyup = (event) =>
			@emit 'keyUp', code: keyCodeMap (event ? window.event).keyCode

		@Canvas.onmousemove = (event) =>
			mouseEvent = event ? window.event
			@emit 'mouseMove',
				x: mouseEvent.clientX - @offset_[0]
				y: mouseEvent.clientY - @offset_[1]

		@Canvas.onmousedown = (event) =>
			mouseEvent = event ? window.event
			@emit 'mouseButtonDown',
				x: mouseEvent.clientX - @offset_[0]
				y: mouseEvent.clientY - @offset_[1]
				button: mouseButtonMap mouseEvent.button

		document.onmouseup = (event) =>
			mouseEvent = event ? window.event
			@emit 'mouseButtonUp',
				x: mouseEvent.clientX - @offset_[0]
				y: mouseEvent.clientY - @offset_[1]
				button: mouseButtonMap mouseEvent.button
		
		handleWheel = (event) =>
			wheelEvent = event ? window.event
			
			delta = if event.detail < 0 or event.wheelDelta > 0
				1
			else
				-1
			@emit 'mouseWheelMove', delta: delta
			
			event.preventDefault() and false
			
		@Canvas.addEventListener 'DOMMouseScroll', handleWheel, false
		@Canvas.addEventListener 'mousewheel', handleWheel, false		
		
		@offset_ = [0, 0]
		
	calculateOffset: -> @offset_ = Dom.calculateOffset @Canvas 
	
	'%display': ->
	
	'%height': -> @Canvas.height
	
	'%pollEvents': ->
		
	'%render': (image, rectangle) ->
		
		image.render(
			Rectangle.position rectangle
			
			# Duck typing FTW, since we have this.Canvas, this will Just Work.
			this
			
			255
			Image.DrawMode_Blend
			rectangle
		)
		
	'%setFlags': (flags) ->
	
	'%setSize': (size) -> [@Canvas.width, @Canvas.height] = size
	
	'%setMouseVisibility': (visibility) ->
	
	'%setWindowTitle': (window_, iconified) ->
		window.document.title = window_
	
	'%size': -> [@Canvas.width, @Canvas.height]
	
	'%width': -> @Canvas.width

	@KeyCode:

		Backspace: 8
		Tab: 9
		Enter: 13
		Escape: 27
		Space: 32
		ExclamationMark: 33
		QuotationMark: 34
		NumberSign: 35
		DollarSign: 36
		PercentSign: 37
		Ampersand: 38
		Apostrophe: 39
		ParenthesisLeft: 40
		ParenthesisRight: 41
		Asterisk: 42
		Plus: 43
		Comma: 44
		Dash: 45
		Period: 46
		Slash: 47

		0: 48
		1: 49
		2: 50
		3: 51
		4: 52
		5: 53
		6: 54
		7: 55
		8: 56
		9: 57

		Colon: 58
		Semicolon: 59
		LessThan: 60
		EqualsSign: 61
		GreaterThan: 62
		QuestionMark: 63
		At: 64

		A: 65
		B: 66
		C: 67
		D: 68
		E: 69
		F: 70
		G: 71
		H: 72
		I: 73
		J: 74
		K: 75
		L: 76
		M: 77
		N: 78
		O: 79
		P: 80
		Q: 81
		R: 82
		S: 83
		T: 84
		U: 85
		V: 86
		W: 87
		X: 88
		Y: 89
		Z: 90

		BracketLeft: 91
		Backslash: 92
		BracketRight: 93
		Caret: 94
		Underscore: 95
		Backtick: 96

		# Lowercase alphabet excluded...

		BraceLeft: 123
		Pipe: 124
		BraceRight: 125
		Tilde: 126
		Delete: 127

		F1: 256
		F2: 257
		F3: 258
		F4: 259
		F5: 260
		F6: 261
		F7: 262
		F8: 263
		F9: 264
		F10: 265
		F11: 266
		F12: 267
		F13: 268
		F14: 269
		F15: 270

		ArrowUp: 271
		ArrowRight: 272
		ArrowDown: 273
		ArrowLeft: 274

		Insert: 275
		Home: 276
		End: 277
		PageUp: 278
		PageDown: 279

		ControlLeft: 280
		AltLeft: 281
		ShiftLeft: 282
		SystemLeft: 283
		ControlRight: 284
		AltRight: 285
		ShiftRight: 286
		SystemRight: 287
		Menu: 288

		Pause: 289
		
	@Mouse:
		
		ButtonLeft: 1
		ButtonMiddle: 2
		ButtonRight: 3
		WheelUp: 4
		WheelDown: 5
	
keyCodeMap = (keyCode) ->
	
	switch keyCode
	
		when 8 then Window.KeyCode.Backspace
		when 9 then Window.KeyCode.Tab
		when 13 then Window.KeyCode.Enter
		when 27 then Window.KeyCode.Escape
		when 32 then Window.KeyCode.Space
		when 33 then Window.KeyCode.ExclamationMark
		when 34 then Window.KeyCode.QuotationMark
		when 35 then Window.KeyCode.NumberSign
		when 36 then Window.KeyCode.DollarSign
		when 37 then Window.KeyCode.PercentSign
		when 38 then Window.KeyCode.Ampersand
		when 39 then Window.KeyCode.Apostrophe
		when 40 then Window.KeyCode.ParenthesisLeft
		when 41 then Window.KeyCode.ParenthesisRight
		when 42 then Window.KeyCode.Asterisk
		when 43 then Window.KeyCode.Plus
		when 188 then Window.KeyCode.Comma
		when 173 then Window.KeyCode.Dash
		when 190 then Window.KeyCode.Period
		when 191 then Window.KeyCode.Slash
	
		when 48 then Window.KeyCode['0']
		when 49 then Window.KeyCode['1']
		when 50 then Window.KeyCode['2']
		when 51 then Window.KeyCode['3']
		when 52 then Window.KeyCode['4']
		when 53 then Window.KeyCode['5']
		when 54 then Window.KeyCode['6']
		when 55 then Window.KeyCode['7']
		when 56 then Window.KeyCode['8']
		when 57 then Window.KeyCode['9']
	
		when 58 then Window.KeyCode.Colon
		when 59 then Window.KeyCode.Semicolon
		when 60 then Window.KeyCode.LessThan
		when 61 then Window.KeyCode.EqualsSign
		when 62 then Window.KeyCode.GreaterThan
		when 63 then Window.KeyCode.QuestionMark
		when 64 then Window.KeyCode.At
	
		when 65 then Window.KeyCode.A
		when 66 then Window.KeyCode.B
		when 67 then Window.KeyCode.C
		when 68 then Window.KeyCode.D
		when 69 then Window.KeyCode.E
		when 70 then Window.KeyCode.F
		when 71 then Window.KeyCode.G
		when 72 then Window.KeyCode.H
		when 73 then Window.KeyCode.I
		when 74 then Window.KeyCode.J
		when 75 then Window.KeyCode.K
		when 76 then Window.KeyCode.L
		when 77 then Window.KeyCode.M
		when 78 then Window.KeyCode.N
		when 79 then Window.KeyCode.O
		when 80 then Window.KeyCode.P
		when 81 then Window.KeyCode.Q
		when 82 then Window.KeyCode.R
		when 83 then Window.KeyCode.S
		when 84 then Window.KeyCode.T
		when 85 then Window.KeyCode.U
		when 86 then Window.KeyCode.V
		when 87 then Window.KeyCode.W
		when 88 then Window.KeyCode.X
		when 89 then Window.KeyCode.Y
		when 90 then Window.KeyCode.Z
	
		when 219 then Window.KeyCode.BracketLeft
		when 220 then Window.KeyCode.Backslash
		when 221 then Window.KeyCode.BracketRight
		when 94 then Window.KeyCode.Caret
		when 95 then Window.KeyCode.Underscore
		when 192 then Window.KeyCode.Backtick
	
		when 123 then Window.KeyCode.BraceLeft
		
		# Lowerwhen alphabet excluded...
		
		when 124 then Window.KeyCode.Pipe
		when 125 then Window.KeyCode.BraceRight
		when 126 then Window.KeyCode.Tilde
		when 46 then Window.KeyCode.Delete
	
		when 112 then Window.KeyCode.F1
		when 113 then Window.KeyCode.F2
		when 114 then Window.KeyCode.F3
		when 115 then Window.KeyCode.F4
		when 116 then Window.KeyCode.F5
		when 117 then Window.KeyCode.F6
		when 118 then Window.KeyCode.F7
		when 119 then Window.KeyCode.F8
		when 120 then Window.KeyCode.F9
		when 121 then Window.KeyCode.F10
		when 122 then Window.KeyCode.F11
		when 123 then Window.KeyCode.F12
		when 124 then Window.KeyCode.F13
		when 125 then Window.KeyCode.F14
		when 126 then Window.KeyCode.F15
	
		when 38 then Window.KeyCode.ArrowUp
		when 39 then Window.KeyCode.ArrowRight
		when 40 then Window.KeyCode.ArrowDown
		when 37 then Window.KeyCode.ArrowLeft
	
		when 45 then Window.KeyCode.Insert
		when 36 then Window.KeyCode.Home
		when 35 then Window.KeyCode.End
		when 33 then Window.KeyCode.PageUp
		when 34 then Window.KeyCode.PageDown
	
		when 17 then Window.KeyCode.ControlLeft
		when 18 then Window.KeyCode.AltLeft
		when 16 then Window.KeyCode.ShiftLeft
		when 91 then Window.KeyCode.SystemLeft
		when 17 then Window.KeyCode.ControlRight
		when 18 then Window.KeyCode.AltRight
		when 16 then Window.KeyCode.ShiftRight
		when 91 then Window.KeyCode.SystemRight
		when 93 then Window.KeyCode.Menu

mouseButtonMap = (button) ->

	switch button
	
		when 0 then Window.Mouse.ButtonLeft
		when 1 then Window.Mouse.ButtonMiddle
		when 2 then Window.Mouse.ButtonRight

	