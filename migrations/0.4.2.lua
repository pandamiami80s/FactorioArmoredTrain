-- Change file name to enable migrations! (Took me 2 days to find this out)

for index, force in pairs(game.forces) do
	if force.technologies["armored-train-turret-wagons"].researched then

		force.recipes["armored-locomotive-mk1"].enabled = true
		force.recipes["minigun-platform-mk1"].enabled = true
		force.recipes["rocket-platform-mk1"].enabled = true
		force.recipes["cannon-wagon-mk1"].enabled = true
		force.recipes["flamethrower-wagon-mk1"].enabled = true
		force.recipes["radar-platform-mk1"].enabled = true
		
	end
end