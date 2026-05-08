extends HBoxContainer

func _ready() -> void:
	# Dengarkan sinyal dari SignalBus
	SignalBus.status_applied.connect(_on_status_applied)

func _on_status_applied(status_name: String, duration: float, icon: Texture2D) -> void:
	var icon_rect = TextureRect.new()
	icon_rect.texture = icon
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.custom_minimum_size = Vector2(32, 32) # Ukuran ikon
	
	# Munculkan di UI
	add_child(icon_rect)
	
	# Tunggu sesuai durasi (3 detik), lalu hapus ikonnya
	await get_tree().create_timer(duration).timeout
	icon_rect.queue_free()
