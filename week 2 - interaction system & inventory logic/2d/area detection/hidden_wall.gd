extends Node2D

@onready var visual = $TileMap
@onready var static_collision = $StaticBody2D/CollisionShape2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = create_tween()
		tween.tween_property(visual, "modulate:a", 0.3, 0.5)
		

		static_collision.set_deferred("disabled", true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = create_tween()
		tween.tween_property(visual, "modulate:a", 1.0, 0.5)
		
		static_collision.set_deferred("disabled", false)
