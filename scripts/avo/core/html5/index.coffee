
module.exports = Core = {}

Core[Class] = require "./#{Class}" for Class in [
	'CoreService'
]
