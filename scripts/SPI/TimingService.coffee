
currentSpi = ''

module.exports = ->
	
	new (require "SPI/#{currentSpi}/Timing/TimingService")

module.exports.implementSpi = (name) ->
	currentSpi = name
	
	Timing = require 'Timing'
	
	Timing.Counter = require "SPI/#{currentSpi}/Timing/Counter"

	Service = require "SPI/#{currentSpi}/Timing/TimingService"
	for key of Service
		@[key] = Service[key]
