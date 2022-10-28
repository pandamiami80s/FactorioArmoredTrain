--------------------------
--FUNCTIONS---------------
--------------------------
--Is this mod entity? If yes true, othervise false
isModEntity = function(modEntity)
	if modEntity and modEntity.name ~= nil then		-- null fix
		--List of known entities
		if modEntity.name == "minigun-platform-mk1" 
			or modEntity.name == "rocket-platform-mk1" 
			or modEntity.name == "cannon-wagon-mk1" 
			or modEntity.name == "flamethrower-wagon-mk1"
			or modEntity.name == "radar-platform-mk1" then	
			return true
		end
	end
	return false
end




--Create turret as proxy to platform (data stored to table)
function createProxyTurretMinigun(position, surface, force)
	local proxy = surface.create_entity{
	name = "minigun-turret-mk1", 
	position = position, 
	force = force}
	return proxy
end
function createProxyTurretRocket(position, surface, force)
	local proxy = surface.create_entity{
	name = "rocket-turret-mk1", 
	position = position, 
	force = force}
	return proxy
end


function createProxyTurretCannon(position, surface, force)
	local proxy = surface.create_entity{
	name = "cannon-turret-mk1", 
	position = position, 
	force = force}
	return proxy
end


function createProxyTurretFlamethrower(position, surface, force)
	local proxy = surface.create_entity{
	name = "flamethrower-turret-mk1", 
	position = position, 
	force = force}
	return proxy
end

function createProxyRadar(position, surface, force)
	local proxy = surface.create_entity{
	name = "radar-mk1", 
	position = position, 
	force = force}
	return proxy
end





--Create initTurretPlatformList table to store data for proxy and platform or pass data if created
function initTurretPlatformList(tableValue)
	--If first time calling = create table?
	if tableValue == nil then
		return {}
	--if table created just pass values
	else
		return tableValue
	end
end



-------------
--ON_EVENTS--
-------------

--ON LOAD \/
--Prevent on load bug when no hp ws dounded
script.on_load(
function(event)

	platformMaxHealth = 1000
	



	
end)
--ON LOAD /\


--ON BUILT \/--
function entityBuilt(event)
	--createdEntity reference (to simplify usage in this context)
	local createdEntity = {}
    if event.name == defines.events.script_raised_built then 
        createdEntity = event.entity
    else
        createdEntity = event.created_entity
    end
	
	--Is this mod entity?
	if isModEntity(createdEntity) then
		--createdWagon now defines itself with created platform + turret (later on)
		local createdPlatform = {
		--Actual entity as class
		entity = createdEntity}
		
		
		if createdEntity.name == "minigun-platform-mk1" then
		
			--Create and defince a proxy At created entity position and surface and force
			createdPlatform.proxy = createProxyTurretMinigun(
				createdEntity.position, 
				createdEntity.surface, createdEntity.force)
		end 
		if createdEntity.name == "cannon-wagon-mk1" then		
			
			createdPlatform.proxy = createProxyTurretCannon(
				createdEntity.position, 
				createdEntity.surface, createdEntity.force)
			
		end 
		
		if createdEntity.name == "rocket-platform-mk1" then		
			
			createdPlatform.proxy = createProxyTurretRocket(
				createdEntity.position, 
				createdEntity.surface, createdEntity.force)
			
		end 
		
		if createdEntity.name == "flamethrower-wagon-mk1" then		
			
			createdPlatform.proxy = createProxyTurretFlamethrower(
				createdEntity.position, 
				createdEntity.surface, createdEntity.force)
			
		end 
			
		if createdEntity.name == "radar-platform-mk1" then		
	
			createdPlatform.proxy = createProxyRadar(
				createdEntity.position, 
				createdEntity.surface, createdEntity.force)
			
		end 
			
		
		--Create table "turretPlatformList" and store data (if null create else just pass data)
		global.turretPlatformList = initTurretPlatformList(global.turretPlatformList)
		--Add created platform and turret to table (list)
		table.insert(global.turretPlatformList, createdPlatform)
		
		--Define max health var (for reference)
		platformMaxHealth = 1000
	end
end
--ON_BUILT EVENT
script.on_event(defines.events.on_built_entity, entityBuilt)
script.on_event(defines.events.on_robot_built_entity, entityBuilt)
script.on_event(defines.events.script_raised_built, entityBuilt)
--ON BUILT /\--






