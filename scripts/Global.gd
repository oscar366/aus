extends Node

const TILE_WIDTH = 100
const TILE_HEIGHT = 100

const WIDTH = TILE_WIDTH * 16
const HEIGHT = TILE_HEIGHT * 16
var worldgen: Node2D
const WorldGen = preload("res://scripts/world_gen.gd")
func _ready() -> void:
	if worldgen == null:
		worldgen = WorldGen.new()
		add_child(worldgen)
