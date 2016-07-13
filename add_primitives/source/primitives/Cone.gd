extends "../Primitive.gd"

var top_radius = 0.0
var bottom_radius = 1.0
var height = 2.0
var sides = 16
var slice_from = 0
var slice_to = 0
var generate_top = true
var generate_bottom = true
var generate_ends = true

static func get_name():
	return "Cone"
	
func update():
	var slice_angle = Utils.TWO_PI - deg2rad(slice_to)
	var circumference = (slice_angle * PI * max(bottom_radius, top_radius))/PI
	
	var top = Vector3(0, height/2, 0)
	var bottom = Vector3(0, -height/2, 0)
	var center_uv = Vector2(0.5, 0.5)
	
	var bc = Utils.build_circle(bottom, sides, bottom_radius, deg2rad(slice_from), slice_angle)
	var tc = null
	
	var b_uv = Utils.ellipse_uv(center_uv, sides, Vector2(bottom_radius, bottom_radius), slice_angle)
	var t_uv = null
	
	begin()
	
	add_smooth_group(smooth)
	
	if top_radius > 0:
		tc = Utils.build_circle(top, sides, top_radius, deg2rad(slice_from), slice_angle)
		t_uv = Utils.ellipse_uv(center_uv, sides, Vector2(top_radius, top_radius), slice_angle)
		
		for i in range(sides):
			var u1 = float(i)/sides * circumference
			var u2 = float(i + 1)/sides * circumference
			
			add_quad([tc[i], bc[i], bc[i + 1], tc[i + 1]],\
			         [Vector2(u1, height), Vector2(u1, 0), Vector2(u2, 0), Vector2(u2, height)])
			
	else:
		for i in range(sides):
			add_tri([top, bc[i], bc[i + 1]], [center_uv, b_uv[i], b_uv[i + 1]])
			
	add_smooth_group(false)
	
	if generate_ends and slice_to > 0:
		if top_radius > 0:
			var quad_uv = [Vector2(top_radius, 0), Vector2(), Vector2(0, height), Vector2(bottom_radius, height)]
			
			add_quad([tc[0], top, bottom, bc[0]], quad_uv)
			
			if not flip_normals:
				quad_uv.invert()
				
			add_quad([bc[sides], bottom, top, tc[sides]], quad_uv)
			
		else:
			var tri_uv = [Vector2(bottom_radius, height), Vector2(), Vector2(0, height)]
			
			add_tri([bc[0], top, bottom], tri_uv)
			
			if not flip_normals:
				tri_uv.invert()
				
			add_tri([bottom, top, bc[sides]], tri_uv)
			
	var gen_top = generate_top and top_radius > 0
	
	if generate_bottom or gen_top:
		for i in range(sides):
			if gen_top:
				add_tri([top, tc[i], tc[i + 1]], [center_uv, t_uv[i], t_uv[i + 1]])
				
			if generate_bottom:
				add_tri([bottom, bc[i + 1], bc[i]], [center_uv, b_uv[i + 1], b_uv[i]])
				
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('top_radius', top_radius, 0)
	editor.add_numeric_parameter('bottom_radius', bottom_radius)
	editor.add_numeric_parameter('height', height)
	editor.add_numeric_parameter('sides', sides, 3, 64, 1)
	editor.add_numeric_parameter('slice_from', slice_from, 0, 360, 1)
	editor.add_numeric_parameter('slice_to', slice_to, 0, 359, 1)
	editor.add_empty()
	editor.add_bool_parameter('generate_top', generate_top)
	editor.add_bool_parameter('generate_bottom', generate_bottom)
	editor.add_bool_parameter('generate_ends', generate_ends)

