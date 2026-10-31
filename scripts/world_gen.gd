extends Node2D
@onready var global_vars = get_node("/root/Global")

@onready var Height = global_vars.TILE_HEIGHT
@onready var Width = global_vars.TILE_WIDTH

# alt, heat, humidity, soil comp, [tile cords]
# Vector2 = min/max range
# 0 = any
#-1  dependent on other conditions spesfide in the code
#-99 none only for testing

var biomes = {
#	"beach": -1,
	"alpine": [Vector2(0.7, 1), 0, 0, 0, [Vector3(1,1,50),Vector3(2,1,5),Vector3(3,1,5),Vector3(6,0,13),Vector3(7,0,13),Vector3(0,1,13)]],
	"boreal": [Vector2(-1, 0.7), Vector2(-0.3, 0.5), Vector2(0.5, 1), Vector2(-0.2, 1),[Vector3(2,1,50),Vector3(3,1,50)]],
	"tundra": [Vector2(-0.3, 0.3), Vector2(-0.5, 0.2), Vector2(0, 0.3), 0, [Vector3(1,1,85),Vector3(6,0,5),Vector3(7,0,5),Vector3(0,1,5)]],
	"polar": [Vector2(-1, 0.7), Vector2(-1, -0.4), 0, 0, [Vector3(6,0,33),Vector3(7,0,33),Vector3(0,1,33)]],
	"polor_desert": [Vector2(-1,-0.3),Vector2(-1,-0.3),Vector2(-1,-0.7),0,Vector3(6,0,33),Vector3(7,0,33),Vector3(0,1,33)],
	"ocean": [0,Vector2(-0.3,0.7),Vector2(-0.3,0.7),0, [Vector3(4,0,50),Vector3(3,0,50)]],
	"temperate": [Vector2(-0.5, 0.7), Vector2(0, 0.5), 0, 0,[Vector3(1,0,90),Vector3(2,0,10)]],
	"tropical": [Vector2(0, 0.8), Vector2(0.5, 1), Vector2(-0.3, 1), 0,[Vector3(1,0,10),Vector3(2,0,80)]],
	"arid": [0, Vector2(0.6, 1), Vector2(-1, -0.3), Vector2(-1, 0.5),[Vector3(5,0,90),Vector3(0,0,10)]],
	"savanna": [Vector2(-0.3, 0.5), Vector2(0.3, 1.0),Vector2(-0.4, 0.3), Vector2(-0.2, 0.5),[Vector3(6,1,50),Vector3(7,1,50)]],
	"chaparral": [Vector2(-1,0.7), Vector2(0.5, 0.7), Vector2(-0.6, 0), Vector2(-0.5, 0.3),[Vector3(5,0,5),Vector3(0,0,10),Vector3(5,1,85)]],
	#"lake": [Vector2(-1, -0.7), 0, Vector2(0.3, 1), 0, [Vector3(3,0,50),Vector3(4,0,50)]],
	"lake": [Vector2(-0.3,0.3),0,Vector2(-0.3,0.3),Vector2(-0.3,0.3),[Vector3(0,2,50),Vector3(1,2,50)]],
	"beach": [Vector2(-0.7, 0.1), Vector2(-0.2, 0.8),Vector2(-0.5, 0.5),Vector2(-0.5, 0.5),[Vector3(0,0,100)]],
	"bog": [Vector2(-0.3,0.3), Vector2(-0.2,0.2),Vector2(-0.1,1),Vector2(0.3,1),[Vector3(4,2,90),Vector3(3,0,10)]],
	"unknown_bome": [-99, -99, -99, -99 ,[Vector3(7,7,0.01),Vector3(3,0,24.99),Vector3(4,0,25),Vector3(0,2,25),Vector3(1,2,25)]]
}

#set up the random number genrator
var rng = RandomNumberGenerator.new()
#create genraters for the alt heat and other
var altitude_noise = FastNoiseLite.new()
var heat_noise = FastNoiseLite.new()
var humidity_noise = FastNoiseLite.new()
var soilcomp_noise = FastNoiseLite.new()

var base_humidity
var base_altiude
var base_heat 
func _ready() -> void:
	altitude_noise.seed = rng.randi()
	heat_noise.seed = rng.randi()
	humidity_noise.seed = rng.randi()
	soilcomp_noise.seed = rng.randi()
	
	altitude_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	heat_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	humidity_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	soilcomp_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	
	#this is infiuced by are "starting location"
	#are  "starting location" is teh place on eart were we are
	# so for exaple rusha is very cold so we would have a lower base heat
	#however we would still be able to change that to get more interesting biomes

	#value that can be from 1 to -1 (genrated on a bell curve) so it does not infulce too much
	base_heat = clampf(rng.randfn(0.0, 0.15), -1.0, 1.0)
	base_altiude = clampf(rng.randfn(0.0, 0.15), -1.0, 1.0)
	base_humidity  = clampf(rng.randfn(0.0, 0.15), -1.0, 1.0)





func get_heat(x: float, y: float) -> float:
	return clampf(
		heat_noise.get_noise_2d(x, y) * 2 + base_heat * 0.15,
		-1.0, 1.0
	)


func get_altitude(x: float, y: float) -> float:
	return clampf(
		altitude_noise.get_noise_2d(x, y) * 2 + base_altiude * 0.15,
		-1.0, 1.0
	)


func get_humidity(x: float, y: float) -> float:
	return clampf(
		humidity_noise.get_noise_2d(x, y) * 2 + base_humidity * 0.15,
		-1.0, 1.0
	)

func get_soilcomp(x: float,y: float) -> float:
	return clampf(
		soilcomp_noise.get_noise_2d(x, y),
		-1.0, 1.0
	)

func get_biome(x: float, y: float) -> String:
	var alt = get_altitude(x, y)
	var temp = get_heat(x, y)
	var humid = get_humidity(x, y)
	var soil = get_soilcomp(x, y)

	

	var values = [alt, temp, humid, soil]

	for biome in biomes:
		
		
		if biome == "beach" or biome == "unknown_bome":
			continue

		var data = biomes[biome]
		var matches = true

		for i in range(4):
			if 1 == 1:
				pass
			
			if data[i] is int:
				continue

			if values[i] < data[i].x or values[i] > data[i].y:
				matches = false
				break
			
			
			
		if matches:
			#print("Selected biome: ", biome)
			return biome

	#print("Selected biome: unknown_bome")
	return "unknown_bome"

func get_biome_tile(biome: String) -> Vector2i:
	# sorry not human but im doing the best i can
	var tiles = biomes[biome][4]
	var total_weight = 0.0
	for tile in tiles:
		total_weight += tile.z
	var roll = randf() * total_weight
	for tile in tiles:
		roll -= tile.z
		if roll < 0:
			return Vector2i(int(tile.x), int(tile.y))
	return Vector2i(int(tiles[-1].x), int(tiles[-1].y)) #no tile a gess
