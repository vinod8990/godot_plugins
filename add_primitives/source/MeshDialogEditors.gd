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

# Base class for ParameterEditor and ModifierEditor
class TreeEditor extends VBoxContainer:
	
	var _updating = false
	
	var current = null
	
	var tree
	var slider
	
	static func get_parameter_name(item):
		return item.get_text(0).replace(' ', '_').to_lower()
		
	static func get_parameter_value(item):
		var cell = item.get_cell_mode(1)
		
		if cell == TreeItem.CELL_MODE_CHECK:
			return item.is_checked(1)
			
		elif cell == TreeItem.CELL_MODE_STRING:
			return item.get_text(1)
			
		elif cell == TreeItem.CELL_MODE_RANGE:
			return item.get_range(1)
			
		elif cell == TreeItem.CELL_MODE_CUSTOM:
			return item.get_metadata(1)
			
	func reset_scrollbar():
		tree.find_node('VScrollBar', true, false).set_value(0)
		
	func add_empty():
		var item = tree.create_item(current)
		
		item.set_selectable(0, false)
		item.set_selectable(1, false)
		
	func add_numeric_parameter(text, value, min_ = 0.001, max_ = 100, step = 0.001):
		var item
		
		if typeof(value) == TYPE_REAL:
			item = _create_item(text, 'Real')
			
		else:
			item = _create_item(text, 'Integer')
			
		item.set_cell_mode(1, TreeItem.CELL_MODE_RANGE)
		item.set_range_config(1, min_, max_, step)
		item.set_range(1, value)
		
	func add_enum_parameter(text, selected, items):
		var item = _create_item(text, 'Enum')
		
		item.set_cell_mode(1, TreeItem.CELL_MODE_RANGE)
		item.set_text(1, items)
		item.set_range(1, selected)
		
	func add_bool_parameter(text, checked = false):
		var item = _create_item(text, 'Bool')
		
		item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
		item.set_checked(1, checked)
		item.set_text(1, 'On')
		
	func add_string_parameter(text, string = ''):
		var item = _create_item(text, 'String')
		
		item.set_cell_mode(1, TreeItem.CELL_MODE_STRING)
		item.set_text(1, string)
		
	func item_edited():
		if has_method('_item_edited'):
			_item_edited(tree.get_edited())
			
	func item_selected():
		if has_method('_item_selected'):
			_item_selected(tree.get_selected())
			
	func _create_item(text, type):
		var item = tree.create_item(current)
		
		item.set_text(0, text.capitalize())
		item.set_icon(0, get_icon(type, 'EditorIcons'))
		item.set_selectable(0, false)
		
		item.set_editable(1, true)
		
		return item
		
	func _slider_settings_changed(val, slider):
		if _updating:
			return
			
		_updating = true
		
		if slider.get_step() < 0.1:
			slider.set_step(0.1)
			
		_updating = false
		
	func _init():
		tree = Tree.new()
		
		tree.set_hide_root(true)
		tree.set_columns(2)
		tree.set_column_expand(0, true)
		tree.set_column_min_width(0, 30)
		tree.set_column_expand(1, true)
		tree.set_column_min_width(1, 15)
		
		tree.set_v_size_flags(SIZE_EXPAND_FILL)
		
		tree.connect("item_edited", self, "item_edited")
		tree.connect("cell_selected", self, "item_selected")
		
		var slider = tree.find_node('HSlider', true, false)
		slider.connect("changed", self, "_slider_settings_changed", [slider])
		
# End TreeEditor

