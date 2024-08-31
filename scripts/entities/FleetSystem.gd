# File: scripts/entities/FleetSystem.gd
extends Node

# Load MovementSystem
var movement_system = preload("res://scripts/systems/MovementSystem.gd").new()

# Moves a fleet and all its units to a new location
func move_fleet(entity_manager: EntityManager, fleet_id: String, new_location: Vector2i, new_sector: String):
	var fleet_component = entity_manager.get_component(fleet_id, "FleetComponent")
	if fleet_component:
		# Update the fleet's location
		fleet_component.location.sextant = new_location
		fleet_component.location.sector = new_sector
		
		# Move all units in the fleet
		for unit_id in fleet_component.units:
			movement_system.move_entity(entity_manager, unit_id, new_location, new_sector)
