------------
--- ITEM ---
------------
function wagon_item(name)
return
{
	type = "item",
	name = name,
	icon = "__Armored-train__/assets/wagons-box/" .. name .. "-icon.png",
	icon_size = 64, icon_mipmaps = 4,
	subgroup = "transport",
	order = "a[train-system]-l[platform_mk1_00]",
	place_result = name,
	stack_size = 5
}
end

data:extend
({
	wagon_item("cannon-wagon-mk1"),
	wagon_item("flamethrower-wagon-mk1")
})	
	
--------------
--- RECIPE ---
--------------
function wagon_recipe(name, ingredients_map)
return
{
	type = "recipe",
	name = name,
	enabled = false,						-- default state (not researched)
	ingredients = ingredients_map,
	result = name
}
end
data:extend
({
	wagon_recipe("cannon-wagon-mk1",
		{
			{"iron-plate", 40},			
			{"steel-plate", 40},
			{"iron-gear-wheel", 20},				
			{"engine-unit", 15},
			{"advanced-circuit", 5}
		}),
	wagon_recipe("flamethrower-wagon-mk1",
		{
			{"iron-plate", 40},			
			{"steel-plate", 40},
			{"iron-gear-wheel", 20},				
			{"engine-unit", 15},
			{"pipe", 10}
		})
})


--------------
--- ENTITY ---
--------------
-- Deep copy base data and create new one with custom parametres
function default_wagon(name)
	local default_platform_mk1 = util.table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
	default_platform_mk1.name = name
	default_platform_mk1.icon = "__Armored-train__/assets/wagons-box/" .. name .. "-icon.png"
	default_platform_mk1.icon_size = 64
	default_platform_mk1.icon_mipmaps = 4
	-- Inventory
	default_platform_mk1.inventory_size = 5					-- Do not need inventory
	default_platform_mk1.minable = 
	{
		mining_time = 0.5, 
		result = name	
	}
	default_platform_mk1.max_health = 1000					-- Same as turret hp (Critical component or will be destroyed using old script)	
	default_platform_mk1.weight = 2000
	default_platform_mk1.energy_per_hit_point = 5
	-- Animation
	default_platform_mk1.pictures =
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
					"__Armored-train__/assets/wagons-box/sprites/wagon-mk1-01.png",
					"__Armored-train__/assets/wagons-box/sprites/wagon-mk1-02.png",
					"__Armored-train__/assets/wagons-box/sprites/wagon-mk1-03.png",
					"__Armored-train__/assets/wagons-box/sprites/wagon-mk1-04.png"
				}
			}
		}
	}
	default_platform_mk1.horizontal_doors = nil
	default_platform_mk1.vertical_doors = nil
	-- Minimap representation
	default_platform_mk1.minimap_representation =
	{
		filename = "__Armored-train__/assets/wagons-box/" .. name .. "-minimap-representation.png",
		flags = {"icon"},
		size = {20, 40},
		scale = 0.5
	}
	default_platform_mk1.selected_minimap_representation =
	{
		filename = "__Armored-train__/assets/wagons-box/" .. name .. "-selected-minimap-representation.png",
		flags = {"icon"},
		size = {20, 40},
		scale = 0.5
	}

	return default_platform_mk1
end

-- Write result
data:extend
({
	default_wagon("cannon-wagon-mk1"),
	default_wagon("flamethrower-wagon-mk1")
})