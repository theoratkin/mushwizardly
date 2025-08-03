extends TextureButton

@export var price = 10

func _process(_delta):
	self._set_active(can_afford())

func can_afford():
	return GameState.coin_balance >= price

func _set_active(state: bool):
	disabled = not state
	var label: Label = get_node("label")
	label.modulate = Color.WHITE if state else Color.RED


func _on_pressed() -> void:
	if GameState.active_ring and can_afford():
		GameState.active_ring.spawn_protector()
		GameState.coin_balance -= price
