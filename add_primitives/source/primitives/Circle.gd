extends "../Primitive.gd"

var radius = 1
var segments = 16
var slice_from = 0
var slice_to = 0

static func get_name():
	return "Circle"
	
func update():
	var slice_angle = Utils.TWO_PI - deg2rad(slice_to)
	
	var center = Vector3()
	var center_uv = Vector2(0.5, 0.5)
	
	var circle = Utils.build_circle(center, segments, radius, deg2rad(slice_from), slice_angle)
	var uv = Utils.ellipse_uv(center_uv, segments, Vector2(radius, radius), slice_angle)
	
	begin()
	
	add_smooth_group(smooth)
	
	for i in range(segments):
		add_tri([center, circle[i], circle[i + 1]], [center_uv, uv[i], uv[i + 1]])
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('radius', radius)
	editor.add_numeric_parameter('segments', segments, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	