class ModifierEditor extends TreeEditor:
	
	const Tool = {
		ERASE = 0,
		MOVE_UP = 1,
		MOVE_DOWN = 2
	}
	
	var modifiers
	
	var menu
	var remove
	var move_up
	var move_down
	
	var items = []
	
	signal modifier_edited
	
	static func get_signal():
		return "modifier_edited"
		
	func get_modifiers():
		return items
		
	func setup():
		items.clear()
		
		menu.clear()
		tree.clear()
		
		reset_scrollbar()
		
		var keys = modifiers.keys()
		keys.sort()
		
		for k in keys:
			menu.add_item(k)
			
		tree.create_item()
		
	func create_modifier(script):
		var root = tree.get_root()
		
		current = tree.create_item(root)
		current.set_cell_mode(0, TreeItem.CELL_MODE_STRING)
		current.set_text(0, script.get_name())
		
		current.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
		current.set_checked(1, true)
		current.set_text(1, 'On')
		current.set_editable(1, true)
		current.set_selectable(1, false)
		
		current.set_custom_bg_color(0, get_color('prop_category', 'Editor'))
		current.set_custom_bg_color(1, get_color('prop_category', 'Editor'))
		
		var mod = script.new()
		
		current.set_metadata(0, mod.get_instance_ID())
		
		mod.modifier_parameters(self)
		
		items.push_back(mod)
		
	func generate_state():
		var state = []
		
		var item = tree.get_root().get_children()
		
		while item:
			var item_state = {
				selected = item.is_selected(0),
				checked = item.is_checked(1),
				collapsed = item.is_collapsed()
			}
			
			state.append(item_state)
			
			item = item.get_next()
			
		return state
		
	func clear():
		items.clear()
		tree.clear()
		
		modifiers.clear()
		
	func _modifier_tools(what):
		var item = tree.get_selected()
		
		if what == Tool.ERASE:
			items.erase(instance_from_id(item.get_metadata(0)))
			
			item.get_parent().remove_child(item)
			
			remove.set_disabled(true)
			move_up.set_disabled(true)
			move_down.set_disabled(true)
			
		elif what == Tool.MOVE_UP or what == Tool.MOVE_DOWN:
			var mod = instance_from_id(item.get_metadata(0))
			
			var first = items.find(mod)
			var second = first
			
			if what == Tool.MOVE_UP:
				second -= 1
				
			elif what == Tool.MOVE_DOWN:
				second += 1
				
			var aux = items[first]
			items[first] = items[second]
			items[second] = aux
			
			var state = generate_state()
			
			aux = state[first]
			state[first] = state[second]
			state[second] = aux
			
			_rebuild_tree(state)
			_item_selected(tree.get_selected())
			
			state.clear()
			
		tree.update()
		
		emit_signal("modifier_edited")
		
	func _add_modifier(index):
		var mod = menu.get_item_text(index)
		
		create_modifier(modifiers[mod])
		
		emit_signal("modifier_edited")
		
	func _rebuild_tree(state):
		tree.clear()
		
		var root = tree.create_item()
		
		for i in range(items.size()):
			current = tree.create_item(root)
			current.set_collapsed(state[i].collapsed)
			
			current.set_cell_mode(0, TreeItem.CELL_MODE_STRING)
			current.set_text(0, items[i].get_name())
			
			if state[i].selected:
				current.select(0)
				
			current.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
			current.set_text(1, 'On')
			current.set_editable(1, true)
			current.set_checked(1, state[i].checked)
			current.set_selectable(1, false)
			
			current.set_custom_bg_color(0, get_color('prop_category', 'Editor'))
			current.set_custom_bg_color(1, get_color('prop_category', 'Editor'))
			
			current.set_metadata(0, items[i].get_instance_ID())
			
			items[i].modifier_parameters(self)
			
	func _item_edited(item):
		var parent = item.get_parent()
		
		if parent == tree.get_root():
			var mod = instance_from_id(item.get_metadata(0))
			
			if mod:
				mod.enabled = item.is_checked(1)
				
			emit_signal("modifier_edited")
			
			return
			
		var name = get_parameter_name(item)
		var value = get_parameter_value(item)
		
		var mod = instance_from_id(parent.get_metadata(0))
		
		if mod:
			mod.set(name, value)
			
		emit_signal("modifier_edited")
		
	func _item_selected(item):
		if item.get_parent() == tree.get_root():
			remove.set_disabled(false)
			move_up.set_disabled(item.get_prev() == null)
			move_down.set_disabled(item.get_next() == null)
			
		else:
			remove.set_disabled(true)
			move_up.set_disabled(true)
			move_down.set_disabled(true)
			
	func _init(base):
		set_name("modifiers")
		
		# Load modifiers
		modifiers = preload('Modifiers.gd').get_modifiers()
		
		var hbox_tools = HBoxContainer.new()
		hbox_tools.set_h_size_flags(SIZE_EXPAND_FILL)
		add_child(hbox_tools)
		
		var add = MenuButton.new()
		add.set_button_icon(base.get_icon('New', 'EditorIcons'))
		add.set_tooltip("Add New Modifier")
		hbox_tools.add_child(add)
		
		menu = add.get_popup()
		menu.connect("item_pressed", self, "_add_modifier")
		
		remove = ToolButton.new()
		remove.set_button_icon(base.get_icon('Remove', 'EditorIcons'))
		remove.set_tooltip("Remove Modifier")
		remove.set_disabled(true)
		hbox_tools.add_child(remove)
		remove.connect("pressed", self, "_modifier_tools", [Tool.ERASE])
		
		# Spacer
		var s = Control.new()
		s.set_h_size_flags(SIZE_EXPAND_FILL)
		hbox_tools.add_child(s)
		
		move_up = ToolButton.new()
		move_up.set_button_icon(base.get_icon('MoveUp', 'EditorIcons'))
		move_up.set_disabled(true)
		hbox_tools.add_child(move_up)
		move_up.connect("pressed", self, "_modifier_tools", [Tool.MOVE_UP])
		
		move_down = ToolButton.new()
		move_down.set_button_icon(base.get_icon('MoveDown', 'EditorIcons'))
		move_down.set_disabled(true)
		hbox_tools.add_child(move_down)
		move_down.connect("pressed", self, "_modifier_tools", [Tool.MOVE_DOWN])
		
		add_child(tree)
		
