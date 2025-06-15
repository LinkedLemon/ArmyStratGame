# move_state.gd
class_name MoveState
extends State

#func enter() -> void:
	## Play movement animation if available
	#if actor.has_node("AnimationPlayer"):
		#var anim_player = actor.get_node("AnimationPlayer")
		#if anim_player.has_animation("move"):
			#anim_player.play("move")

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
