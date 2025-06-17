extends RigidBody2D
class_name Unit

signal died

enum AnimStates {
	Idle,
	Walk,
	Attack,
	Die
}

@export var unit_stats : UnitBase
@export var attack_zone : Area2D
@export var sprite : Sprite2D
@export var unit_stateMachine : StateMachine
@export var animation_player : AnimationPlayer
@export var die_sfx : AudioStreamPlayer2D

@onready var shadow = $Shadow
@onready var hurt_sfx = $HurtSfx


var added_animations: Array[String] = []  # Track animations we've added

var attack_zone_units : Array[Unit]
var is_dead : bool = false
var anim_library_name : String
var shadow_y : float

func _ready():
	$HealthBar.max_value = unit_stats.health
	$HealthBar.min_value = 0
	
	attack_zone.body_entered.connect(attack_zone_entered)
	attack_zone.body_exited.connect(attack_zone_exited)
	shadow_y = shadow.global_position.y
	load_animations_from_library(unit_stats.animation_library)
	#play_animation(AnimStates.Walk)
	
	change_physical_to_type()

func _physics_process(delta):
	$HealthBar.value = unit_stats.health
	
	shadow.global_position.y = shadow_y
	
	change_physical_to_type()

func SpawnSetup(isPlayer : bool):
	if isPlayer:
		unit_stats.type = UnitBase.UnitType.PLAYER
	else:
		unit_stats.type = UnitBase.UnitType.ENEMY

func Die():
	died.emit()
	die_sfx.play()
	is_dead = true
	unit_stateMachine.change_state("DeadState")
	play_animation(AnimStates.Die)
	await animation_player.animation_finished
	queue_free()

func Hurt(other_body_damage : int):
	hurt_sfx.play()
	unit_stats.health -= other_body_damage
	
	if snappedf(unit_stats.health, 1) <= 0.1:
		Die()

func attack_zone_entered(body : Node2D):
	var new_unit : Unit = body
	
	if new_unit.unit_stats.type == unit_stats.type:
		return
	
	attack_zone_units.append(new_unit)
	if !is_dead and unit_stateMachine.current_state != AttackingState:
		unit_stateMachine.change_state("AttackingState")

func attack_spawn_zone():
	unit_stateMachine.change_state("AttackingState")

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
	
	if attack_zone_units.size() <= 0 and !is_dead:
		if animation_player.current_animation.contains("Attack"):
			await animation_player.animation_finished
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
		sprite.flip_h = true

func play_animation(animation: AnimStates) -> void:
	var anim_name = animation_to_string(animation)
	if animation_player.has_animation(anim_library_name+"/"+anim_name):
		animation_player.play(anim_library_name+"/"+anim_name)

func animation_to_string(animation: AnimStates) -> String:
	match animation:
		AnimStates.Idle: return "Idle"
		AnimStates.Walk: return "Walk"
		AnimStates.Attack: return "Attack"
		AnimStates.Die: return "Die"
		_: return "Idle"

func load_animations_from_library(library: AnimationLibrary) -> void:
	for anim_name in added_animations:
		if animation_player.has_animation(anim_name):
			animation_player.remove_animation(anim_name)
	
	animation_player.add_animation_library(extract_filename(library.resource_path),library)
	anim_library_name = extract_filename(library.resource_path)

func extract_filename(res_path: String) -> String:
	return res_path.trim_prefix("res://KeegansStuff/Units/UnitAnimationLibary/").trim_suffix(".res")
