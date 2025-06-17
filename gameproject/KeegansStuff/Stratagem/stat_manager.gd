extends Control
class_name StratManager

signal StratFinished(bool)
signal StratStarted

@export var spawn : Control
var arrow_scene = preload("res://KeegansStuff/Stratagem/Arrow/arrow.tscn")

# Direction mapping
const DIRECTIONS = {
	"up": 0,
	"down": 1,
	"left": 2,
	"right": 3
}

# States
const STATE_NEUTRAL = 0
const STATE_SUCCESS = 1
const STATE_FAILURE = 2

# Sequence management
var current_sequence = []
var current_index = 0
var is_active = false


func _input(event):
	# Input handling
	if !is_active:
		return
	
	if event.is_action_pressed("strat_up"):
		handle_input("up")
	elif event.is_action_pressed("strat_down"):
		handle_input("down")
	elif event.is_action_pressed("strat_left"):
		handle_input("left")
	elif event.is_action_pressed("strat_right"):
		handle_input("right")

func start_test_sequence():
	# Create a test sequence: up, left, down, right
	start_sequence(["up", "left", "down", "right"])

func start_sequence(sequence: Array):
	clear_arrows()
	StratStarted.emit()
	current_sequence = sequence
	current_index = 0
	is_active = true
	
	# Spawn all arrows in neutral state
	for direction in sequence:
		add_arrow(direction)

func add_arrow(direction_name: String):
	var arrow = arrow_scene.instantiate()
	
	if DIRECTIONS.has(direction_name):
		arrow.direction = DIRECTIONS[direction_name]
		arrow.state = STATE_NEUTRAL
		arrow.update_texture()
	
	spawn.add_child(arrow)
	return arrow

func update_arrow_state(index: int, success: bool):
	var arrows = spawn.get_children()
	if index >= arrows.size():
		return
	
	var arrow = arrows[index]
	arrow.state = STATE_SUCCESS if success else STATE_FAILURE
	arrow.update_texture()
	
	# Trigger visual feedback
	if success:
		arrow.pulse()
	else:
		arrow.shake()
		sequence_failed()

func clear_arrows():
	for child in spawn.get_children():
		child.queue_free()
	current_index = 0
	is_active = false

func handle_input(direction: String):
	if !is_active:
		return
	
	current_index = min(current_index, current_sequence.size())
	
	var correct = current_sequence[current_index] == direction
	
	# Update visual state
	update_arrow_state(current_index, correct)
	
	if correct:
		current_index += 1
		# Check for sequence completion
		if current_index >= current_sequence.size():
			sequence_completed()
	

func sequence_completed():
	is_active = false
	# Success effect - pulse all arrows
	for i in range(current_sequence.size()):
		update_arrow_state(i, true)
		await get_tree().create_timer(0.1).timeout
	
	# Reset after delay
	await get_tree().create_timer(0.5).timeout
	StratFinished.emit(true)
	clear_arrows()

func sequence_failed():
	is_active = false
	# Create a duplicate of the indices to process
	var indices_to_update = range(current_index, current_sequence.size())
	current_index = current_sequence.size()  # Prevent further input processing
	
	# Process each arrow with delay
	for i in indices_to_update:
		var arrows = spawn.get_children()
		if i < arrows.size():
			# Update state directly without going through update_arrow_state
			var arrow = arrows[i]
			arrow.state = STATE_FAILURE
			arrow.update_texture()
			arrow.shake()
		
		# Wait before processing next arrow
		await get_tree().create_timer(0.1).timeout
	
	# Reset after delay
	StratFinished.emit(false)
	await get_tree().create_timer(0.5).timeout
	clear_arrows()
