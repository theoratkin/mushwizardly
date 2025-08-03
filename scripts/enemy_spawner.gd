extends Node2D

@onready var enemies_container = get_node("/root/main/enemies container")

var enemy_pool: Array[Resource] = [
	preload("res://reusable_scenes/evil_green_thing.tscn"),
	preload("res://reusable_scenes/evil_red_thing.tscn")
]


func spawn_random_enemy():
	var instance = enemy_pool.pick_random().instantiate()
	instance.global_position = global_position
	enemies_container.add_child(instance)
