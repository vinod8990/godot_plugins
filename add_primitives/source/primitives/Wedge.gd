extends "../Primitive.gd"

var width = 1.0
var height = 1.0
var length = 2.0
var generate_bottom = true
var generate_end = true

static func get_name():
	return "Wedge"
	
func update():
	var slope_length = sqrt(pow(length, 2) + pow(height, 2))
	
	var ofs = -Vector3(width/2, height/2, length/2)
	
	var rd = Vector3(width, 0, 0)
	var fd = Vector3(0, 0, length)
	var ud = Vector3(0, height, 0)
	
	begin()
	
	add_smooth_group(smooth)
	
	if generate_bottom:
		add_plane(fd, rd, ofs)
		
	if generate_end:
		add_plane(rd, ud, ofs)
		
	ofs.y += height
	
	add_quad([ofs, ofs + rd, ofs + Vector3(width, -height, length), ofs + Vector3(0, -height, length)],\
	         Utils.plane_uv(width, slope_length))
	
	add_tri([ofs + Vector3(0, -height, length), ofs - ud, ofs],\
	        Utils.plane_uv(length, height, false))
	add_tri([ofs + rd, ofs + rd - ud, ofs + Vector3(width, -height, length)],\
	        Utils.plane_uv(height, length, false))
	
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('width', width)
	editor.add_numeric_parameter('height', height)
	editor.add_numeric_parameter('length', length)
	editor.add_empty()
	editor.add_bool_parameter('generate_bottom', generate_bottom)
	editor.add_bool_parameter('generate_end', generate_end)
	

