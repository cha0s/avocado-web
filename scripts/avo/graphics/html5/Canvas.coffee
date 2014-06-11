
{CoreService} = require 'avo/core'

Promise = require 'avo/vendor/bluebird'
Rectangle = require 'avo/extension/rectangle'
Vector = require 'avo/extension/vector'

Images = {}

module.exports = class Canvas
	
	constructor: (width, height) ->

		@_uri = ''
		@_pixels = null
		@_canvas = @_Graphics.graphicsService.newCanvas()
		
		if width?
			
			[width, height] = width if width instanceof Array
		
			@_canvas.width = width
			@_canvas.height = height
	
	'%drawCircle': (position, radius, r, g, b, a, mode) ->
		
		context = @_Graphics.graphicsService.contextFromCanvas @_canvas
		context.save()
		
		context.fillStyle = @_Graphics.graphicsService.rgbToHex r, g, b
		context.globalAlpha = a
		context.lineWidth = 1
		context.lineCap = 'butt'
		
#		context.globalCompositeOperation = 'copy'
		
		context.beginPath()
		context.arc(
			position[0]
			position[1]
			radius
			0
			2 * Math.PI
		)
		context.fill()
			
		context.restore()
		
	'%drawFilledBox': (box, r, g, b, a, mode) ->
		
		context = @_Graphics.graphicsService.contextFromCanvas @_canvas
		context.save()
		
		if @_Graphics.GraphicsService.BlendMode_Replace is mode
		
			context.clearRect(
				.5 + box[0]
				.5 + box[1]
				box[2]
				box[3]
			)
		
		context.fillStyle = @_Graphics.graphicsService.rgbToHex r, g, b
		context.globalAlpha = a
		context.fillRect(
			.5 + box[0]
			.5 + box[1]
			box[2]
			box[3]
		)
		
		context.restore()
			
	'%drawLine': (line, r, g, b, a, mode) ->
		
		context = @_Graphics.graphicsService.contextFromCanvas @_canvas
		context.save()

		context.strokeStyle = @_Graphics.graphicsService.rgbToHex r, g, b
		context.globalAlpha = a
		context.lineWidth = 1
		context.lineCap = 'butt'
		
		context.beginPath()
		context.moveTo(
			.5 + line[0]
			.5 + line[1]
		)
		context.lineTo(
			.5 + line[2]
			.5 + line[3]
		)
		context.stroke()
		
		context.restore()
			
	'%drawLineBox': (box, r, g, b, a, mode) ->
		
		context = @_Graphics.graphicsService.contextFromCanvas @_canvas
		context.save()

		context.strokeStyle = @_Graphics.graphicsService.rgbToHex r, g, b
		context.globalAlpha = a
		context.lineWidth = 1
		context.lineCap = 'butt'
		
		context.strokeRect(
			.5 + box[0]
			.5 + box[1]
			box[2]
			box[3]
		)
		
		context.restore()
			
	'%fill': (r, g, b, a) ->
		
		context = @_Graphics.graphicsService.contextFromCanvas @_canvas
		context.save()

		context.fillStyle = @_Graphics.graphicsService.rgbToHex r, g, b
		
		if a > 0
			
			context.globalAlpha = a
			context.fillRect 0, 0, @width(), @height()
		
		else
			
			context.clearRect 0, 0, @width(), @height()
	
		context.restore()
			
	'%width': -> @_canvas.width
	
	'%height': -> @_canvas.height
	
	'%lockPixels': ->
		
		unless @_pixels?
			
			context = @_Graphics.graphicsService.contextFromCanvas @_canvas
			@_pixels = context.getImageData 0, 0, @width(), @height()
	
	'%pixelAt': (x, y) ->
		
		if @_pixels?
		
			data = @_pixels.data
			i = (y * @width() + x) * 4
			
		else
			
			context = @_Graphics.graphicsService.contextFromCanvas @_canvas
			data = context.getImageData(x, y, 1, 1).data
			i = 0
		
		(data[i + 3] << 24) | (data[i] << 16) | (data[i + 1] << 8 ) | data[i + 2]
	
	'%setPixelAt': (x, y, c) ->
		
		return unless x >= 0 and y >= 0 and x < @width() and y < @height()
	
		if @_pixels?
			
			imageData = @_pixels
			i = (y * @width() + x) * 4
			
		else
			
			context = @_Graphics.graphicsService.contextFromCanvas @_canvas
			imageData = context.createImageData 1, 1
			i = 0
		
		imageData.data[i    ] = (c >>> 16) & 255
		imageData.data[i + 1] = (c >>> 8) & 255
		imageData.data[i + 2] = c & 255
		imageData.data[i + 3] = c >>> 24
		
		unless @_pixels?
			
			context = @_Graphics.graphicsService.contextFromCanvas @_canvas
			context.putImageData imageData, x, y
	
	'%unlockPixels': ->
		
		if @_pixels?
			
			context = @_Graphics.graphicsService.contextFromCanvas @_canvas
			context.putImageData @_pixels, 0, 0
			@_pixels = null
	
	'%uri': -> @_uri
