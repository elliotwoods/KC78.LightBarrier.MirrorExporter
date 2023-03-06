# Copyright 2016-2022 Trimble Inc
# Licensed under the MIT license

require 'sketchup.rb'

module LightBarrier
	module ExportMirrors
    def self.export_mirror(mirror, transformation)
        @file.puts "M"
        mirror.definition.entities.each do |entity|
        if entity.is_a?(Sketchup::Face)
          loops = entity.loops
          loops[0].vertices.each do |vertex|
            transformed_pos = transformation * vertex.position
            @file.puts "V %f, %f, %f" % [transformed_pos.x, transformed_pos.y, transformed_pos.z]
          end
          @file.puts "\n"
        end
      end
    end

		def self.traverse_entities(entities, transformation)
			entities.each do |entity|
        if entity.is_a?(Sketchup::Group)
          sub_transform = transformation * entity.transformation
          self.traverse_group(entity, sub_transform)
        end
        if entity.is_a?(Sketchup::ComponentInstance)
          sub_transform = transformation * entity.transformation
          self.traverse_component(entity, sub_transform)
        end
      end
		end

		def self.traverse_component(componentInstance, transformation)
			definition = componentInstance.definition

      if definition.name == "Mirror 260"
        self.export_mirror(componentInstance, transformation)
      end

      subEntities = definition.entities
      self.traverse_entities(subEntities, transformation)
		end

		def self.traverse_group(group, transformation)
        self.traverse_entities(group.entities)
		end

		def self.export_mirrors
			model = Sketchup.active_model

			model.start_operation('Export mirrors', true)
			selection = model.selection
			selected_entities = selection.to_a

      current_dir = File.dirname(__FILE__)
      @file = File.new(current_dir + "/../../mirrors.txt", "w")
			self.traverse_entities(selected_entities, Geom::Transformation.new())
      @file.close

			# group = model.active_entities.add_group
			# entities = group.entities
			# points = [
			# 	Geom::Point3d.new(0,   0,   0),
			# 	Geom::Point3d.new(2.m, 0,   0),
			# 	Geom::Point3d.new(1.m, 1.m, 0),
			# 	Geom::Point3d.new(0,   1.m, 0)
			# ]
			# face = entities.add_face(points)
			# face.pushpull(-1.m)

			model.commit_operation
		end

		unless file_loaded?(__FILE__)
			menu = UI.menu('Plugins')
			menu.add_item('Export mirrors...') {
				self.export_mirrors
			}
			file_loaded(__FILE__)
		end

	end # module ExportMirrors
end # module LightBarrier
