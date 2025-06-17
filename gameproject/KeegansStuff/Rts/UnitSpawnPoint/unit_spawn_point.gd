extends Marker2D
class_name UnitSpawnPoint

enum spawnType {
	Player,
	Enemy
}

@export var spawn_type : spawnType

var spawned_units : Array[Unit]

func spawn_unit(unit : UnitListGlobal.UnitNames):
	
	clear_nulls()
	
	if spawned_units.size() < 5:
		var unit_to_spawn = UnitListGlobal.Units.get(unit)
		var instance : Unit = unit_to_spawn.instantiate()
		
		if spawn_type == spawnType.Player:
			instance.unit_stats.type = UnitBase.UnitType.PLAYER
		else:
			instance.unit_stats.type = UnitBase.UnitType.ENEMY
		
		add_child(instance)
		
		spawned_units.append(instance)

func clear_nulls():
	var i = spawned_units.size() - 1
	
	while i >= 0:
		if spawned_units[i] == null:
			spawned_units.remove_at(i)
		i -= 1
