extends Node2D
class_name Nuke

@onready var animation_player = $AnimationPlayer

func drop_bomb():
	animation_player.play("Drop_bomb")

func kill_all():
	for unit in get_tree().get_nodes_in_group("Unit"):
		unit.queue_free()
