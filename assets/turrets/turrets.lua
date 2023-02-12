--------------
--- ENTITY ---
--------------
-- Deep copy base data and create new one with custom parametres
function default_turett(name, scalse_attacking_speed)
	local default_turett = util.table.deepcopy(data.raw["ammo-turret"]["gun-turret"])
	default_turett.name = name
	default_turett.flags = 
		{
			"player-creation",				-- Can draw enemies
			"placeable-off-grid", 
			"not-on-map",					-- Do not show on minimap
			"not-repairable", 
			"not-deconstructable", 
			"not-blueprintable"
		}
	default_turett.minable = nil	--Нельзя добыть
	default_turett.max_health = 1000			-- Same as platform hp (Critical component or will be destroyed using old script)
	
	-- Resistance copy
	local l_base_wagon_copy_param = util.table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"]["resistances"])	
	default_turett.resistances = l_base_wagon_copy_param			-- Prevent faster damage from turret

	-- Collision
	default_turett.collision_box = {{-1, -1 }, {1, 1}}
	default_turett.collision_mask = { "object-layer" }				-- Fix player stuck inside wagon forever
	default_turett.selection_box = {{-1.25, -1.25 }, {1.25, 1.25}}
	
	-- Rotation speed
	local l_base_tank_copy_param = util.table.deepcopy(data.raw["car"]["tank"]["turret_rotation_speed"])	
	default_turett.rotation_speed = l_base_tank_copy_param
	-- Inventory
	default_turett.inventory_size = 1
	-- Автоматическая загрузка патронов. Не нужна, так как патроны сами забираются с платформы
	default_turett.automated_ammo_count = 10
	-- Attack speed
	default_turett.attacking_speed = default_turett.attacking_speed * scalse_attacking_speed
	
	-- Animation functions
	default_turett.gun_animation_render_layer = "higher-object-under"
	
	return default_turett
end

-- Animation functions
function turret_extension(name,inputs, w, h, pixelOffset)
return
{
	filename = "__Armored-train__/assets/turrets/" .. name .. "/raising.png",
	priority = "medium",
	width = w,
	height = h,
	direction_count = 4,
	frame_count = inputs.frame_count,
	line_length = inputs.line_length or 0,
	run_mode = inputs.run_mode,
	shift = util.by_pixel(0, -pixelOffset),							-- Sprite offset in world
	scale = 0.5,											-- Sprite scale
	axially_symmetrical = false
	-- hr version missing
}
end

