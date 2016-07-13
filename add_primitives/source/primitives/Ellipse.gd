extends "../Primitive.gd"

var width = 1.0
var length = 1.0
var segments = 16
var slice_from = 0
var slice_to = 0

static func get_name():
	return "Ellipse"
	
static func get_container():
	return "Extra Objects"
	
func update():
	var slice_angle = Utils.TWO_PI - deg2rad(slice_to)
	
	var center = Vector3()
	var center_uv = Vector2(0.5, 0.5)
	
	var ellipse = Utils.build_ellipse(center, segments, Vector2(width, length), deg2rad(slice_from), slice_angle)
	var uv = Utils.ellipse_uv(center_uv, segments, Vector2(width, length), slice_angle)
	
	begin()
	
	add_smooth_group(smooth)
	
	for i in range(segments):
		add_tri([center, ellipse[i + 1], ellipse[i]], [center_uv, uv[i + 1], uv[i]])
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('width', width)
	editor.add_numeric_parameter('length', length)
	editor.add_numeric_parameter('segments', segments, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	

