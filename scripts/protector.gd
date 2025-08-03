extends Node2D

@export var patrol_radius: float = 28
@export var patrol_speed: float = 1
@export var firerate: float = 1
@export var firing_range: float = 32

@onready var home = get_node("/root/main/home")
@onready var enemies_container: Node = get_node("/root/main/enemies container")

var projectile_scene = preload("res://reusable_scenes/projectile.tscn")

var current_ring_pos = 0
var firerate_timeout = 0


func _get_closest_enemy():
	var closest_enemy = null
	for enemy in enemies_container.get_children():
		if not closest_enemy:
			closest_enemy = enemy
			continue
		var current_closest_distance = global_position.distance_to(closest_enemy.global_position)
		var distance = global_position.distance_to(enemy.global_position)
		if distance < current_closest_distance:
			closest_enemy = enemy
	return closest_enemy


func _process(delta: float):
	if GameState.is_game_over:
		return
	current_ring_pos += delta * patrol_speed
	global_position = home.global_position + self.polar_to_cartesian(patrol_radius, current_ring_pos)
	if firerate_timeout <= 0:
		fire_at_closest_enemy_within_range()
	else:
		firerate_timeout -= delta


func polar_to_cartesian(r, angle):
	return Vector2(r * cos(angle), r * sin(angle))


func fire_at_closest_enemy_within_range():
	var closest_enemy = self._get_closest_enemy()
	if not closest_enemy:
		return
	var distance = global_position.distance_to(closest_enemy.global_position)
	if distance <= firing_range:
		fire_at_enemy(closest_enemy)


func fire_at_enemy(enemy: Node2D):
	spawn_projectile(enemy.global_position)
	firerate_timeout = firerate


func spawn_projectile(target: Vector2):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.target = target
	get_node("..").add_child(projectile)
