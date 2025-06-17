extends State
class_name PickingState

@export var unit_ui : Control
@export var game_root : GameRoot

func enter() -> void:
	await get_tree().create_timer(.65).timeout
	unit_ui.process_mode = Node.PROCESS_MODE_INHERIT
	if game_root.button != null:
		game_root.button.grab_focus()
