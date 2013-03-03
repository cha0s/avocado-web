
currentSpi = ''

module.exports = ->
	
	new (require "SPI/#{currentSpi}/Sound/SoundService")

module.exports.implementSpi = (name) ->
	currentSpi = name
	
	Sound = require 'Sound'
	Sound.Image = require "SPI/#{currentSpi}/Sound/Music"
	Sound.Window = require "SPI/#{currentSpi}/Sound/Sample"

	Service = require "SPI/#{currentSpi}/Sound/SoundService"
	for key in Service
		@[key] = Service[key]
