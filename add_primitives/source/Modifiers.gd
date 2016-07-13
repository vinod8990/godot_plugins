#==============================================================================#
# Copyright (c) 2015 Franklin Sobrinho.                                        #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining        #
# a copy of this software and associated documentation files (the "Software"), #
# to deal in the Software without restriction, including without               #
# limitation the rights to use, copy, modify, merge, publish,                  #
# distribute, sublicense, and/or sell copies of the Software, and to           #
# permit persons to whom the Software is furnished to do so, subject to        #
# the following conditions:                                                    #
#                                                                              #
# The above copyright notice and this permission notice shall be               #
# included in all copies or substantial portions of the Software.              #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,              #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF           #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.       #
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY         #
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,         #
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE            #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                       #
#==============================================================================#

extends Reference

class Modifier extends MeshDataTool:
	
	var enabled = true
	
	var mesh = null
	var aabb = AABB()
	
	var remove_surface = false
	var surface_count = 0
	
	static func get_name():
		return ""
		
	func is_enabled():
		return enabled
		
	func set_mesh(mesh):
		self.mesh = mesh
		
		if mesh:
			surface_count = mesh.get_surface_count()
			
		else:
			surface_count = 0
			
	func set_aabb(aabb):
		self.aabb = aabb
		
	func modify():
		pass
		
	func create_data():
		if surface_count == 0:
			return
			
		create_from_surface(mesh, 0)
		
		remove_surface = true
		
	func commit():
		if surface_count == 0:
			return
			
		commit_to_surface(mesh)
		
		if remove_surface:
			mesh.surface_remove(0)
			
			remove_surface = false
			
	func clear():
		mesh = null
		aabb = AABB()
		
		remove_surface = false
		surface_count = 0
		
		.clear()
		
	func modifier_parameters(editor):
		pass
		
# End Modifier

class TaperModifier extends Modifier:
	
	var axis = Vector3.AXIS_Y
	var value = -0.5
	var lock_x_axis = false
	var lock_y_axis = false
	var lock_z_axis = false
	
	static func get_name():
		return "Taper"
		
	static func taper(scale, unlocked_axis):
		var vec = Vector3(1, 1, 1)
		
		for i in unlocked_axis:
			vec[i] += scale
			
		return vec
		
	func modify():
		var size = aabb.size[axis]/2
		
		var unlocked_axis = []
		
		if not lock_x_axis and axis != Vector3.AXIS_X:
			unlocked_axis.push_back(Vector3.AXIS_X)
			
		if not lock_y_axis and axis != Vector3.AXIS_Y:
			unlocked_axis.push_back(Vector3.AXIS_Y)
			
		if not lock_z_axis and axis != Vector3.AXIS_Z:
			unlocked_axis.push_back(Vector3.AXIS_Z)
			
		for surf in range(surface_count):
			create_data()
			
			for i in range(get_vertex_count()):
				var v = get_vertex(i)
				
				set_vertex(i, v * taper(v[axis]/size * value, unlocked_axis))
				
			commit()
			
	func modifier_parameters(editor):
		editor.add_enum_parameter('axis', axis, 'X,Y,Z')
		editor.add_numeric_parameter('value', value, -100, 100, 0.001)
		editor.add_bool_parameter('lock_x_axis', lock_x_axis)
		editor.add_bool_parameter('lock_y_axis', lock_y_axis)
		editor.add_bool_parameter('lock_z_axis', lock_z_axis)
		
# End TaperModifer

class ShearModifier extends Modifier:
	
	var shear_axis = Vector3.AXIS_X
	var axis = Vector3.AXIS_Y
	var value = 1
	
	static func get_name():
		return "Shear"
		
	func modify():
		var size = aabb.size[axis]/2
		
		for surf in range(surface_count):
			create_data()
			
			for i in range(get_vertex_count()):
				var v = get_vertex(i)
				
				v[shear_axis] += v[axis]/size * value
				
				set_vertex(i, v)
				
			commit()
			
	func modifier_parameters(editor):
		editor.add_enum_parameter('shear_axis', shear_axis, 'X,Y,Z')
		editor.add_enum_parameter('axis', axis, 'X,Y,Z')
		editor.add_numeric_parameter('value', value, -100, 100, 0.001)
		
# End ShearModifier

class TwistModifier extends Modifier:
	
	var axis = Vector3.AXIS_Y
	var angle = 30
	
	static func get_name():
		return "Twist"
		
	func modify():
		var a = deg2rad(angle)
		var size = aabb.size[axis]/2
		
		var r_axis = Vector3()
		r_axis[axis] = 1
		
		for surf in range(surface_count):
			create_data()
			
			for i in range(get_vertex_count()):
				var v = get_vertex(i)
				
				set_vertex(i, v.rotated(r_axis, v[axis]/size * a))
				
			commit()
			
	func modifier_parameters(editor):
		editor.add_enum_parameter('axis', axis, 'X,Y,Z')
		editor.add_numeric_parameter('angle', angle, -180, 180, 1)
		
