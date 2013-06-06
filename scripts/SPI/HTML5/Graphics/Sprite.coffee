
Graphics = require 'Graphics'

Rectangle = require 'Extension/Rectangle'
Vector = require 'Extension/Vector'

module.exports = Sprite = class
	
	constructor: ->
		
		@_alpha = 1
		@_blendMode = Graphics.GraphicsService.BlendMode_Blend
		@_position = [0, 0]
		@_angle = 0
		@_factor = [1, 1]
		@_source = null
		@_sourceRectangle = [0, 0, 0, 0]
	
	'%renderTo': (destination) ->
	
		context = Graphics.contextFromCanvas destination.Canvas
		
		context.save()
		
		context.globalAlpha = @_alpha
		
		unless @_factor[0] is 0 and @_factor[1] is 0
		
			context.scale @_factor[0], @_factor[1]
			position = [
				@_position[0] / @_factor[0]
				@_position[1] / @_factor[1]
			]
			
		else
			
			position = @_position
		
		if @_angle
			context.translate position[0] + @_rotationOrientation[0], position[1] + @_rotationOrientation[1]
			
			# Degrees -> radians
			context.rotate @_angle * 0.0174532925
			
			position = [-@_rotationOrientation[0], -@_rotationOrientation[1]]
			
		if @_emptySourceRectangle
		
			context.drawImage @_source, position[0], position[1]
		
		else
		
			context.drawImage(
				@_source
				
				@_sourceRectangle[0], @_sourceRectangle[1]
				@_sourceRectangle[2], @_sourceRectangle[3]
				
				position[0], position[1]
				@_sourceRectangle[2], @_sourceRectangle[3]
			)
		
		context.restore()
		
	_clipCoordinates: ->
		
		# Is this necessary, still?
		for i in [0..1]
			if @_position[i] < 0
				if @_position[i] <= -@_sourceRect[i + 2]
					return
				@_sourceRect[i] -= @_position[i]
				@_sourceRect[i + 2] += @_position[i]
				@_position[i] = 0

	_checkSourceRectangle: ->
		
		@_emptySourceRectangle = Rectangle.equals(
			@_sourceRectangle
			[0, 0, 0, 0]
		)
	
	'%setAlpha': (@_alpha) ->
	
	'%setBlendMode': (@_blendMode) ->
	
	'%setPosition': (position) ->
		@_position = Vector.round position
	
	'%setRotation': (@_angle, @_rotationOrientation) ->
	
	'%setScale': (factorX, factorY) -> @_factor = [factorX, factorY]
	
	'%setSource': (source) ->
		@_source = source.BrowserImage ? source.Canvas
		@_checkSourceRectangle()
	
	'%setSourceRectangle': (sourceRectangle) ->
		@_sourceRectangle = Rectangle.round sourceRectangle
		@_checkSourceRectangle()
