class_name Actor
extends KinematicBody2D

#__________SIGNALS__________
signal invulnerable_changed
signal died

#__________CONSTANTS__________

const UP = Vector2.UP

#__________VARIABLES__________

#EXPORTED
export (int) var max_speed = 50
export (int) var move_speed = 100
export (int) var move_speed_air = 50
export (int) var friction = 5
export (int) var friction_air = 1
export (int) var jump_force = 100

export (int) var base_attack_damage = 1
export (int) var base_max_health = 3
export (float) var knockback_resistance = 0.0
export (float) var stun_duration = 1.0
export (float) var invulnerable_duration = 1.0

#PUBLIC
var velocity: Vector2
var can_move: bool = true
var max_health: int = base_max_health
var health: int = max_health

#PRIVATE
var _alive: bool = true

#ONREADY
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")
onready var animation: AnimationPlayer = $AnimationPlayer
onready var state_machine := $StateMachine

#__________FUNCTIONS__________

#BUILT-IN
func _ready() -> void:
	state_machine.fsm_init(self)

func _process(delta) -> void:
	state_machine.process(delta)

func _physics_process(delta) -> void:
	state_machine.physics_process(delta)

#PUBLIC
func play_animation(animation_name) -> void:
	if animation:
		animation.play(animation_name)

func face_direction(direction: int) -> void:
	if direction < 0:
		scale.y = -1
		rotation_degrees = 180
	elif direction > 0:
		scale.y = 1
		rotation_degrees = 0

func do_action(action) -> bool:
	return state_machine.do_action(action)

func deal_damage(target_hurtbox: Area2D = null) -> void:
	if target_hurtbox.has_method("take_damage"):
		target_hurtbox.take_damage(_calculate_damage_to_deal(), self)

func take_damage(amount: int = 0, source = null) -> void:
	_take_knockback_from_damage(amount, source)
	
	if invulnerable_duration > 0:
		_do_invulnerability()
	
	if stun_duration > 0:
# warning-ignore:return_value_discarded
		do_action("stunned")
	
	health -= amount
	if health <= 0:
		_die()

func get_hitbox_active_state() -> Array:
	var children = get_children()
	var state: Array = []
	for child in children:
		if child.get("monitoring") != null:
			state.append(child.monitoring)
	
	return state

func set_hitbox_active_state(state: Array) -> void:
	var children = get_children()
	for child in children:
		if child.get("monitoring") != null:
			child.set_deferred("monitoring", state.pop_front())

func deactivate_hitbox() -> void:
	var children = get_children()
	for child in children:
		if child.get("monitoring") != null:
			child.set_deferred("monitoring", false)

func destroy_attack_boxes() -> void:
	for child in get_children():
		if child.has_method("take_damage") || child.has_method("_is_own_hurtbox"):
			child.queue_free()

#PRIVATE
func _calculate_damage_to_deal() -> int:
	return base_attack_damage

func _take_knockback_from_damage(damage_amount: int, source) -> void:
	var direction = source.global_position.direction_to(self.global_position).normalized()
	if direction.y > 0:
		direction.y = -direction.y
	direction.y -= 0.3
	
	var force = 100 * sqrt(damage_amount) + 30
	force = force * (-knockback_resistance + 1)
	
	self.velocity = Vector2.ZERO
# warning-ignore:return_value_discarded
	move_and_slide(Vector2.UP, Vector2.UP)
	direction = direction.normalized()
	
	self.velocity += (direction * force)

func _die() -> void:
	_alive = false
# warning-ignore:return_value_discarded
	do_action("dead")
	emit_signal("died")

func _do_invulnerability() -> void:
	_set_invulnerable(true)
	emit_signal("invulnerable_changed", true)
	yield(get_tree().create_timer(invulnerable_duration), "timeout")
	emit_signal("invulnerable_changed", false)
	_set_invulnerable(false)

func _set_invulnerable(value: bool) -> void:
	for child in get_children():
		if child.get("monitorable") != null:
			child.set_deferred("monitorable", !value)
