extends Marker2D
class_name UnitSpawnPoint

enum spawnType {
	Player,
	Enemy
}

@export var spawn_type : spawnType

func spawn_unit(unit : UnitListGlobal.UnitNames):
	var unit_to_spawn = UnitListGlobal.Units.get(unit)
	var instance : Unit = unit_to_spawn.instantiate()
	
	if spawn_type == spawnType.Player:
		instance.unit_stats.type = UnitBase.UnitType.PLAYER
	else:
		instance.unit_stats.type = UnitBase.UnitType.ENEMY
	
	add_child(instance)
