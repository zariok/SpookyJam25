extends CharacterBody2D

signal exit_sequence_finished

@export var death_sound: AudioStream
@export var jump_sound: AudioStream

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const FIREBALL_SCENE = preload("res://scenes/fireball.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_sound = $WalkSoundPlayer
@onready var muzzle = $Muzzle

func _ready():
	GameManager.level_cleared.connect(_on_level_cleared)

func _on_level_cleared():
	print("Level Cleared!  Blasting off!!")
	set_physics_process(false)
	if animated_sprite:
		animated_sprite.play("jump")
	
	var tween = create_tween()
	# Fly up 1500px in 2 seconds
	var target_y = global_position.y - 1500
	tween.tween_property(self, "global_position:y", target_y, 2.0)
	await tween.finished
	exit_sequence_finished.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func shoot():
	var fireball = FIREBALL_SCENE.instantiate()
	
	fireball.global_position = muzzle.global_position
	var move_direction = 1
	if $AnimatedSprite2D.flip_h:
		move_direction = -1
	fireball.direction = Vector2.RIGHT * move_direction
	get_tree().root.add_child(fireball)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		AudioManager.play_sound(jump_sound)
		velocity.y = JUMP_VELOCITY

	# Gets input direction -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
			walk_sound.stop()
		else:
			animated_sprite.play("run")
			if not walk_sound.playing:
				walk_sound.play()
	else:
		walk_sound.stop()
		animated_sprite.play("jump")
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	check_gnome_collisions()
	
func check_gnome_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		# what'd we hit
		var collider = collision.get_collider()
		# gnome?
		if collider and collider.is_in_group("gnome") and not collider.is_in_group("dead_gnome"):
			# 0 top, 1 side
			var shapeIdx = collision.get_collider_shape_index()
			print("Collided with %s" % shapeIdx)
			if shapeIdx == 0:
				# hit top
				if collider.has_method("got_stomped"):
					collider.got_stomped()
					velocity.y = JUMP_VELOCITY * 0.5
			elif shapeIdx == 1:
				GameManager.you_died(self)
					
