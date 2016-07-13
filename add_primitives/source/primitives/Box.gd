extends "../Primitive.gd"

var width = 2.0
var length = 2.0
var height = 2.0
var right_face = true
var left_face = true
var top_face = true
var bottom_face = true
var front_face = true
var back_face = true

static func get_name():
	return "Box"
	
func update():
	var fd = Vector3(width, 0, 0)
	var rd = Vector3(0, 0, length)
	var ud = Vector3(0, height, 0)
	
	var ofs = Vector3(width/2, height/2, length/2)
	
	begin()
	
	add_smooth_group(smooth)
	
	if right_face:
		add_plane(-rd, -ud, ofs)
		
	if left_face:
		add_plane(ud, rd, -ofs)
		
	if top_face:
		add_plane(-fd, -rd, ofs)
		
	if bottom_face:
		add_plane(rd, fd, -ofs)
		
	if front_face:
		add_plane(-ud, -fd, ofs)
		
	if back_face:
		add_plane(fd, ud, -ofs)
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('width', width)
	editor.add_numeric_parameter('length', length)
	editor.add_numeric_parameter('height', height)
	editor.add_empty()
	editor.add_bool_parameter('right_face', right_face)
	editor.add_bool_parameter('left_face', left_face)
	editor.add_bool_parameter('top_face', top_face)
	editor.add_bool_parameter('bottom_face', bottom_face)
	editor.add_bool_parameter('front_face', front_face)
	editor.add_bool_parameter('back_face', back_face)
	

