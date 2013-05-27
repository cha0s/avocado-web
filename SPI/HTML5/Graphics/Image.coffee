
CoreService = require('Core').CoreService
Graphics = require 'Graphics'
Q = require 'Utility/Q'
Rectangle = require 'Extension/Rectangle'
Vector = require 'Extension/Vector'

Images = {}

# Why AvoImage and not Image, you may ask? Because (window.)Image is already
# present in a browser environment, and it's easier for us to leave it alone,
# since we need to instantiate one for each of our images.

module.exports = AvoImage = class
	
	constructor: (width, height) ->

		@URI = ''
		@Pixels = null
			
	@['%load'] = (uri, fn) ->
		
		image = new AvoImage()
		
		resolve = ->
			
			image.URI = uri
			image.src = Images[uri].src
			image.BrowserImage = Images[uri]
			
			fn null, image
		
		reject = -> fn new Error "Couldn't load Image: #{uri}"
		
		if Images[uri]?
		
			Images[uri].defer.promise.then(
				-> resolve()
				-> reject()
			).done()
			
		else
		
			defer = Q.defer()
			
			Images[uri] = new Image()
			Images[uri].onload = ->
				
				resolve()
				defer.resolve()
				
			Images[uri].onerror = reject
			Images[uri].defer = Q.defer()
			
			defer.promise.then(
				-> Images[uri].defer.resolve()
			).done()
			
			Images[uri].src = if uri.match /\./
				"#{CoreService.ResourcePath}#{uri}"
			else
				"data:image/png;base64,#{uri}"
			
		undefined
	
	rgbToHex = (r, g, b) -> "rgb(#{r}, #{g}, #{b})"
	
	alphaContext = (context, alpha, callback) ->
	
		oldAlpha = context.globalAlpha
		context.globalAlpha = alpha / 255
		
		callback()
		
		context.globalAlpha = oldAlpha
		
	'%width': -> @Width ?= @BrowserImage.width
	
	'%height': -> @Height ?= @BrowserImage.height
	
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
					@BrowserImage
					position[0], position[1]
				)
				
			else
			
				context.drawImage(
					@BrowserImage
					sourceRect[0], sourceRect[1], sourceRect[2], sourceRect[3]
					position[0], position[1], sourceRect[2], sourceRect[3]
				)
	
	'%uri': -> @URI
