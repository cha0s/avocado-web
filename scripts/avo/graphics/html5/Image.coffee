
{CoreService} = require 'avo/core'

Promise = require 'avo/vendor/bluebird'
Rectangle = require 'avo/extension/rectangle'
Vector = require 'avo/extension/vector'

Images = {}

# Why AvoImage and not Image, you may ask? Because (window.)Image is already
# present in a browser environment, and it's easier for us to leave it alone,
# since we need to instantiate one for each of our images.

module.exports = class AvoImage
	
	constructor: (width, height) ->

		@_uri = ''
		@_pixels = null
			
	@['%load'] = (uri, fn) ->
		
		image = new AvoImage()
		
		resolve = ->
			
			image._uri = uri
			image._src = Images[uri].src
			image._browserImage = Images[uri]
			
			fn null, image
		
		reject = -> fn new Error "Couldn't load Image: #{uri}"
		
		if Images[uri]?
		
			Images[uri].defer.promise.then(
				-> resolve()
				-> reject()
			).done()
			
		else
		
			defer = Promise.defer()
			
			Images[uri] = new Image()
			Images[uri].onload = ->
				
				resolve()
				defer.resolve()
				
			Images[uri].onerror = reject
			Images[uri].defer = Promise.defer()
			
			defer.promise.then(
				-> Images[uri].defer.resolve()
			).done()
			
			Images[uri].src = if uri.match /\./
				"#{CoreService.ResourcePath}#{uri}"
			else
				"data:image/png;base64,#{uri}"
			
		undefined
	
	'%width': -> @_width ?= @_browserImage.width
	
	'%height': -> @_height ?= @_browserImage.height
	
	'%uri': -> @_uri
