extends "../Primitive.gd"

var angle = 90
var counter_clockwise = false
var stair_height = 2.0
var steps = 8
var inner_radius = 1.0
var step_width = 1.0
var generate_sides = true
var generate_bottom = true
var generate_end = true

static func get_name():
	return "Curved Stair"
	
static func get_container():
	return "Stair"
	
func update():
	var radians = deg2rad(angle)
	
	var inner = inner_radius
	var outer = inner + step_width
	
	if counter_clockwise:
		radians = -radians
		
		var temp = inner
		inner = outer
		outer = temp
		
	var height_inc = stair_height/steps
	
	var uv_inner = radians * inner
	var uv_outer = radians * outer
	
	var ic = Utils.build_circle(Vector3(), steps, inner, 0, radians)
	var oc = Utils.build_circle(Vector3(), steps, outer, 0, radians)
	
	begin()
	
	add_smooth_group(smooth)
	
	var base = Vector3()
	
	for i in range(steps):
		var sh = Vector3(0, base.y + height_inc, 0)
		
		var uv = [
		    Vector2(ic[i].x, ic[i].z),
		    Vector2(oc[i].x, oc[i].z),
		    Vector2(oc[i + 1].x, oc[i + 1].z),
		    Vector2(ic[i + 1].x, ic[i + 1].z)
		]
		
		add_quad([ic[i] + sh, oc[i] + sh, oc[i + 1] + sh, ic[i + 1] + sh], uv)
		
		if generate_bottom:
			if not flip_normals:
				uv.invert()
				
			add_quad([ic[i + 1], oc[i + 1], oc[i], ic[i]], uv)
			
		uv[0] = Vector2(0, base.y)
		uv[1] = Vector2(0, sh.y)
		uv[2] = Vector2(step_width, sh.y)
		uv[3] = Vector2(step_width, base.y)
		
		add_quad([oc[i] + base, oc[i] + sh, ic[i] + sh, ic[i] + base], uv)
		
		if generate_sides:
			var u1 = float(i)/steps
			var u2 = float(i + 1)/steps
			
			uv[0] = Vector2(u1 * uv_outer, sh.y)
			uv[1] = Vector2(u1 * uv_outer, 0)
			uv[2] = Vector2(u2 * uv_outer, 0)
			uv[3] = Vector2(u2 * uv_outer, sh.y)
			
			add_quad([oc[i] + sh, oc[i], oc[i + 1], oc[i + 1] + sh], uv)
			
			uv[0] = Vector2(u2 * uv_inner, sh.y)
			uv[1] = Vector2(u2 * uv_inner, 0)
			uv[2] = Vector2(u1 * uv_inner, 0)
			uv[3] = Vector2(u1 * uv_inner, sh.y)
			
			add_quad([ic[i + 1] + sh, ic[i + 1], ic[i], ic[i] + sh], uv)
			
		base = sh
		
	if generate_end:
		var uv = [
		    Vector2(),
		    Vector2(0, stair_height),
		    Vector2(step_width, stair_height),
		    Vector2(step_width, 0)
		]
		
		add_quad([ic[steps], ic[steps] + base, oc[steps] + base, oc[steps]], uv)
		
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('angle', angle, 1, 360, 1)
	editor.add_bool_parameter('counter_clockwise', counter_clockwise)
	editor.add_numeric_parameter('stair_height', stair_height)
	editor.add_numeric_parameter('steps', steps, 3, 64, 1)
	editor.add_numeric_parameter('inner_radius', inner_radius)
	editor.add_numeric_parameter('step_width', step_width)
	editor.add_empty()
	editor.add_bool_parameter('generate_sides', generate_sides)
	editor.add_bool_parameter('generate_bottom', generate_bottom)
	editor.add_bool_parameter('generate_end', generate_end)
	

