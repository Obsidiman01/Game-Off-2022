class_name Marble
extends RigidBody2D
#__________ENUMS__________
enum BALL_COLORS {
	random,
	blue,
	green,
	purple,
	yellow
}

#__________VARIABLES__________

#EXPORTED
export (BALL_COLORS) var marble_color
export (Dictionary) var texture_list = {
	"blue": Texture,
	"green": Texture,
	"purple": Texture,
	"yellow": Texture,
}

#PRIVATE
var _spawn_cooldown_complete: bool = false

#ONREADY
onready var ball_sprite = $BallSprite
onready var gloss_sprite = $GlossSprite
onready var hover = $HoverRayCast
onready var sparkle = $SparkleMedium

#__________FUNCTIONS__________

#BUILT-IN
func _ready() -> void:
	randomize()
	if marble_color == BALL_COLORS.random:
		ball_sprite.texture = texture_list.values()[randi() % texture_list.values().size()]
	else:
		ball_sprite.texture = texture_list.get(marble_color)
	

func _physics_process(delta) -> void:
	gloss_sprite.global_rotation_degrees = 0
# warning-ignore:integer_division
	ball_sprite.global_rotation_degrees = (int(self.global_rotation_degrees + 180) / 45) * 45
	hover.global_rotation_degrees = 0
	sparkle.global_rotation_degrees = 0
	
	if _spawn_cooldown_complete:
		if hover.is_colliding() && hover.get_collider() is TileMap:
			var point_dist = self.global_position.distance_to(hover.get_collision_point())
			linear_damp = 0
			if abs(linear_velocity.y) > 10:
				linear_velocity.y = move_toward(linear_velocity.y, 10 * (1 if linear_velocity.y > 0 else -1), 10 * delta)
			linear_velocity.x = move_toward(linear_velocity.x, 0, delta)
			angular_damp = 0
			angular_velocity = move_toward(angular_velocity,  PI * (1 if angular_velocity > 0 else -1), 2 * delta)
			gravity_scale = 0.05
			if point_dist <= 16:
				apply_central_impulse((Vector2.UP * 100 / max(point_dist - 8, 1)) * delta)
		else:
			angular_damp = -1
			linear_damp = -1
			gravity_scale = 1

#PRIVATE


func _on_Timer_timeout():
	_spawn_cooldown_complete = true
