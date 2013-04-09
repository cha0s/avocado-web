
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
		
	close: ->
