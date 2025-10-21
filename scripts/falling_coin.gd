extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


@export var bounce_strength: float = 0.6
@export var bounce_cutoff: float = 80.0
@export var friction: float = 0.1
@export var rest_height: float = 4.0
@onready var coin: Area2D = $Coin

var gravity: float

func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	coin.body_entered.connect(_on_coin_collected)
	coin.coin_picked_up.connect(_on_coin_finished)

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += gravity * delta
	
	var velocity_before_move = velocity
	# If this detects we hit the floor, it will set velocity = 0
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision:
		# get collision velocity and dampen
		var bounced_velocity = velocity_before_move.bounce(collision.get_normal()) * bounce_strength
		if is_on_floor() and bounced_velocity.length() < bounce_cutoff:
			velocity = Vector2.ZERO
			# set to rest position
			position.y -= rest_height
			# disable 
			set_physics_process(false)
		else:
			velocity = bounced_velocity
			if is_on_floor():
				# friction to horizontal movement
				velocity.x = lerp(velocity.x, 0.0, friction)


func launch(initial_velocity: Vector2):
	velocity = initial_velocity
	set_physics_process(true)
	
func launch_with_angle(angle_degrees: float, speed: float):
	var angle_radians = deg_to_rad(angle_degrees)
	var initial_velocity = Vector2.RIGHT.rotated(angle_radians) * speed
	launch(initial_velocity)

func _on_coin_finished():
	print("coin finished lets delete ourselves")
	queue_free()

func _on_coin_collected(body: Node2D):
	set_physics_process(false)
	collision_shape.disabled = true
	
