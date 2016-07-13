extends "../Primitive.gd"

var segments = 16
var section_segments = 8
var radius = 1.0
var section_radius = 0.2
var p = 2
var q = 3

static func get_name():
	return "Torus Knot"
	
static func get_container():
	return "Extra Objects"
	
static func compute_vector(dir):
	var z = dir.normalized()
	var x = Vector3(0, 1, 0).cross(z).normalized()
	var y = z.cross(x).normalized()
	
	var m3 = Matrix3(x, y, z)
	
	return m3
	
func update():
	var segs = segments * p
	
	var v = []
	v.resize(segs * section_segments)
	
	var index = 0
	
	begin()
	
	add_smooth_group(smooth)
	
	for i in range(segs):
		var phi = float(i)/segments * Utils.TWO_PI
		
		var x = (2 + cos(q * phi/p)) * cos(phi)/3
		var y = sin(q * phi/p)/3
		var z = (2 + cos(q * phi/p)) * sin(phi)/3
		
		var v1 = Vector3(x, y, z)
		
		phi = float(i + 1)/segments * Utils.TWO_PI
		
		x = (2 + cos(q * phi/p)) * cos(phi)/3
		y = sin(q * phi/p)/3
		z = (2 + cos(q * phi/p)) * sin(phi)/3
		
		var v2 = Vector3(x, y, z)
		
		var dir = (v2 - v1).normalized()
		
		var m3 = compute_vector(dir)
		
		for j in range(section_segments):
			var alpha = float(j)/section_segments * Utils.TWO_PI
			var vp = section_radius * m3.xform(Vector3(cos(alpha), sin(alpha), 0))
			
			v[index] = (v1 * radius) + vp
			
			if i != segs and i > 0 and j > 0:
				var idx = index - 1
				
				add_quad([v[idx], v[idx + 1], v[idx - section_segments + 1], v[idx - section_segments]])
				
			index += 1
			
		if i:
			var idx = index - 1
			
			add_quad([v[idx], v[idx - section_segments + 1],\
			          v[idx - (section_segments * 2) + 1], v[idx - section_segments]])
			
	var b = v.size() - section_segments
	
	for i in range(section_segments - 1):
		var j = b + i
		
		add_quad([v[i], v[i + 1], v[j + 1], v[j]])
		
	add_quad([v[b], v[b + section_segments - 1], v[section_segments - 1], v[0]])
	
	commit()
	
func mesh_parameters(editor):
	editor.add_numeric_parameter('segments', segments, 3, 64, 1)
	editor.add_numeric_parameter('section_segments', section_segments, 3, 64, 1)
	editor.add_numeric_parameter('radius', radius)
	editor.add_numeric_parameter('section_radius', section_radius)
	editor.add_numeric_parameter('p', p, 1, 8, 1)
	editor.add_numeric_parameter('q', q, 1, 8, 1)
	
