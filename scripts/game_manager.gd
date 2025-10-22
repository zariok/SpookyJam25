extends Node

var coins = 0
var goblets = 0
var diamonds = 0

func add_coin():
	coins += 1
	print("Coin: " + str(coins))

func add_goblet():
	goblets += 1
	print("Goblet: " + str(goblets))

func add_diamond():
	diamonds += 1
	print("Diamond: " + str(diamonds))
