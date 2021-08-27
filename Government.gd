extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Consumer._production_rate = 0
	$Consumer/Product.hide()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

####

func get_consumer() -> Node:
	return $Consumer

func buy():
	$Consumer.buy()	
#	var money_in_market:float = $Consumer._money_in_market
#	$Consumer._shop.buy_candies(money_in_market/2,$Consumer)
#	$Consumer._shop.buy_chocolates(money_in_market/2,$Consumer)
	
func _on_BuyButton_pressed():
	buy()
#
#func send_money_to_government(amount_arg:float):
#	$Consumer.set_owned_money($Consumer._owned_money+amount_arg)

func _on_CreateMoney_pressed():
	var param_amount_to_add:float = 1
	$Consumer.add_owned_money(param_amount_to_add)

func _on_Buy_pressed():
	var money_in_market:float = $Consumer._money_in_market
	$Consumer._shop.buy_candies(money_in_market/2,$Consumer)
	$Consumer._shop.buy_chocolates(money_in_market/2,$Consumer)
	
func _on_SendMoneyToMarketButton_pressed():
	$Consumer.send_all_money_to_market()
