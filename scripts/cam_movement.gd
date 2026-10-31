extends Camera2D

@export var speed: float = 500.0
@export var ZOOM_SPEED: float = 10.0

@export var MIN_ZOOM: float = 0.5
@export var MAX_ZOOM: float = 10.0

@onready var global_vars = get_node("/root/Global")

@onready var Height = global_vars.TILE_HEIGHT
@onready var Width = global_vars.TILE_WIDTH

@onready var tilemap: TileMapLayer = $"../TileMap"

var target_zoom: float = 1.0

func _ready() -> void:
	target_zoom = zoom.x
	

func _process(delta: float) -> void:
	# Camera movement
	var direction = Input.get_vector(
		"ui_left", "ui_right",
		"ui_up", "ui_down"
	)

	position += direction * speed * delta

	# Zoom controls
	if Input.is_action_pressed("zoom up"):
		target_zoom += ZOOM_SPEED * delta

	elif Input.is_action_pressed("zoom down"):
		target_zoom -= ZOOM_SPEED * delta

	# Prevent excessive zoom
	target_zoom = clamp(target_zoom, MIN_ZOOM, MAX_ZOOM)

	# Smooth zoom
	zoom = zoom.lerp(
		Vector2(target_zoom, target_zoom),
		clamp(10.0 * delta, 0.0, 1.0)
	)
	
	
	#limit camra movent things:
	#NOT thnks to: https://godotforums.org/d/25248-automating-camera-limits-i-e-making-it-not-able-to-go-past-tilemap/2
	#var rect = tilemap.get_used_rect()
	
	
	#SHH DONT LOOK ITS A SECRIT
	if Input.is_action_just_pressed("secrit_reset_button_;0"):
		get_tree().reload_current_scene()
		global_vars._ready()
