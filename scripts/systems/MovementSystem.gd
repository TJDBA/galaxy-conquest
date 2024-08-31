
# File: scripts/systems/MovementSystem.gd
extends Node

# Moves an entity to a new location
func move_entity(entity_manager: EntityManager, entity_id: String, new_location: Vector2i, new_sector: String):
	var location_component = entity_manager.get_component(entity_id, "LocationComponent")
	if location_component:
		location_component.sextant = new_location
		location_component.sector = new_sector
		print("Moved entity %s to new location: %s, %s" % [entity_id, new_location, new_sector])
