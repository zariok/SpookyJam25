extends Node

var collectibles = {
	"coin":0, 
	"goblet":0, 
	"diamond":0
}

# used by HUD.gd
signal score_changed(score)
signal collectibles_changed(collected, total)
signal gnomes_changed(stomped, total)
signal level_cleared

var score: int = 0 
var collectible_total: int = 0
var collectible_collected: int = 0
var gnome_total: int = 0
var gnome_stomped: int = 0
var isLevelCleared = false
var death_timer: Timer

const SCORE_VALUES = {
	"coin":      10,
	"goblet":    50,
	"diamond":  100
}

func _ready():
	death_timer = Timer.new()
	death_timer.wait_time = 0.6
	death_timer.one_shot = true
	death_timer.timeout.connect(_on_death_timer_timeout)
	add_child(death_timer)
	

func init_level_totals():
	await get_tree().process_frame
	
	isLevelCleared = false
	
	# Collectibles
	for k in collectibles:
		collectibles[k] = 0
	collectible_collected = 0
	collectible_total = get_tree().get_nodes_in_group("Collectible").size()
	collectibles_changed.emit(collectible_collected, collectible_total)

	# Gnomes
	gnome_stomped = 0
	gnome_total = get_tree().get_nodes_in_group("gnome").size()
	gnomes_changed.emit(gnome_stomped, gnome_total)
	
	# Score
	score = 0
	score_changed.emit(score)

# This is used by collectible spawners (e.g. coin_generator)
func notify_collectible_spawned(count: int = 1):
	collectible_total += count
	collectibles_changed.emit(collectible_collected, collectible_total)

func stomped_gnome():
	gnome_stomped = get_tree().get_nodes_in_group("dead_gnome").size()
	gnome_total = get_tree().get_nodes_in_group("gnome").size()
	gnomes_changed.emit(gnome_stomped, gnome_total)
	_is_level_compelete()

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
	
	_is_level_compelete()

# Are we done with this level?
func _is_level_compelete():
	if collectible_collected >= collectible_total and gnome_stomped >= gnome_total and not isLevelCleared:
		isLevelCleared = true
		print("Level cleared!")
		level_cleared.emit()

func you_died(body: Node2D):
	print("You have perished, try again.")
	AudioManager.play_sound(body.death_sound)
	Engine.time_scale = 0.5
	# body is player, the only thing hitting Killzone
	# Remove the collision shape so the player "falls off screen"
	body.get_node("CollisionShape2D").queue_free()
	death_timer.start()
	
	init_level_totals()

func _on_death_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
