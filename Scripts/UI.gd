extends Node2D

# Declare member variables here. Examples:
onready var StartList = $MenuButtons/StartList
onready var Title = $Title
var items : Array = read_json_file("res://JSON/tasksList.json")
var item : Dictionary
var index_item : int = 0

# initializes list for the file names of the icons
var iconList = []
var tasklist = [] 
var tasknums = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#If the "depth" is >1, used when the game is "quit"
	if InputControl.depth >= 1:
		Title.text = "Your tasks"
		StartList.clear()
		for x in range(items.size()):
			item = items[x]
			var tasks = item.task
			StartList.add_item(tasks)
		StartList.add_item("Go Back")
		
	#Reads the JSON file, populating the taskList and tasknums arrays
	for x in range(items.size()):
		item = items[x]
		var tasks = item.task
		tasklist.append(item.task)
		tasknums.append(len(item["steps"]))

# reads the json file
func read_json_file(filename):
	var file = File.new()
	file.open(filename, file.READ)
	var text = file.get_as_text()
	var json_data = parse_json(text)
	file.close()
	return json_data

# recognizes click in the ItemList node called StartList
func _on_StartList_item_selected(index):
	#Plays click sound
	if InputControl.soundfx:
		Clicksound.play()
	#if start is clicked, displays all task names
	if (StartList.get_item_text(index) == "Start"):
		Title.text = "Your tasks"
		StartList.clear()
		for x in range(items.size()):
			item = items[x]
			var tasks = item.task
			StartList.add_item(tasks)
		StartList.add_item("Go Back")
	
	#Code for setting page
	elif (StartList.get_item_text(index) == "Settings"):
		settings()
	elif (StartList.get_item_text(index) == "Music: ON"):
		Backgroundsound.playing = false
		settings()
	elif (StartList.get_item_text(index) == "Music: OFF"):
		Backgroundsound.playing = true
		settings()
	elif (StartList.get_item_text(index) == "Sound: ON"):
		InputControl.soundfx = false
		settings()
	elif (StartList.get_item_text(index) == "Sound: OFF"):
		InputControl.soundfx = true
		settings()
	
	#Quitting the game
	elif (StartList.get_item_text(index) == "Quit"):
		get_tree().quit()
	
	#Code for "going back"
	elif (StartList.get_item_text(index) == "Go Back"):
		get_tree().change_scene("res://Scenes/MainScene.tscn")
		InputControl.depth = 0
	
	#Code for entering a game
	else:
		for i in range(len(tasklist)):
			if StartList.get_item_text(index) == tasklist[i]:
				item = items[i]
				for x in item.steps.size():
					InputControl.imgarraypass.append("res://Icons/" + item["icons"][x])
				SceneTransition.change_scene("res://Scenes/mainthing.tscn")
				InputControl.N = tasknums[i]
				#Changes the background music
				if Backgroundsound.playing:
					Gamemusic.playing = true
				Backgroundsound.playing = false

#Loads the settings page depending on whether or not music and sound are on/off
func settings():
	Title.text = "Settings"
	StartList.clear()
	if Backgroundsound.playing:
		StartList.add_item("Music: ON")
	else:
		StartList.add_item("Music: OFF")
	if InputControl.soundfx:
		StartList.add_item("Sound: ON")
	else:
		StartList.add_item("Sound: OFF")
	StartList.add_item("Go Back")

# randomizes the file names in "IconList"
func shuffleList(list):
	randomize()
	list.shuffle()
	return list

