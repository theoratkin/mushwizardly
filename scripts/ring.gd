extends Node2D

@export var radius = 28
@export var standing_tolerance = 4
@export var highlight_color = Color.WHITE

@onready var player = get_node("/root/main/player")

@onready var sprite: Sprite2D = get_node("sprite")

var protector_scene = preload("res://reusable_scenes/protector.tscn")

var normal_color: Color

func _ready():
	normal_color = sprite.modulate

func is_player_standing_on_circle():
	var distance = player.global_position.distance_to(global_position)
	return abs(distance - radius) < standing_tolerance

func spawn_protector():
	var instance = protector_scene.instantiate()
	instance.patrol_radius = radius
	instance.patrol_speed = instance.patrol_speed / radius
	get_node("..").add_child(instance)

func _process(_delta: float):
	sprite.modulate = highlight_color if is_player_standing_on_circle() else normal_color
	if is_player_standing_on_circle() and Input.is_action_just_pressed("attack"):
		spawn_protector()
