extends "../Primitive.gd"

var width = 1.0
var height = 2.0
var length = 2.0
var steps = 10
var generate_sides = true
var generate_bottom = true
var generate_end = true

static func get_name():
	return "Linear Stair"
	
static func get_container():
	return "Stair"
	
func update():
	var ofs_x = -width/2
	
	var height_inc = height/steps
	var length_inc = length/steps
	
	var pz = Vector2()
	var py = Vector2()
	
	var uv_w = Vector2(0, width)
	var uv_l = Vector2(length_inc, 0)
	var uv_h = Vector2(height_inc, 0)
	
	var d = [
	    Vector3(width, 0, 0),
	    Vector3(0, 0, length_inc),
	    Vector3(0, height_inc, 0)
	]
	
	begin()
	
	add_smooth_group(smooth)
	
	for i in range(steps):
		var sh = height_inc * i
		var sl = length_inc * i
		var bh = sh + height_inc
		
		add_quad(Utils.build_plane(d[0], d[1], Vector3(ofs_x, bh, sl)),\
		         [py, py + uv_w, py + uv_w + uv_l, py + uv_l])
		add_quad(Utils.build_plane(d[0], d[2], Vector3(ofs_x, sh, sl)),\
		         [pz, pz + uv_w, pz + uv_w + uv_h, pz + uv_h])
		
		if generate_sides:
			var ch = Vector2(0, bh)
			
			add_quad(Utils.build_plane(Vector3(0, bh, 0), d[1], Vector3(ofs_x, 0, sl)),\
			         [py, py + ch, py + uv_l + ch, py + uv_l])
			add_quad(Utils.build_plane(d[1], Vector3(0, bh, 0), Vector3(-ofs_x, 0, sl)),\
			         [py, py + uv_l, py + uv_l + ch, py + ch])
			
		py.x += length_inc
		pz.x += height_inc
		
	if generate_end:
		add_plane(Vector3(0, height, 0), d[0], Vector3(ofs_x, 0, length))
		
	if generate_bottom:
		add_plane(Vector3(0, 0, length), d[0], Vector3(ofs_x, 0, 0))
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('width', width)
	editor.add_numeric_parameter('height', height)
	editor.add_numeric_parameter('length', length)
	editor.add_numeric_parameter('steps', steps, 2, 64, 1)
	editor.add_empty()
	editor.add_bool_parameter('generate_sides', generate_sides)
	editor.add_bool_parameter('generate_bottom', generate_bottom)
	editor.add_bool_parameter('generate_end', generate_end)
	

