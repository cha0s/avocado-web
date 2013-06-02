
currentSpi = ''

module.exports = ->
	
	new (require "SPI/#{currentSpi}/Core/CoreService")

module.exports.implementSpi = (name) ->
	currentSpi = name
	
	Core = require 'Core'
	
	Service = require "SPI/#{currentSpi}/Core/CoreService"
	for key of Service
		@[key] = Service[key]
	
module.exports.ResourcePath = 'resource'
