extends VBoxContainer

signal selection_changed(index, node)
signal actioned(index)

const PRESSED_COUNTER := 90
const MenuItem = preload("res://dialogues/dialogue_balloon/menu_item.tscn")

export var select_action := "ui_accept"
export var _pointer: NodePath = NodePath()
export var pointer_valign: float = 0.5
export var is_active: bool = true

onready var pointer = get_node_or_null(_pointer)

var index := 0


func _process(_delta: float) -> void:
	if not is_active:
		return

	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
		set_index(Utils.next_idx_in_loop(index, get_child_count()))
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left"):
		set_index(Utils.prev_idx_in_loop(index, get_child_count()))
	if Input.is_action_just_pressed(select_action):
		action_item(index)


func set_index(next_index: int) -> void:
	if next_index != index:
		index = next_index
		emit_signal("selection_changed", index)

	if is_instance_valid(pointer) and get_child_count() > 0:
		var selected = get_child(index)
		if is_instance_valid(selected):
			pointer.rect_global_position.y = selected.rect_global_position.y


func action_item(item_index: int) -> void:
	var actioned_node = get_child(item_index)

	if actioned_node and not actioned_node.is_allowed:
		return

	is_active = false
	emit_signal("actioned", item_index, actioned_node)


func setup_responses(responses: Array) -> void:
	for child in get_children():
		child.queue_free()
	for response in responses:
		var item = MenuItem.instance()
		item.bbcode_text = response.prompt
		item.is_allowed = response.is_allowed
		add_child(item)


### SIGNAL


func _on_Menu_visibility_changed():
	if pointer != null:
		pointer.visible = visible
		set_index(index)
