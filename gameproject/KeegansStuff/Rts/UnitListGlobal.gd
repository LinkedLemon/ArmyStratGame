extends Node

enum UnitNames {
	Cannon1,
	Big1
}

var Units : Dictionary[UnitNames,PackedScene] = {
	UnitNames.Cannon1 : preload("res://KeegansStuff/Units/cannon_fodder_unit.tscn"),
	UnitNames.Big1 : preload("res://KeegansStuff/Units/big_strength_unit.tscn")
}
