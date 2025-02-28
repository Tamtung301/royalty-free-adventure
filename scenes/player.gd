extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_attacking: bool = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	# Connect the 'animation_finished' signal to a callable targeting _on_animation_finished
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	# Handle Attack input first
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		animated_sprite_2d.play("attack")

	# If currently attacking, skip all other animation logic
	if is_attacking:
		# You can still allow movement or flipping while attacking if desired:
		var direction := Input.get_axis("move_left", "move_right")
		velocity.x = direction * SPEED
		
		# Flip the sprite mid-attack
		if direction < 0:
			animated_sprite_2d.flip_h = true
		elif direction > 0:
			animated_sprite_2d.flip_h = false

		# Apply gravity so the character can still fall if in the air
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		move_and_slide()
		return  # Important! Prevent other animations from overriding the attack

	# -----------------------------
	# Normal movement/animation code
	# -----------------------------
	
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

	# Flip sprite based on horizontal movement
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump")

	# Animation logic
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if animated_sprite_2d.animation != "jump":
			animated_sprite_2d.play("jump")

	move_and_slide()

func _on_animation_finished() -> void:
	# This function is called when an animation finishes on AnimatedSprite2D
	if animated_sprite_2d.animation == "attack":
		# If the finished animation was "attack", end the attack state
		is_attacking = false


func _on_sword_hit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		area.take_damage()
