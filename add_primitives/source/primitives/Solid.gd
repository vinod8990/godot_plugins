extends "../Primitive.gd"

const Solid = {
	TETRAHEDRON = 0,
	HEXAHEDRON = 1,
	OCTAHEDRON = 2,
	DODECAHEDRON = 3,
	ICOSAHEDRON = 4
}

var solid = Solid.OCTAHEDRON
var radius = 1.0
var subdivisions = 0

static func get_name():
	return "Solid"
	
static func get_middle_point(i1, i2, verts, radius):
	var idx = verts.size()
	var middle = (verts[i1] + verts[i2])/2
	
	verts.push_back(middle.normalized() * radius)
	
	return idx
	
static func create_solid(solid, radius, verts):
	if solid == Solid.TETRAHEDRON:
		verts.resize(4)
		
		verts[0] = Vector3(1, 1, 1).normalized() * radius
		verts[1] = Vector3(-1, -1, 1).normalized() * radius
		verts[2] = Vector3(-1, 1, -1).normalized() * radius
		verts[3] = Vector3(1, -1, -1).normalized() * radius
		
		
		var faces = [
		    0, 1, 2,
		    2, 3, 0,
		    0, 3, 1,
		    1, 3, 2
		]
		
		return faces
		
	elif solid == Solid.HEXAHEDRON:
		var s = 1.0/sqrt(3) * radius
		
		verts.resize(8)
		
		verts[0] = Vector3(-s, -s, -s)
		verts[1] = Vector3(s, -s, -s)
		verts[2] = Vector3(s, s, -s)
		verts[3] = Vector3(-s, s, -s)
		verts[4] = Vector3(-s, -s, s)
		verts[5] = Vector3(s, -s, s)
		verts[6] = Vector3(s, s, s)
		verts[7] = Vector3(-s, s, s)
		
		var faces = [
		    2, 3, 0,
		    0, 1, 2,
		    5, 1, 0,
		    0, 4, 5,
		    7, 4, 0,
		    0, 3, 7,
		    1, 5, 6,
		    6, 2, 1,
		    3, 2, 6,
		    6, 7, 3,
		    4, 7, 6,
		    6, 5, 4
		]
		
		return faces
		
	elif solid == Solid.OCTAHEDRON:
		verts.resize(6)
		
		verts[0] = Vector3(0, -radius, 0)
		verts[1] = Vector3(radius, 0, 0)
		verts[2] = Vector3(0, 0, radius)
		verts[3] = Vector3(-radius, 0, 0)
		verts[4] = Vector3(0, 0, -radius)
		verts[5] = Vector3(0, radius, 0)
		
		var faces = [
		    2, 1, 0,
		    3, 2, 0,
		    4, 3, 0,
		    1, 4, 0,
		    1, 2, 5,
		    2, 3, 5,
		    3, 4, 5,
		    4, 1, 5
		]
		
		return faces
		
	elif solid == Solid.DODECAHEDRON:
		var t = (1.0 + sqrt(5))/2
		var r = 1/t
		
		verts.resize(20)
		
		verts[0] = Vector3(-1, -1, -1).normalized() * radius
		verts[1] = Vector3(-1, -1, 1).normalized() * radius
		verts[2] = Vector3(-1, 1, -1).normalized() * radius
		verts[3] = Vector3(-1, 1, 1).normalized() * radius
		verts[4] = Vector3(1, -1, -1).normalized() * radius
		verts[5] = Vector3(1, -1, 1).normalized() * radius
		verts[6] = Vector3(1, 1, -1).normalized() * radius
		verts[7] = Vector3(1, 1, 1).normalized() * radius
		verts[8] = Vector3(0, -r, -t).normalized() * radius
		verts[9] = Vector3(0, -r, t).normalized() * radius
		verts[10] = Vector3(0, r, -t).normalized() * radius
		verts[11] = Vector3(0, r, t).normalized() * radius
		verts[12] = Vector3(-r, -t, 0).normalized() * radius
		verts[13] = Vector3(-r, t, 0).normalized() * radius
		verts[14] = Vector3(r, -t, 0).normalized() * radius
		verts[15] = Vector3(r, t, 0).normalized() * radius
		verts[16] = Vector3(-t, 0, -r).normalized() * radius
		verts[17] = Vector3(t, 0, -r).normalized() * radius
		verts[18] = Vector3(-t, 0, r).normalized() * radius
		verts[19] = Vector3(t, 0, r).normalized() * radius
		
		var faces = [
		    7, 11, 3,
		    15, 7, 3,
		    13, 15, 3,
		    17, 19, 7,
		    6, 17, 7,
		    15, 6, 7,
		    8, 4, 17,
		    10, 8, 17,
		    6, 10, 17,
		    16, 0, 8,
		    2, 16, 8,
		    10, 2, 8,
		    1, 12, 0,
		    18, 1, 0,
		    16, 18, 0,
		    2, 10, 6,
		    13, 2, 6,
		    15, 13, 6,
		    18, 16, 2,
		    3, 18, 2,
		    13, 3, 2,
		    9, 1, 18,
		    11, 9, 18,
		    3, 11, 18,
		    12, 14, 4,
		    0, 12, 4,
		    8, 0, 4,
		    5, 9, 11,
		    19, 5, 11,
		    7, 19, 11,
		    14, 5, 19,
		    4, 14, 19,
		    17, 4, 19,
		    14, 12, 1,
		    5, 14, 1,
		    9, 5, 1
		]
		
		return faces
		
	elif solid == Solid.ICOSAHEDRON:
		var t = (1.0 + sqrt(5))/2
		
		verts.resize(12)
		
		verts[0] = Vector3(-1, t, 0).normalized() * radius
		verts[1] = Vector3( 1, t, 0).normalized() * radius
		verts[2] = Vector3(-1, -t, 0).normalized() * radius
		verts[3] = Vector3( 1, -t, 0).normalized() * radius
		verts[4] = Vector3( 0, -1, t).normalized() * radius
		verts[5] = Vector3( 0, 1, t).normalized() * radius
		verts[6] = Vector3( 0, -1, -t).normalized() * radius
		verts[7] = Vector3( 0, 1, -t).normalized() * radius
		verts[8] = Vector3( t, 0, -1).normalized() * radius
		verts[9] = Vector3( t, 0, 1).normalized() * radius
		verts[10] = Vector3(-t, 0, -1).normalized() * radius
		verts[11] = Vector3(-t, 0, 1).normalized() * radius
		
		var faces = [
		    5, 11, 0,
		    1, 5, 0,
		    7, 1, 0,
		    10, 7, 0,
		    11, 10, 0,
		    9, 5, 1,
		    4, 11, 5,
		    2, 10, 11,
		    6, 7, 10,
		    8, 1, 7,
		    4, 9, 3,
		    2, 4, 3,
		    6, 2, 3,
		    8, 6, 3,
		    9, 8, 3,
		    5, 9, 4,
		    11, 4, 2,
		    10, 2, 6,
		    7, 6, 8,
		    1, 8, 9
		]
		
		return faces
		