# End ModifierEditor

class ParameterEditor extends TreeEditor:
	
	var builder
	
	var smooth_button
	var flip_button
	
	signal parameter_edited
	
	static func get_signal():
		return "parameter_edited"
		
	func edit(object):
		builder = object
		
		tree.clear()
		
		reset_scrollbar()
		
		if not builder:
			return
			
		current = tree.create_item()
		
		builder.mesh_parameters(self)
		
		smooth_button.set_pressed(builder.smooth)
		flip_button.set_pressed(builder.flip_normals)
		
	func clear():
		tree.clear()
		
	func _check_box_pressed(pressed, name):
		if builder:
			builder.set(name, pressed)
			
		emit_signal("parameter_edited")
		
	func _item_edited(item):
		if not builder:
			return
			
		var name = get_parameter_name(item)
		var value = get_parameter_value(item)
		
		builder.set(name, value)
		
		emit_signal("parameter_edited")
		
	func _init():
		set_name("parameters")
		
		add_child(tree)
		
		var hb = HBoxContainer.new()
		hb.set_h_size_flags(SIZE_EXPAND_FILL)
		add_child(hb)
		
		smooth_button = CheckBox.new()
		smooth_button.set_text('Smooth')
		smooth_button.set_h_size_flags(SIZE_EXPAND_FILL)
		hb.add_child(smooth_button)
		
		flip_button = CheckBox.new()
		flip_button.set_text('Flip Normals')
		flip_button.set_h_size_flags(SIZE_EXPAND_FILL)
		hb.add_child(flip_button)
		
		smooth_button.connect("toggled", self, "_check_box_pressed", ['smooth'])
		flip_button.connect("toggled", self, "_check_box_pressed", ['flip_normals'])
		
# End ParameterEditor

