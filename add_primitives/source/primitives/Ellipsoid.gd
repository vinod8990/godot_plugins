extends "../Primitive.gd"

var width = 1.0
var length = 1.0
var height = 1.0
var segments = 16
var height_segments = 8
var slice_from = 0
var slice_to = 0
var hemisphere = 0.0
var generate_ends = true
var generate_cap = true

static func get_name():
	return "Ellipsoid"
	
static func get_container():
	return "Extra Objects"
	
func update():
	var angle = lerp(PI, 0, hemisphere)/height_segments
	
	var pos = Vector3(0, -cos(angle) * height, 0)
	var radius = sin(angle)
	
	var ellipse = Utils.build_ellipse(Vector3(), segments, Vector2(width, length), deg2rad(slice_from), deg2rad(360 - slice_to))
	
	begin()
	
	if generate_ends and slice_to > 0:
		add_smooth_group(false)
		
		var center = Vector3(0, cos(angle * height_segments) * height, 0)
		
		for i in range(height_segments):
			var rp = sin(angle * i)
			var rn = sin(angle * (i + 1))
			
			var p = Vector3(0, cos(angle * i) * height, 0)
			var n = Vector3(0, cos(angle * (i + 1)) * height, 0)
			
			add_tri([center, ellipse[0] * rp + p, ellipse[0] * rn + n])
			add_tri([center, ellipse[segments] * rn + n, ellipse[segments] * rp + p])
			
	var hs = height_segments
	
	if hemisphere > 0:
		pos.y = cos(angle * height_segments) * height
		radius = sin(angle * height_segments)
		
		if generate_cap:
			if not slice_to:
				add_smooth_group(false)
				
			for idx in range(segments):
				add_tri([pos, ellipse[idx] * radius + pos, ellipse[idx + 1] * radius + pos])
				
			add_smooth_group(smooth)
			
	else:
		add_smooth_group(smooth)
		
		for idx in range(segments):
			add_tri([Vector3(0, -height, 0), ellipse[idx] * radius + pos, ellipse[idx + 1] * radius + pos])
			
		hs -= 1
		
	for i in range(hs, 1, -1):
		var next_pos = Vector3(0, cos(angle * (i - 1)) * height, 0)
		var next_radius = sin(angle * (i - 1))
		
		for idx in range(segments):
			add_quad([ellipse[idx] * radius + pos,
			          ellipse[idx] * next_radius + next_pos,
			          ellipse[idx + 1] * next_radius + next_pos,
			          ellipse[idx + 1] * radius + pos])
			
		pos = next_pos
		radius = next_radius
		
	pos = Vector3(0, cos(angle) * height, 0)
	
	for idx in range(segments):
		add_tri([ellipse[idx + 1] * radius + pos, ellipse[idx] * radius + pos, Vector3(0, height, 0)])
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('width', width)
	editor.add_numeric_parameter('length', length)
	editor.add_numeric_parameter('height', height)
	editor.add_numeric_parameter('segments', segments, 3, 64, 1)
	editor.add_numeric_parameter('height_segments', height_segments, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	editor.add_numeric_parameter('hemisphere', hemisphere, 0, 0.999)
	editor.add_empty()
	editor.add_bool_parameter('generate_ends', generate_ends)
	editor.add_bool_parameter('generate_cap', generate_cap)
	

