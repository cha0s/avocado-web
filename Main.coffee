# Subclass Main. We update the elapsed time manually, since we don't get
# a tight loop like on native platforms; everything is interval-based in a
# browser.

Config = require 'Config'

Config.coreSpi = 'HTML5'
Config.graphicsSpi = 'HTML5'
Config.soundSpi = 'HTML5'
Config.timingSpi = 'HTML5'

Core = require 'Core'
Core.CoreService.implementSpi Config.coreSpi
Core.coreService = new Core.CoreService()

Graphics = require 'Graphics'
Graphics.GraphicsService.implementSpi Config.graphicsSpi
Graphics.graphicsService = new Graphics.GraphicsService()

Sound = require 'Sound'
Sound.SoundService.implementSpi Config.soundSpi
Sound.soundService = new Sound.SoundService()

Timing = require 'Timing'
Timing.TimingService.implementSpi Config.timingSpi
Timing.timingService = new Timing.TimingService()
Timing.ticksPerSecondTarget = Config.ticksPerSecondTarget
Timing.rendersPerSecondTarget = Config.rendersPerSecondTarget

# Monkey patches & SPI proxies.
require 'monkeyPatches'
require 'proxySpiis'


Debug = require 'Debug'
Main = require 'Main'
Q = require 'Utility/Q'

Q.stopUnhandledRejectionTracking()

timeCounter = new Timing.Counter()
originalTimestamp = timeCounter.current()

window.main = main = new Main()

main.on 'beforeTick', ->
	
	Timing.TimingService.setElapsed(
		(timeCounter.current() - originalTimestamp) / 1000
	)

main.on 'stateInitialized', (name) ->
	
	if name is 'Initial'
		
		document.body.appendChild Graphics.window.Canvas
		Graphics.window.calculateOffset()

quit = (error) ->

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

main.begin()
