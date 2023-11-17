extends RigidBody3D
class_name RigidBodyCharacter

@export var movementForce : float = 25000
@export var spinForce : float = 300
@export var playerMass : float = 500
@export var clickMass : float = 10

@export var Joint : Generic6DOFJoint3D

func _ready():
	mass = playerMass

func _physics_process(delta):
	var direction = Input.get_vector("Right", "Left", "Forward", "Backward")
	var direction3D = Vector3.FORWARD * direction.y + Vector3.RIGHT * direction.x
	
	if Input.is_action_pressed("Click"):
		self.mass = clickMass
	else:
		self.mass = playerMass
		apply_force(direction3D * movementForce, Vector3())
	
	

