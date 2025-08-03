extends RigidBody2D

@export var health = 100
@export var speed = 30
@export var hit_throwback = 30
@export var dps = 5

@onready var target = get_node("/root/main/home")

const coin_scene = preload("res://reusable_scenes/coin.tscn")

var swaying = Vector2()
var is_touching_home = false
var attack_timeout = 0.0

func _ready():
	swaying = Vector2(randf() - 0.5, randf() - 0.5) * 2

func _process(delta: float):
	if GameState.is_game_over:
		return
	if is_touching_home and attack_timeout <= 0:
		target.take_damage(dps)
		attack_timeout = 1.0
	attack_timeout -= delta

func _physics_process(delta: float) -> void:
	if GameState.is_game_over:
		return
	var direction = global_position.direction_to(target.global_position) + swaying
	apply_central_force(direction * speed)
	swaying.x -= sign(swaying.x) * delta/20
	swaying.y -= sign(swaying.y) * delta/20

func drop_coin():
	var coin = coin_scene.instantiate()
	get_node("/root/main/coins container").add_child(coin)
	coin.global_position = global_position

func die():
	call_deferred("drop_coin")
	queue_free()

func on_hit(origin: Vector2):
	var opposing_direction = origin.direction_to(global_position) * hit_throwback
	apply_central_impulse(opposing_direction)
	health -= 60
	if health <= 0:
		die()
