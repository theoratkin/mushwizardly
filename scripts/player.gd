extends CharacterBody2D

signal coin_collected(total_coins: int)

@export var SPEED = 2500.0

@onready var sprite: AnimatedSprite2D = get_node("sprite")

var swoosh = preload("res://reusable_scenes/swoosh.tscn")
var is_flipped = false

func collect_coin():
	GameState.coin_balance += 1
	coin_collected.emit(GameState.coin_balance)

func _physics_process(delta: float) -> void:
	if GameState.is_game_over:
		return
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	self._handle_movement(direction, delta)
	self._handle_flip(direction)

func _handle_movement(direction: Vector2, delta: float) -> void:
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity = Vector2()
	move_and_slide()

func _handle_flip(direction: Vector2):
	if direction.x:
		is_flipped = direction.x < 0
		sprite.flip_h = is_flipped
		get_node("shadow").flip_h = is_flipped

func _input(event):
	if GameState.is_game_over:
		return
	self._handle_attack(event)
	if OS.has_feature("editor"):
		self._handle_debug_keys(event)

func _handle_attack(event: InputEvent):
	if event.is_action_pressed("attack"):
		sprite.play("attack")
		var instance = swoosh.instantiate()
		add_child(instance)
		instance.set_flipped(is_flipped)

func _handle_debug_keys(event: InputEvent):
	if event.is_action_pressed("debug_get_coins"):
		GameState.coin_balance += 10

func _on_animation_finished() -> void:
	sprite.play("default")
