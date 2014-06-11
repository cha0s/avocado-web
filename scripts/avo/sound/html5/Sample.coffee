
Sound = require './Sound'
Promise = require 'avo/vendor/bluebird'

module.exports = class Sample extends Sound
	
	@['%load'] = (uri, fn) ->
		
		Sound.load(uri).then (sound) ->
			
			sample = new Sample()
			
			sample.Media = sound.Media
			sample.Audio = sound.Audio
			sample.URI = sound.URI
			
			fn sample
	
