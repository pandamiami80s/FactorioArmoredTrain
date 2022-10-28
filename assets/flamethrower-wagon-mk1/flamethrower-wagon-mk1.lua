------------
--- ITEM ---
------------
data:extend
({
	{
		type = "item",
		name = "flamethrower-wagon-mk1",
		icon = "__Armored-train__/assets/flamethrower-wagon-mk1/flamethrower-wagon-mk1-icon.png",
		icon_size = 64, icon_mipmaps = 4,
		subgroup = "transport",
		order = "a[train-system]-l[wagon_mk1_01]",
		place_result = "flamethrower-wagon-mk1",
		stack_size = 5
	}
})
	
	
	
--------------
--- RECIPE ---
--------------
data:extend
({
	{
		type = "recipe",
		name = "flamethrower-wagon-mk1",
		enabled = false,						-- default state (not researched)
		ingredients =
		{
			{"iron-plate", 40},			
			{"steel-plate", 40},
			{"iron-gear-wheel", 20},				
			{"engine-unit", 15},
			{"pipe", 10}			-- Unique
		},
		result = "flamethrower-wagon-mk1"
	}
})



--------------
--- ENTITY ---
--------------
-- Deep copy base data and create new one with custom parametres
local l_flamethrower_platform_mk1 = util.table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
l_flamethrower_platform_mk1.name = "flamethrower-wagon-mk1"
l_flamethrower_platform_mk1.icon = "__Armored-train__/assets/flamethrower-wagon-mk1/flamethrower-wagon-mk1-icon.png"
l_flamethrower_platform_mk1.icon_size = 64
l_flamethrower_platform_mk1.icon_mipmaps = 4
-- Inventory
l_flamethrower_platform_mk1.inventory_size = 0					-- Do not need inventory
l_flamethrower_platform_mk1.minable = 
{
	mining_time = 0.5, 
	result = "flamethrower-wagon-mk1"		
}
l_flamethrower_platform_mk1.max_health = 1000					-- Same as turret hp (Critical component or will be destroyed using old script)	
l_flamethrower_platform_mk1.weight = 2000
l_flamethrower_platform_mk1.energy_per_hit_point = 5
-- Animation
l_flamethrower_platform_mk1.pictures =
{
	layers =
	{
		{
			priority = "very-low",
			width = 256,
			height = 256,
			back_equals_front = false,    			--means to not rotate mirroring
			direction_count = 128, 					--means to add aditional frames
			allow_low_quality_rotation = true,
			line_length = 32,
			lines_per_file = 1,
			shift = {0.4, -1.25},
			filenames =
			{
				"__Armored-train__/assets/flamethrower-wagon-mk1/sprites/wagon-mk1-01.png",
				"__Armored-train__/assets/flamethrower-wagon-mk1/sprites/wagon-mk1-02.png",
				"__Armored-train__/assets/flamethrower-wagon-mk1/sprites/wagon-mk1-03.png",
				"__Armored-train__/assets/flamethrower-wagon-mk1/sprites/wagon-mk1-04.png"
			}
		}
	}
}
l_flamethrower_platform_mk1.horizontal_doors = nil
l_flamethrower_platform_mk1.vertical_doors = nil
-- Minimap representation
l_flamethrower_platform_mk1.minimap_representation =
{
	filename = "__Armored-train__/assets/flamethrower-wagon-mk1/flamethrower-wagon-mk1-minimap-representation.png",
	flags = {"icon"},
	size = {20, 40},
	scale = 0.5
}
l_flamethrower_platform_mk1.selected_minimap_representation =
{
	filename = "__Armored-train__/assets/flamethrower-wagon-mk1/flamethrower-wagon-mk1-selected-minimap-representation.png",
	flags = {"icon"},
	size = {20, 40},
	scale = 0.5
}

-- Write result
data:extend
({
	l_flamethrower_platform_mk1
})