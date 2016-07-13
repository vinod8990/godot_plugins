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

extends Reference

const TWO_PI = PI * 2

static func build_plane(dir1, dir2, offset = Vector3()):
	var plane = []
	plane.resize(4)
	
	plane[0] = offset
	plane[1] = offset + dir1
	plane[2] = offset + dir1 + dir2
	plane[3] = offset + dir2
	
	return plane
	
static func build_circle(pos, segments, radius = 1, start = 0, angle = TWO_PI):
	var circle = []
	circle.resize(segments + 1)
	
	var s_angle = angle/segments
	
	for i in range(segments):
		var a = (s_angle * i) + start
		
		circle[i] = Vector3(cos(a), 0, sin(a)) * radius + pos
		
	if angle != TWO_PI:
		angle += start
		
		circle[segments] = Vector3(cos(angle), 0, sin(angle)) * radius + pos
		
	else:
		circle[segments] = circle[0]
		
	return circle
	
static func build_ellipse(pos, segments, radius = Vector2(1, 1), start = 0, angle = TWO_PI):
	var ellipse = []
	ellipse.resize(segments + 1)
	
	var s_angle = angle/segments
	
	for i in range(segments):
		var a = (s_angle * i) + start
		
		ellipse[i] = Vector3(sin(a) * radius.x, 0, cos(a) * radius.y) + pos
		
	if angle != TWO_PI:
		angle += start
		
		ellipse[segments] = Vector3(sin(angle) * radius.x, 0, cos(angle) * radius.y) + pos
		
	else:
		ellipse[segments] = ellipse[0]
		
	return ellipse
	
static func ellipse_uv(pos, segments, radius = Vector2(1, 1), angle = TWO_PI):
	var ellipse = []
	ellipse.resize(segments + 1)
	
	var s_angle = angle/segments
	
	for i in range(segments):
		var a = s_angle * i
		
		ellipse[i] = Vector2(sin(a) * radius.x, cos(a) * radius.y) + pos
		
	if angle != TWO_PI:
		ellipse[segments] = Vector2(sin(angle) * radius.x, cos(angle) * radius.y) + pos
		
	else:
		ellipse[segments] = ellipse[0]
		
	return ellipse
	
static func plane_uv(width, height, last = true):
	var uv = []
	uv.resize(4)
	
	uv[0] = Vector2()
	uv[1] = Vector2(width, 0)
	uv[2] = Vector2(width, height)
	uv[3] = Vector2(0, height)
	
	if not last:
		uv.remove(3)
		
	return uv
	

