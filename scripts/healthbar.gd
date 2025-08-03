extends Node2D

func set_health(normalized_health: float):
	get_node("sprite").scale.x = normalized_health
