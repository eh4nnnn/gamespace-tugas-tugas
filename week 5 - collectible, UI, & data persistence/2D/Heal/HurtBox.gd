extends Area2D

# Fungsi ini akan dipanggil oleh senjata saat menebas
func take_damage(amount: float) -> void:
	# Teruskan serangan ke script tong (induknya)
	if get_parent().has_method("take_damage"):
		get_parent().take_damage(amount)
