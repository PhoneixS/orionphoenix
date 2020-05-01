extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var colsNum: int = 100
export var colsWidth: float = 16.0
export var rowsNum: int = 100
export var rowsHeight: float = 16.0
export var lineWidth: float = 1.0
export var lineColor: Color = Color(0.5, 0.5, 0.5, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var maxHeight = rowsNum * rowsHeight
	var maxWidth = colsNum * colsWidth
	
	for i in range(colsNum + 1):
		var line = Line2D.new()
		line.width = lineWidth
		line.default_color = lineColor
		line.add_point(Vector2(i * colsWidth, 0))
		line.add_point(Vector2(i * colsWidth, maxHeight))
		add_child(line)
		
	for i in range(rowsNum + 1):
		var line = Line2D.new()
		line.width = lineWidth
		line.default_color = lineColor
		line.add_point(Vector2(0, i * rowsHeight))
		line.add_point(Vector2(maxWidth, i * rowsHeight))
		add_child(line)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
