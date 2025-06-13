extends RigidBody2D
class_name Unit

@export var unit_stats : UnitBase
@export var attack_zone : Area2D

var attack_zone_units : Array[Unit]

func _ready():
	attack_zone.body_entered.connect(attack_zone_entered)
	attack_zone.body_exited.connect(attack_zone_exited)

func _physics_process(delta):
	pass

func SpawnSetup(isPlayer : bool):
	if isPlayer:
		unit_stats.type = UnitBase.UnitType.PLAYER
	else:
		unit_stats.type = UnitBase.UnitType.ENEMY

func MovementUpdate(delta):
	var direction: Vector2
	
	match unit_stats.type:
		UnitBase.UnitType.PLAYER:
			direction = Vector2.LEFT
		UnitBase.UnitType.ENEMY:
			direction = Vector2.RIGHT
		_:
			return  # Unknown type, do nothing
	if linear_velocity.length() < unit_stats.movement_speed:
		apply_central_force(direction * unit_stats.movement_speed)

func StopMovement():
	pass

func Attack():
	if attack_zone_units.size() <= 0:
		return
	
	for i in attack_zone_units:
		attack_zone_units[i].Hurt(unit_stats.attack_strength)

func Die():
	pass

func Hurt(other_body_damage : int):
	unit_stats.health -= other_body_damage
	
	if unit_stats.health <= 0:
		Die()

func attack_zone_entered(body : Node2D):
	if !body.is_class("Unit"):
		return
	
	var new_unit : Unit = body
	
	if new_unit.unit_stats.type == UnitBase.UnitType.PLAYER:
		return
	
	attack_zone_units.append(new_unit)

func attack_zone_exited(body : Node2D):
	if !body.is_class("Unit"):
		return
	
	var old_unit : Unit = body
	
	if old_unit.unit_stats.type == UnitBase.UnitType.PLAYER:
		return
	
	var old_unit_index = attack_zone_units.find(old_unit)
	
	if old_unit_index != null:
		attack_zone_units.remove_at(old_unit_index)
	else:
		print("couldnt find in list")
