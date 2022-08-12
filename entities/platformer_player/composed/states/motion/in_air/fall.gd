extends 'in_air.gd'

export (float) var terminal_velocity := 200.0


func update(delta):
	velocity.y = min(velocity.y, terminal_velocity)
	.update(delta)
