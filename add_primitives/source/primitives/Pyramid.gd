extends "../Primitive.gd"

var width = 2.0
var length = 2.0
var height = 2.0

static func get_name():
	return "Pyramid"
	
static func get_container():
	return "Extra Objects"
	
func update():
	var hw = sqrt(pow(width/2, 2) + pow(height/2, 2))
	var hl = sqrt(pow(length/2, 2) + pow(height/2, 2))
	
	var ofs = Vector3(width/2, height/2, length/2)
	
	var top = Vector3(0, height/2, 0)
	var base = Utils.build_plane(Vector3(0, 0, length), Vector3(width, 0, 0), -ofs)
	
	var uv = [Vector2(0, hw), Vector2(length/2, 0), Vector2(length, hw)]
	
	begin()
	
	add_smooth_group(smooth)
	
	add_plane(Vector3(0, 0, length), Vector3(width, 0, 0), -ofs)
	
	add_tri([base[0], top, base[1]], uv)
	add_tri([base[2], top, base[3]], uv)
	
	uv[0].y = hl
	uv[1].x = width/2
	uv[2] = Vector2(width, hl)
	
	add_tri([base[1], top, base[2]], uv)
	add_tri([base[3], top, base[0]], uv)
	
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('width', width)
	editor.add_numeric_parameter('length', length)
	editor.add_numeric_parameter('height', height)
	

