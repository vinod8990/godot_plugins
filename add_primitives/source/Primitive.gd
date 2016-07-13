#==============================================================================#
# Copyright (c) 2015 Franklin Sobrinho.                                        #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining        #
# a copy of this software and associated documentation files (the "Software"), #
# to deal in the Software without restriction, including without               #
# limitation the rights to use, copy, modify, merge, publish,                  #
# distribute, sublicense, and/or sell copies of the Software, and to           #
# permit persons to whom the Software is furnished to do so, subject to        #
# the following conditions:                                                    #
#                                                                              #
# The above copyright notice and this permission notice shall be               #
# included in all copies or substantial portions of the Software.              #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,              #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF           #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.       #
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY         #
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,         #
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE            #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                       #
#==============================================================================#

extends SurfaceTool

const Utils = preload('Utils.gd')

var smooth = false
var flip_normals = false

var mesh = Mesh.new()

static func get_name():
	return ""
	
static func get_container():
	return ""
	
func get_mesh():
	return mesh
	
func begin():
	.begin(Mesh.PRIMITIVE_TRIANGLES)
	
func add_tri(verts, uv = []):
	if flip_normals:
		verts.invert()
		uv.invert()
		
	if uv.size():
		add_uv(uv[0])
		add_vertex(verts[0])
		add_uv(uv[1])
		add_vertex(verts[1])
		add_uv(uv[2])
		add_vertex(verts[2])
		
	else:
		add_vertex(verts[0])
		add_vertex(verts[1])
		add_vertex(verts[2])
		
func add_quad(verts, uv = []):
	if flip_normals:
		verts.invert()
		uv.invert()
		
	if uv.size():
		add_uv(uv[0])
		add_vertex(verts[0])
		add_uv(uv[1])
		add_vertex(verts[1])
		add_uv(uv[2])
		add_vertex(verts[2])
		add_vertex(verts[2])
		add_uv(uv[3])
		add_vertex(verts[3])
		add_uv(uv[0])
		add_vertex(verts[0])
		
	else:
		add_vertex(verts[0])
		add_vertex(verts[1])
		add_vertex(verts[2])
		add_vertex(verts[2])
		add_vertex(verts[3])
		add_vertex(verts[0])
		
func add_plane(dir1, dir2, offset = Vector3()):
	var verts = Utils.build_plane(dir1, dir2, offset)
	
	var width = verts[0].distance_to(verts[1])
	var height = verts[0].distance_to(verts[3])
	
	var uv = Utils.plane_uv(width, height)
	
	add_quad(verts, uv)
	
func update():
	pass
	
func commit():
	generate_normals()
	index()
	
	if mesh.get_surface_count():
		mesh.surface_remove(0)
		
	.commit(mesh)
	
	clear()
	
func _init():
	mesh.set_name(get_name().replace(' ', '_').to_lower())
	

