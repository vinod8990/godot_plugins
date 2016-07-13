extends "../Primitive.gd"

var major_radius = 0.8
var minor_radius = 0.2
var torus_segments = 16
var segments = 8
var slice_from = 0
var slice_to = 0
var generate_ends = true

static func get_name():
	return "Torus"
	
static func build_circle_rot(pos, segments, radius = 1, rotation = 0):
	var circle = []
	circle.resize(segments + 1)
	
	var s_angle = Utils.TWO_PI/segments
	
	var matrix = Matrix3(Vector3(0, 1, 0), rotation)
	
	for i in range(segments):
		var a = s_angle * i
		
		var vector = Vector3(cos(a), sin(a), 0) * radius
		vector = matrix.xform(vector) + pos
		
		circle[i] = vector
		
	circle[segments] = circle[0]
	
	return circle
	
func update():
	var slice_angle = Utils.TWO_PI - deg2rad(slice_to)
	var start = deg2rad(slice_from)
	var angle = slice_angle/torus_segments
	
	var torus_start = Vector3(major_radius, 0, 0).rotated(Vector3(0, 1, 0), start)
	
	begin()
	
	add_smooth_group(smooth)
	
	var c = build_circle_rot(torus_start, segments, minor_radius, start)
	
	for i in range(torus_segments):
		var m1 = Matrix3(Vector3(0, 1, 0), angle * i)
		
		if slice_to or i < torus_segments - 1:
			var m2 = Matrix3(Vector3(0, 1, 0), angle * (i + 1))
			
			for idx in range(segments):
				add_quad([m1.xform(c[idx]), m2.xform(c[idx]),
				          m2.xform(c[idx + 1]), m1.xform(c[idx + 1])])
				
		else:
			for idx in range(segments):
				add_quad([m1.xform(c[idx]), c[idx],
				          c[idx + 1], m1.xform(c[idx + 1])])
				
	if generate_ends and slice_to > 0:
		var m = Matrix3(Vector3(0, 1, 0), slice_angle)
		
		var torus_end = m.xform(c[0])
		
		add_smooth_group(false)
		
		for idx in range(segments):
			add_tri([c[0], c[idx], c[idx + 1]])
			add_tri([m.xform(c[idx + 1]), m.xform(c[idx]), torus_end])
			
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('major_radius', major_radius)
	editor.add_numeric_parameter('minor_radius', minor_radius)
	editor.add_numeric_parameter('torus_segments', torus_segments, 3, 64, 1)
	editor.add_numeric_parameter('segments', segments, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	editor.add_empty()
	editor.add_bool_parameter('generate_ends', generate_ends)
	

