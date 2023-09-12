extends CharacterBody2D

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var dead_state : DeadState = $CharacterStateMachine/DeadState
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector : Node2D = $WallDetector
@onready var player_particles: Node2D = $PlayerParticles
@onready var health_component: HealthComponent = $HealthComponent
@onready var interact_component: InteractComponent = $InteractComponent
@onready var directions2D : Directions2D = $Directions2D

func _ready():
	health_component.dead.connect(func(): state_machine.travel_to(dead_state))
	
func _physics_process(delta: float):
	move_and_slide()
	interact_component.check_interactables()
	health_component.process_invincibility(delta)
