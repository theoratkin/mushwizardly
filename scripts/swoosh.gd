extends Area2D

func set_flipped(flipped: bool):
	get_node("animated sprite").flip_h = flipped

func _on_animation_end() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.get_meta("is_enemy", false) and "on_hit" in body:
		body.on_hit(global_position)
