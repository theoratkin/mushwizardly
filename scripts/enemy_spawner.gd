extends Node2D

var enemy_pool: Array[Resource] = [
	preload("res://reusable_scenes/evil_green_thing.tscn"),
	preload("res://reusable_scenes/evil_red_thing.tscn")
]


func spawn_random_enemy():
	var instance = enemy_pool.pick_random().instantiate()
	add_child(instance)
