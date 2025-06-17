class_name IdleState
extends State

var unit : Unit

func enter() -> void:
	print("idle entered")
	if actor is Unit:
		unit = actor
	else:
		return
	
	unit.play_animation(Unit.AnimStates.Idle)

func physics_update(_delta: float) -> void:
	# Transition to move state if we should move
	if should_move():
		state_machine.change_state("MovingState")

func should_move() -> bool:
	# Add your movement condition logic here
	return false
