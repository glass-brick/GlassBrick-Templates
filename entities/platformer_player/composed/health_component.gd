extends Node
class_name HealthComponent

const AuraShader = preload("res://shaders/aura_shader.gdshader")

signal dead
signal invincibility_finished

@export var health := 100

@export var invincibility_time := 0.5
var invincibility_counter = 0.0
var invincibility = false

func on_hit(attack: AttackResource):
	if not invincibility:
		set_health(health - attack.damage)
		invincibility = true

func set_health(new_health):
	health = max(new_health, 0)
	if health == 0:
		dead.emit()

func process_invincibility(delta):
	if invincibility:
		invincibility_counter += delta
		get_parent().material.set_shader_parameter("active", true)
		if invincibility_counter > invincibility_time:
			invincibility = false
			invincibility_finished.emit()
	else:
		invincibility_counter = 0
		get_parent().material.set_shader_parameter("active", false)
