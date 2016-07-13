extends "../Primitive.gd"

var radius = 1.0
var segments = 16
var height_segments = 8
var slice_from = 0
var slice_to = 0
var hemisphere = 0.0
var generate_ends = true
var generate_cap = true

static func get_name():
	return "Sphere"
	
func update():
	var angle = lerp(PI, 0, hemisphere)/height_segments
	
	var pos = Vector3(0, -cos(angle) * radius, 0)
	var rd = sin(angle)
	
	var circle = Utils.build_circle(Vector3(), segments, radius, deg2rad(slice_from), deg2rad(360 - slice_to))
	
	begin()
	
	if generate_ends and slice_to > 0:
		add_smooth_group(false)
		
		var center = Vector3(0, cos(angle * height_segments) * radius, 0)
		
		for i in range(height_segments):
			var rp = sin(angle * i)
			var rn = sin(angle * (i + 1))
			
			var p = Vector3(0, cos(angle * i) * radius, 0)
			var n = Vector3(0, cos(angle * (i + 1)) * radius, 0)
			
			add_tri([center, circle[0] * rn + n, circle[0] * rp + p])
			add_tri([center, circle[segments] * rp + p, circle[segments] * rn + n])
			
	var hs = height_segments
	
	if hemisphere > 0:
		pos.y = cos(angle * height_segments) * radius
		rd = sin(angle * height_segments)
		
		if generate_cap:
			if not slice_to:
				add_smooth_group(false)
				
			for idx in range(segments):
				add_tri([pos, circle[idx + 1] * rd + pos, circle[idx] * rd + pos])
				
		add_smooth_group(smooth)
		
	else:
		add_smooth_group(smooth)
		
		for idx in range(segments):
			add_tri([Vector3(0, -radius, 0), circle[idx + 1] * rd + pos, circle[idx] * rd + pos])
			
		hs -= 1
		
	for i in range(hs, 1, -1):
		var n = i - 1
		
		var next_pos = Vector3(0, cos(angle * n) * radius, 0)
		var next_radius = sin(angle * n)
		
		for idx in range(segments):
			add_quad([circle[idx] * rd + pos,
			          circle[idx + 1] * rd + pos,
			          circle[idx + 1] * next_radius + next_pos,
			          circle[idx] * next_radius + next_pos])
			
		pos = next_pos
		rd = next_radius
		
		
	pos = Vector3(0, cos(angle) * radius, 0)
	
	for idx in range(segments):
		add_tri([circle[idx] * rd + pos, circle[idx + 1] * rd + pos, Vector3(0, radius, 0)])
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('radius', radius)
	editor.add_numeric_parameter('segments', segments, 3, 64, 1)
	editor.add_numeric_parameter('height_segments', height_segments, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	editor.add_numeric_parameter('hemisphere', hemisphere, 0, 0.999)
	editor.add_empty()
	editor.add_bool_parameter('generate_ends', generate_ends)
	editor.add_bool_parameter('generate_cap', generate_cap)

