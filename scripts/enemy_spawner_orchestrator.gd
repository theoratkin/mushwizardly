extends Node2D

var spawners = []
@onready var timer: Timer = get_node("timer")

func _ready():
	var children = get_children()
	for child in children:
		if "spawn_random_enemy" in child:
			spawners.append(child)

func spawn_random_enemy():
	var spawner = spawners.pick_random()
	spawner.spawn_random_enemy()

func _on_timer_timeout() -> void:
	if GameState.is_game_over:
		return
	timer.wait_time = 1 + randf() * 1
	spawn_random_enemy()
