extends RigidBody2D
class_name Unit

@export var unit_stats : UnitBase
@export var attack_zone : Area2D
@export var unit_stateMachine : StateMachine

#var unit_stats : UnitBase

var attack_zone_units : Array[Unit]

#func _enter_tree():
	#if unit_stats_base != null:
		#unit_stats = unit_stats_base.duplicate()

func _ready():
	attack_zone.body_entered.connect(attack_zone_entered)
	attack_zone.body_exited.connect(attack_zone_exited)
	unit_stateMachine.change_state("MovingState")
	change_physical_to_type()

func _physics_process(delta):
	change_physical_to_type()

func SpawnSetup(isPlayer : bool):
	if isPlayer:
		unit_stats.type = UnitBase.UnitType.PLAYER
	else:
		unit_stats.type = UnitBase.UnitType.ENEMY

func Attack():
	if attack_zone_units.size() <= 0:
		return
	
	for i in attack_zone_units:
		attack_zone_units[i].Hurt(unit_stats.attack_strength)

func Die():
	queue_free()

func Hurt(other_body_damage : int):
	unit_stats.health -= other_body_damage
	
	print(name + " health: " + str(unit_stats.health))
	
	if unit_stats.health <= 0:
		Die()

func attack_zone_entered(body : Node2D):
	if body is not Unit:
		return
	
	var new_unit : Unit = body
	
	if new_unit.unit_stats.type == unit_stats.type:
		return
	
	attack_zone_units.append(new_unit)
	unit_stateMachine.change_state("AttackingState")
	print("Attacking")

func attack_zone_exited(body : Node2D):
	if body is not Unit:
		return
	
	var old_unit : Unit = body
	
	if old_unit.unit_stats.type == unit_stats.type:
		return
	
	var old_unit_index = attack_zone_units.find(old_unit)
	
	if old_unit_index != null:
		attack_zone_units.remove_at(old_unit_index)
	else:
		print("couldnt find in list")
	
	if attack_zone_units.size() <= 0:
		unit_stateMachine.change_state("MovingState")

func clean_attack_zone_units():
	var i = 0
	while i < attack_zone_units.size():
		if not is_instance_valid(attack_zone_units[i]):
			attack_zone_units.remove_at(i)
		else:
			i += 1

func change_physical_to_type():
	if unit_stats.type == UnitBase.UnitType.ENEMY:
		var parent : Node2D = attack_zone.get_parent()
		parent.scale.x = parent.scale.x * -parent.scale.x
		$Sprite2D.flip_h
		$Sprite2D.flip_v
