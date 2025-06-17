extends TextureRect
class_name StratArrow

# Configuration
@export var direction: int = 0
@export var state: int = 0
const FRAME_WIDTH = 32
const FRAME_HEIGHT = 32

func _ready():
	update_texture()

func update_texture():
	var atlas = AtlasTexture.new()
	atlas.atlas = preload("res://Assets/Art/Arrows/InputButtons.webp")
	
	# Calculate region (4 columns, 3 rows)
	var region_x = direction * FRAME_WIDTH
	var region_y = state * FRAME_HEIGHT
	atlas.region = Rect2(region_x, region_y, FRAME_WIDTH, FRAME_HEIGHT)
	
	texture = atlas

# Visual feedback functions
func pulse():
	var original_scale = scale
	var original_modulate = modulate
	
	# Create parallel tweens for scale and color
	var tween = create_tween().set_parallel(true)
	
	# Scale pulse
	tween.tween_property(self, "scale", original_scale * 1.3, 0.1)
	
	# Color pulse (brighter)
	tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5), 0.1)
	
	# Return to normal
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", original_scale, 0.2)
	tween.tween_property(self, "modulate", original_modulate, 0.2)

func shake():
	# Store original values
	var original_position = position
	var original_modulate = modulate
	
	# Only create tweens if node is valid
	if !is_inside_tree():
		return
	
	# Create shake effect
	var tween = create_tween().set_parallel(false)
	
	# Quick horizontal shake
	tween.tween_property(self, "position:x", original_position.x + 8, 0.05)
	tween.tween_property(self, "position:x", original_position.x - 8, 0.05)
	tween.tween_property(self, "position:x", original_position.x + 8, 0.05)
	tween.tween_property(self, "position:x", original_position.x, 0.05)
	
	# Red flash effect
	var color_tween = create_tween()
	color_tween.tween_property(self, "modulate", Color(2.0, 0.5, 0.5), 0.05)
	color_tween.tween_property(self, "modulate", original_modulate, 0.2)
