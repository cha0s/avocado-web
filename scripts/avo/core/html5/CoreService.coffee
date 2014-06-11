
Promise = require 'avo/vendor/bluebird'

module.exports = class CoreService
	
	close: ->

CoreService['%writeStderr'] = ->
	
	console?.log? argument for argument in arguments

resourceMap = {}
CoreService['%readResource'] = (uri, fn) ->

	if resourceMap[uri]?
		
		fn null, resourceMap[uri]
		
	else 
		
		request = new XMLHttpRequest()
		request.open 'GET', "#{@ResourcePath}#{uri}"
		request.onreadystatechange = ->
			
			if request.readyState is 4
				
				if request.status is 200
					fn null, resourceMap[uri] = request.responseText
				else
					fn new Error "Couldn't load resouce: #{uri}"
		
		request.send()
