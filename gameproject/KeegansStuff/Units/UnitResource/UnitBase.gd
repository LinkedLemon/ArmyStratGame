extends Resource
class_name UnitBase

enum UnitType {PLAYER, ENEMY}


@export_category("Combat")
@export var attack_strength : int = 0 ## Damage per attack
@export var attack_speed : int = 0 ## Attack per second
@export var attack_distance : float = 0.0 ## Attack distance in pixels
@export var movement_speed : float = 0.0 ## Movespeed in pixels per second
@export_category("Other")
@export var health : float = 0.0 ## Health
@export var defence : float = 0.0 ## Defence is applied before final health calc
@export var notoriety : int = 0.0 ## Skill and rank level
@export var animation_libary : AnimationLibrary ## Unit animations and textures

var type: UnitBase.UnitType = UnitBase.UnitType.PLAYER
