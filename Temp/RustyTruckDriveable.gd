extends VehicleBody3D
class_name DriveableVehicle

@export var maxSteer : float = 0.6
@export var steerSpeed : float = 1.5
@export var enginePower : float = 650

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var steerDirection = -Input.get_axis("Left", "Right")
	var enginePowerDirection = Input.get_axis("Forward", "Backward")
	
	steering = move_toward(steering, steerDirection * maxSteer, delta * steerSpeed)
	engine_force = enginePowerDirection * enginePower 
	
