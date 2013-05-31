
Q = require 'Utility/Q'

module.exports = CoreService = class
	
	close: ->

CoreService['%writeStderr'] = ->
	
	console?.log? argument for argument in arguments

resourceMap = {}
CoreService['%readResource'] = (uri, fn) ->

	# This SUCKS, but I haven't thought out how to handle the dynamic SPIs in
	# a more sensical manner. I am leaning towards implementing writeStderr and
	# readResource as methods of the CoreService INSTANCE, instead of the 
	# class.
	CoreServiceHack = require('Core').CoreService
	
	if resourceMap[uri]?
		
		fn null, resourceMap[uri]
		
	else 
		
		request = new XMLHttpRequest()
		request.open 'GET', "#{CoreServiceHack.ResourcePath}#{uri}"
		request.onreadystatechange = ->
			
			if request.readyState is 4
				
				if request.status is 200
					fn null, resourceMap[uri] = request.responseText
				else
					fn new Error "Couldn't load resouce: #{uri}"
		
		request.send()
