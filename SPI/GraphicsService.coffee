
currentSpi = ''

module.exports = ->
	
	new (require "SPI/#{currentSpi}/Graphics/GraphicsService")

module.exports.implementSpi = (name) ->
	currentSpi = name
	
	Graphics = require 'Graphics'
	Graphics.Image = require "SPI/#{currentSpi}/Graphics/Image"
	Graphics.Window = require "SPI/#{currentSpi}/Graphics/Window"

	Service = require "SPI/#{currentSpi}/Graphics/GraphicsService"
	for key in Service
		@[key] = Service[key]
