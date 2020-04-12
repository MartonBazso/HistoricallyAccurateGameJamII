extends Spatial

const cutSceneResource = preload("res://Cutscene.tscn")

var NPC_NBR = globals.dictionary[globals.current_level][1]
var hit_npc = 0
var rng = RandomNumberGenerator.new()

func _ready():
	get_tree().paused = true;
	if globals.current_level > 3:
		$Path.translation.y = 4
	$EndgameArea.connect("endgame_area_entered", self, "_on_EndGameArea_endgame_area_entered")
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.wait_time = globals.dictionary[globals.current_level][0]
	$AnimationPlayer.connect("animation_started", self, "_on_AnimationPlayer_animation_started")
	$AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	_instanciate_npcs()
	_set_label(str(hit_npc) + "/" + str(NPC_NBR))
	


func _instanciate_npcs():
	for i in range(NPC_NBR):  	
		var path = PathFollow.new()
		path.rotation_mode = PathFollow.ROTATION_ORIENTED
		var human = load("Human.tscn").instance()
		human.connect("human_hit", self, "_on_Human_Hit")
		path.add_child(human)
		$Path.add_child(path)
		path.unit_offset = ((1/NPC_NBR) * i) * rng.randf_range(0.5,0.9)

func _process(delta):
	var time = str($Timer.time_left)
	var time_left = time.substr(0, time.length() - 4)
	$UserInterface/VBoxContainer/TIMER.text = time_left

func _physics_process(delta):
	for path in $Path.get_children():
		path.offset += delta * 5


func _on_Human_Hit():
	if hit_npc < NPC_NBR:
		hit_npc += 1
		_set_label(str(hit_npc) + "/" + str(NPC_NBR))	

func _set_label(var text):
	$UserInterface/VBoxContainer/NPC_HIT.text = text

func _on_Timer_timeout():
	get_tree().paused = true
	_instantiate_cutscene("You lose\n No more time left", false)

func _on_EndGameArea_endgame_area_entered():
	if hit_npc == NPC_NBR:
		get_tree().paused = true
		_instantiate_cutscene("You win", true)
	else:
		$UserInterface/MissingRequirements/MessageTimer.start()
		$UserInterface/MissingRequirements.visible = true

func _instantiate_cutscene(var text, var win):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var cutSceneInstance= cutSceneResource.instance()
	cutSceneInstance.set_text(text)
	cutSceneInstance.next_lvl_button_on(win)
	self.add_child(cutSceneInstance)

func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.start()
	if globals.current_level == 0:
		$TutorialLabel.visible = true
	get_tree().paused = false; # Replace with function body.


func _on_AnimationPlayer_animation_started(anim_name):
	get_tree().paused = true; 
