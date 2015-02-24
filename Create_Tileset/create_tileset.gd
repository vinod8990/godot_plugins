tool
extends EditorPlugin

var plugin_button = null
var dialog = null
var imagepath = null
var ts = null

func _init():
	pass

func get_name():
	return "Create Tileset"

func _enter_tree():
	plugin_button = Button.new()
	plugin_button.set_text("Create Tileset")
	
	plugin_button.connect("pressed",self,"_show_dialog")
	add_custom_control(CONTAINER_CANVAS_EDITOR_MENU, plugin_button)
	
	dialog = preload("create_tileset_dialog.xml").instance();
	dialog.add_cancel("Cancel")
	dialog.get_ok().set_custom_minimum_size(Vector2(50,20))
	pass

func _on_file_selected(path):
	imagepath = path
	
func _show_dialog():
	if dialog.get_parent() == null:
		add_child(dialog)
	dialog.show()
	dialog.popup_centered()
	if not dialog.is_connected("confirmed",self,"_on_dialog_confirm"):
		dialog.connect("confirmed",self,"_on_dialog_confirm")
	if not dialog.is_connected("on_file_selected",self,"_on_file_selected"):
		dialog.connect("on_file_selected",self,"_on_file_selected")

func _on_dialog_confirm():
	ts = dialog.getTileSize()
	var root =  get_tree().get_edited_scene_root()
	var image  = ImageTexture.new()
	image.load(imagepath)
	
	var pp = imagepath
	var lpos = pp.find_last("/")
	pp = pp.substr(0,lpos)
	var dir = pp
	var json = imagepath.substr(0,imagepath.find("."))+".json"
	
	var f = File.new()
	if not f.file_exists(json):
		gridBreak(root,image)
	else:
		f.open(json,File.READ)
		parseJson(root,image,f.get_as_text())
		f.close()
	
	
	dialog.disconnect("confirmed",self,"_on_dialog_confirm")
	dialog.disconnect("on_file_selected",self,"_on_file_selected")
	pass

func parseJson(root,image,data):
	var frames = {}
	frames.parse_json(data)
	for imagename in frames.frames:
		var frame = frames.frames[imagename]["frame"]
		var s = Sprite.new()
		s.set_texture(image)
		s.set_region(true)
		s.set_region_rect(Rect2(frame.x,frame.y,frame.w,frame.h))
		root.add_child(s)
		var pos = Vector2(frame.x,frame.y)
		s.set_pos(pos)
		s.set_owner(root)
		s.set_name(imagename)
	
func gridBreak(root,image):
	var r=0
	var i=0
	while i<image.get_width():
		var j=0
		r+=1
		var c=0
		while j<image.get_height():
			if not checkRegionEmpty(image.get_data(),i,j,ts.x,ts.y):
				var s = Sprite.new()
				s.set_texture(image)
				s.set_region(true)
				s.set_region_rect(Rect2(i,j,ts.x,ts.y))
				root.add_child(s)
				var pos = Vector2(r*(ts.x+10),c*(ts.y+10))
				c+=1
				s.set_pos(pos)
				s.set_owner(root)
			j+=ts.y
		i+=ts.x
	
func checkRegionEmpty(image,x,y,w,h):
	for i in range(x,x+w):
		for j in range(y,y+h):
			if not image.get_pixel(i,j).a==0:
				return false
	return true

	
func _exit_tree():
	plugin_button.disconnect("pressed",self,"_show_dialog")
	plugin_button.free()
	dialog.disconnect("confirmed",self,"_on_dialog_confirm")
	dialog.disconnect("on_file_selected",self,"_on_file_selected")
	dialog.dispose()
	dialog.queue_free()
	plugin_button  = null
	dialog = null
	pass
