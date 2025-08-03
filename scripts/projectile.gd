extends Area2D

@export var speed = 100
@export var target = Vector2()

func _process(delta: float):
	global_position = global_position.move_toward(target, delta * speed)


func destroy():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if "on_hit" in body:
		body.on_hit(global_position)
		call_deferred("destroy")
