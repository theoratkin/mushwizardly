extends Node

const WIZARD_PRICE = 10

var coin_balance = 0
var active_ring: Node
var is_game_over = false
var wizard_count = 0

func reset():
	coin_balance = 0
	active_ring = null
	is_game_over = false
	wizard_count = 0

func can_afford_wizard():
	return coin_balance >= 10

func try_buy_wizard():
	if active_ring and can_afford_wizard():
		GameState.active_ring.spawn_protector()
		coin_balance -= WIZARD_PRICE
