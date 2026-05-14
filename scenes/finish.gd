extends Area2D

const CONFETTI_SCENE: PackedScene = preload("res://scenes/confetti.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		var confetti: Node2D = CONFETTI_SCENE.instantiate()
		confetti.global_position = global_position
		get_tree().current_scene.add_child(confetti)
		queue_free()
