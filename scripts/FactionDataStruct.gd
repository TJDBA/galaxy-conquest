# File: scripts/FactionDataStruct.gd
extends Resource

class_name FactionDataStruct

# Properties
@export var player_id: String                   # ID of the player who owns the faction
@export var faction_name: String = "New Faction"  # Name of the faction
@export var faction_symbol: String = "XXX"        # Faction symbol (3 characters)

# Encountered factions and their hostility status
# Dictionary format: {"faction_id": "hostility_status"} where hostility_status can be "neutral", "friendly", "hostile"
@export var encountered_factions: Dictionary = {}

# Current resource points
@export var resource_points: int = 0

# Methods

# Add a new encountered faction with initial hostility status
func add_encountered_faction(faction_id: String, status: String = "neutral"):
	if not encountered_factions.has(faction_id):
		encountered_factions[faction_id] = status

# Update hostility status towards an encountered faction
func update_hostility_status(faction_id: String, status: String):
	if encountered_factions.has(faction_id):
		encountered_factions[faction_id] = status
	else:
		print("Faction %s not found in encountered factions." % faction_id)

# Get the current hostility status towards an encountered faction
func get_hostility_status(faction_id: String) -> String:
	if encountered_factions.has(faction_id):
		return encountered_factions[faction_id]
	return "unknown"  # Return "unknown" if faction hasn't been encountered

# Add resource points to the current total
func add_resource_points(amount: int):
	resource_points += amount

# Remove resource points from the current total, ensuring it does not go below zero
func remove_resource_points(amount: int):
	if resource_points - amount < 0:
		push_error("Error: Resource points cannot go below zero. Current: %d, Attempted to remove: %d" % [resource_points, amount])
	else:
		resource_points -= amount
