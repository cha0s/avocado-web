path = require 'path'

module.exports = (grunt) ->

	coffees = [
		'scripts/**/*.coffee'
		'Initialize.coffee'
		'Main.coffee'
	]
	
	sourceMapping = grunt.file.expandMapping coffees, 'js/',
		rename: (destBase, destPath) ->
			destBase + destPath.replace /\.coffee$/, ".js"
	
	# Don't include test suites
	for source, index in sourceMapping
		if source.src[0].match '\.spec\.coffee'
			delete sourceMapping[index]
	
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		
		coffee:
			compile:
				files: sourceMapping
			
		copy:
			main:
				files: [
					src: [
						'scripts/**/*.js'
					]
					dest: 'js/'
					expand: true
				]
		wrap:
			modules:
				src: ['js/scripts/**/*.js']
				dest: 'js/wrapped/'
				wrapper: (filepath) ->
					
					moduleName = filepath.substr 11
					dirname = path.dirname moduleName
					extname = path.extname moduleName
					moduleName = path.join dirname, path.basename moduleName, extname 
					
					if moduleName?
						["requires_['#{moduleName}'] = function(module, exports) {\n\n", '\n};\n']
					else
						['', '']
		
		concat:
			self:
				src: [
					'js/wrapped/js/scripts/**/*.js'
					'js/Initialize.js'
					'js/Main.js'
				]
				dest: 'avocado-web.js'
		
		uglify:
			build:
				options:
					report: 'min'
				files:
					'avocado-web.min.js': ['avocado-web.js']
				
		clean:
			output: ['js']
				
		watch:
			scripts:
				files: coffees
				tasks: 'default'

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-wrap'
	
	grunt.registerTask 'default', ['coffee', 'copy', 'wrap', 'concat', 'clean']
	grunt.registerTask 'production', ['coffee', 'copy', 'wrap', 'concat', 'uglify', 'clean']
	