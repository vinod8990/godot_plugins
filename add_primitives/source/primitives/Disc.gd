extends "../Primitive.gd"

var outer_radius = 1.0
var inner_radius = 0.5
var segments = 16
var slice_from = 0
var slice_to = 0

static func get_name():
	return "Disc"
	
static func get_container():
	return "Extra Objects"
	
func update():
	var slice_angle = Utils.TWO_PI - deg2rad(slice_to)
	
	var circle = Utils.build_circle(Vector3(), segments, 1, deg2rad(slice_from), slice_angle)
	var uv = Utils.ellipse_uv(Vector2(), segments, Vector2(1, 1), slice_angle)
	
	begin()
	
	add_smooth_group(smooth)
	
	for i in range(segments):
		add_quad([circle[i] * inner_radius, circle[i] * outer_radius,
		          circle[i + 1] * outer_radius, circle[i + 1] * inner_radius],\
		         [uv[i] * inner_radius, uv[i] * outer_radius,
		          uv[i + 1] * outer_radius, uv[i + 1] * inner_radius])
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('outer_radius', outer_radius)
	editor.add_numeric_parameter('inner_radius', inner_radius)
	editor.add_numeric_parameter('segments', segments, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	

