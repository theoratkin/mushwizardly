extends Node

@export var destroy_on_finished = false

func _on_finished() -> void:
	if destroy_on_finished:
		queue_free()
