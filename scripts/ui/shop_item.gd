extends TextureButton

func _process(_delta):
	self._set_active(GameState.can_afford_wizard())

func _set_active(state: bool):
	disabled = not state
	var label: Label = get_node("label")
	label.modulate = Color.WHITE if state else Color.RED

func _on_pressed() -> void:
	GameState.try_buy_wizard()
