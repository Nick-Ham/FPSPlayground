extends Node3D
class_name CharacterNeck

var neckHeightTarget : float
var originalNeckHeight : float

@export_category("Config")
@export var heightChangeSpeed : float = 6.0

func _ready():
	neckHeightTarget = position.y
	originalNeckHeight = position.y

func _process(delta):
	position.y = lerp(position.y, neckHeightTarget * originalNeckHeight, delta * heightChangeSpeed)

func setHeightTarget(inHeightTarget : float, shouldAnimate : bool = true):
	neckHeightTarget = inHeightTarget
	
	if !shouldAnimate:
		position.y = neckHeightTarget

func resetHeight(shouldAnimate : bool = true):
	neckHeightTarget = originalNeckHeight
	
	if !shouldAnimate:
		position.y = neckHeightTarget
