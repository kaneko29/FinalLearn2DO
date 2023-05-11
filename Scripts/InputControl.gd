extends Node

#Global script which holds global data. Used to pass info between screens
#Also used for the settings page

#Number of steps for a task
var N

#Array with the names for images used for a task
var imgarraypass = []

#"Depth" is used for going back/quitting 
var depth = 0

#Music on for settings
var music_on = true

#Sound on for settings
var soundfx = true




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func sayhi():
	print("hello")
