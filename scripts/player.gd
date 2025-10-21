extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const FIREBALL_SCENE = preload("res://scenes/fireball.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle = $Muzzle

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
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
