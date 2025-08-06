extends CharacterBody2D

signal coin_collected(total_coins: int)

@export var SPEED = 2500.0
@export var STOP_THRESHOLD = 8.0

@onready var sprite: AnimatedSprite2D = get_node("sprite")

var swoosh = preload("res://reusable_scenes/swoosh.tscn")
var swoosh_sound = preload("res://reusable_scenes/swoosh_sound.tscn")
var is_flipped = false
var target_position: Vector2
var has_tap_target: bool = false

func collect_coin():
	GameState.coin_balance += 1
	coin_collected.emit(GameState.coin_balance)
	get_node("/root/main/sounds/coin sound").play()

func _physics_process(delta: float) -> void:
	if GameState.is_game_over:
		return

	var kb_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if kb_input != Vector2.ZERO:
		has_tap_target = false
		_handle_movement(kb_input, delta)
		_handle_flip(kb_input)
	elif has_tap_target:
		var to_target = (target_position - global_position)
		if to_target.length() <= STOP_THRESHOLD:
			has_tap_target = false
			velocity = Vector2.ZERO
		else:
			var dir = to_target.normalized()
			_handle_movement(dir, delta)
			_handle_flip(dir)
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _unhandled_input(event: InputEvent):
	if GameState.is_game_over:
		return
	_handle_attack(event)
	var is_editor = OS.has_feature("editor")
	if is_editor:
		_handle_debug_keys(event)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_editor:
		_set_move_target(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		_set_move_target(event.position)

func _set_move_target(screen_pos: Vector2) -> void:
	target_position = get_global_mouse_position()
	has_tap_target = true

func _handle_movement(direction: Vector2, delta: float) -> void:
	velocity = direction * SPEED * delta

func _handle_flip(direction: Vector2):
	if direction.x != 0:
		is_flipped = direction.x < 0
		sprite.flip_h = is_flipped
		get_node("shadow").flip_h = is_flipped

func _handle_attack(event: InputEvent):
	if event.is_action_pressed("attack"):
		sprite.play("attack")
		var instance = swoosh.instantiate()
		add_child(instance)
		instance.set_flipped(is_flipped)
		var swoosh_sound_instance = swoosh_sound.instantiate()
		get_node("/root/main").add_child(swoosh_sound_instance)

func _handle_debug_keys(event: InputEvent):
	if event.is_action_pressed("debug_get_coins"):
		GameState.coin_balance += 10

func _on_animation_finished() -> void:
	sprite.play("default")
