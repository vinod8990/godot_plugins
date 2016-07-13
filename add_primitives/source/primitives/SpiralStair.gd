extends "../Primitive.gd"

var spirals = 1
var counter_clockwise = false
var spiral_height = 2.0
var steps_per_spiral = 8
var inner_radius = 1.0
var step_width = 1.0
var extra_step_height = 0.0

static func get_name():
	return "Spiral Stair"
	
static func get_container():
	return "Stair"
	
func update():
	var angle = Utils.TWO_PI
	
	var inner = inner_radius
	var outer = inner + step_width
	
	if counter_clockwise:
		angle = -angle
		
		var temp = inner
		inner = outer
		outer = temp
		
	var ic = Utils.build_circle(Vector3(), steps_per_spiral, inner, 0, angle)
	var oc = Utils.build_circle(Vector3(), steps_per_spiral, outer, 0, angle)
	
	var height_inc = spiral_height/steps_per_spiral
	
	begin()
	
	add_smooth_group(smooth)
	
	for sp in range(spirals):
		var ofs_y = spiral_height * sp
		
		for i in range(steps_per_spiral):
			var h = Vector3(0, i * height_inc + ofs_y, 0)
			var sh = Vector3(0, h.y + height_inc + extra_step_height, 0)
			
			var uv = [
			    Vector2(ic[i + 1].x, ic[i + 1].z),
			    Vector2(oc[i + 1].x, oc[i + 1].z),
			    Vector2(oc[i].x, oc[i].z),
			    Vector2(ic[i].x, ic[i].z)
			]
			
			add_quad([ic[i + 1] + h, oc[i + 1] + h, oc[i] + h, ic[i] + h], uv)
			
			if not flip_normals:
				uv.invert()
				
			add_quad([ic[i] + sh, oc[i] + sh, oc[i + 1] + sh, ic[i + 1] + sh], uv)
			
			var sides = [ic[i], oc[i], oc[i + 1], ic[i + 1], ic[i]]
			
			var t = Vector2(0, h.y)
			var b = Vector2(0, sh.y)
			
			for i in range(sides.size() - 1):
				var w = Vector2(sides[i].distance_to(sides[i + 1]), 0)
				
				add_quad([sides[i] + sh, sides[i] + h, sides[i + 1] + h, sides[i + 1] + sh],\
				         [t, b, b + w, t + w])
				
				t.x += w.x
				b.x += w.x
				
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('spirals', spirals, 1, 64, 1)
	editor.add_bool_parameter('counter_clockwise', counter_clockwise)
	editor.add_numeric_parameter('spiral_height', spiral_height)
	editor.add_numeric_parameter('steps_per_spiral', steps_per_spiral, 3, 64, 1)
	editor.add_numeric_parameter('inner_radius', inner_radius)
	editor.add_numeric_parameter('step_width', step_width)
	editor.add_numeric_parameter('extra_step_height', extra_step_height, -100, 100, 0.001)
	

