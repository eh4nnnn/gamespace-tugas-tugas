extends StaticBody2D

@export var heal_drop_scene = preload("res://week 5 - collectible, UI, & data persistence/2D/Heal/HealDrop.tscn")

# Fungsi ini dipanggil oleh pedang saat menebas
func take_damage(amount: float) -> void:
	print("Pedang berhasil mengenai tong! Damage: ", amount) # <-- Teks detektif
	
	if has_node("HealthComponent"):
		$HealthComponent.take_damage(amount)

func _on_health_component_died() -> void:
	print("Darah tong habis, tong hancur!") # <-- Teks detektif
	
	var drop = heal_drop_scene.instantiate()
	get_parent().call_deferred("add_child", drop)
	drop.global_position = self.global_position
	queue_free()
