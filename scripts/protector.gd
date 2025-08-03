extends Node2D

@export var patrol_radius: float = 28
@export var patrol_speed: float = 1

@onready var home = get_node("/root/main/home")

var projectile_scene = preload("res://reusable_scenes/projectile.tscn")

var current_ring_pos = 0

func _process(delta: float):
	current_ring_pos += delta * patrol_speed
	global_position = home.global_position + self.polar_to_cartesian(patrol_radius, current_ring_pos)

func polar_to_cartesian(r, angle):
	return Vector2(r * cos(angle), r * sin(angle))


func spawn_projectile(target: Vector2):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.target = target
	get_node("..").add_child(projectile)


func _on_body_entered(body: Node2D) -> void:
	if "on_hit" in body:
		call_deferred("spawn_projectile", body.global_position)
