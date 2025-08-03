extends Node

@export var health = 100

var current_health

func _ready():
	current_health = health
	
func take_damage(damage: float):
	current_health -= damage
	get_node("healthbar").set_health(current_health / health)
	if current_health <= 0:
		on_destroy()

func on_destroy():
	get_node("sprite").play("destroyed")
	GameState.is_game_over = true
	var restart_timer: Timer = get_node("/root/main/restart timer")
	restart_timer.start()

func _on_body_entered(body: Node2D) -> void:
	if "is_touching_home" in body:
		body.is_touching_home = true

func _on_body_exited(body: Node2D) -> void:
	if "is_touching_home" in body:
		body.is_touching_home = false
