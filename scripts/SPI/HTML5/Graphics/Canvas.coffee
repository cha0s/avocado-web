
CoreService = require('Core').CoreService
Graphics = require 'Graphics'
Q = require 'Utility/Q'
Rectangle = require 'Extension/Rectangle'
Vector = require 'Extension/Vector'

Images = {}

module.exports = class
	
	constructor: (width, height) ->

		@URI = ''
		@Pixels = null
		@Canvas = Graphics.newCanvas()
		
		if width?
			
			[width, height] = width if width instanceof Array
		
			@Canvas.width = width
			@Canvas.height = height
	
	'%drawCircle': (position, radius, r, g, b, a, mode) ->
		
		context = Graphics.contextFromCanvas @Canvas
		context.save()
		
		context.fillStyle = Graphics.rgbToHex r, g, b
		context.globalAlpha = a
		context.lineWidth = 1
		context.lineCap = 'butt'
		
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
		
		context = Graphics.contextFromCanvas @Canvas
		context.save()
		
		if a > 0
			
			context.fillStyle = Graphics.rgbToHex r, g, b
			context.globalAlpha = a
			
			context.fillRect(
				.5 + box[0]
				.5 + box[1]
				box[2]
				box[3]
			)
		
		context.restore()
			
	'%drawLine': (line, r, g, b, a, mode) ->
		
		context = Graphics.contextFromCanvas @Canvas
		context.save()

		context.strokeStyle = Graphics.rgbToHex r, g, b
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
		
		context = Graphics.contextFromCanvas @Canvas
		context.save()

		context.strokeStyle = Graphics.rgbToHex r, g, b
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
		
		context = Graphics.contextFromCanvas @Canvas
		context.save()

		context.fillStyle = Graphics.rgbToHex r, g, b
		
		if a > 0
			
			context.globalAlpha = a
			context.fillRect 0, 0, @width(), @height()
		
		else
			
			context.clearRect 0, 0, @width(), @height()
	
		context.restore()
			
	'%width': -> @Canvas.width
	
	'%height': -> @Canvas.height
	
	'%lockPixels': ->
		
		unless @Pixels?
			
			context = Graphics.contextFromCanvas @Canvas
			@Pixels = context.getImageData 0, 0, @width(), @height()
	
	'%pixelAt': (x, y) ->
		
		if @Pixels?
		
			data = @Pixels.data
			i = (y * @width() + x) * 4
			
		else
			
			context = Graphics.contextFromCanvas @Canvas
			data = context.getImageData(x, y, 1, 1).data
			i = 0
		
		(data[i + 3] << 24) | (data[i] << 16) | (data[i + 1] << 8 ) | data[i + 2]
	
	'%setPixelAt': (x, y, c) ->
		
		return unless x >= 0 and y >= 0 and x < @width() and y < @height()
	
		if @Pixels?
			
			imageData = @Pixels
			i = (y * @width() + x) * 4
			
		else
			
			context = Graphics.contextFromCanvas @Canvas
			imageData = context.createImageData 1, 1
			i = 0
		
		imageData.data[i    ] = (c >>> 16) & 255
		imageData.data[i + 1] = (c >>> 8) & 255
		imageData.data[i + 2] = c & 255
		imageData.data[i + 3] = c >>> 24
		
		unless @Pixels?
			
			context = Graphics.contextFromCanvas @Canvas
			context.putImageData imageData, x, y
	
	'%unlockPixels': ->
		
		if @Pixels?
			
			context = Graphics.contextFromCanvas @Canvas
			context.putImageData @Pixels, 0, 0
			@Pixels = null
	
	'%uri': -> @URI
