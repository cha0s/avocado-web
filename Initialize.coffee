
requires_ = {}

# Implement require in the spirit of NodeJS.
window.require = require = (name) ->
	
	throw new Error "Module #{name} not found!" unless requires_[name]?
	
	unless requires_[name].module?
		exports = {}
		module = exports: exports
		
		f = requires_[name]
		requires_[name] = module: module
		
		f.call null, module, exports
		
	requires_[name].module.exports

# Hack in the SPIIs.
Core = requires_['Core'] = module: exports:
	CoreService: require 'SPI/CoreService'
	
Graphics = requires_['Graphics'] = module: exports:
	GraphicsService: require 'SPI/GraphicsService'
	
Sound = requires_['Sound'] = module: exports:
	SoundService: require 'SPI/SoundService'
	
Timing = requires_['Timing'] = module: exports:
	TimingService: require 'SPI/TimingService'
	
Timing['%setTimeout'] = setTimeout
Timing['%setInterval'] = setInterval
Timing['%clearTimeout'] = clearTimeout
Timing['%clearInterval'] = clearInterval
