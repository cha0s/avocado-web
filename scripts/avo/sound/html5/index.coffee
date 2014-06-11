
module.exports = Sound = {}

Sound[Class] = require "./#{Class}" for Class in [
	'SoundService', 'Music', 'Sample'
]
