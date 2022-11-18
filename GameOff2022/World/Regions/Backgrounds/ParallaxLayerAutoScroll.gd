class_name ParallaxLayerAutoScroll
extends ParallaxLayer

#__________VARIABLES__________

#EXPORTED
export (Vector2) var scroll_rate

#__________FUNCTIONS__________

#BUILT-IN
func _process(delta) -> void:
	motion_offset += scroll_rate * delta

