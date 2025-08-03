extends Area2D

@onready var player = get_node("/root/main/player")

const move_towards_player_min_distance = 20
const move_towards_player_speed = 10

func _process(delta: float) -> void:
	self._move_towards_player(delta)

func _move_towards_player(delta: float):
	var distance = global_position.distance_to(player.global_position)
	if distance < move_towards_player_min_distance:
		global_position = global_position. move_toward(player.global_position, delta * move_towards_player_speed)

func disappear():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "collect_coin" in body:
		body.collect_coin()
		self.disappear()


func _on_disappear_timer_timeout() -> void:
	disappear()


func _on_disappear_warning_timer_timeout() -> void:
	get_node("animated sprite").play("disappear warning")
