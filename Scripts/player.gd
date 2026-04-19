extends CharacterBody2D


@export var speed = 150.0
@export var jump_force = -300.0
@export var gravity_value = 1000.0 # Custom "fake" gravity

@onready var animated_sprite = $Visuals/AnimatedSprite2D
@onready var visuals = $Visuals

var z_velocity = 0.0
var z_height = 0.0



func get_input(delta: float):
	# 1. Handle Horizontal/Vertical Movement
	var direction := Input.get_vector("left", "right", "up", "down")

	velocity = direction * speed
	
	# 2. Handle Jump Initiation
	# We check if z_height >= 0 (on the ground) to allow the jump
	if Input.is_action_just_pressed("jump") and z_height >= 0:
		z_velocity = jump_force

	# 3. Apply Fake 3D Gravity
	# If we are in the air (z_height < 0) OR we just started jumping (z_velocity < 0)
	if z_height < 0 or z_velocity < 0:
		z_velocity += gravity_value * delta
		z_height += z_velocity * delta
		
		# Landing logic: if we fall back to or past the ground level
		if z_height > 0:
			z_height = 0
			z_velocity = 0

	# 4. Handle Animations
	if z_height < 0:
		animated_sprite.play("walk") # Or a "jump" animation
	elif direction.length() > 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	if direction.x > 0:
		visuals.scale.x = 1
	elif direction.x < 0:
		visuals.scale.x = -1
		
func _physics_process(delta: float) -> void:
	get_input(delta)

	animated_sprite.position.y = z_height
	move_and_slide()
	
signal update_health(new_health)
var health = 100

func add_health(value):
	health += value
	if health <100:
		update_health.emit(health)

func remove_health(value):
	health -= value
	if health >= 0 :
		update_health.emit(health)

func _on_addhealth_timer_timeout() -> void:
	add_health(15)
	print("+Health" + str(health))


func _on_removehealth_timer_timeout() -> void:
	remove_health(20)
	print("-Health" + str(health))

#func _input(event):
	#if event.is_action_pressed("ui_inventory"):
		#inventory_ui.visible = !inventory_ui.visible
		#get_tree().paused = !get_tree().paused
