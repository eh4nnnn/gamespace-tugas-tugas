extends CharacterBody2D

@export var max_hp: int = 5
var hp_sekarang: int

func _ready() -> void:
	hp_sekarang = max_hp

func terima_damage(jumlah_damage: int) -> void:
	hp_sekarang -= jumlah_damage
	print("Musuh kena hit! HP sisa: ", hp_sekarang)
	
	if hp_sekarang <= 0:
		mati()

func mati() -> void:
	print("Musuh mati!")
	queue_free()
