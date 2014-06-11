
module.exports = Graphics = {}

Graphics[Class] = require "./#{Class}" for Class in [
	'GraphicsService', 'Canvas', 'Font', 'Image', 'Sprite', 'Window'
]
