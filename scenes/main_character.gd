extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var spawn_position: Vector2 = Vector2(34, 429)
var shielded: bool = false

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	spawn_position = global_position

func activate_shield() -> void:
	shielded = true
	if not has_node("ShieldOrb"):
		var orb: Sprite2D = Sprite2D.new()
		orb.name = "ShieldOrb"
		orb.texture = preload("res://shield.png")
		orb.scale = Vector2(1.5, 1.5)
		orb.modulate = Color(1.0, 1.0, 1.0, 0.5)
		orb.z_index = 1
		add_child(orb)
	await get_tree().create_timer(3.0).timeout
	shielded = false
	if has_node("ShieldOrb"):
		$ShieldOrb.queue_free()

func _physics_process(delta: float) -> void:
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "run"
	else:
		sprite_2d.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2d.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		sprite_2d.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, 24)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
