func cross(o, a, b):
     return (a[0] - o[0])  (b[1] - o[1]) - (a[1] - o[1])  (b[0] - o[0])

func convex_hull(points):
 points = sorted(set(points))

 if len(points) <= 1:
     return points

 lower = []
 for p in points:
     while len(lower) >= 2 and cross(lower[-2], lower[-1], p) <= 0:
         lower.pop()
     lower.append(p)
 
 # Build upper hull
 upper = []
 for p in reversed(points):
     while len(upper) >= 2 and cross(upper[-2], upper[-1], p) <= 0:
         upper.pop()
     upper.append(p)
 return lower[:-1] + upper[:-1] #this needs to be changed

assert convex_hull([(i//10, i%10) for i in range(100)]) == [(0, 0), (9, 0), (9, 9), (0, 9)]