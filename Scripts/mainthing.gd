extends Node2D

#Number of tasks
var N = 7

#Size of screen
var screenx
var screeny
signal value_updated(value)

#Size of rectangles
var rx 
var ry 

#Scaling factor
var dx = 0.9
var dy = 0.8
var scl = 0.9

#Y translation, gives space for the buttons to go
var ytransl = 90

#Questions and ansslots store the dropzones, one for the left column the 
#other for the right
var questions = []
var ansslots = []

#Stores all the tasks
var answers = []

#The name of the current activity
var activity = "tooth"

#Gets "check" and "quit" buttons 
onready var checkButton: Button = self.get_child(0) 
onready var quitButton: Button = self.get_child(1) 

#Starts the program!
func _ready():
	#Adjusts colors for background and the buttons
	VisualServer.set_default_clear_color(Color(0.407,0.447,0.470,1.0))
	quitButton.modulate = Color(0.8, 0, 0, 0.8)
	#Getting input from the global script
	N = InputControl.N
	
	#Connects to the button
	checkButton.connect("pressed", self, "anscheck")
	quitButton.connect("pressed", self, "quit")
	quitButton.visible = true
	
	#Gets the size of the viewport/screen
	screenx = get_viewport().size.x 
	screeny = get_viewport().size.y
	rx = screenx * dx / 2
	ry = dy * screeny / N
	screeny -= ytransl
	
	#Scales the buttons and adjusts positions
	var buttonscale = Vector2(2, 2)
	checkButton.rect_scale = buttonscale
	quitButton.rect_scale = buttonscale
	checkButton.rect_position = Vector2(screenx/4 - checkButton.rect_size.x * buttonscale.x / 2, ytransl/2 - checkButton.rect_size.y * buttonscale.y / 2) 
	quitButton.rect_position = Vector2(3 * screenx/4 - quitButton.rect_size.x * buttonscale.x / 2, ytransl/2 - quitButton.rect_size.y * buttonscale.y / 2)
	 
	#makes the array a certain length
	questions.resize(N)
	answers.resize(N)
	ansslots.resize(N)
	
	#Loads the dropzones in, creates instance and initiliazes them
	for i in range(N):
		questions[i] = preload("res://Scenes/DropZone.tscn").instance()
		questions[i].init( (screenx - 2 * rx)/3, ytransl + (screeny - N * ry)/(N+1) * (i) + (ry) * i, rx, ry, Color(0.847,0.945,1.0, 1.0), true)
		add_child(questions[i])
	for i in range(N):
		ansslots[i] = preload("res://Scenes/DropZone.tscn").instance()
		ansslots[i].init(rx + 2 * (screenx - 2 * rx)/3, ytransl + (screeny - N * ry)/(N+1) * (i) + (ry) * i, rx, ry, Color.blue, false)
		add_child(ansslots[i])	
	
	# Create an array of numbers from 0 to n-1 and shuffles it: this randomizes the order
	var imgorder = range(1,N+1)
	imgorder.shuffle()

	#Creates array with the names of the images
	var imgarray=[]
	for i in imgorder:
		imgarray.append(InputControl.imgarraypass[i-1])

	#Loads all the step cards in the task and initializes it
	for i in range(N):
		answers[i] = preload("res://Scenes/appsforzgood.tscn").instance()
		answers[i].init(rx / 6, ytransl + (screeny - N * ry)/(N+1) * (i+1) + (ry) * i, rx, ry, questions[i], imgarray[i], imgorder[i], scl)
		add_child(answers[i])
	for i in range(N):
		questions[i].addans(answers[i])


#Checks if the answers are correct, called when the button is pressed
func anscheck():
	#Plays a click sound
	if InputControl.soundfx:
		Clicksound.play()
		
	#Counter for counting how many answers were correct
	var counter = 0
	for i in range(N):
		#checks if the dropzone is not empty and the task inside of it is in right position
		if ansslots[i].ans != null and InputControl.imgarraypass[ansslots[i].ans.ordernum - 1] == InputControl.imgarraypass[i]:
			ansslots[i].change_color(Color.green)
			counter += 1
		else:
			ansslots[i].change_color(Color.red)
	#If everything is correct, play victory sound and change the color and text of the quit button
	if counter == N:
		quitButton.modulate = Color(0, 0.8, 0, 0.8)
		quitButton.text = "Nice job!"
		if InputControl.soundfx:
			Correctsound.play()
	else:
		quitButton.modulate = Color(0.8, 0, 0, 0.8)
		quitButton.text = "Quit"

#Code for exiting the game
func quit():
	if InputControl.soundfx:
		Clicksound.play()
	if Gamemusic.playing:
		Backgroundsound.playing = true
	Gamemusic.playing = false
	#Changes the scenes
	SceneTransition.change_scene("res://Scenes/MainScene.tscn")
	InputControl.depth = 2
	InputControl.imgarraypass = []

