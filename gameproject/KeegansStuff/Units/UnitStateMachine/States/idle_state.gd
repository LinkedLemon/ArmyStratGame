class_name IdleState
extends State

#func enter() -> void:
	#if actor.has_node("AnimationPlayer"):
		#actor.get_node("AnimationPlayer").play("idle")

func physics_update(_delta: float) -> void:
	# Transition to move state if we should move
	if should_move():
		state_machine.change_state("MovingState")

func should_move() -> bool:
	# Add your movement condition logic here
	return false
