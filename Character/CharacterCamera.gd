extends Camera3D
class_name CharacterCamera

var cameraFovTarget : float
var originalCameraFov : float

@export_category("Config")
@export var fovChangeSpeed : float = 6.0

func _ready():
	cameraFovTarget = fov
	originalCameraFov = fov

func _process(delta):
	fov = lerp(fov, cameraFovTarget, delta * fovChangeSpeed)

func setFovTarget(inFovMult : float, shouldAnimate : bool = true):
	cameraFovTarget = inFovMult * originalCameraFov
	
	if !shouldAnimate:
		fov = inFovMult * originalCameraFov

func resetFov(shouldAnimate : bool = true):
	cameraFovTarget = originalCameraFov
	
	if !shouldAnimate:
		fov = cameraFovTarget
