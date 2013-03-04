
Rectangle = require 'Extension/Rectangle'
Vector = require 'Extension/Vector'
upon = require 'Utility/upon'

Images = {}
module.exports = AvoImage = class
	
	constructor: (width, height) ->

		@URI = ''
		@Pixels = null
		@Canvas = document.createElement 'canvas'
		
		if width?
			
			[width, height] = width if width instanceof Array
		
			@Canvas.width = width
			@Canvas.height = height
	
	@['%load'] = (uri, fn) ->
		
		CoreService = require('Core').CoreService
		
		defer = upon.defer()
		
		i = new AvoImage()
		
		resolve = ->
			
			i.URI = uri
			i.src = Images[uri].src
			i.BrowserImage = Images[uri]
			i.Canvas = document.createElement 'canvas'
			
			i.Canvas.width = i.BrowserImage.width
			i.Canvas.height = i.BrowserImage.height
			
			context = i.Canvas.getContext '2d'
			context.drawImage i.BrowserImage, 0, 0
			
			defer.resolve i
			fn i
		
		if Images[uri]?
		
			Images[uri].defer.then -> resolve()
			
		else
		
			Images[uri] = new Image()
			Images[uri].onload = resolve
			Images[uri].defer = upon.defer()
			
			defer.then -> Images[uri].defer.resolve()
			
			Images[uri].src = if uri.match /\./
				"#{CoreService.ResourcePath}#{uri}"
			else
				"data:image/png;base64,#{uri}"
			
		defer.promise
	
	rgbToHex = (r, g, b) -> "rgb(#{r}, #{g}, #{b})"
	
	'%drawCircle': (position, radius, r, g, b, a, mode) ->
		
		context = @Canvas.getContext '2d'
		
		context.beginPath();
		context.arc position[0], position[1], radius, 0, 2*Math.PI
		
		oldAlpha = context.globalAlpha
		context.globalAlpha = a / 255
		
		context.fillStyle = rgbToHex r, g, b
		context.fill()
		
		context.globalAlpha = oldAlpha
		
	'%drawFilledBox': (box, r, g, b, a, mode) ->
		
		context = @Canvas.getContext '2d'
		
		if a > 0
			
			oldAlpha = context.globalAlpha
			context.globalAlpha = a / 255
			
			context.fillStyle = rgbToHex r, g, b
			context.fillRect box[0], box[1], box[2], box[3]
		
			context.globalAlpha = oldAlpha
		
		else
		
			context.clearRect box[0], box[1], box[2], box[3]
			
	'%drawLine': (line, r, g, b, a, mode) ->
		
		context = @Canvas.getContext '2d'
	
		context.beginPath()
		context.moveTo line[0], line[1]
		context.lineTo line[2], line[3]
		
		oldAlpha = context.globalAlpha
		context.globalAlpha = a / 255
		
		context.strokeStyle = rgbToHex r, g, b
		context.stroke()
	
		context.globalAlpha = oldAlpha
		
	'%drawLineBox': (box, r, g, b, a, mode) ->
		
		context = @Canvas.getContext '2d'
		
		oldAlpha = context.globalAlpha
		context.globalAlpha = a / 255
		
		context.lineCap = 'butt';
		context.fillStyle = context.strokeStyle = rgbToHex r, g, b
		context.strokeRect box[0] + .5, box[1] + .5, box[2], box[3]
		
		context.globalAlpha = oldAlpha
		
	'%fill': (r, g, b, a) ->
		
		context = @Canvas.getContext '2d'
		
		# HACK!
		if a > 0
			
			oldAlpha = context.globalAlpha
			context.globalAlpha = a / 255
			
			context.fillStyle = rgbToHex r, g, b
			context.fillRect 0, 0, @width(), @height()
			
			context.globalAlpha = oldAlpha
		
		else
			
			context.clearRect 0, 0, @width(), @height()
	
	'%width': -> @Canvas.width
	
	'%height': -> @Canvas.height
	
	'%lockPixels': ->
		
		unless @Pixels?
			
			@Pixels = @Canvas.getContext('2d').getImageData 0, 0, @width(), @height()
	
	'%pixelAt': (x, y) ->
		
		if @Pixels?
		
			data = @Pixels.data
			i = (y * @width() + x) * 4
			
		else
			
			data = @Canvas.getContext('2d').getImageData(x, y, 1, 1).data
			i = 0
		
		(data[i + 3] << 24) | (data[i] << 16) | (data[i + 1] << 8 ) | data[i + 2]
	
	'%render': (position, destination, alpha, mode, sourceRect) ->
		context = destination.Canvas.getContext '2d'
		
		sourceRect[2] = @width() if sourceRect[2] is 0
		sourceRect[3] = @height() if sourceRect[3] is 0
		
		sourceRect = Rectangle.round sourceRect
		position = Vector.round position
		
		sourceRect[0] = 0 if sourceRect[0] < 0
		sourceRect[1] = 0 if sourceRect[1] < 0
		
		if position[0] < 0
			sourceRect[0] += -position[0]
			sourceRect[2] += position[0]
			position[0] = 0
		
		if position[1] < 0
			sourceRect[1] += -position[1]
			sourceRect[3] += position[1]
			position[1] = 0
		
		oldAlpha = context.globalAlpha
		context.globalAlpha = alpha / 255
		
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
		
		context.globalAlpha = oldAlpha
	
	'%setPixelAt': (x, y, c) ->
		
		return unless x >= 0 and y >= 0 and x < @width() and y < @height()
	
		if @Pixels?
			
			imageData = @Pixels
			i = (y * @width() + x) * 4
			
		else
			
			imageData = @Canvas.getContext('2d').createImageData 1, 1
			i = 0
		
		imageData.data[i    ] = (c >>> 16) & 255
		imageData.data[i + 1] = (c >>> 8) & 255
		imageData.data[i + 2] = c & 255
		imageData.data[i + 3] = c >>> 24
		
		unless @Pixels?
			
			@Canvas.getContext('2d').putImageData imageData, x, y
	
	'%unlockPixels': ->
		
		if @Pixels?
			
			@Canvas.getContext('2d').putImageData @Pixels, 0, 0
			@Pixels = null
	
	'%uri': -> @URI

