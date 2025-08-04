extends RigidBody2D

@export var health = 100
@export var speed = 30
@export var hit_throwback = 30
@export var dps = 5
@export var coins = 1

@onready var target = get_node("/root/main/home")

const coin_scene = preload("res://reusable_scenes/coin.tscn")

var is_touching_home = false
var attack_timeout = 0.0
var hit_sound: AudioStreamPlayer2D
var is_dead = false

var sway_angle = 0.0
var sway_timer = 0.0
var sway_direction = 1.0

func _ready():
	_choose_random_swaying()
	hit_sound = get_node("hit sound")
	remove_child(hit_sound)
	get_node("/root/main").add_child(hit_sound)

func _choose_random_swaying():
	sway_direction = 1.0 if randf() > 0.5 else -1.0
	sway_angle = randf() * 0.6
	sway_timer = randf() * 1.5 + 0.5

func _process(delta: float):
	if GameState.is_game_over:
		return
	if is_touching_home and attack_timeout <= 0:
		target.take_damage(dps)
		attack_timeout = 1.0
		get_node("nomnom").play()
	attack_timeout -= delta

func _physics_process(delta: float) -> void:
	if GameState.is_game_over:
		return
	var to_target = global_position.direction_to(target.global_position)
	var rotated_direction = to_target.rotated(sway_angle * sway_direction)
	apply_central_force(rotated_direction * speed)
	sway_timer -= delta
	if sway_timer <= 0:
		_choose_random_swaying()

func drop_coins():
	for i in coins:
		var coin = coin_scene.instantiate()
		get_node("/root/main/coins container").add_child(coin)
		coin.global_position = global_position + Vector2(10 * randf(), 10 * randf())

func die():
	if is_dead:
		return
	is_dead = true
	call_deferred("drop_coins")
	hit_sound.destroy_on_finished = true
	queue_free()

func on_hit(origin: Vector2):
	var opposing_direction = origin.direction_to(global_position) * hit_throwback
	apply_central_impulse(opposing_direction)
	hit_sound.play()
	health -= 60
	if health <= 0:
		die()
