tool # Always declare as Tool, if it's meant to run in the editor.
extends EditorPlugin

var toolbar_button = null
var main_popup = null
var config_file = null
var res_data = null
var path = null


func get_name(): 
	return "Resolution Switcher"


func _init():
	pass
	

func _enter_tree():	
	toolbar_button = MenuButton.new()
	toolbar_button.set_text("Switch Resolution")
	main_popup = toolbar_button.get_popup()
	
	reload()
	
	add_custom_control(CONTAINER_CANVAS_EDITOR_MENU,toolbar_button)
	main_popup.connect("item_pressed",self,"switched")

	
func reload():
	path = OS.get_data_dir()
	var lpos = path.find_last("/")
	path = path.substr(0,lpos)
	lpos = path.find_last("/")
	path = path.substr(0,lpos) + "/plugins/Resolution Switcher/list.txt"
	
	config_file = ConfigFile.new()
	config_file.load(path)
	
	res_data = {}
	main_popup.clear()
	for section in config_file.get_sections():
		for label in config_file.get_section_keys(section):
			var wh = config_file.get_value(section,label).split("x")
			var w = wh.get(0)
			var h = wh.get(1)
			var t = label + "    (" + w + "x" + h +")"
			res_data[t] = {"label":label,"width":w,"height":h}
			main_popup.add_item(t)
		main_popup.add_separator()
		
	main_popup.add_item("Add Custom Size")
	

func switched(id):
	var key = main_popup.get_item_text(main_popup.get_item_index(id))
			
	if key == "Add Custom Size":
		var c = preload("custom_res_popup.xml").instance()
		add_child(c)
		c.set_pos(Vector2(get_tree().get_root().get_rect().size.x/2 - c.get_size().x/2,get_tree().get_root().get_rect().size.y/2 - c.get_size().y/2))
			
		var addButton = Button.new()
		addButton.set_text("Add Resolution")
		addButton.set_h_size_flags(Button.SIZE_EXPAND)
		addButton.set_custom_minimum_size(Vector2(150,25))
		addButton.connect("pressed",self,"_on_add_new",[c])
		c.get_node("vbox/hbox3").add_child(addButton)
	else:
		var w = res_data[key]["width"]
		var h = res_data[key]["height"]
		toolbar_button.set_text(key)
		Globals.set_persisting("display/test_width",true)
		Globals.set_persisting("display/test_height",true)
		Globals.set("display/test_width",w)
		Globals.set("display/test_height",h)
		Globals.save()

func _on_add_new(new_window):
	var category = new_window.get_node("vbox/hbox4/category").get_text()
	var label = new_window.get_node("vbox/hbox1/labelText").get_text()
	var width = new_window.get_node("vbox/hbox2/widthText").get_text()
	var height = new_window.get_node("vbox/hbox2/heightText").get_text()
	remove_child(new_window)
	if config_file.has_section(category):
		config_file.set_value(category,label,width+"x"+height)
		config_file.save(path)
		reload()

func _exit_tree():
	main_popup.clear()
	main_popup = null
	res_data.clear()
	toolbar_button.free()
	toolbar_button=null
	config_file = null