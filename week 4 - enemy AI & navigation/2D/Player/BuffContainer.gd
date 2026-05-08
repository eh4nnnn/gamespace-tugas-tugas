extends HBoxContainer

func _ready() -> void:
	SignalBus.status_applied.connect(_on_status_applied)

func _on_status_applied(_status_name: String, duration: float, icon: Texture2D) -> void:
	var icon_rect = TextureRect.new()
	icon_rect.texture = icon
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.custom_minimum_size = Vector2(32, 32) # Sesuaikan ukuran dengan UI kamu
	
	add_child(icon_rect)
	
	await get_tree().create_timer(duration).timeout
	icon_rect.queue_free()
