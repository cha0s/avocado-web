
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
	
	rgbToHex = (r, g, b) -> "rgb(#{r}, #{g}, #{b})"
	
	alphaContext = (context, alpha, callback) ->
	
		oldAlpha = context.globalAlpha
		context.globalAlpha = alpha / 255
		
		callback()
		
		context.globalAlpha = oldAlpha
		
	'%drawCircle': (position, radius, r, g, b, a, mode) ->
		
		context = Graphics.contextFromCanvas @Canvas
		context.beginPath();
		context.arc position[0], position[1], radius, 0, 2*Math.PI
		context.fillStyle = rgbToHex r, g, b
		
		alphaContext context, a, ->
		
			context.fill()
		
	'%drawFilledBox': (box, r, g, b, a, mode) ->
		
		context = Graphics.contextFromCanvas @Canvas
		context.fillStyle = rgbToHex r, g, b
		
		if a > 0
			
			alphaContext context, a, ->
			
				context.fillRect box[0], box[1], box[2], box[3]
		
		else
		
			context.clearRect box[0], box[1], box[2], box[3]
			
	'%drawLine': (line, r, g, b, a, mode) ->
		
		context = Graphics.contextFromCanvas @Canvas
		context.beginPath()
		context.moveTo line[0] + .5, line[1] + .5
		context.lineTo line[2], line[3]
		context.strokeStyle = rgbToHex r, g, b
		
		alphaContext context, a, ->
		
			context.stroke()
		
	'%drawLineBox': (box, r, g, b, a, mode) ->
		
		context = Graphics.contextFromCanvas @Canvas
		context.lineCap = 'butt';
		context.fillStyle = context.strokeStyle = rgbToHex r, g, b
		
		alphaContext context, a, ->
		
			context.strokeRect box[0] + .5, box[1] + .5, box[2], box[3]
		
	'%fill': (r, g, b, a) ->
		
		context = Graphics.contextFromCanvas @Canvas
		context.fillStyle = rgbToHex r, g, b
		
		# HACK!
		if a > 0
			
			alphaContext context, a, =>
			
				context.fillRect 0, 0, @width(), @height()
		
		else
			
			context.clearRect 0, 0, @width(), @height()
	
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
	
	'%render': (position, destination, alpha, mode, sourceRect) ->
		
		sourceRect[2] = @width() if sourceRect[2] is 0
		sourceRect[3] = @height() if sourceRect[3] is 0
		
		sourceRect = Rectangle.round sourceRect
		position = Vector.round position
		
		for i in [0..1]
			if position[i] < 0
				if position[i] <= -sourceRect[i + 2]
					return
				sourceRect[i] += -position[i]
				sourceRect[i + 2] += position[i]
				position[i] = 0
		
		context = Graphics.contextFromCanvas destination.Canvas
		
		alphaContext context, alpha, =>
			
			# Seems to be a faster execution path this way, so we'll take it
			# if we can.
			if sourceRect[0] is 0 and sourceRect[1] is 0 and sourceRect[2] is @width() and sourceRect[3] is @height()
				
				context.drawImage(
					@Canvas
					position[0], position[1]
				)
				
			else
			
				context.drawImage(
					@Canvas
					sourceRect[0], sourceRect[1], sourceRect[2], sourceRect[3]
					position[0], position[1], sourceRect[2], sourceRect[3]
				)
	
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
