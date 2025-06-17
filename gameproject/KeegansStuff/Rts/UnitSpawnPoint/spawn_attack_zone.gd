extends StaticBody2D
class_name SpawnUnit

signal destroyed

@export var unit_stats : SpawnStats

var is_dead : bool = false

func Hurt(other_body_damage : int):
	if is_dead:
		return
	
	unit_stats.health -= other_body_damage
	
	if snappedf(unit_stats.health, 1) <= 0.1:
		is_dead = true
		destroyed.emit()
