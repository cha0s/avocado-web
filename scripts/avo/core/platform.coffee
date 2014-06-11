
exports.augment = ({CoreService}) ->
	
	CoreService::_Core = require 'avo/core'
	
	CoreService.ResourcePath = '/resource'	
