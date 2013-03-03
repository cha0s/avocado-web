
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
	CoreService: require 'main/web/Bindings/CoreService'
	
Graphics = requires_['Graphics'] = module: exports:
	GraphicsService: require 'main/web/Bindings/GraphicsService'
	Font: require 'main/web/Bindings/Font'
	Image: require 'main/web/Bindings/Image'
	Window: require 'main/web/Bindings/Window'
	
Sound = requires_['Sound'] = module: exports:
	SoundService: require 'main/web/Bindings/SoundService'
	Music: require 'main/web/Bindings/Music'
	Sample: require 'main/web/Bindings/Sample'
	
Timing = requires_['Timing'] = module: exports:
	TimingService: require 'main/web/Bindings/TimingService'
	Counter: require 'main/web/Bindings/Counter'
	
Timing['%setTimeout'] = setTimeout
Timing['%setInterval'] = setInterval
Timing['%clearTimeout'] = clearTimeout
Timing['%clearInterval'] = clearInterval
