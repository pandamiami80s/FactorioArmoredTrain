------------
--- ITEM ---
------------
function wagon_item(name)
return
{
	type = "item",
	name = name,
	icon = "__Armored-train__/assets/wagons-platforms/" .. name .. "-icon.png",
	icon_size = 64, icon_mipmaps = 4,
	subgroup = "transport",
	order = "a[train-system]-l[platform_mk1_00]",
	place_result = name,
	stack_size = 5
}
end

data:extend
({
	wagon_item("minigun-platform-mk1"),
	wagon_item("radar-platform-mk1"),
	wagon_item("rocket-platform-mk1")
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
	wagon_recipe("minigun-platform-mk1",
		{
			{"iron-plate", 20},			
			{"steel-plate", 20},
			{"iron-gear-wheel", 10},				
			{"engine-unit", 15},
			{"copper-plate", 10}
		}),
	wagon_recipe("radar-platform-mk1",
		{
			{"iron-plate", 20},			
			{"steel-plate", 20},
			{"iron-gear-wheel", 10},				
			{"engine-unit", 15},
			{"electronic-circuit", 5}
		}),
	wagon_recipe("rocket-platform-mk1",
		{
			{"iron-plate", 20},			
			{"steel-plate", 20},
			{"iron-gear-wheel", 10},				
			{"engine-unit", 15},
			{"electronic-circuit", 20}
		})
})



--------------
--- ENTITY ---
--------------
-- Deep copy base data and create new one with custom parametres
function default_wagon(name)
	local default_platform_mk1 = util.table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
	default_platform_mk1.name = name
	default_platform_mk1.icon = "__Armored-train__/assets/wagons-platforms/" .. name .. "-icon.png"
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
					"__Armored-train__/assets/wagons-platforms/sprites/platform-mk1-01.png",
					"__Armored-train__/assets/wagons-platforms/sprites/platform-mk1-02.png",
					"__Armored-train__/assets/wagons-platforms/sprites/platform-mk1-03.png",
					"__Armored-train__/assets/wagons-platforms/sprites/platform-mk1-04.png"
				}
			}
		}
	}
	default_platform_mk1.horizontal_doors = nil
	default_platform_mk1.vertical_doors = nil
	-- Minimap representation
	default_platform_mk1.minimap_representation =
	{
		filename = "__Armored-train__/assets/wagons-platforms/" .. name .. "-minimap-representation.png",
		flags = {"icon"},
		size = {20, 40},
		scale = 0.5
	}
	default_platform_mk1.selected_minimap_representation =
	{
		filename = "__Armored-train__/assets/wagons-platforms/" .. name .. "-selected-minimap-representation.png",
		flags = {"icon"},
		size = {20, 40},
		scale = 0.5
	}

	return default_platform_mk1
end


local l_minigun_platform_mk1 = default_wagon("minigun-platform-mk1")
local l_rocket_platform_mk1 = default_wagon("rocket-platform-mk1")
local l_radar_platform_mk1 = default_wagon("radar-platform-mk1")
l_radar_platform_mk1.pictures.layers[#l_radar_platform_mk1.pictures.layers + 1] = 
	--DECORATIVES
	{
		priority = "very-low",
		width = 96,--72
		height = 140,--57
		back_equals_front = false,    		--means to not rotate mirroring
		direction_count = 128, 				--means to add aditional frames
		allow_low_quality_rotation = true,
		line_length = 32,
		lines_per_file = 1,
		--shift = {0.0, -2.2},
		shift = {0.2, -1.35},
		scale = 0.675,
		filenames =
		{
			"__Armored-train__/assets/radar-mk1/sprites/radar-mk1-01-fix.png",
			"__Armored-train__/assets/radar-mk1/sprites/radar-mk1-02-fix.png",
			"__Armored-train__/assets/radar-mk1/sprites/radar-mk1-03-fix.png",
			"__Armored-train__/assets/radar-mk1/sprites/radar-mk1-04-fix.png"
		}
	}
		
-- Write result
data:extend
({
	l_radar_platform_mk1,
	l_minigun_platform_mk1,
	l_rocket_platform_mk1
})