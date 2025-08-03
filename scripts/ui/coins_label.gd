extends Label

func _on_player_coin_collected(total_coins: int) -> void:
	text = str(total_coins)
