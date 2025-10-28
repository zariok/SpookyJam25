extends Node

var collectibles = {
	"coin":0, 
	"goblet":0, 
	"diamond":0
}

# used by HUD.gd
signal score_changed(score)
signal collectibles_changed(collected, total)
signal level_cleared

var score: int = 0 
var collectible_total: int = 0
var collectible_collected: int = 0
var isLevelCleared = false

const SCORE_VALUES = {
	"coin":      10,
	"goblet":    50,
	"diamond":  100
}

func init_level_totals():
	await get_tree().process_frame
	
	isLevelCleared = false
	
	# Collectibles
	for k in collectibles:
		collectibles[k] = 0
	collectible_collected = 0
	collectible_total = get_tree().get_nodes_in_group("Collectible").size()

	# Score
	score = 0
	score_changed.emit(score)
	collectibles_changed.emit(collectible_collected, collectible_total)

# This is used by collectible spawners (e.g. coin_generator)
func notify_collectible_spawned(count: int = 1):
	collectible_total += count
	collectibles_changed.emit(collectible_collected, collectible_total)

func add_collectable(type: String):
	if type not in collectibles:
		print("UNKNOWN collectible - " + type)
		return
	collectibles[type] += 1
	print(type + ": " + str(collectibles[type]))
	
	# Calculate score based on collectible values
	if type in SCORE_VALUES:
		score += SCORE_VALUES[type]
	score_changed.emit(score)
	
	# how many collectibles do we have
	var collected: int = 0
	for k in collectibles:
		collected += collectibles[k]
		
	collectible_collected = collected
	collectibles_changed.emit(collectible_collected, collectible_total)
	
	# Are we done with this level?
	if collectible_collected >= collectible_total and not isLevelCleared:
		isLevelCleared = true
		level_cleared.emit()


func you_died():
	print("You have perished, try again.")
	init_level_totals()
	
