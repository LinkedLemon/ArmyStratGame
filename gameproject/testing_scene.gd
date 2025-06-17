extends Node2D
class_name GameRoot

@onready var health = $UI/GeneralUi/Health
@onready var enemy_health = $UI/GeneralUi/EnemyHealth
@onready var cur_spawned_units = $UI/GeneralUi/CurSpawnedUnits
@onready var player_spawnpoint = $PlayerSpawn
@onready var unit_change_sfx = $UnitChangeSfx



var button: BaseButton
@export var game_state_machine : StateMachine
@export var strat_manager : StratManager

@export var player_spawn : Unit
@export var enemy_spawn : Unit

func _ready():
	player_spawn.unit_stats.type = UnitBase.UnitType.PLAYER
	enemy_spawn.unit_stats.type = UnitBase.UnitType.ENEMY
	
	player_spawn.died.connect(game_won, false)
	enemy_spawn.died.connect(game_won, true)
	
	
	strat_manager.StratStarted.connect(change_to_strat)
	strat_manager.StratFinished.connect(change_to_pick)
	
	button = find_first_basebutton(self)
	
	game_state_machine.change_state("PickingState")
	
	if button:
		button.grab_focus()
	else:
		push_warning("No BaseButton found in the scene tree")

func find_first_basebutton(root: Node) -> BaseButton:
	for child in root.get_children():
		# Return immediately if we find a BaseButton
		if child is BaseButton:
			return child
		
		# Recursively search in child nodes
		var result: BaseButton = find_first_basebutton(child)
		if result:
			return result
	
	return null

func change_to_pick(_input : bool):
	game_state_machine.change_state("PickingState")

func change_to_strat():
	game_state_machine.change_state("StratState")

func set_button(btn: BaseButton):
	button = btn
	print("Button set: ", button.name)

func _physics_process(delta):
	cur_spawned_units.text = str(player_spawnpoint.spawned_units.size())
	health.value = player_spawn.unit_stats.health
	enemy_health.value = enemy_spawn.unit_stats.health
	player_spawnpoint.clear_nulls()

func game_won(did_win : bool):
	if did_win:
		GameManager.game_won()
	else:
		GameManager.game_lost()

func _input(event):
	if event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_focus_prev"):
		if game_state_machine.current_state is PickingState:
			unit_change_sfx.play()
