
Graphics = require 'Graphics'

module.exports = class
	
	constructor: ->
	
# Initialize WebGL if possible
		try
			
			throw new Error "WebGL isn't supported yet :/"
			
		catch e
			
			Graphics.newCanvas = -> document.createElement 'canvas'
			
			contextKey = '2d'
		
		Graphics.contextFromCanvas = (canvas) -> canvas.getContext contextKey
		
		Graphics.rgbToHex = (r, g, b) -> "rgb(#{r}, #{g}, #{b})"
		
		Graphics.alphaContext = (context, alpha, callback) ->
			
			newAlpha = alpha / 255
			oldAlpha = context.globalAlpha
			
			return callback() if oldAlpha is newAlpha
			
			context.globalAlpha = newAlpha
			
			callback()
			
			context.globalAlpha = oldAlpha
			
	close: ->
