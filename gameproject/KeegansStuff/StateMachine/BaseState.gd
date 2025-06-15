# state.gd
class_name State
extends Node

## Reference to the owning state machine
var state_machine: StateMachine = null
## Reference to the parent node (character/entity)
var actor: Node = null

# Virtual methods (override these in concrete states)
func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
