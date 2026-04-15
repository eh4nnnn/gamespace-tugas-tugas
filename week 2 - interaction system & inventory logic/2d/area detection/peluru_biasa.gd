extends Area2D

@export var kecepatan: float = 400.0
@export var damage: int = 1
var arah := Vector2.RIGHT 

func _process(delta: float) -> void:
	position += arah * kecepatan * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	if area.name == "HitBox":
		var musuh = area.get_parent()
		
		if musuh.has_method("terima_damage"):
			musuh.terima_damage(damage)
			queue_free()


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	queue_free()
