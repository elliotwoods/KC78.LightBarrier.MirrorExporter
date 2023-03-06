# Copyright 2016-2022 Trimble Inc
# Licensed under the MIT license

require 'sketchup.rb'
require 'extensions.rb'

module LightBarrier # TODO: Change module name to fit the project.
	module ExportMirrors

		unless file_loaded?(__FILE__)
			ex = SketchupExtension.new('Hello Cube', 'lb_export_mirrors/main')
			ex.description = 'Export the mirrors from SketchUp file.'
			ex.version     = '1.0.0'
			ex.copyright   = 'Trimble Inc © 2016-2022'
			ex.creator     = 'SketchUp'
			Sketchup.register_extension(ex, true)
			file_loaded(__FILE__)
		end

	end # module ExportMirrors

	# Reload extension by running this method from the Ruby Console:
	#   Example::HelloWorld.reload
	def self.reload
		original_verbose = $VERBOSE
		$VERBOSE = nil
		pattern = File.join(__dir__, '**/*.rb')
		Dir.glob(pattern).each { |file|
			# Cannot use `Sketchup.load` because its an alias for `Sketchup.require`.
			load file
		}.size
	ensure
		$VERBOSE = original_verbose
	end
end # module LightBarrier