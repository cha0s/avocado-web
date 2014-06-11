# Subclass Main. We update the elapsed time manually, since we don't get
# a tight loop like on native platforms; everything is interval-based in a
# browser.

spii.proxy() for spii in [
	Core = require 'avo/core'
	Graphics = require 'avo/graphics'
	Sound = require 'avo/sound'
	Timing = require 'avo/timing'
]

require 'avo/monkeyPatches'

Main = require 'avo/main'

originalTimestamp = Timing.TimingService.current()

window.main = main = new Main()

main.on 'beforeTick', ->
	
	Timing.TimingService.setElapsed(
		(Timing.TimingService.current() - originalTimestamp) / 1000
	)

main.on 'stateInitialized', (name) ->
	
	if name is 'initial'
		
		document.body.appendChild Graphics.window._canvas
		Graphics.window.calculateOffset()

quit = (error) ->

	throw error
	console.log error
	main.quit()

# Log and exit on error.
main.on 'error', quit
window.onerror = (message, filename, lineNumber) ->
	quit new Error message, filename, lineNumber
	true
	
# Close out services and stop running on quit.
main.on 'quit', ->
	
	Sound.soundService.close()
	Timing.timingService.close()
	Graphics.graphicsService.close()
	Core.coreService.close()
	
	# Browser-specific stuff?

# GO!
console.log 'hi'
main.begin()
