extends CharacterBody3D
class_name PlayerCharacterTest

@export_category("Config")
@export var maxSpeed : float = 2.0
@export var acceleration : float = 2200.0
@export var maxSpeedEnforcement : float = 10
@export var airMovementModifier : float = 0.7
@export var friction : float = 300.0
@export var jumpVelocity : float = 4.5
@export var coyoteFrames : int = 3

@export_group("Sprint")
@export var sprintSpeed : float = 2.3
@export var sprintAcceleration : float = 2200.0
@export var sprintFovEnabled : bool = false
@export var sprintFovMod : float = 1.1
@export var sprintFovTransitionSpeed : float = 6.0


const MOUSE_SENSITIVITY_CONST = .001

@export_category("MouseSensitivity")
@export var mouseSensitivity : float = 2.0

@export_subgroup("IndividualAxisSensitivity")
@export var horizontalSensitivity : float = 1.0
@export var verticalSensitivity : float = 1.0

@export_category("Built-In")
@export var Head : Node3D
@export var Neck : Node3D
@export var HeadBob : PeriodicShifter
@export var HeadTilt : HeadTilter
@export var Camera : Camera3D

@onready var cameraDefaultFov = Camera.fov
var isCoyoteTime : bool = false
var isSprinting : bool = false
var coyoteTimeCounter : int = 0
var currentStrafeAmount : float = 0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY_CONST * mouseSensitivity * horizontalSensitivity)
		Neck.rotate_x(-event.relative.y * MOUSE_SENSITIVITY_CONST * mouseSensitivity * verticalSensitivity)
		Neck.rotation.x = clamp(Neck.rotation.x, -PI/2.0, PI/2.0)

func _process(delta):
	if sprintFovEnabled:
		var targetFov = cameraDefaultFov * sprintFovMod if isSprinting else cameraDefaultFov
		Camera.fov = lerp(Camera.fov, targetFov, delta * sprintFovTransitionSpeed)

func _physics_process(delta):
	
	updateCoyoteTime()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or isCoyoteTime):
		velocity.y = jumpVelocity
	
	isSprinting = Input.is_action_pressed("Sprint")
	
	var inputDirection = Input.get_vector("Left", "Right", "Forward", "Backward")
	currentStrafeAmount = inputDirection.x
	
	var direction = (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
	if !direction.is_zero_approx() && is_on_floor():
		HeadBob.update(delta)
	
	HeadTilt.update(delta, currentStrafeAmount)
	
	velocity = calculateNewVelocity(direction, velocity, delta)
	
	velocity = limitVelocityPlanar(velocity, delta)
	
	if is_on_floor():
		velocity = applyFrictionPlanar(velocity, delta)
	
	move_and_slide()
	
	handleCollision()

func isStrafing() -> bool:
	return !(is_zero_approx(currentStrafeAmount) or is_on_wall())

func handleCollision():
	# PLACEHOLDER
	
	var collision = get_last_slide_collision()
	
	if !collision:
		return
	
	var collider = collision.get_collider() as RigidBody3D
	
	if !collider:
		return
	
	var collisionForce = -(collision.get_position() - collision.get_collider().global_position)
	
	collider.apply_impulse(collisionForce, collision.get_position())

func calculateNewVelocity(inDirection : Vector3, inVelocity : Vector3, delta : float) -> Vector3:
	var addedVelocity = Vector3()
	if inDirection:
		addedVelocity.x += inDirection.x * getAcceleration() * delta * delta
		addedVelocity.z += inDirection.z * getAcceleration() * delta * delta
	
	if !is_on_floor():
		addedVelocity *= airMovementModifier
	
	return addedVelocity + inVelocity

func applyFrictionPlanar(inVelocity : Vector3, delta : float) -> Vector3:
	var frictionDirection = -inVelocity.normalized()
	var length = inVelocity.length()
	var speedMultiplier = (length / getMaxSpeed()) + 1
	var outVelocity = frictionDirection * friction * speedMultiplier * delta * delta
	
	return outVelocity + inVelocity

func limitVelocityPlanar(inVelocity : Vector3, delta : float) -> Vector3:
	var velocity2D = Vector2(inVelocity.x, inVelocity.z)
	velocity2D = lerp(velocity2D, velocity2D.limit_length(getMaxSpeed()), maxSpeedEnforcement * delta)
	var resultant = Vector3(velocity2D.x, inVelocity.y, velocity2D.y)
	
	return resultant

func updateCoyoteTime() -> void:
	if is_on_floor():
		coyoteTimeCounter = 0
		isCoyoteTime = false
	else:
		if coyoteTimeCounter < coyoteFrames:
			isCoyoteTime = true
		else:
			isCoyoteTime = false
		coyoteTimeCounter += 1

func getMaxSpeed() -> float:
	return sprintSpeed if isSprinting else maxSpeed

func getAcceleration() -> float:
	return sprintAcceleration if isSprinting else acceleration
