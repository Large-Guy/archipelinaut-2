extends HBoxContainer

var selected_slot = 0
var inventory: Array = ["air", "air", "air", "air", "air"]
var inventory_amounts: Array[int] = [0, 0, 0, 0, 0]

@onready var tooltip = $"../Tooltip"
@onready var anim = $"../TooltipAnim"

func _input(event: InputEvent) -> void:
	for slot in range(5):
		if event.is_action_pressed("slot_" + str(slot)):
			if selected_slot != slot:
				if inventory[slot] == "air":
					tooltip.text = ""
					if anim.is_playing(): anim.advance(2.8 - anim.current_animation_position)
				else:
					if anim.is_playing():
						anim.stop()
						anim.play("tooltip")
						anim.advance(0.1)
					else: anim.play("tooltip")
					tooltip.text = str(inventory_amounts[slot]) + "x [color=7EE3A0][wave]" + inventory[slot] + "[/wave][/color]"
			selected_slot = slot

## Pick up an amount of an item. Returns true if there's space
func pick_up(item: StringName, amount: int = 1) -> bool:
	if inventory.has(item):
		inventory_amounts[inventory.find(item)] += amount
		return true
	elif inventory.has("air"):
		inventory_amounts[inventory.find("air")] += amount
		inventory[inventory.find("air")] = item
		return true
	return false
