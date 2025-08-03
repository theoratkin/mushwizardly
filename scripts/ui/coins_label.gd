extends Label

func _process(_delta):
	text = str(GameState.coin_balance)
