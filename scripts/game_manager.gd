extends Node

var collectables = {"coin":0, "goblet":0, "diamond":0}

func add_collectable(type: String):
	if type not in collectables:
		print("UNKNOWN collectable - " + type)
		return
	collectables[type] += 1
	print(type + ": " + str(collectables[type]))
	


func you_died():
	print("You have perished.")
	for k in collectables:
		collectables[k] = 0
	
