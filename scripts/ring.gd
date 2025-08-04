extends Node2D

signal player_entered_circle(ring)
signal player_exited_circle(ring)

@export var radius = 28
@export var standing_tolerance = 8
@export var speed_multiplier = 1
@export var highlight_color = Color.WHITE

@onready var player = get_node("/root/main/player")

@onready var sprite: Sprite2D = get_node("sprite")

var protector_scene = preload("res://reusable_scenes/protector.tscn")

var normal_color: Color
var is_player_standing_on_circle

func _ready():
	normal_color = sprite.modulate

func check_is_player_standing_on_circle():
	var distance = player.global_position.distance_to(global_position)
	return abs(distance - radius) < standing_tolerance

func spawn_protector():
	var dir_vector = player.global_position - global_position
	var angle = dir_vector.angle()
	var instance = protector_scene.instantiate()
	instance.set_ring_position(angle)
	instance.patrol_radius = radius
	instance.patrol_speed = instance.patrol_speed / radius * speed_multiplier
	get_node("..").add_child(instance)
	GameState.wizard_count += 1


func _process(_delta: float):
	var did_player_stand_on_circle = is_player_standing_on_circle
	is_player_standing_on_circle = check_is_player_standing_on_circle()
	sprite.modulate = highlight_color if is_player_standing_on_circle else normal_color
	if not did_player_stand_on_circle and is_player_standing_on_circle:
		GameState.active_ring = self
		player_entered_circle.emit(self)
	if did_player_stand_on_circle and not is_player_standing_on_circle:
		player_exited_circle.emit(self)
