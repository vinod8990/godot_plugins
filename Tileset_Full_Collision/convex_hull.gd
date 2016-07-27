func cross(o, a, b):
	return (a.x  - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)

func convex_hull(points):
	points = sorted(unique(points))
	
	if points.size() <= 1:
		return points
	
	var lower = []
	for p in points:
		while lower.size() >= 2 and cross(lower[lower.size() - 2], lower[lower.size() - 1], p) <= 0:
			lower.pop_back()
		lower.append(p)
	
	# Build upper hull
	var upper = []
	for p in reversed(points):
		while upper.size() >= 2 and cross(upper[upper.size() - 2], upper[upper.size() - 1], p) <= 0:
			upper.pop_back()
		upper.append(p)
	
	lower.resize(lower.size() - 1)
	upper.resize(upper.size() - 1)
	
	return lower + upper

func reversed(points):
	var arr = []
	for point in points:
		arr.push_front(point)
	return arr

func compare(point1, point2):
	if point1.x != point2.x:
		return point1.x < point2.x
	return point1.y < point2.y

func sorted(points):
	points.sort_custom(self, "compare")
	return points

func unique(points):
	var arr = []
	for point in points:
		if arr.find(point) == -1:
			arr.append(point)
	return arr
