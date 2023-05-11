extends Position2D

#idk what these are for but they needed i think
signal correct()
export var correct = false

#Position of the dropzone
var pos = Vector2(300, 0)

#Dimensions of the dropzones
var xrect = 200
var yrect = 100

#Is it occupied by a task?
var occupied = false

#The current task occupying it if any
var ans = null

#Color of dropzone
var color 

#initializes with inputs
func init(xp, yp, xval, yval, C, occ):
	pos[0] = xp
	pos[1] = yp
	xrect = xval
	yrect = yval
	color = C
	occupied = occ

#Sets a task (only used in the beginning of the code)
func addans(answer):
	ans = answer

#Draws the rect
func _draw():
	draw_rect(Rect2(Vector2(pos[0], pos[1]), Vector2(xrect, yrect)), color)
	modulate.a = 0.1
	
#idk what this does but its needed
func select():
	if correct:
		emit_signal("correct")

#Changes the color, used for setting it green or red
func change_color(c):
	color = c
	update()




