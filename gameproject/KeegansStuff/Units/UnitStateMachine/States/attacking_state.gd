extends State

var unit : Unit

func enter() -> void:
	if actor is Unit:
		unit = actor
	
	attack()

func exit() -> void:
	pass

func attack():
	if unit.attack_zone_units.size() <= 0:
		return
	
	unit.clean_attack_zone_units()
	
	for target_unit in unit.attack_zone_units:
		if is_instance_valid(target_unit) and target_unit is Unit:
			target_unit.Hurt(unit.unit_stats.attack_strength)
			
			var to_target = (target_unit.global_position - unit.global_position)
			var knockback_direction = Vector2.ZERO
			
			# For side-on fighting game, we always want horizontal knockback
			# with slight upward angle. Direction depends on relative positions
			if to_target.x >= 0:  # Target is to the right of attacker
				knockback_direction = Vector2(1, -0.4)  # Knock right with upward angle
			else:  # Target is to the left of attacker
				knockback_direction = Vector2(-1, -0.4)  # Knock left with upward angle
			
			knockback_direction = knockback_direction.normalized()
			
			# Apply knockback force using RigidBody2D physics
			var knockback_power = unit.unit_stats.attack_strength * 15.0
			target_unit.apply_central_impulse(knockback_direction * (knockback_power - target_unit.unit_stats.defence))
	
	await get_tree().create_timer(unit.unit_stats.attack_speed).timeout
	
	unit.clean_attack_zone_units()
	if unit.attack_zone_units.size() <= 0:
		state_machine.change_state("MovingState")
	else:
		attack()
