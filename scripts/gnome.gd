extends CharacterBody2D


const SPEED = 20
var direction = -1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var top_entry: CollisionShape2D = $TopEntry
@onready var side_entry: CollisionShape2D = $SideEntry
@onready var grayscale_material = preload("res://scripts/shader/grayscale_material.tres")
@onready var coin_generator_scene = preload("res://scenes/collectables/coin_generator.tscn")

@export var death_sound: AudioStream

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	add_to_group("gnome")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if ray_cast_right.is_colliding():
		direction = -1 
	elif ray_cast_left.is_colliding():
		direction = 1
		
	if direction == -1:
		velocity.x = -SPEED
		animated_sprite.flip_h = false
	else:
		velocity.x = SPEED
		animated_sprite.flip_h = true
		
	move_and_slide()
	
func got_stomped():
	print("Gnome was stomped")
	AudioManager.play_sound(death_sound)
	set_physics_process(false)
	velocity = Vector2.ZERO
	animated_sprite.stop()
	animated_sprite.frame = 1
	
	# Flatten this guy!
	animated_sprite.scale.x = 0.75
	animated_sprite.scale.y = 1.5
	animated_sprite.position.y += 14
	animated_sprite.rotation_degrees = 90
	animated_sprite.material = grayscale_material
	
	top_entry.set_deferred("disabled", true)
	side_entry.set_deferred("disabled", true)
	add_to_group("dead_gnome")
	
	# COINS!
	var coin_gen = coin_generator_scene.instantiate()
	coin_gen.global_position = self.global_position
	coin_gen.position.y -= 10
	get_parent().add_child(coin_gen)
	
	GameManager.stomped_gnome()
