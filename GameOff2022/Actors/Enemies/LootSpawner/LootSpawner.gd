class_name LootSpawner
extends Node2D

#__________SIGNALS__________
signal loot_dropped

#__________FUNCTIONS__________

#PUBLIC
func serve_loot(table_path: String) -> void:
	randomize()
	
	var table = load(table_path).loot
	var loot_stash: Array = []
	
	for key in table:
		var item_path = key
		
		var q = table[key]
		var item_min = q.x
		var item_max = q.y
		var item_weight = q.z
		
		var quantity: int = int(round(rand_range(item_min, item_max)))
		
		for _i in quantity:
			if item_weight >= randf():
				loot_stash.append(item_path)
	
	for item_path in loot_stash:
		var item = load(item_path).instance()
		
		get_parent().add_child(item)
		item.global_position = self.global_position
		item.call_deferred("apply_central_impulse", _random_launch_vector())
	
	emit_signal("loot_dropped")

#PRIVATE
func _random_launch_vector() -> Vector2:
	
	var x = (randf() - 0.5) * 0.5
	var y = -randf()
	var force = rand_range(90, 160)
	return Vector2(x, y).normalized() * force
