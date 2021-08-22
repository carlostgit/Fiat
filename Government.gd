extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var _factory_node_path_1
export(NodePath) var _factory_node_path_2

var _owned_money:float = 1
var _money_in_market:float = 0
var _consumed_products:float = 0

#var _product_price = 1
#var _tax_rate = 0.2

signal signal_remove_products_from_market(amount,government)
signal signal_money_in_market(amount,government)
# Called when the node enters the scene tree for the first time.
func _ready():
	var factory1 = get_node(_factory_node_path_1)
	factory1.connect("signal_money_to_government",self,"on_money_to_government")
#	pass # Replace with function body.
	var factory2 = get_node(_factory_node_path_2)
	factory2.connect("signal_money_to_government",self,"on_money_to_government")
#	pass # Replace with function body.
	
	set_owned_money(self._owned_money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

####

func on_money_to_government(amount_arg:float, factory_arg):
	set_owned_money(_owned_money+amount_arg)

func set_owned_money(amount_arg:float):
	_owned_money = amount_arg
	$Bill/OwnedBills.set_text(str(_owned_money))

####

func send_all_money_to_market():
	send_money_to_market(_owned_money)
	
func send_money_to_market(amount_arg:float):
	set_money_in_market(_money_in_market + amount_arg)
	set_owned_money(_money_in_market - amount_arg)
	
func set_money_in_market(amount_arg:float):
	_money_in_market = amount_arg
	$Bill/BillsInMarket.set_text(str(_money_in_market))
	emit_signal("signal_money_in_market",_money_in_market,self)

func remove_money_from_market(amount_arg:float):
	set_money_in_market(_money_in_market-amount_arg)

func get_money_in_market()->float:
	return _money_in_market

####

func remove_products_from_market(amount_arg:float):
	emit_signal("signal_remove_products_from_market", amount_arg,self)
#	set_products_in_market(_products_in_market-amount_arg)

func get_products_in_market()->float:
	return 0.0

func get_chocolates_in_market()->float:
	return 0.0

func get_candies_in_market()->float:
	return 0.0

####


func add_consumed_products(amount_arg:float):
	set_consumed_products(_consumed_products + amount_arg)
	
func set_consumed_products(amount_arg:float):
	_consumed_products = amount_arg
	$ConsumingProducts/OwnedChocolatesAndCandies.set_text(str(amount_arg))
####

func _on_SendMoneyToMarketButton_pressed():
	send_all_money_to_market()
#	pass # Replace with function body.

####

func buy():
	
	var money_in_market = _money_in_market
	var money_for_taxes_in_products_bought = money_in_market*Globals._tax_rate
	var amount_of_product_bought = money_in_market/Globals._product_price
	
	#todo: set amount of products bought
	add_consumed_products(amount_of_product_bought)
	remove_money_from_market(_money_in_market)
	send_money_to_government(money_for_taxes_in_products_bought)
	
func _on_BuyButton_pressed():
	buy()
	
#	pass # Replace with function body.

####
func send_money_to_government(amount_arg:float):
	set_owned_money(_owned_money+amount_arg)


func add_owned_money(amount_arg:float):
	set_owned_money(self._owned_money + amount_arg)

func _on_CreateMoney_pressed():
	var param_amount_to_add:float = 1
	add_owned_money(param_amount_to_add)
	
