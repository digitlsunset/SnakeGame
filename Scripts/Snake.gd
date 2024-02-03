extends Node2D

const bodyPart : PackedScene = preload("res://Scenes/BodyPart.tscn")

const POS_MIN = 0
const POS_MAX = 9
var bugPos : Vector2i = Vector2i(-1, -1)
var snakePos : Array[Vector2i] = [Vector2i(0, 0)]
var snakeLength : int = 1
var direction : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnBug()
	Redraw()

func SpawnBug():
	bugPos = Vector2i(randi_range(POS_MIN, POS_MAX), randi_range(POS_MIN, POS_MAX))
	if bugPos in snakePos:
		SpawnBug()

func GetPos(index : int):
	return (51 * index) + 26

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_up"):
		if snakeLength > 1:
			direction = 0 if Vector2i(snakePos[0].x, snakePos[0].y - 1) != snakePos[1] else direction 
		else:
			direction = 0

	elif event.is_action_pressed("ui_down"):
		if snakeLength > 1:
			direction = 1 if Vector2i(snakePos[0].x, snakePos[0].y + 1) != snakePos[1] else direction
		else:
			direction = 1

	elif event.is_action_pressed("ui_left"):
		if snakeLength > 1:
			direction = 2 if Vector2i(snakePos[0].x + 1, snakePos[0].y) != snakePos[1] else direction
		else:
			direction = 2

	elif event.is_action_pressed("ui_right"):
		if snakeLength > 1:
			direction = 3 if Vector2i(snakePos[0].x - 1, snakePos[0].y) != snakePos[1] else direction
		else:
			direction = 3

func Move():
	var pos = snakePos[0]
	var addingPos : Vector2i = Vector2i(-1, -1)
	match direction:
		0: # Up
			addingPos = Vector2i(pos.x, pos.y - 1)
			pass
		1: # Down
			addingPos = Vector2i(pos.x, pos.y + 1)
			pass
		2: # Left
			addingPos = Vector2i(pos.x - 1, pos.y)
			pass
		3: # Right
			addingPos = Vector2i(pos.x + 1, pos.y)
			pass
	var body = snakePos.duplicate()
	body.pop_back()
	if addingPos in body or (addingPos.x < POS_MIN or addingPos.y < POS_MIN) or (addingPos.x > POS_MAX or addingPos.y > POS_MAX):
		$MoveTimer.stop()
		$Fail/ScoreLabel.text += str(snakeLength)
		$Fail.visible = true
	snakePos.push_front(addingPos)
	if addingPos == bugPos:
		snakeLength += 1
		SpawnBug()
	snakePos.resize(snakeLength)
	Redraw()

func Redraw():
	var body = $Body.get_children()
	for segment in body:
		segment.queue_free()
	
	$Bug.position.x = GetPos(bugPos.x)
	$Bug.position.y = GetPos(bugPos.y)
	
	for segment in snakePos:
		if segment == snakePos.front():
			$Head.position.x = GetPos(segment.x)
			$Head.position.y = GetPos(segment.y)
			continue
		var newPart = bodyPart.instantiate()
		newPart.position.x = GetPos(segment.x)
		newPart.position.y = GetPos(segment.y)
		$Body.add_child(newPart)


func MainMenuPressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
