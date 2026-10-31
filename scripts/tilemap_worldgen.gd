extends TileMapLayer

@onready var global_vars = get_node("/root/Global")

@onready var worldgen = global_vars.worldgen
var rng = RandomNumberGenerator.new()
enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

func _ready() -> void:
	# world gen things
	add_child(worldgen)
	
	for y in range(worldgen.Height):
		for x in range(worldgen.Width):
			var biome = worldgen.get_biome(x, y)
			if rng.randi() % 2 == 0 && !(biome == "unknown_bome" || biome == "savanna"):
				if rng.randi() % 2 == 0:
					set_cell(Vector2i(x, y),0,worldgen.get_biome_tile(biome),0 | TileTransform.ROTATE_90)
				else:
					set_cell(Vector2i(x, y),0,worldgen.get_biome_tile(biome),0 | TileTransform.ROTATE_180)
			else:
				set_cell(Vector2i(x, y),0,worldgen.get_biome_tile(biome),0)
