--------------
--- ENTITY ---
--------------
-- Deep copy base data and create new one with custom parametres
local l_cannon_turret_mk1 = util.table.deepcopy(data.raw["ammo-turret"]["gun-turret"])
l_cannon_turret_mk1.name = "cannon-turret-mk1"
-- Flags
l_cannon_turret_mk1.flags = 
{
	"player-creation",				-- Can draw enemies
	"placeable-off-grid", 
	"not-on-map",					-- Do not show on minimap
	"not-repairable", 
	"not-deconstructable", 
	"not-blueprintable"
}
l_cannon_turret_mk1.minable = nil
-- HP 
l_cannon_turret_mk1.max_health = 1000			-- Same as platform hp (Critical component or will be destroyed using old script)
-- Resistance copy
local l_base_wagon_copy_param = util.table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"]["resistances"])		
l_cannon_turret_mk1.resistances = l_base_wagon_copy_param			-- Prevent faster damage from turret
-- Collision
l_cannon_turret_mk1.collision_box = {{-1, -1 }, {1, 1}}
l_cannon_turret_mk1.collision_mask = { "object-layer" }				-- Fix player stuck inside wagon forever
l_cannon_turret_mk1.selection_box = {{-1.25, -1.25 }, {1.25, 1.25}}
-- Rotation speed
local l_base_tank_copy_param = util.table.deepcopy(data.raw["car"]["tank"]["turret_rotation_speed"])	
l_cannon_turret_mk1.rotation_speed = l_base_tank_copy_param
-- Inventory
l_cannon_turret_mk1.inventory_size = 3
-- Ammo count copy
local l_base_ammo_copy_param = util.table.deepcopy(data.raw["ammo"]["cannon-shell"]["stack_size"])	
l_cannon_turret_mk1.automated_ammo_count = l_base_ammo_copy_param * 2
-- Attack speed
l_cannon_turret_mk1.attacking_speed = l_cannon_turret_mk1.attacking_speed / 2

-- Animation functions
l_cannon_turret_mk1.gun_animation_render_layer = "higher-object-under"
local function cannon_turret_extension(inputs)
return
{
	filename = "__Armored-train__/assets/cannon-turret-mk1/sprites/cannon-turret-raising.png",
	priority = "medium",
	width = 179,
	height = 132,
	direction_count = 4,
	frame_count = inputs.frame_count or 5,
	line_length = inputs.line_length or 0,
	run_mode = inputs.run_mode or "forward",
	shift = util.by_pixel(0, -60),							-- Sprite offset in world
	scale = 0.5,											-- Sprite scale
	axially_symmetrical = false
	-- hr version missing
}
end
function cannon_turret_attack(inputs)
return
{
	layers =
	{
		{
			width = 179,
			height = 132,
			frame_count = inputs.frame_count or 2,
			axially_symmetrical = false,
			direction_count = 64,
			shift = util.by_pixel(0, -60),
			scale = 0.5,	
			stripes =
			{
				{
					filename = "__Armored-train__/assets/cannon-turret-mk1/sprites/cannon-turret-shooting-1.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				},
				{
					filename = "__Armored-train__/assets/cannon-turret-mk1/sprites/cannon-turret-shooting-2.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				},
				{
					filename = "__Armored-train__/assets/cannon-turret-mk1/sprites/cannon-turret-shooting-3.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				},
				{
					filename = "__Armored-train__/assets/cannon-turret-mk1/sprites/cannon-turret-shooting-4.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				}
			}
			-- hr version missing and mask and shadow
		}
	}
}
end
-- Animation calls
l_cannon_turret_mk1.folded_animation =
{
	layers =
	{
		cannon_turret_extension{frame_count=1, line_length = 1},
		--gun_turret_extension_mask{frame_count=1, line_length = 1},
		--gun_turret_extension_shadow{frame_count=1, line_length = 1}
	}
}
l_cannon_turret_mk1.preparing_animation =
{
	layers =
	{
		cannon_turret_extension{},
		--gun_turret_extension_mask{},
		--gun_turret_extension_shadow{}
	}
}
l_cannon_turret_mk1.prepared_animation = cannon_turret_attack{frame_count=1}
l_cannon_turret_mk1.attacking_animation = cannon_turret_attack{}
l_cannon_turret_mk1.folding_animation =
{
	layers =
	{
		cannon_turret_extension{run_mode = "backward"},
		--gun_turret_extension_mask{run_mode = "backward"},
		--gun_turret_extension_shadow{run_mode = "backward"}
	}
}
-- Base picture
local blank_layers = 
{
	layers = 
	{
		{
			filename = 	"__Armored-train__/assets/minigun-turret-mk1/fakeTransparent.png",
			direction_count = 1,
			height = 16,
			width = 16
		}
	}
}
l_cannon_turret_mk1.base_picture = blank_layers

-- Attack parameters
-- Base projectile modification
data.raw["projectile"]["cannon-projectile"].force_condition = "not-same"						
data.raw["projectile"]["uranium-cannon-projectile"].force_condition = "not-same"
data.raw["projectile"]["explosive-cannon-projectile"].force_condition = "not-same"
data.raw["projectile"]["explosive-uranium-cannon-projectile"].force_condition = "not-same"
local l_base_gun_copy = util.table.deepcopy(data.raw["gun"]["tank-cannon"])
l_cannon_turret_mk1.attack_parameters = l_base_gun_copy.attack_parameters							
l_cannon_turret_mk1.attack_parameters.projectile_center = {-0.15625, -0.07812 * 7.5}			-- Overwrite parameter
-- Range
l_cannon_turret_mk1.attack_parameters.min_range = 3.5											-- Overwrite parameter

-- Write result
data:extend
({
	l_cannon_turret_mk1
})



-- Custom safe projectile and safe ammo
--local safe_projectile = util.table.deepcopy(data.raw["projectile"]["cannon-projectile"])
--safe_projectile.name = "safe-projectile"
--safe_projectile.force_condition = "not-same"
--local safe_ammo = util.table.deepcopy(data.raw["ammo"]["cannon-shell"])
--safe_ammo.name = "safe-ammo"
--safe_ammo.ammo_type =
---{
--	category = "cannon-shell",		
--	target_type = "direction",
--	action =
--	{
--		type = "direct",
--		action_delivery =
--		{
--			type = "projectile",
--			projectile = "safe-projectile",
--			starting_speed = 1,
--			direction_deviation = 0.1,
--			range_deviation = 0.1,
--			max_range = 25,
--			min_range = 5,
--			source_effects =
--			{
--				type = "create-explosion",
--				entity_name = "explosion-gunshot"
--			}
--		}
--	}
--}