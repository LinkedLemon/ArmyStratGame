extends Node

enum UnitNames {
	Cannon1,
	Big1,
	BetterBasic,
	TankUnit
}

var Units : Dictionary[UnitNames,PackedScene] = {
	UnitNames.Cannon1 : preload("res://KeegansStuff/Units/cannon_fodder_unit.tscn"),
	UnitNames.Big1 : preload("res://KeegansStuff/Units/big_strength_unit.tscn"),
	UnitNames.BetterBasic : preload("res://KeegansStuff/Units/Better_basic_unit.tscn"),
	UnitNames.TankUnit : preload("res://KeegansStuff/Units/tank_unit.tscn")
}
