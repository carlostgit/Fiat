extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String) var _product_type = "Candy"
export(Texture) var _product_texture

var _production_rate = 1

var _owned_products:float = 0
var _products_in_market:float = 0
var _owned_money:float = 0
var _money_in_market:float = 0

var _consumed_products:float = 0

signal signal_candies_in_market(amount, factory)
signal signal_chocolates_in_market(amount, factory)
signal signal_money_in_market(amount, factory)
signal signal_money_to_government(amount,factory)



#var _product_price = 1
#var _tax_rate = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Product.set_texture(_product_texture)
	
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

####

func produce():
	produce_amount(_production_rate)

####

func buy():
	
#	update_product_price()
	var products_in_market = _products_in_market
	var value_of_products_in_market = Globals._product_price*products_in_market
	var money_for_taxes_in_products_sold = value_of_products_in_market*Globals._tax_rate
	var money_obtained_from_products = value_of_products_in_market - money_for_taxes_in_products_sold
	
	var money_in_market = _money_in_market
	var money_for_taxes_in_products_bought = money_in_market*Globals._tax_rate
	var amount_of_product_money_can_buy = money_in_market/Globals._product_price
	
	#todo: set money obtained from products
	add_owned_money(money_obtained_from_products)
	remove_products_from_market(_products_in_market)
	
#	var money_for_taxes_in_products_bought = _money_in_market*Globals._tax_rate
#	var money_to_buy = _money_in_market - money_for_taxes_in_products_bought
#	var amount_of_product_bought = money_to_buy/Globals._product_price
	#todo: set amount of products bought
	
	add_consumed_products(amount_of_product_money_can_buy)
	remove_money_from_market(money_in_market)
	send_money_to_government(money_for_taxes_in_products_bought)
	


####

func get_total_value_in_market():
	var value_of_products_in_market = Globals._product_price*_products_in_market
	var total_value_in_market = value_of_products_in_market + _money_in_market
	return total_value_in_market
	
####

#func update_product_price():
#	#TODO
#	pass
	
####

func add_owned_products(amount_arg:float):
	set_owned_products(_owned_products + amount_arg)

func set_owned_products(amount_arg:float):
	_owned_products = amount_arg
	$Product/OwnedProduct.set_text(str(_owned_products))
	
func produce_amount(amount_arg:float):
	 set_owned_products(_owned_products+amount_arg)
	
func empty_owned_products():
	set_owned_products(0.0)
####

func send_all_products_to_market():
	send_products_to_market(_owned_products)
	
func send_products_to_market(amount_arg:float):
	set_products_in_market(_products_in_market + amount_arg)
	set_owned_products(_owned_products - amount_arg)
	
func get_products_in_market() -> float:
	return _products_in_market
	
func get_chocolates_in_market()->float:
	if(self._product_type=="Candy"):
		return 0.0
	else:
		return get_products_in_market()

func get_candies_in_market()->float:
	if(self._product_type=="Candy"):
		return get_products_in_market()
	else:
		return 0.0
	
func set_products_in_market(amount_arg:float):
	_products_in_market = amount_arg
	$Product/ProductsInMarket.set_text(str(_products_in_market))
	if ("Candy"==_product_type):
		emit_signal("signal_candies_in_market",_products_in_market,self)
	else:
		emit_signal("signal_chocolates_in_market",_products_in_market,self)	
#func empty_products_in_market():
#	set_products_in_market(0.0)

func remove_products_from_market(amount_arg:float):
	set_products_in_market(_products_in_market-amount_arg)




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

func empty_money_in_market():
	set_products_in_market(0.0)

func get_money_in_market()->float:
	return _money_in_market
####


func add_owned_money(amount_arg:float):
	set_owned_money(_owned_money + amount_arg)
	
func set_owned_money(amount_arg:float):
	_owned_money = amount_arg
	$Bill/OwnedBills.set_text(str(_owned_money))
	
####

func send_money_to_government(amount_arg:float):
	emit_signal("signal_money_to_government",amount_arg,self)

####

func add_consumed_products(amount_arg:float):
	set_consumed_products(_consumed_products + amount_arg)
	
func set_consumed_products(amount_arg:float):
	_consumed_products = amount_arg
	$ConsumingProduct/OwnedChocolatesAndCandies.set_text(str(amount_arg))

####

func _on_ProduceButton_pressed():
	produce()
#	pass # Replace with function body.

func _on_SendProductsToMarketButton_pressed():
	send_all_products_to_market()
#	pass # Replace with function body.

func _on_SendMoneyToMarketButton_pressed():
	send_all_money_to_market()
#	pass # Replace with function body.

func _on_BuyButton_pressed():
	buy()
#	pass # Replace with function body.

	
	
