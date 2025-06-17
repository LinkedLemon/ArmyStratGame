# move_state.gd
class_name MoveState
extends State

var unit : Unit

func enter() -> void:
	if actor is Unit:
		unit = actor
	else:
		return
	
	unit.play_animation(Unit.AnimStates.Walk)


func physics_update(_delta: float) -> void:
	if !actor or !actor is RigidBody2D:
		return
	
	var direction: Vector2
	
	# Determine direction based on unit type
	match actor.unit_stats.type:
		UnitBase.UnitType.PLAYER:
			direction = Vector2.RIGHT
		UnitBase.UnitType.ENEMY:
			direction = Vector2.LEFT
		_:
			direction = Vector2.ZERO
	
	# Apply force if below speed limit
	if actor.linear_velocity.length() < actor.unit_stats.max_movement_speed:
		actor.apply_central_force(direction * actor.unit_stats.movement_speed)
