
currentSpi = ''

module.exports = ->
	
	new (require "SPI/#{currentSpi}/Sound/SoundService")

module.exports.implementSpi = (name) ->
	currentSpi = name
	
	Sound = require 'Sound'
	Sound.Music = require "SPI/#{currentSpi}/Sound/Music"
	Sound.Sample = require "SPI/#{currentSpi}/Sound/Sample"

	Service = require "SPI/#{currentSpi}/Sound/SoundService"
	for key in Service
		@[key] = Service[key]
