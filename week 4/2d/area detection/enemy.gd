extends CharacterBody2D

@export var max_hp: int = 20
@export var batas_sekarat: int = 3

@export_group("Kecepatan Musuh")
@export var kecepatan_jalan: float = 300.0
@export var kecepatan_kabur: float = 400

var hp_sekarang: int
var player_target: Node2D = null

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	hp_sekarang = max_hp
	player_target = get_tree().get_first_node_in_group("Player")
	
	health_bar.max_value = max_hp
	health_bar.value = hp_sekarang

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if player_target != null:
		if hp_sekarang <= batas_sekarat:
			var arah_ke_player = sign(player_target.global_position.x - global_position.x)
			velocity.x = -arah_ke_player * kecepatan_kabur
			
			if has_node("Sprite2D"):
				$Sprite2D.flip_h = velocity.x < 0 
		else:
			nav_agent.target_position = player_target.global_position

			if nav_agent.is_target_reachable() == false:
				print("BUNTU! AI tidak melihat ada jalan ke Player.")
			
			var titik_selanjutnya = nav_agent.get_next_path_position()
			var arah_x = sign(titik_selanjutnya.x - global_position.x)
			
			if abs(titik_selanjutnya.x - global_position.x) < 5:
				arah_x = 0
				
			velocity.x = arah_x * kecepatan_jalan
			
			if has_node("Sprite2D") and arah_x != 0:
				$Sprite2D.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, 10)

	move_and_slide()

# --- Sistem Darah ---
func terima_damage(jumlah_damage: int) -> void:
	hp_sekarang -= jumlah_damage
	
	health_bar.value = hp_sekarang 
	
	print("Musuh kena hit! HP sisa: ", hp_sekarang)
	
	if hp_sekarang <= 0:
		mati()

@onready var health_bar: ProgressBar = $ProgressBar

func mati() -> void:
	print("Musuh mati!")
	queue_free()
