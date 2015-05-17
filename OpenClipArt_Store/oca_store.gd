tool
extends EditorPlugin

var plugin_button = null
var store_window = null

func _init():
	pass

func get_name():
	return "Open Clip Art Store"

func _enter_tree():
	plugin_button = Button.new()
	plugin_button.set_text("OpenClipArt")
	plugin_button.connect("pressed",self,"_show_store")
	add_custom_control(CONTAINER_TOOLBAR, plugin_button)
	
	store_window = preload("oca_browser_window.xml").instance()
	

func _show_store():
	if store_window.get_parent() == null:
		add_child(store_window)
	store_window.show()
	store_window.popup_centered()
	store_window.initialize()

func _exit_tree():
	store_window.dispose()
	store_window.queue_free()
	store_window = null
	plugin_button.disconnect("pressed",self,"_show_store")
	plugin_button.free()
	plugin_button = null