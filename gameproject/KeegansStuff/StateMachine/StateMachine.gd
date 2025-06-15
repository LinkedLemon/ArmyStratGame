# state_machine.gd
class_name StateMachine
extends Node

## The current active state
var current_state: State = null
## Dictionary of all available states
var states: Dictionary[String,State] = {}

# Called when the node enters the scene tree
func _ready() -> void:
	# Automatically register all child states
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.actor = get_parent()
	
	# Initialize with first state
	if states.size() > 0:
		var first_state = states.values()[0]
		change_state(first_state.name)

## Transition to a new state
func change_state(new_state_name: String) -> void:
	if current_state:
		current_state.exit()
	
	if states.has(new_state_name):
		current_state = states[new_state_name]
		current_state.enter()
	else:
		push_error("State '%s' not found!" % new_state_name)

## Process current state
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

## Physics process current state
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

## Handle input in current state
func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