function turret_attack(name,inputs, w, h, pixelOffset)
return
{
	layers =
	{
		{
			width = w,
			height = h,
			frame_count = inputs.frame_count or 2,
			axially_symmetrical = false,
			direction_count = 64,
			shift = util.by_pixel(0, -pixelOffset),
			scale = 0.5,	
			stripes =
			{
				{
					filename = "__Armored-train__/assets/turrets/" .. name .. "/shooting-1.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				},
				{
					filename = "__Armored-train__/assets/turrets/" .. name .. "/shooting-2.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				},
				{
					filename = "__Armored-train__/assets/turrets/" .. name .. "/shooting-3.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				},
				{
					filename = "__Armored-train__/assets/turrets/" .. name .. "/shooting-4.png",
					width_in_frames = inputs.frame_count or 2,
					height_in_frames = 16
				}
			}
			-- hr version missing and mask and shadow
		}
	}
}
end

function blank_layers()
return
{
	layers = 
	{
		{
			filename = 	"__Armored-train__/assets/turrets/fakeTransparent.png",
			direction_count = 1,
			height = 16,
			width = 16
		}
	}
}
end

function animation(name,inputs, w, h, pixelOffset)
return
{
	layers = {
		turret_extension(name,inputs,w,h,pixelOffset)
	}
}
end





local l_cannon_turret_mk1 = default_turett("cannon-turret-mk1", 0.5)
-- Animation calls
l_cannon_turret_mk1.folded_animation = animation("cannon-turret-mk1",{frame_count=1, line_length = 1, run_mode = "forward"},179,132,60)
l_cannon_turret_mk1.preparing_animation = animation("cannon-turret-mk1",{frame_count=5, run_mode = "forward"},179,132,60)
l_cannon_turret_mk1.folding_animation = animation("cannon-turret-mk1",{frame_count=5, run_mode = "backward"},179,132,60)
l_cannon_turret_mk1.prepared_animation = turret_attack("cannon-turret-mk1",{frame_count=1},179,132,60)
l_cannon_turret_mk1.attacking_animation = turret_attack("cannon-turret-mk1",{frame_count=2},179,132,60)
-- Base picture
l_cannon_turret_mk1.base_picture = blank_layers()

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
l_cannon_turret_mk1.attack_parameters.min_range = 7.5											-- Overwrite parameter


local l_flamethrower_turret_mk1 = default_turett("flamethrower-turret-mk1", 4)
l_flamethrower_turret_mk1.folded_animation = animation("flamethrower-turret-mk1",{frame_count=1, line_length = 1, run_mode = "forward"},152,128,75)
l_flamethrower_turret_mk1.preparing_animation = animation("flamethrower-turret-mk1",{frame_count=15, run_mode = "forward"},152,128,75)
l_flamethrower_turret_mk1.folding_animation = animation("flamethrower-turret-mk1",{frame_count=15, run_mode = "backward"},152,128,75)

l_flamethrower_turret_mk1.prepared_animation = turret_attack("flamethrower-turret-mk1",{frame_count=1},158,128,74)
l_flamethrower_turret_mk1.attacking_animation = turret_attack("flamethrower-turret-mk1",{frame_count=2},158,128,74)
-- Base picture
l_flamethrower_turret_mk1.base_picture = blank_layers()

-- Attack parameters
local l_base_gun_copy = util.table.deepcopy(data.raw["gun"]["flamethrower"])			-- Get from base ref
l_flamethrower_turret_mk1.attack_parameters = l_base_gun_copy.attack_parameters							
l_flamethrower_turret_mk1.attack_parameters.gun_center_shift = { 0, -3.25}				--  default -1.15
-- Range
local l_base_gun_copy_param = util.table.deepcopy(data.raw["fluid-turret"]["flamethrower-turret"]["attack_parameters"])
l_flamethrower_turret_mk1.attack_parameters.range = l_base_gun_copy_param.range
l_flamethrower_turret_mk1.attack_parameters.min_range = l_base_gun_copy_param.min_range



local l_minigun_turret_mk1 = default_turett("minigun-turret-mk1", 1)
l_minigun_turret_mk1.folded_animation = animation("minigun-turret-mk1",{frame_count=1, line_length = 1, run_mode = "forward"},130,126,40)
l_minigun_turret_mk1.preparing_animation = animation("minigun-turret-mk1",{frame_count=5, run_mode = "forward"},130,126,40)
l_minigun_turret_mk1.folding_animation = animation("minigun-turret-mk1",{frame_count=5, run_mode = "backward"},130,126,40)

l_minigun_turret_mk1.prepared_animation = turret_attack("minigun-turret-mk1",{frame_count=1},132,130,74)
l_minigun_turret_mk1.attacking_animation = turret_attack("minigun-turret-mk1",{frame_count=2},132,130,74)
-- Base picture
l_minigun_turret_mk1.base_picture = blank_layers()

-- Attack parameters
local l_base_gun_copy = util.table.deepcopy(data.raw["gun"]["tank-machine-gun"])
l_minigun_turret_mk1.attack_parameters = l_base_gun_copy.attack_parameters
l_minigun_turret_mk1.attack_parameters.projectile_center = {-0.15625, -0.07812 * 7}			-- Overwrite parameter




local l_rocket_turret_mk1 = default_turett("rocket-turret-mk1", 0.5)
l_rocket_turret_mk1.folded_animation = animation("rocket-turret-mk1",{frame_count=1, line_length = 1, run_mode = "forward"},88,80,50)
l_rocket_turret_mk1.preparing_animation = animation("rocket-turret-mk1",{frame_count=5, run_mode = "forward"},88,80,50)
l_rocket_turret_mk1.folding_animation = animation("rocket-turret-mk1",{frame_count=5, run_mode = "backward"},88,80,50)
l_rocket_turret_mk1.folded_animation.layers[1].scale = 1
l_rocket_turret_mk1.preparing_animation.layers[1].scale = 1
l_rocket_turret_mk1.folding_animation.layers[1].scale = 1

l_rocket_turret_mk1.prepared_animation = turret_attack("rocket-turret-mk1",{frame_count=1},88,80,50)
l_rocket_turret_mk1.attacking_animation = turret_attack("rocket-turret-mk1",{frame_count=2},88,80,50)
l_rocket_turret_mk1.prepared_animation.layers[1].scale = 1
l_rocket_turret_mk1.attacking_animation.layers[1].scale = 1
-- Base picture
l_rocket_turret_mk1.base_picture = blank_layers()

-- Attack parameters
local l_base_gun_copy = util.table.deepcopy(data.raw["gun"]["rocket-launcher"])
l_rocket_turret_mk1.attack_parameters = l_base_gun_copy.attack_parameters
l_rocket_turret_mk1.attack_parameters.projectile_center = {-0.17, -0.75}					-- Overwrite parameter
-- Range
l_rocket_turret_mk1.attack_parameters.min_range = 3.5										-- Overwrite parameter


-- Write result
data:extend
({
	l_cannon_turret_mk1,
	l_flamethrower_turret_mk1,
	l_minigun_turret_mk1,
	l_rocket_turret_mk1
})