# End TwistModifier

class ArrayModifier extends Modifier:
	
	var count = 2
	var relative = true
	var x = 1.0
	var y = 0.0
	var z = 0.0
	
	static func get_name():
		return "Array"
		
	func modify():
		var ofs = Vector3(x, y, z)
		
		if relative:
			ofs *= aabb.size
			
		for surf in range(surface_count):
			create_data()
			
			commit()
			
			for c in range(count - 1):
				for i in range(get_vertex_count()):
					set_vertex(i, get_vertex(i) + ofs)
					
				commit()
				
	func modifier_parameters(editor):
		editor.add_numeric_parameter('count', count, 1, 100, 1)
		editor.add_bool_parameter('relative', relative)
		editor.add_numeric_parameter('x', x, -100, 100, 0.001)
		editor.add_numeric_parameter('y', y, -100, 100, 0.001)
		editor.add_numeric_parameter('z', z, -100, 100, 0.001)
		
# End ArrayModifier

class OffsetModifier extends Modifier:
	
	var relative = true
	var x = 0.0
	var y = 0.5
	var z = 0.0
	
	static func get_name():
		return "Offset"
		
	func modify():
		var ofs = Vector3(x, y, z)
		
		if relative:
			ofs *= aabb.size
			
		for surf in range(surface_count):
			create_data()
			
			for i in range(get_vertex_count()):
				set_vertex(i, get_vertex(i) + ofs)
				
			commit()
			
	func modifier_parameters(editor):
		editor.add_bool_parameter('relative', relative)
		editor.add_numeric_parameter('x', x, -100, 100, 0.001)
		editor.add_numeric_parameter('y', y, -100, 100, 0.001)
		editor.add_numeric_parameter('z', z, -100, 100, 0.001)
		
# End OffsetModifier

class RandomModifier extends Modifier:
	
	var random_seed = 0
	var amount = 0.1
	
	static func get_name():
		return "Random"
		
	func modify():
		var idx = str(random_seed)
		
		if has_meta(idx):
			seed(get_meta(idx))
			
		else:
			if random_seed == 0:
				randomize()
				
			var r = randi() % 0xFFFFFF
			set_meta(idx, r)
			
			seed(r)
			
		var cache = {}
		
		for surf in range(surface_count):
			create_data()
			
			for i in range(get_vertex_count()):
				var v = get_vertex(i)
				
				if not cache.has(v):
					cache[v] = Vector3(rand_range(-1, 1),\
					                   rand_range(-1, 1),\
					                   rand_range(-1, 1)) * amount
					
				set_vertex(i, v + cache[v])
				
			commit()
			
		cache.clear()
		
	func modifier_parameters(editor):
		editor.add_numeric_parameter('amount', amount)
		editor.add_numeric_parameter('random_seed', random_seed, 0, 50, 1)
		
# End RandomModifier

class UVTransformModifier extends Modifier:
	
	var translation_x = 0.0
	var translation_y = 0.0
	var rotation = 0
	var scale_x = 1.0
	var scale_y = 1.0
	
	static func get_name():
		return "UV Transform"
		
	func modify():
		var t = Matrix32(deg2rad(rotation), Vector2(translation_x, translation_y)).scaled(Vector2(scale_x, scale_y))
		
		for surf in range(surface_count):
			create_data()
			
			if not get_format() & Mesh.ARRAY_FORMAT_TEX_UV:
				commit()
				
				continue
				
			for i in range(get_vertex_count()):
				set_vertex_uv(i, t.xform(get_vertex_uv(i)))
				
			commit()
			
	func modifier_parameters(editor):
		editor.add_numeric_parameter('translation_x', translation_x, -100, 100, 0.001)
		editor.add_numeric_parameter('translation_y', translation_y, -100, 100, 0.001)
		editor.add_numeric_parameter('rotation', rotation, -360, 360, 1)
		editor.add_numeric_parameter('scale_x', scale_x)
		editor.add_numeric_parameter('scale_y', scale_y)
		
# End UVTransformModifier 

################################################################################
################################################################################
################################################################################

static func get_modifiers():
	var modifiers = {
		'Taper' : TaperModifier,
		'Shear' : ShearModifier,
		'Twist' : TwistModifier,
		'Array' : ArrayModifier, 
		'Offset' : OffsetModifier,
		'Random' : RandomModifier,
		'UV Transform' : UVTransformModifier 
	}
	
	return modifiers
	

