
Sound = require 'SPI/HTML5/Sound/Sound'
upon = require 'Utility/upon'

module.exports = class extends Sound
	
	@['%load'] = (uri, fn) ->
		
		Sound.load(uri).then (sound) ->
			
			sample = new Sample()
			
			sample.Media = sound.Media
			sample.Audio = sound.Audio
			sample.URI = sound.URI
			
			fn sample
	