func update():
	var verts = []
	var faces = create_solid(solid, radius, verts)
	
	begin()
	
	add_smooth_group(smooth)
	
	for i in range(subdivisions):
		var last = (i == subdivisions - 1)
		
		var new_faces = []
		
		for idx in range(0, faces.size(), 3):
			var a = get_middle_point(faces[idx], faces[idx + 1], verts, radius)
			var b = get_middle_point(faces[idx + 1], faces[idx + 2], verts, radius)
			var c = get_middle_point(faces[idx + 2], faces[idx], verts, radius)
			
			if last:
				add_tri([verts[faces[idx]], verts[a], verts[c]])
				add_tri([verts[faces[idx + 1]], verts[b], verts[a]])
				add_tri([verts[faces[idx + 2]], verts[c], verts[b]])
				add_tri([verts[a], verts[b], verts[c]])
				
				continue
				
			new_faces.push_back(faces[idx])
			new_faces.push_back(a)
			new_faces.push_back(c)
			
			new_faces.push_back(faces[idx + 1])
			new_faces.push_back(b)
			new_faces.push_back(a)
			
			new_faces.push_back(faces[idx + 2])
			new_faces.push_back(c)
			new_faces.push_back(b)
			
			new_faces.push_back(a)
			new_faces.push_back(b)
			new_faces.push_back(c)
			
		if not last:
			faces = new_faces
			
	if subdivisions == 0:
		for i in range(0, faces.size(), 3):
			add_tri([verts[faces[i]], verts[faces[i + 1]], verts[faces[i + 2]]])
			
	commit()
	
func mesh_parameters(editor):
	editor.add_enum_parameter('solid', solid, 'Tetrahedron,Hexahedron,Octahedron,Dodecahedron,Icosahedron')
	editor.add_numeric_parameter('radius', radius)
	editor.add_numeric_parameter('subdivisions', subdivisions, 0, 4, 1)
	

