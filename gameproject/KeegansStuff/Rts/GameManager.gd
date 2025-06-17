extends Node

func game_won():
	get_tree().paused = true

func game_lost():
	get_tree().paused = true
