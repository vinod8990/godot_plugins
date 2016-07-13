extends "../Primitive.gd"

var radius = 1.0
var height = 1.0
var sides = 16
var height_segments = 8
var slice_from = 0
var slice_to = 0
var use_cap_height = false
var cap_height = 1.0
var generate_ends = true

static func get_name():
	return "Capsule"
	
func update():
	var angle = PI/height_segments
	var slice_angle = Utils.TWO_PI - deg2rad(slice_to)
	
	var ch = radius
	
	if use_cap_height:
		ch = cap_height
		
	var r = Vector3(sin(angle), 0, sin(angle))
	var p = Vector3(0, cos(angle) * ch + height, 0)
	
	var circle = Utils.build_circle(Vector3(), sides, radius, deg2rad(slice_from), slice_angle)
	
	begin()
	
	add_smooth_group(smooth)
	
	for idx in range(sides):
		add_tri([Vector3(0, ch + height, 0), circle[idx] * r + p,
		         circle[idx + 1] * r + p])
		add_tri([circle[idx + 1] * r - p, circle[idx] * r - p,
		         Vector3(0, -(ch + height), 0)])
		
	for i in range((height_segments - 2)/2):
		var np = Vector3(0, cos(angle * (i + 2)) * ch + height, 0)
		var nr = Vector3(sin(angle * (i + 2)), 0, sin(angle * (i + 2)))
		
		for idx in range(sides):
			add_quad([circle[idx] * r + p, circle[idx] * nr + np,
			          circle[idx + 1] * nr + np, circle[idx + 1] * r + p])
			add_quad([circle[idx + 1] * r - p, circle[idx + 1] * nr - np,
			          circle[idx] * nr - np, circle[idx] * r - p])
			
		p = np
		r = nr
		
	var h = Vector3(0, height, 0)
	
	for idx in range(sides):
		add_quad([circle[idx] + h, circle[idx] - h,
		          circle[idx + 1] - h, circle[idx + 1] + h])
		
	if generate_ends and slice_to > 0:
		add_smooth_group(false)
		
		add_quad([circle[0] + h, h, -h, circle[0] - h])
		add_quad([h, circle[sides] + h, circle[sides] - h, -h])
		
		var r = 0
		var p = Vector3(0, height + ch, 0)
		
		for i in range(height_segments/2):
			var nr = sin(angle * (i + 1))
			var np = Vector3(0, cos(angle * (i + 1)) * ch + height, 0)
			
			add_tri([h, circle[0] * nr + np, circle[0] * r + p])
			add_tri([h, circle[sides] * r + p, circle[sides] * nr + np])
			
			add_tri([-h, circle[0] * r - p, circle[0] * nr - np])
			add_tri([-h, circle[sides] * nr - np, circle[sides] * r - p])
			
			r = nr
			p = np
			
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('radius', radius)
	editor.add_numeric_parameter('height', height)
	editor.add_numeric_parameter('sides', sides, 3, 64, 1)
	editor.add_numeric_parameter('height_segments', height_segments, 2, 64, 2)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	editor.add_empty()
	editor.add_bool_parameter('use_cap_height', use_cap_height)
	editor.add_numeric_parameter('cap_height', cap_height)
	editor.add_empty()
	editor.add_bool_parameter('generate_ends', generate_ends)
	

