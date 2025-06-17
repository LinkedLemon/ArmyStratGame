extends State

@export var unit_ui : Control
@export var game_root : GameRoot

func enter() -> void:
	unit_ui.process_mode = Node.PROCESS_MODE_INHERIT
	get_viewport().gui_release_focus()
