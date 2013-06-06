
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
	
	'%width': -> @Width ?= @BrowserImage.width
	
	'%height': -> @Height ?= @BrowserImage.height
	
	'%uri': -> @URI
