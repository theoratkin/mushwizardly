extends Control


func _on_player_entered_circle(_ring: Node) -> void:
	visible = true


func _on_player_exited_circle(_ring: Node) -> void:
	visible = false
