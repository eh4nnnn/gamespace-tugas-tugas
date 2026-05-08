extends Area2D

@export var heal_percentage: float = 0.15

func _on_body_entered(body: Node2D) -> void:
	# --- KODE BARU: Hanya peduli kalau yang nabrak adalah "Player" ---
	if not body.is_in_group("Player"):
		return # Kalau bukan Player, abaikan saja dan berhenti di sini!
	# ------------------------------------------------------------------
	
	if body.has_node("HealthComponent"):
		var health = body.get_node("HealthComponent")
		
		if health.has_method("heal_by_percentage"):
			health.heal_by_percentage(heal_percentage)
			
			var heal_icon = load("res://assets/2d/Icon buff/Heal.png") 
			SignalBus.status_applied.emit("Heal", 3.0, heal_icon)
			
			queue_free()
