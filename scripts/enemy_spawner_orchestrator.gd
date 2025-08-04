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
	timer.wait_time = _spawn_delay_linear(GameState.wizard_count, 3, 0.2, 0.2)
	print(str(GameState.wizard_count) + " wizards, wait time " + str(timer.wait_time))
	spawn_random_enemy()

func _spawn_delay_linear(towers, base_delay=5.0, factor=0.2, min_delay=1.0):
	var delay = base_delay - (towers * factor)
	return max(delay, min_delay)
