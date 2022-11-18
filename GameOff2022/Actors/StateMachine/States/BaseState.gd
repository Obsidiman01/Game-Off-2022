class_name BaseState
extends Node

#__________VARIABLES__________

#EXPORTED
export (String) var animation_name

#PUBLIC
var actor: Actor
var move_vector: Vector2 = Vector2.ZERO
var states: Dictionary
var friction: int = 0

#__________FUNCTIONS__________

#PUBLIC
func init() -> void:
	pass

func enter() -> void:
	actor.play_animation(animation_name)

# warning-ignore:unused_argument
func do_action(action) -> BaseState:
	if action is String:
		return _get_state(action)
	else:
		return null

func exit() -> void:
	pass

# warning-ignore:unused_argument
func input(event: InputEvent) -> BaseState:
	return null

# warning-ignore:unused_argument
func process(delta: float) -> BaseState:
	return null

# warning-ignore:unused_argument
func physics_process(delta: float) -> BaseState:
	return null

#PRIVATE
func _face_direction(direction: int) -> void:
	actor.face_direction(direction)

func _get_state(identifier: String) -> BaseState:
	return get_node_or_null("../" + states[identifier]) as BaseState

func _do_friction() -> void:
	actor.velocity.x = move_toward(actor.velocity.x, 0, friction)

func _do_gravity(delta: float, modifier: float = 1.0) -> void:
	actor.velocity.y += (actor.gravity * modifier) * delta

func _do_motion() -> void:
	actor.velocity = actor.move_and_slide(actor.velocity, actor.UP)

func _inherit_actor_property(property: String, suffix: String = "") -> void:
	if actor.get(property):
		self.set(property.trim_suffix(suffix), actor.get(property))

