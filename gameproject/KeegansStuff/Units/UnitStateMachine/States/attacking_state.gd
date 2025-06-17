class_name AttackingState
extends State

@onready var cooldown : Timer = $Cooldown

var unit : Unit
var can_attack : bool = true

func _ready():
	cooldown.timeout.connect(cooldown_finished)

func enter() -> void:
	if actor is Unit:
		unit = actor
	
	cooldown.wait_time = unit.unit_stats.attack_speed
	
	cooldown.start()

func attack():
	if !can_attack:
		return
	
	if unit.is_dead:
		return
	
	if unit.attack_zone_units.size() <= 0:
		return
	
	unit.clean_attack_zone_units()
	
	unit.play_animation(Unit.AnimStates.Attack)
	
	for target_unit in unit.attack_zone_units:
		if target_unit.is_dead:
			return
		
		if is_instance_valid(target_unit) and target_unit is Unit:
			if target_unit.is_dead == false:
				target_unit.Hurt(calculate_damage(unit, target_unit))
				
				var to_target = (target_unit.global_position - unit.global_position)
				var knockback_direction = Vector2.ZERO
				
				# For side-on fighting game, we always want horizontal knockback
				# with slight upward angle. Direction depends on relative positions
				if to_target.x >= 0:  # Target is to the right of attacker
					knockback_direction = Vector2(1, -1.0)  # Knock right with upward angle
				else:  # Target is to the left of attacker
					knockback_direction = Vector2(-1, -1.0)  # Knock left with upward angle
				
				knockback_direction = knockback_direction.normalized()
				
				# Apply knockback force using RigidBody2D physics
				var knockback_power = unit.unit_stats.attack_strength * 12
				target_unit.apply_central_impulse(knockback_direction * (knockback_power - (target_unit.unit_stats.defence * randf_range(1.25,2.00))))
	
	cooldown.start()
	can_attack = false
	
	unit.clean_attack_zone_units()

func cooldown_finished():
	can_attack = true
	attack()

func calculate_damage(attacker, target) -> int:
	var attack_str: float = attacker.unit_stats.attack_strength
	var defence: float = target.unit_stats.defence
	
	# Calculate base damage with defense scaling
	var damage_ratio: float = attack_str / (attack_str + defence * randf_range(1.25, 1.85))
	var raw_damage: float = attack_str * damage_ratio
	
	# Apply minimum damage guarantee and randomness
	var final_damage: int = max(1, ceil(raw_damage * randf_range(0.95, 1.05)))
	return final_damage
