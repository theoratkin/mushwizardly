extends Node


func _on_timeout() -> void:
	get_tree().reload_current_scene()
	GameState.reset()
