extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _product_price = 1
var _tax_rate = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_price_without_taxes()->float:
	return (1-_tax_rate)*_product_price

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
