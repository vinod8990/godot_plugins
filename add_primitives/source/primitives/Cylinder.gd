extends "../Primitive.gd"

var radius = 1.0
var height = 2.0
var sides = 16
var height_segments = 1
var slice_from = 0
var slice_to = 0
var generate_top = true
var generate_bottom = true
var generate_ends = true

static func get_name():
	return "Cylinder"
	
func update():
	var slice_angle = deg2rad(360 - slice_to)
	var circumference = (slice_angle * PI * radius)/PI
	
	var top = Vector3(0, height/2, 0)
	var bottom = Vector3(0, -height/2, 0)
	
	var circle = Utils.build_circle(Vector3(), sides, radius, deg2rad(slice_from), slice_angle)
	
	begin()
	
	add_smooth_group(false)
	
	if generate_top or generate_bottom:
		var c = Vector2(0.5, 0.5)
		var uv = Utils.ellipse_uv(c, sides, Vector2(radius, radius), slice_angle)
		
		for i in range(sides):
			if generate_top:
				add_tri([top, circle[i] + top, circle[i + 1] + top], [c, uv[i], uv[i + 1]])
				
			if generate_bottom:
				add_tri([bottom, circle[i + 1] + bottom, circle[i] + bottom], [c, uv[i + 1], uv[i]])
				
	if generate_ends and slice_to > 0:
		var p = bottom
		
		for i in range(height_segments):
			var n = bottom.linear_interpolate(top, float(i + 1)/height_segments)
			
			var v1 = i/height_segments * height
			var v2 = (i + 1)/height_segments * height
			
			var uv = [
			    Vector2(0, v1),
			    Vector2(radius, v1),
			    Vector2(radius, v2),
			    Vector2(0, v2)
			]
			
			add_quad([p, circle[0] + p, circle[0] + n, n], uv)
			
			if not flip_normals:
				uv.invert()
				
			add_quad([n, circle[sides] + n, circle[sides] + p, p], uv)
			
			p = n
			
	add_smooth_group(smooth)
	
	var p = bottom
	
	for i in range(height_segments):
		var n = bottom.linear_interpolate(top, (i + 1)/height_segments)
		
		var v1 = lerp(height, 0, i/height_segments)
		var v2 = lerp(height, 0, (i + 1)/height_segments)
		
		for idx in range(sides):
			var u1 = float(idx)/sides * circumference
			var u2 = float(idx + 1)/sides * circumference
			
			add_quad([circle[idx] + p, circle[idx + 1] + p, circle[idx + 1] + n, circle[idx] + n],\
			         [Vector2(u1, v1), Vector2(u2, v1), Vector2(u2, v2), Vector2(u1, v2)])
			
		p = n
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('radius', radius)
	editor.add_numeric_parameter('height', height)
	editor.add_numeric_parameter('sides', sides, 3, 64, 1)
	editor.add_numeric_parameter('height_segments', height_segments, 1, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	editor.add_empty()
	editor.add_bool_parameter('generate_top', generate_top)
	editor.add_bool_parameter('generate_bottom', generate_bottom)
	editor.add_bool_parameter('generate_ends', generate_ends)
	