--ON TICK \/--
function onTickMain(event)  -- Move each turret to follow its wagon
	--If turretPlatformList is not empty (turret and platform palced in world)
	if global.turretPlatformList ~= nil then
	--for each individual createdPlatform do
		for i , createdPlatform in ipairs(global.turretPlatformList) do
			--Is this entity valid/nil?
			if createdPlatform.proxy ~= nil and createdPlatform.proxy.valid then	--or if isEntityValid(createdPlatform.proxy) then
			
			
			
			
				--teleport i turret to i platform (good)
				createdPlatform.proxy.teleport({
						x = createdPlatform.entity.position.x,			
						y = createdPlatform.entity.position.y -- 0.25
					})
					
				
				
				
						
				
				
				
				
				--each ~ 3 sec do
				if event.tick %20 == 3 then
				
					--Taken damge to TURRET is applyed to WAGON
					local damageTaken = platformMaxHealth - createdPlatform.proxy.health
					--prevent nullpop
					if (damageTaken > 0) then
						local platformCurrentHealth = createdPlatform.entity.health;
						--If health 0 destroy all
						if (platformCurrentHealth <= damageTaken) then
							createdPlatform.proxy.destroy();
							createdPlatform.entity.die();
						else
							--subtract wagon health by given to turret damage
							createdPlatform.entity.health = platformCurrentHealth - damageTaken;
							--redefine proxy health back to full
							createdPlatform.proxy.health = platformMaxHealth;
						end
					end
							
							
							
							
					
				end
			end
		end
	end
end
script.on_event(defines.events.on_tick, onTickMain)
--ON TICK /\--





--ON PRE MINED (Remove turret when object not mined but going to be mined) \/--
--if removed /destroyed
function entityRemoved(event)
	--Is this known enity?
	if isModEntity(event.entity) then
	
	
		local newFunction = function (val) 
		
			return val.entity == event.entity
			
			
			end
		
		
		
		local wagon = getWagonFromEntity(global.turretPlatformList, event.entity)
		
		
		--if Wagon still there do:
		if wagon ~= nil then --or if isWagonValid(wagon) then		--can produce bug wher mining and wagon destroeyd
		
			if wagon.proxy ~= nil and wagon.proxy.valid then		-- or if isEntityValid(wagon.proxy) then
				
					
					
					wagon.proxy.destroy()
					wagon.proxy = nil
					
			end
				
				
			--remove from table
			global.turretPlatformList = nilIfEmptyTable(remove_if(newFunction, global.turretPlatformList))
		end
		
	
		
		
		
	end
end
script.on_event(defines.events.on_pre_player_mined_item, entityRemoved)
script.on_event(defines.events.on_robot_pre_mined, entityRemoved)
script.on_event(defines.events.script_raised_destroy, entityRemoved)
--ON PRE MINED (Remove turret when object not mined but going to be mined) /\--

--ON MINED (BUFFER for item) \/--
function entityMined(event)
	--Is this mod entity?
	if isModEntity(event.entity) then

		--define buffer for removed enity
		local bufferRemovedEntity = event.buffer
		
		
		
		

		--if modEntity.name == "minigun-platform-mk1"
		--or modEntity.name == "cannon-wagon-mk1" 
		--or modEntity.name == "rocket-platform-mk1" 
		--or modEntity.name == "armored-wagon-chaingun-mk1" then		--modEntity.name == "cannon-wagon-mk1" or 

		--game.print(removedEntity.name)

		--game.print(game.players[event.player_index])

		--game.print(removedEntity.insert({name="iron-plate", count=1}))

		--if (game.players[event.player_index].can_insert()) then
		--game.print("can insert")

	end
			

end
script.on_event(defines.events.on_player_mined_entity, entityMined)
--ON MINED (BUFFER) /\--






function entityDestroyed(event)
	--Is this know enity?
	if isModEntity(event.entity) then
	
		local newFunction = function (val) 
		
			return val.entity == event.entity
			
			
			end
	
		
		local wagon = getWagonFromEntity(global.turretPlatformList, event.entity)
		
		
		
		--if Wagon still there do:
		if wagon ~= nil then --or if isWagonValid(wagon) then		--can produce bug wher mining and wagon destroeyd
		


		if wagon.proxy ~= nil and wagon.proxy.valid then		-- or if isEntityValid(wagon.proxy) then
			
			
				
				--add explotion
				wagon.proxy.destroy()	--wagon.damage(10000, game.forces.enemy)
				wagon.proxy = nil
				
				
			end
			
			
			
			global.turretPlatformList = nilIfEmptyTable(remove_if(newFunction, global.turretPlatformList))
		end
	end
end
script.on_event(defines.events.on_entity_died, entityDestroyed)













function getWagonFromEntity(wagons, entity)
	if wagons == nil then return nil end
	
	for i,value in ipairs(wagons) do
		if isEntityValid(value.entity) and entity == value.entity then
			return value
		end
	end
end


--It this entity valid? (not nul land valid)
function isEntityValid(validEntity) --return(validEntity ~= nil and validEntity.valid)
	if validEntity ~= nil and validEntity.valid then
		return true
	end
		return false
end





function nilIfEmptyTable(value)
	if value == nil or #value < 1 then
		return nil
	else 
		return value
	end
end



function remove_if(func, arr)
  if arr == nil then return nil end
  local new_array = {}
  for _,v in ipairs(arr) do
    if not func(v) then table.insert(new_array, v) end
  end
  return new_array
end