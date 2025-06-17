extends TextureButton
class_name UnitButton

@export var cooldown_time : float = 1

var new_game_root : Node2D

func _ready():
	await get_tree().process_frame
	new_game_root = get_tree().get_first_node_in_group("GameRoot")
	pressed.connect(timeout)

func timeout():
	if new_game_root:
		new_game_root.button = self as BaseButton
	
	disabled = true
	await get_tree().create_timer(cooldown_time).timeout
	disabled = false
