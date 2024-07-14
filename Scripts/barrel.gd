extends Area2D

@onready var player = $"../Player"

func _on_body_entered(body):
	if body == player:
		player.barrel = true

func _on_body_exited(body):
	if body == player:
		player.barrel = false
