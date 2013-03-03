path = require 'path'

module.exports = (grunt) ->

	sourceDirectories = [
		'SPI/**/*.coffee'
		'Initialize.coffee'
		'Main.coffee'
	]
	
	sourceMapping = grunt.file.expandMapping sourceDirectories, 'js/scripts/',
		rename: (destBase, destPath) ->
			destBase + destPath.replace /\.coffee$/, ".js"
	
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		
		coffee:
			compile:
				files: sourceMapping
			
		wrap:
			modules:
				src: ['js/scripts/**/*.js']
				dest: 'js/wrapped/'
				wrapper: (filepath) ->
					
					unless filepath.match /^js\/scripts\/(Initialize|Main)\.js$/
						moduleName = filepath.substr 11
						dirname = path.dirname moduleName
						extname = path.extname moduleName
						moduleName = path.join dirname, path.basename moduleName, extname 
					
					if moduleName?
						["requires_['#{moduleName}'] = function(module, exports) {\n\n", '\n}\n']
					else
						['', '']
		
		uglify:
			options:
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
			build:
				src: [
					'js/wrapped/**/*.js'
				]
				dest: 'build/<%= pkg.name %>.min.js'
				
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-wrap'
	
	grunt.registerTask 'default', ['coffee', 'wrap']
