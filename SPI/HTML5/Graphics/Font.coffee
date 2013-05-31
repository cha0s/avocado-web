
Graphics = require 'Graphics'

CoreService = require('Core').CoreService
Q = require 'Utility/Q'

module.exports = Font = class
	
	constructor: ->
		
		@Family = ''
		@Size = 12
	
	textNode = (text, size) ->
	
		node = document.createElement 'span'
		# Characters that vary significantly among different fonts
		node.innerHTML = text
		# Visible - so we can measure it - but not on the screen
		node.style.position      = 'absolute'
		node.style.left          = '-10000px'
		node.style.top           = '-10000px'
		# Large font size makes even subtle changes obvious
		node.style.fontSize      = "#{size}px"
		# Reset any font properties
		node.style.fontFamily    = 'sans-serif'
		node.style.fontVariant   = 'normal'
		node.style.fontStyle     = 'normal'
		node.style.fontWeight    = 'normal'
		node.style.letterSpacing = '0'
		
		node
	
	# Adapted from http://stackoverflow.com/a/11689060
	pollForLoadedFont = (family, fn) ->
		
		node = textNode 'giItT1WQy@!-/#', 300
		
		document.body.appendChild node
		
		width = node.offsetWidth
	
		node.style.fontFamily = family
		
		checkFont = ->
			
			if node and node.offsetWidth isnt width
				
				node.parentNode.removeChild node
				node = null
				
				clearInterval interval
				fn()
		
		interval = setInterval checkFont, 5

	Fonts = {}
	@['%load'] = (uri, fn) ->
		
		unless Fonts[uri]?
			deferred = Q.defer()
			Fonts[uri] = deferred.promise
			
			parts = uri.split('/')
			family = parts[parts.length - 1].replace /[^A-Za-z0-9_\-]/, '-'
			
			font = new Font()
			font.Family = family
		
			fontStyle = document.createElement 'style'
			fontStyle.appendChild document.createTextNode """
@font-face {
  font-family: "#{font.Family}";
  src: url("#{CoreService.ResourcePath}#{uri}") format("truetype");
}
"""
			document.getElementsByTagName('head').item(0).appendChild fontStyle
		
			pollForLoadedFont font.Family, -> deferred.resolve font
			
		Fonts[uri].done (font) -> fn null, font

	'%setSize': (@Size) ->
		
	'%setStyle': (@Style) ->
		
	'%textHeight': (text) ->
		
		node = textNode text, @Size
		node.clientHeight
		
	'%textWidth': (text) ->
		
		node = textNode text, @Size
		node.clientWidth
		
	'%render': (position, text, destination, r, g, b, a, clip) ->
		
		context = Graphics.contextFromCanvas destination.Canvas
		
		context.font = "#{@Size}px #{@Family}"
		context.fillStyle = Graphics.rgbToHex r, g, b
		context.lineWidth = .2
		context.strokeStyle = Graphics.rgbToHex 0, 0, 0
		context.textBaseline = 'top'
		
		Graphics.alphaContext context, a, ->
			context.fillText text, position[0], position[1] + 5
			context.strokeText text, position[0], position[1] + 5
			