
{CoreService} = require 'avo/core'

Promise = require 'avo/vendor/bluebird'
Vector = require 'avo/extension/vector'

module.exports = class Font
	
	constructor: ->
		
		@_family = ''
		@_size = 12
	
	textNode = (text, size, family) ->
	
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
		node.style.fontFamily    = family
		node.style.fontVariant   = 'normal'
		node.style.fontStyle     = 'normal'
		node.style.fontWeight    = 'normal'
		
		node
	
	# Adapted from http://stackoverflow.com/a/11689060
	pollForLoadedFont = (family, fn) ->
		
		node = textNode 'giItT1WQy@!-/#', 300, 'sans-serif'
		
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
			deferred = Promise.defer()
			Fonts[uri] = deferred.promise
			
			parts = uri.split('/')
			family = parts[parts.length - 1].replace /[^A-Za-z0-9_\-]/, '-'
			
			font = new Font()
			font._family = family
		
			fontStyle = document.createElement 'style'
			fontStyle.appendChild document.createTextNode """
@font-face {
  font-family: "#{font._family}";
  src: url("#{CoreService.ResourcePath}#{uri}") format("truetype");
}
"""
			document.getElementsByTagName('head').item(0).appendChild fontStyle
		
			pollForLoadedFont font._family, -> deferred.resolve font
			
		Fonts[uri].done (font) -> fn null, font

	'%setSize': (@_size) ->
		
	'%setStyle': (@_style) ->
		
	'%textHeight': (text) ->
		
		node = textNode text, @_size, @_family
		document.body.appendChild node
		
		height = node.offsetHeight
		
		node.parentNode.removeChild node
		node = null
		
		height
		
	'%textWidth': (text) ->
		
		node = textNode text, @_size, @_family
		document.body.appendChild node

		width = node.offsetWidth
		
		node.parentNode.removeChild node
		node = null
		
		width
		
	'%render': (position, text, destination, r, g, b, a, clip) ->
		
		context = @_Graphics.graphicsService.contextFromCanvas destination.Canvas
		context.save()
		
		context.font = "#{@_size}px #{@_family}"
		context.fillStyle = @_Graphics.graphicsService.rgbToHex r, g, b
		context.lineWidth = .2
		context.strokeStyle = @_Graphics.graphicsService.rgbToHex 0, 0, 0
		context.textBaseline = 'top'
		
		# Yuck!
		position = Vector.add position, [0, @_size / 4]
		
		context.fillText text, position[0], position[1]
		context.strokeText text, position[0], position[1]
			
		context.restore()
			