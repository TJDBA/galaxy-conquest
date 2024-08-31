
# File: scripts/components/FleetComponent.gd
extends Resource

class_name FleetComponent

@export var units: Array = []  # List of unit IDs belonging to the fleet
@export var location: Resource = preload("res://scripts/components/LocationComponent.gd").new()
