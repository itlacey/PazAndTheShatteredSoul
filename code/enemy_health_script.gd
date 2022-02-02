extends Area2D

var vine_man_health = 4 
var vine_man_health_purple = 6 
var rat_health = 2
onready var vine_man = self.get_owner()
onready var sprite = get_node("../AnimatedSprite")
onready var _animated_sprite = get_node("../AnimatedSprite/AnimationPlayer")
onready var state_machine =  get_node("../AnimationTree").get("parameters/playback")


func do_damage(hit_points):
	sprite.modulate = Color( 1, 0, 0, 1 )
	vine_man_health = vine_man_health - hit_points
	if vine_man_health <= 0 :
		sprite.modulate = Color( 1, 1, 1, 1 )
		state_machine.travel("die")
		yield(get_tree().create_timer(.9), "timeout")
		vine_man.queue_free()
	yield(get_tree().create_timer(.1), "timeout")
	sprite.modulate = Color( 1, 1, 1, 1 )


