--------------
--- ENTITY ---
--------------
-- Deep copy base data and create new one with custom parametres
local l_radar_mk1 = util.table.deepcopy(data.raw["radar"]["radar"])
l_radar_mk1.name = "radar-mk1"
-- Flags
l_radar_mk1.flags = 
{
	"player-creation",				-- Can draw enemies
	"placeable-off-grid", 
	"not-on-map",					-- Do not show on minimap
	"not-repairable", 
	"not-deconstructable", 
	"not-blueprintable"
}
l_radar_mk1.minable = nil
-- HP 
l_radar_mk1.max_health = 1000			-- Same as platform hp (Critical component or will be destroyed using old script)
-- Resistance copy
local l_base_wagon_copy_param = util.table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"]["resistances"])		
l_radar_mk1.resistances = l_base_wagon_copy_param			-- Prevent faster damage from turret
-- Collision
l_radar_mk1.collision_box = {{-1, -1 }, {1, 1}}
l_radar_mk1.collision_mask = { "object-layer" }				-- Fix player stuck inside wagon forever
l_radar_mk1.selection_box = {{-1.25, -1.25 }, {1.25, 1.25}}

-- Radar parameters
l_radar_mk1.energy_per_sector = "3.5MJ"							-- Default (devide by 7) "10MJ"	
l_radar_mk1.max_distance_of_sector_revealed = 2					-- Default 14
l_radar_mk1.max_distance_of_nearby_sector_revealed = 1			-- Default 3
l_radar_mk1.energy_per_nearby_scan = "85kJ"						-- Default "250kJ"
l_radar_mk1.energy_source =
{
	type = "burner",
	fuel_category = "chemical",
	effectivity = 1,
	emissions_per_minute = 1,						-- 4
	fuel_inventory_size = 1,
	smoke =
	{
		{
			name = "smoke",
			frequency = 2,							-- 10
			position = {0.7, -1.2},
			starting_vertical_speed = 0.08,
			starting_frame_deviation = 15			-- 60
		}
	}
}
l_radar_mk1.energy_usage = "100kW"								--  "300kW"

-- Base picture
local blank_layers = 
{
	layers = 
	{
		{
			filename = 	"__Armored-train__/assets/radar-mk1/fakeTransparent.png",
			direction_count = 1,
			height = 16,
			width = 16
		}
	}
}
l_radar_mk1.integration_patch = blank_layers
l_radar_mk1.pictures = blank_layers

-- Write result
data:extend
({
	l_radar_mk1
})