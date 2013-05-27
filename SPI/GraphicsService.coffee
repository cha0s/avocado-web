
currentSpi = ''

module.exports = ->
	
	new (require "SPI/#{currentSpi}/Graphics/GraphicsService")
	
module.exports.implementSpi = (name) ->
	currentSpi = name
	
	Graphics = require 'Graphics'
	Graphics.Canvas = require "SPI/#{currentSpi}/Graphics/Canvas"
	Graphics.Font = require "SPI/#{currentSpi}/Graphics/Font"
	Graphics.Image = require "SPI/#{currentSpi}/Graphics/Image"
	Graphics.Window = require "SPI/#{currentSpi}/Graphics/Window"

	Service = require "SPI/#{currentSpi}/Graphics/GraphicsService"
	for key of Service
		@[key] = Service[key]
