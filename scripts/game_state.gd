extends Node

var coin_balance = 0
var active_ring: Node
var is_game_over = false

func reset():
	coin_balance = 0
	active_ring = null
	is_game_over = false
