
module.exports = class GraphicsService
	
	constructor: ->
	
# Initialize WebGL if possible
		try
			
			throw new Error "WebGL isn't supported yet :/"
			
		catch e
			
			@newCanvas = -> document.createElement 'canvas'
			
			contextKey = '2d'
		
		@contextFromCanvas = (canvas) -> canvas.getContext contextKey
		
		@rgbToHex = (r, g, b) -> "rgb(#{r}, #{g}, #{b})"
		
	close: ->
