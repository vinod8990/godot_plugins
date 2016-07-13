extends "../Primitive.gd"

var height = 2.0
var inner_radius = 0.5
var thickness = 0.5
var sides = 16
var slice_from = 0
var slice_to = 0
var generate_top = true
var generate_bottom = true
var generate_ends = true

static func get_name():
	return "Tube"
	
func update():
	var slice_angle = Utils.TWO_PI - deg2rad(slice_to)
	
	var ofs = Vector3(0, height, 0)
	
	var ic = Utils.build_circle(ofs/2, sides, inner_radius, deg2rad(slice_from), slice_angle)
	var oc = Utils.build_circle(ofs/2, sides, inner_radius + thickness, deg2rad(slice_from), slice_angle)
	
	begin()
	
	add_smooth_group(false)
	
	if generate_top or generate_bottom:
		for idx in range(sides):
			if generate_top:
				add_quad([oc[idx + 1], ic[idx + 1], ic[idx], oc[idx]])
				
			if generate_bottom:
				add_quad([oc[idx] - ofs, ic[idx] - ofs, ic[idx + 1] - ofs, oc[idx + 1] - ofs])
				
	if generate_ends and slice_to > 0:
		add_quad([oc[0], ic[0], ic[0] - ofs, oc[0] - ofs])
		add_quad([ic[sides], oc[sides], oc[sides] - ofs, ic[sides] - ofs])
		
	add_smooth_group(smooth)
	
	for idx in range(sides):
		add_quad([oc[idx + 1], oc[idx], oc[idx] - ofs, oc[idx + 1] - ofs])
		add_quad([ic[idx], ic[idx + 1], ic[idx + 1] - ofs, ic[idx] - ofs])
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('height', height)
	editor.add_numeric_parameter('inner_radius', inner_radius)
	editor.add_numeric_parameter('thickness', thickness)
	editor.add_numeric_parameter('sides', sides, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	editor.add_empty()
	editor.add_bool_parameter('generate_top', generate_top)
	editor.add_bool_parameter('generate_bottom', generate_bottom)
	editor.add_bool_parameter('generate_ends', generate_ends)
	

