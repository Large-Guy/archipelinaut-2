extends CharacterBody2D

@export var speed : float
@onready var animTree = $AnimationTree
@onready var player_sprite = $PlayerSprite
@onready var player_reflection_sprite = $PlayerSpriteReflection

var facing_last = 1
@onready var scale_ref = player_sprite.scale

var waddle_target = 0.0

func _physics_process(_delta: float) -> void:
	# Main movement 
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movement_direction * speed
	move_and_slide()
	
	# Change direction the character is facing
	var facing_dir = movement_direction.sign().x
	if facing_dir != 0 && facing_dir != facing_last:
		facing_last = facing_dir
		var turn_tween = get_tree().create_tween()
		turn_tween.tween_property(player_sprite, "scale:x", facing_last * scale_ref.x, 0.12)
		turn_tween.parallel().tween_property(player_reflection_sprite, "scale:x", facing_last * scale_ref.x, 0.12)
	
	# Play bobbing animation if moving
	if velocity != Vector2.ZERO:
		waddle_target = 0.0
	else:
		waddle_target = 1.0
	
	var waddle_tween = get_tree().create_tween()
	waddle_tween.tween_property(animTree, "parameters/walk_idle/blend_amount", waddle_target, 0.1)
