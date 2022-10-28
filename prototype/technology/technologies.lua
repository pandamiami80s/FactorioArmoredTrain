data:extend
({
	{
		type = "technology",
		name = "armored-train-turret-wagons",
		icon = "__Armored-train__/prototype/technology/armored-train-technology-icon.png",
		icon_size = 128,
		effects =
		{
			-- Unlock recipes when technology researched
			{
				type = "unlock-recipe",
				recipe = "armored-locomotive-mk1"
			},
			{
				type = "unlock-recipe",
				recipe = "minigun-platform-mk1"
			},
			{
				type = "unlock-recipe",
				recipe = "rocket-platform-mk1"
			},
			{
				type = "unlock-recipe",
				recipe = "cannon-wagon-mk1"
			},
			{
				type = "unlock-recipe",
				recipe = "flamethrower-wagon-mk1"
			},
			{
				type = "unlock-recipe",
				recipe = "radar-platform-mk1"
			}
		},
		prerequisites = {"gun-turret", "military", "railway"},
		unit =
		{
			count = 100,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1}
			},
			time = 20
		},
		order = "e-g"
	}
})
