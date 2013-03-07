
CoreService = require('Core').CoreService
upon = require 'Utility/upon'

Sounds = {}
module.exports = class

	constructor: ->
		
		@URI = ''
		
	@load: (uri, fn) ->
		
		defer = upon.defer()
		
		s = {}
		
		resolve = (media) ->
			
			Sounds[uri].media = media
			s.Media = media
			s.Audio = Sounds[uri].Audio
			s.URI = uri
			
			defer.resolve s
			fn null, s
		
		reject = ->
			
			fn new Error "Couldn't load Sound: #{uri}"
		
		if Sounds[uri]?
			
			Sounds[uri].defer.then -> resolve Sounds[uri].media
		
		else
		
			audio = new Audio()
			
			audio.src = "#{CoreService.ResourcePath}#{uri}"
			
			Sounds[uri] = {}
			Sounds[uri].Audio = audio
			Sounds[uri].defer = upon.defer()
			
			try
			
				new MediaElement audio, {
					timerRate: 200
					success: resolve
					error: reject
				}
				
			catch error
				
				Sounds[uri].media = null
				fn error, null
			
			defer.then ->
				
				Sounds[uri].defer.resolve()
			
			Sounds[uri].src = uri
		
		undefined
	
	playEnded = ->
		
		@LoopNeedsRestart = true
		
	playTimeUpdate = ->
	
		waitFor = (@Media.duration - @Media.currentTime) * 1000
		if not @Media.loopScheduled and waitFor <= 500
			
			@Media.loopScheduled = true
			
			setTimeout(
				=>
					
					return if @Loops is 0
					@Loops -= 1 if @Loops isnt Music.LoopForever
					
					@Media.loopScheduled = false
					@Media.currentTime = 0
					
					@play() if @LoopNeedsRestart
				
				waitFor - 50
			)
		
	addPlayEventListeners: ->
		
		@Media.addEventListener(
			'ended'
			_.bind playEnded, this
			false
		)
		@Media.addEventListener(
			'timeupdate'
			_.bind playTimeUpdate, this
			false
		)
				
	removePlayEventListeners: ->
		
		@Media.removeEventListener(
			'ended'
			_.bind playEnded, this
			false
		)
		@Media.removeEventListener(
			'timeUpdate'
			_.bind playTimeUpdate, this
			false
		)
		
	'%play': (@Loops) ->
		return unless @Media?
		
		delete @LoopNeedsRestart
		
		@Media.volume = 1
		
		@addPlayEventListeners()
		@Media.play()
	
	'%stop': ->
		return unless @Media?
	
		@removePlayEventListeners()
	
		@Media.pause()
		@Media.currentTime = 0

