extends Node
class_name spawn_manager

@export var spawn : UnitSpawnPoint
@export var strat_manager : StratManager

var should_cancel : bool = false

func spawn_cannon():
	strat_manager.start_sequence(generate_direction_array(2))
	
	var success = await strat_manager.StratFinished
	
	if success:
		spawn.spawn_unit(UnitListGlobal.UnitNames.Cannon1)


func spawn_normal():
	strat_manager.start_sequence(generate_direction_array(4))
	
	var success = await strat_manager.StratFinished
	
	if success:
		spawn.spawn_unit(UnitListGlobal.UnitNames.Big1)

func spawn_better():
	strat_manager.start_sequence(generate_direction_array(8))
	
	var success = await strat_manager.StratFinished
	
	if success:
		spawn.spawn_unit(UnitListGlobal.UnitNames.BetterBasic)

func spawn_tank():
	strat_manager.start_sequence(generate_direction_array(14))
	
	var success = await strat_manager.StratFinished
	
	if success:
		spawn.spawn_unit(UnitListGlobal.UnitNames.TankUnit)

func generate_direction_array(length: int) -> Array:
	var directions = ["up", "down", "left", "right"]
	var result = []
	
	for i in range(length):
		result.append(directions[randi() % directions.size()])
	
	return result

func failed_check():
	await strat_manager.StratFailed
	should_cancel = true
	
