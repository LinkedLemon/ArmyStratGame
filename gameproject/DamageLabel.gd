extends Label

#func _init(input_label : String):
	#text = input_label

func _ready():
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y - 10), .75).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, .75).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	queue_free()
