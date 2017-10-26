local Exodus = RegisterMod("Exodus",1)
local game = Game()
local NullVector = Vector(0,0)

-- PLEASE add variables as Exodus.Something
function Exodus:newgame(fromSave)
  if not fromSave then
    Exodus.HasQueenBee = false --Has Queen Bee.
    Exodus.HasBeenades = false --Has Beenades.
    Exodus.HasBustedPipe = false --Has Busted Pipe.
    Exodus.HasUnholyMantleEffect = true -- Has Unholy Mantle Effect
    Exodus.HasUnholyMantle = false --Has Unholy Mantle.
    Exodus.HasTechY = false --Has Tech Y.
    Exodus.HasPaperCut = false --Has Paper Cut.
    Exodus.HasForgetMeLater = false --Has Forget Me Later.
    Exodus.IsWinStreakRoomClear = false --Room is clear with Win Streak.
    Exodus.HasWinStreak = false --Has Win Streak.
    Exodus.DragonBreathCharge = 0 --Dragon Breath charge,
    Exodus.FireBreathChargeDir = NullVector --Charge direction.
    Exodus.HasDragonBreath = false --Has Dragon Breath.
    Exodus.ForgetMeLtrNumberFloors = 0 --Number of floors before Forget Me Later activates.
    Exodus.NumRitualCandles = 0 --Number of lit up candles with Ritual Candle.
    Exodus.RitualCandleBonus = false -- Has Ritual Candle Bonus?
    Exodus.RitualCandlePentagram = nil --Pentagram entity.
    Exodus.RitualCandlePlayedSound = false -- Did Ritual Candle play sound?
    Exodus.HasPigBlood = false -- Has Pig Blood.
    Exodus.HasWotlBossSpawned = false --Boss spawned?
    Exodus.WotlBossroomIndex = nil --Room that WotL boss is in.
    Exodus.WotlFrameCount = nil --Frame count for WotL.
    Exodus.DmgLostWotl = 0 --Damage lost from WotL.
    Exodus.FDelayLostWotl = 0 --Fire Delay lost from WotL.
    Exodus.RangeLostWotl = 0 --Range lost from WotL.
    Exodus.SpeedLostWotl = 0 --Speed lost from WotL.
    Exodus.FiredOminousLantern = true -- Fired Ominous Lantern?
    Exodus.LiftedOminousLantern = true -- Lifted Ominous Lantern?
    Exodus.HidOminousLantern = false -- Hid Ominous Lantern?
    Exodus.LastOminousLanternHitEnemy = nil -- What's the last enemy Ominous Lantern hit?
    Exodus.LanternFrameModifier = 300 -- Lantern frame modifier
    Exodus.ChargeScale = Vector(1,1) -- Chargebar Scale
    Exodus.HasDBCostume = false
    Exodus.SubRoomChargeItems = { -- Subroom Charge items
        {
            id = Isaac.GetItemIdByName("Ominous Lantern"), 
            frames = Exodus.LanternFrameModifier,
            curCharge = 0
        }
    }

    Exodus.DBSquishables = { --Squishable Enemies for dad's boots
        {id = 85, variant = 0},
        {id = 246},
        {id = 21},
        {id = 23},
        {id = 30},
        {id = 31},
        {id = 32},
        {id = 58, variant = 0},
        {id = 56},
        {id = 77},
        {id = 94},
        {id = 215},
        {id = 243},
        {id = 244},
        {id = 215},
        {id = 255},
        {id = 21},
        {id = 217},
        {id = 206, variant = 1},
        {id = 207, variant = 1}
    }
    
    Exodus.FakeChargeBar = Sprite() -- Fake Chargebar Sprite
    Exodus.FakeChargeBar:Load("gfx/ui/ui_chargebar2.anm2",true) -- Load gfx for Fake Chargebar Sprite
    Exodus.BaseballMittUsed = false  -- If false, you can use the Baseball Mitt again
    Exodus.NumBaseballsSucked = 0 -- Number of Baseballs Sucked by Baseball Mitt
    Exodus.BaseballMittUseDelay = 0 -- When it was used so you can delay it by 120 frames
    Exodus.PseudobulbarIconSprite = Sprite() -- Pseudobulbar Affect Icon Sprite
    Exodus.PseudobulbarIconSprite:Load("gfx/Pseudobulbar Icon.anm2", true) -- Load gfx for Pseudobulbar Affect Icon Sprite
    Exodus.PseudobulbarIconSprite:Play("Idle", true) -- Play Idle for Pseudobulbar Affect Icon Sprite
    Exodus.WinStreakNum = 0 -- Number of Rooms Cleared with Winstreak
    Exodus.NumForbFruitUses = 0 -- How many times did the player use The Forbidden Fruit?
    Exodus.FlyerballFires = {} -- Flyerball Fires Table
    Exodus.HasDefecation = false --Has Defecation.
    Exodus.IsIsaacScissored = false --Has Isaac been Scissored?
    Exodus.HasCursedMetronome = false --Has Cursed Metronome.
    Exodus.WotlPosition = NullVector --WotL Position.
    Exodus.HasMysteriousMoustache = false --Has Mysterious Mustache.
    Exodus.UsedMutantClover = false --Used Mutant Clover?
    Exodus.UsedTragicMushroom = false --Used Tragic Mushroom?
    Exodus.HasWelcomeMat = false --Has Welcome Mat.
    Exodus.MatPosition = NullVector --Welcome Mat's position.
    Exodus.MatDirection = 0 --Welcome Mat's sprite direction.
    Exodus.CloseToMat = false --Is Isaac close to the Welcome Mat?
    Exodus.Parts = 0 --Number of parts picked up out of 12 for an HP upgrade with Gluttony's Stomach.
    
    if player then
      Exodus.PlayerItemCount = player:GetCollectibleCount() --Number of items.
      Exodus.PlayerCoinCount = player:GetNumCoins() --Number of coins.
    else
      Exodus.PlayerItemCount = 0
      Exodus.PlayerCoinCount = 0
    end
  end
end
Exodus.newgame(false)

function Exodus:PlayerIsMoving()
    for i = 0, 3 do
        if Input.IsActionPressed(i, player.ControllerIndex) then
            return true
        end
    end
    
    return false
end

function Exodus:IsProperEnemy(ent)
    if ent~=nil then
        if ent:IsActiveEnemy(false) and ent:CanShutDoors() then
            return true
        end
    end
    
    return false
end

function Exodus:GetRandomEnemyInTheRoom(entity) 
  local index = 1
  local possible = {}
  
  for i = 1,#entities do
    if Exodus:IsProperEnemy(entities[i]) and entity.Position:Distance(entities[i].Position) < 250 then
      possible[index] = entities[i]
      index = index + 1
    end
  end
  
  return possible[math.random(1,index)]
end

function Exodus:PlayCandleTearSprite(candletear)
  local sprite = candletear:GetSprite()
  sprite:Load("gfx/Psychic Tear.anm2",true)
  
  if candletear.CollisionDamage <= 0.5 then
    sprite:Play("RegularTear1",true)
  elseif candletear.CollisionDamage <= 1 then
    sprite:Play("RegularTear2",true)
  elseif candletear.CollisionDamage <= 1.5 then
    sprite:Play("RegularTear3",true)
  elseif candletear.CollisionDamage <= 2 then
    sprite:Play("RegularTear4",true)
  elseif candletear.CollisionDamage <= 3 then
    sprite:Play("RegularTear5",true)
  elseif candletear.CollisionDamage <= 4.5 then
    sprite:Play("RegularTear6",true)
  elseif candletear.CollisionDamage <= 6 then
    sprite:Play("RegularTear7",true)
  elseif candletear.CollisionDamage <= 7.5 then
    sprite:Play("RegularTear8",true)
  elseif candletear.CollisionDamage <= 9 then
    sprite:Play("RegularTear9",true)
  elseif candletear.CollisionDamage <= 10.5 then
    sprite:Play("RegularTear10",true)
  elseif candletear.CollisionDamage <= 15 then
    sprite:Play("RegularTear11",true)
  elseif candletear.CollisionDamage < 20 then
    sprite:Play("RegularTear12",true)
  elseif candletear.CollisionDamage >= 20 then
    sprite:Play("RegularTear13",true)
  end
end

function Exodus:IsAOEFree()
	local entities = Isaac.GetRoomEntities()
    
	for i=1, #entities do
		if entities[i]:GetData().IsOccultistAOE == true then
			return false
		end
	end
end

function Exodus:SpawnCandleTear(npc,isnormal)
  local target = Exodus:GetRandomEnemyInTheRoom(npc)

  if target ~= nil then
    local angle = (target.Position - npc.Position):GetAngleDegrees()
    local candletear = Isaac.Spawn(EntityType.ENTITY_TEAR,0,0,npc.Position,Vector.FromAngle(1*angle):Resized(5),player)
    
    candletear:ToTear().TearFlags = candletear:ToTear().TearFlags | TearFlags.TEAR_HOMING
    Exodus:PlayCandleTearSprite(candletear)
    candletear:GetData().AddedFireBonus = true
  end
end

function Exodus:SpawnGib(position,spawner,big)
	local YOffset = math.random(5,20)
	local LanternGibs = Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Lantern Gibs") ,0,position,Vector(math.random(-20,20),-1 * YOffset),spawner)
	LanternGibs:GetData().Offset = YOffset
	LanternGibs.SpriteRotation = math.random(360)
	if LanternGibs.FrameCount == 0 then
		if big == false then
			LanternGibs:GetSprite():Play("Gib0" .. tostring(math.random(2,4)),false)
			LanternGibs:GetSprite():Stop()
		elseif big then
			LanternGibs:GetSprite():Play("Gib01",false)
			LanternGibs:GetSprite():Stop()
		end
	end
end

function Exodus:FireTurretBullet(pos, vel, spawner)
	local player = Isaac.GetPlayer(0)
	local TurretBullet = player:FireTear(pos, vel, false, true, false)
	if spawner:IsBoss() then
		TurretBullet.CollisionDamage = TurretBullet.CollisionDamage * 2
		TurretBullet.Scale = TurretBullet.Scale * 2
	end
	local sprite = TurretBullet:GetSprite()
	sprite.Color = Color(sprite.Color.R, sprite.Color.G, sprite.Color.B, sprite.Color.A, 100, 0, 0)
	sprite:Load("gfx/Blood Tear.anm2", true)
	if TurretBullet.CollisionDamage <= 0.5 then
		sprite:Play("RegularTear1", true)
	elseif TurretBullet.CollisionDamage <= 1 then
		sprite:Play("RegularTear2", true)
	elseif TurretBullet.CollisionDamage <= 1.5 then
		sprite:Play("RegularTear3", true)
	elseif TurretBullet.CollisionDamage <= 2 then
		sprite:Play("RegularTear4", true)
	elseif TurretBullet.CollisionDamage <= 3 then
		sprite:Play("RegularTear5", true)
	elseif TurretBullet.CollisionDamage <= 4.5 then
		sprite:Play("RegularTear6", true)
	elseif TurretBullet.CollisionDamage <= 6 then
		sprite:Play("RegularTear7", true)
	elseif TurretBullet.CollisionDamage <= 7.5 then
		sprite:Play("RegularTear8", true)
	elseif TurretBullet.CollisionDamage <= 9 then
		sprite:Play("RegularTear9", true)
	elseif TurretBullet.CollisionDamage <= 10.5 then
		sprite:Play("RegularTear10", true)
	elseif TurretBullet.CollisionDamage <= 15 then
		sprite:Play("RegularTear11", true)
	elseif TurretBullet.CollisionDamage < 20 then
		sprite:Play("RegularTear12", true)
	elseif TurretBullet.CollisionDamage >= 20 then
		sprite:Play("RegularTear13", true)
	end
end

function Exodus:FireLantern(pos,vel,anim)
	if (Exodus.FiredOminousLantern == false or player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)) and player:HasCollectible(Isaac.GetItemIdByName("Ominous Lantern")) then 
		Exodus.LastOminousLanternHitEnemy = nil
		player:DischargeActiveItem()
		Exodus.FiredOminousLantern = true
		Exodus.LiftedOminousLantern = true
		local lantern = Isaac.Spawn(2,Isaac.GetEntityVariantByName("Lantern Tear"),0,pos,vel + player.Velocity,player):ToTear()
		lantern.FallingSpeed = -10
		lantern.FallingAcceleration = 1
		if anim then
			player:AnimateCollectible(Isaac.GetItemIdByName("Ominous Lantern"),"HideItem","PlayerPickupSparkle")
		end
	end
end

function Exodus:update()
  local entities = Isaac.GetRoomEntities()
  local room = game:GetRoom()
  local level = game:GetLevel()
  local player = Isaac.GetPlayer(0)
	for i=1, #entities do
		if entities[i].Type == EntityType.ENTITY_FAMILIAR and entities[i].Variant == Isaac.GetEntityVariantByName("Candle") then
			if entities[i]:GetData().RandomizedSpritesheet ~= true then
				entities[i]:GetData().RandomizedSpritesheet = true
				entities[i]:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/candle" .. tostring(math.random(1, 5)) .. ".png")
				entities[i]:GetSprite():LoadGraphics()
			end
		end
	end
    
    
	for i=1, #entities do
		if entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_HEART and entities[i].SubType == HeartSubType.HEART_SCARED then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 653, entities[i].Position, entities[i].Velocity, nil)
			entities[i]:Remove()
		elseif entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_HEART and entities[i].SubType == 653 then
			local entity = entities[i]
			local sprite = entity:GetSprite()
			if entity.FrameCount <= 1 then
				if entity:GetData().HasPlayedAppear ~= true then
					sprite:Play("Appear", false)
				end
				entity:GetData().FleeingFrames = 0
			end
			if entity.FrameCount >= 34 or entity:GetData().HasPlayedAppear == true then
				if sprite:IsFinished("Appear") then
					entity:GetData().HasPlayedAppear = true
				end
				if player.Position:Distance(entity.Position) < 50 and player.Position:Distance(entity.Position) > 25 then
					entity:GetData().FleeingFrames = 60
					entity.Velocity = (player.Position - entity.Position):Resized(-250 / player.Position:Distance(entity.Position))
				end
				if entity:GetData().FleeingFrames > 0 then
					entity:GetData().FleeingFrames = entity:GetData().FleeingFrames - 1
					sprite:Play("Flee", false)
				else
					sprite:Play("Idle", false)
				end
				if player.Position:Distance(entity.Position) < player.Size + entity.Size and player:GetMaxHearts() > player:GetHearts() and entity:GetData().Collected ~= true then
					player:AddHearts(2)
					entity:GetData().Collected = true
					entity:GetData().CollectedFrames = 0
				end
				if entity:GetData().CollectedFrames ~= nil then
					if entity:GetData().CollectedFrames <= 14 then
						sprite:SetFrame("Collect", entity:GetData().CollectedFrames)
						entity:GetData().CollectedFrames = entity:GetData().CollectedFrames + 1
						if entity:GetData().CollectedFrames > 4 then
							entity.Visible = false
						end
					else
						entity:Remove()
					end
				end
			end
		end
	end
    
    
	for i=1, #entities do -- Lobbed shots logic! If you want to make a lobbed shot, spawn a EntityType.ENTITY_TEAR and add FallingSpeed that's negative to it and add :GetData().IsExodusLobbed = true to make it
		local v = entities[i]
		if v.Type == 2 and v:GetData().IsExodusLobbed == true then
			if v.Position:Distance(player.Position) < 18 and v:ToTear().Height < 5 then
				v:Die()
				player:TakeDamage(1, 0, EntityRef(v), 0)
			end
		end
	end
    
    
	if player:HasTrinket(Isaac.GetTrinketIdByName("Bomb's Soul")) then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			local data = entity:GetData()
			if entity:IsActiveEnemy(true) and entity:ToNPC() then
				if entity:IsDead() and data.BombSoulDied ~= true then
					data.BombSoulDied = true
					local rng = player:GetTrinketRNG(Isaac.GetTrinketIdByName("Bomb's Soul"))
					if rng:RandomInt(4) == 1 then
						if not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
							local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_NORMAL, 0, entity.Position, Vector(0,0), player)
						else
							local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_MR_MEGA, 0, entity.Position, Vector(0,0), player)
						end
					end
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE_MIND, 0, entity.Position, Vector.FromAngle((player.Position - entity.Position):GetAngleDegrees()):Resized(10), player)
					tear.CollisionDamage = player.Damage
					tear:ToTear().Scale = 1 * player.Damage / 5
				end
			end
		end
	elseif player:HasTrinket(Isaac.GetTrinketIdByName("Broken Glasses")) then
		local entities = Isaac.GetRoomEntities()
		for i=1, #entities do
			if entities[i]:IsVulnerableEnemy() then
				if player:GetTrinketRNG(Isaac.GetTrinketIdByName("Broken Glasses")):RandomInt(200) == 1 then
					entities[i]:AddConfusion(EntityRef(player), 120, false)
				end
			end
		end
	end
    
    
	for i=1, #entities do
		if entities[i]:GetData().IsOccultistAOE == true then
			if entities[i]:GetData().AOEFrames < 120 then
				if entities[i].FrameCount >= 2 then
					local NewAOETear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entities[i].Position, Vector(0,0), entity)
					NewAOETear:GetData().IsOccultistAOE = true
					NewAOETear:GetData().AOEFrames = entities[i]:GetData().AOEFrames + 1
					entities[i]:Remove()
				end
			end
		end
		if entities[i] ~= nil and entities[i].Type == 1000 and entities[i].Variant == Isaac.GetEntityVariantByName("Iron Lung Gas") then
			if entities[i]:GetSprite():IsFinished("Appear") then
				entities[i]:GetSprite():Play("Pyroclastic Flow", false)
			end
			if entities[i]:GetSprite():IsFinished("Pyroclastic Flow") then
				entities[i]:GetSprite():Play("Fade", false)
			end
			if entities[i]:GetSprite():IsFinished("Fade") then
				entities[i]:Remove()
				entities[i].Visible = false
				entities[i] = nil
			end
			if entities[i] ~= nil then
				for v=1, #entities do
					if entities[v].Type == EntityType.ENTITY_TEAR then
						if entities[v].Position:Distance(entities[i].Position) < entities[i].Size + entities[v].Size then
							entities[v].Velocity = entities[v].Velocity * 0.8
						end
					end
				end
			end
		end
	end
    
    for i=1, #entities do
		if entities[i]:GetData().IsOccultistAOE == true then
			if entities[i]:GetData().AOEFrames < 120 then
				if entities[i].FrameCount >= 2 then
					local NewAOETear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entities[i].Position, Vector(0,0), entity)
					NewAOETear:GetData().IsOccultistAOE = true
					NewAOETear:GetData().AOEFrames = entities[i]:GetData().AOEFrames + 1
					entities[i]:Remove()
				end
			end
		end
		if entities[i] ~= nil and entities[i].Type == 1000 and entities[i].Variant == Isaac.GetEntityVariantByName("Iron Lung Gas") then
			if entities[i]:GetSprite():IsFinished("Appear") then
				entities[i]:GetSprite():Play("Pyroclastic Flow", false)
			end
			if entities[i]:GetSprite():IsFinished("Pyroclastic Flow") then
				entities[i]:GetSprite():Play("Fade", false)
			end
			if entities[i]:GetSprite():IsFinished("Fade") then
				entities[i]:Remove()
				entities[i].Visible = false
				entities[i] = nil
			end
			if entities[i] ~= nil then
				for v=1, #entities do
					if entities[v].Type == EntityType.ENTITY_TEAR then
						if entities[v].Position:Distance(entities[i].Position) < entities[i].Size + entities[v].Size then
							entities[v].Velocity = entities[v].Velocity * 0.8
						end
					end
				end
			end
		end
	end
    
    
  for i=1, #Exodus.FlyerballFires do
		if Exodus.FlyerballFires[i] ~= nil then
			if Exodus.FlyerballFires[i]:GetData().CountDown ~= nil then
				Exodus.FlyerballFires[i]:GetData().CountDown = Exodus.FlyerballFires[i]:GetData().CountDown - 1
				if Exodus.FlyerballFires[i]:GetData().CountDown <= 0 then
					Exodus.FlyerballFires[i]:Remove()
					Exodus.FlyerballFires[i] = nil
				end
			end
			if Exodus.FlyerballFires[i] ~= nil then
				if player.Position:Distance(Exodus.FlyerballFires[i].Position) < Exodus.FlyerballFires[i].Size + player.Size then
					player:TakeDamage(1, DamageFlag.DAMAGE_FIRE, EntityRef(Exodus.FlyerballFires[i]), 30)
				end
			end
		end
	end
    
    
  if Exodus.DragonBreathCharge == nil then Exodus.DragonBreathCharge = 0 end
  
  
  if game:GetFrameCount() == 1 then
		for i=1,#Exodus.SubRoomChargeItems do
			Exodus.SubRoomChargeItems[i].curCharge = 0
		end
	end
	local room = game:GetRoom()
	if player:GetActiveCharge() == 0 then
		for i,item in pairs(Exodus.SubRoomChargeItems) do
			if player:GetActiveItem() == item.id then
				Exodus.SubRoomChargeItems[i].curCharge = Exodus.SubRoomChargeItems[i].curCharge + 1
				if Exodus.SubRoomChargeItems[i].curCharge >= Exodus.LanternFrameModifier then
					Exodus.SubRoomChargeItems[i].curCharge = 0
					player:FullCharge()
				end
			end
		end
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
		Exodus.LanternFrameModifier = 100
	else
		Exodus.LanternFrameModifier = 300
	end
	if game:GetFrameCount() <= 1 or game:GetRoom():GetFrameCount() <= 1 then
		Exodus.FiredOminousLantern = true
		Exodus.LiftedOminousLantern = true
	end	
	if Exodus.FiredOminousLantern == false then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
			player:FullCharge()
		end
		if Exodus.LiftedOminousLantern == false then
			player:AnimateCollectible(Isaac.GetItemIdByName("Ominous Lantern"),"LiftItem","PlayerPickupSparkle")
			Exodus.LiftedOminousLantern = true
		end
	end
	if Exodus.HidOminousLantern then
		Exodus.HidOminousLantern = false
		player:FullCharge()
	end
	for i=1,#entities do
		if entities[i].Type == EntityType.ENTITY_TEAR and entities[i].Variant == Isaac.GetEntityVariantByName("Lantern Tear") then
			if entities[i]:IsDead() then
				SFXManager():Play(SoundEffect.SOUND_METAL_BLOCKBREAK,1,0,false,1.5)
				Exodus:SpawnGib(entities[i].Position,entities[i],true)
				Exodus:SpawnGib(entities[i].Position,entities[i],false)
				Exodus:SpawnGib(entities[i].Position,entities[i],false)
				Exodus:SpawnGib(entities[i].Position,entities[i],false)
				local purplefire = Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Lantern Fire"),0,entities[i].Position,NullVector,player)
				purplefire:GetData().ExistingFrames = 0
			end
		elseif entities[i].Type == 1000 and entities[i].Variant == Isaac.GetEntityVariantByName("Lantern Fire") then
			entities[i]:GetData().ExistingFrames = entities[i]:GetData().ExistingFrames + 1
			if entities[i]:GetData().ExistingFrames >= 300 then
				entities[i]:GetSprite():Play("Dying",false)
				if entities[i]:GetSprite():IsFinished("Dying") then
					entities[i]:Remove()
				end
			end
		end
	end
  if Exodus.BaseballMittUsed and player:HasCollectible(Isaac.GetItemIdByName("Baseball Mitt")) then
    player:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PROJECTILE then
				local playerPos = player.Position
				local bulletPos = entity.Position
				local distance = (playerPos):Distance(bulletPos)
				if distance > player.Size + entity.Size and distance <= 120 then
					local nudgeVector = (playerPos - bulletPos) / (distance)
					entity.Velocity = (entity.Velocity + nudgeVector):Resized(entity.Velocity:Length())
				elseif distance <= player.Size + entity.Size then
					entity:Remove()
					Exodus.NumBaseballsSucked = Exodus.NumBaseballsSucked + 1
				end
			end
		end
		if game:GetFrameCount() >= Exodus.BaseballMittUseDelay + 120 or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) or
		Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) or
		Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
			player:AnimateCollectible(Isaac.GetItemIdByName("Baseball Mitt"), "HideItem", "PlayerPickupSparkle")
			Exodus.BaseballMittUsed = false
			if Exodus.NumBaseballsSucked > 0 then
				repeat
					player:FireTear(player.Position, Vector(10, 1):Rotated(math.random(360)), false, true, false)
					Exodus.NumBaseballsSucked = Exodus.NumBaseballsSucked - 1
				until Exodus.NumBaseballsSucked == 0
				local entities = Isaac.GetRoomEntities()
				for i = 1, #entities do
					if entities[i].Type == EntityType.ENTITY_TEAR then
						if entities[i].Variant ~= Isaac.GetEntityVariantByName("Baseball") then
							local tear = entities[i]:ToTear()
							tear:ChangeVariant(Isaac.GetEntityVariantByName("Baseball"))
							tear.TearFlags = tear.TearFlags + TearFlags.TEAR_BOUNCE 
							tear.TearFlags = tear.TearFlags + TearFlags.TEAR_CONFUSION
                            tear.CollisionDamage = player.Damage * 3
						end
					end
				end
			end
		end
	end
	if player:HasCollectible(Isaac.GetItemIdByName("Defecation")) and not Exodus.HasDefecation then
		Exodus.HasDefecation = true
		if player:GetPlayerType() == PlayerType.PLAYER_THELOST then
			player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/oww white.anm2"))
		elseif player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_APOLLYON then
			player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/oww gray.anm2"))
		elseif player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS then
			player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/oww black.anm2"))
		elseif player:GetPlayerType() == PlayerType.PLAYER_XXX then
			player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/oww blue.anm2"))
		elseif player:GetPlayerType() == PlayerType.PLAYER_AZAZEL then
			player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/oww black w red eyes.anm2"))
		else
			player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/oww.anm2"))
		end
	end
	if player:HasCollectible(Isaac.GetItemIdByName("Defecation")) then
		for i = 1, #entities do
			if entities[i].Type == EntityType.ENTITY_TEAR then
				local e = entities[i]:ToTear()
				if e:GetData().HasReversed == nil then
					entities[i].Velocity = entities[i].Velocity * -1
					e:GetData().HasReversed = true
					entities[i].Position = entities[i].Position + entities[i].Velocity
				end
			end
		end
	end
    if player:HasCollectible(Isaac.GetItemIdByName("Dad's Boots")) then
		for i=1, #entities do
			if entities[i]:IsActiveEnemy() then
				for v=1, #Exodus.DBSquishables do
					if Exodus.DBSquishables[v].id == entities[i].Type and
					(Exodus.DBSquishables[v].variant == entities[i].Variant or Exodus.DBSquishables[v].variant == nil) and
					(Exodus.DBSquishables[v].subtype == entities[i].SubType or Exodus.DBSquishables[v].subtype == nil) and
					entities[i].Position:Distance(player.Position) < player.Size + entities[i].Size and player.Velocity ~= NullVector and Exodus:PlayerIsMoving() then
						entities[i]:Die()
						SFXManager():Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, entities[i].Size / 8)
					end
				end
			end
		end
	end
	if player:HasCollectible(Isaac.GetItemIdByName("Gluttony's Stomach")) and player:HasFullHearts() then
		for i, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 and entity.Variant == 10 and player.Position:Distance(entity.Position) <= 32 then
				local sprite = entity:GetSprite()
				if sprite:IsPlaying("Idle") then
					if entity.SubType == 1 then
						Exodus.Parts = Exodus.Parts + 2
						local heart = entity:ToPickup()
						heart:PlayPickupSound()
						Isaac.Spawn(1000, 15, 0, entity.Position, Vector(0,0), entity)
						Isaac.Spawn(1000, 4990838, 0, player.Position, Vector(0,0), player)
						entity:Remove()
					elseif entity.SubType == 2 then
						Exodus.Parts = Exodus.Parts + 1
						local heart = entity:ToPickup()
						heart:PlayPickupSound()
						Isaac.Spawn(1000, 15, 0, entity.Position, Vector(0,0), entity)
						Isaac.Spawn(1000, 4990837, 0, player.Position, Vector(0,0), player)
						entity:Remove()
					elseif entity.SubType == 5 then
						Exodus.Parts = Exodus.Parts + 4
						local heart = entity:ToPickup()
						heart:PlayPickupSound()
						Isaac.Spawn(1000, 15, 0, entity.Position, Vector(0,0), entity)
						Isaac.Spawn(1000, 4990839, 0, player.Position, Vector(0,0), player)
						entity:Remove()
					end
				end
			end
		end	
	end
	if Exodus.Parts >= 12 then
		Exodus.Parts = Exodus.Parts - 4
		player:AddMaxHearts(2, false)
	end
  if player:HasTrinket(Isaac.GetTrinketIdByName("Pet Rock")) then
    if player:GetData().HasHadSturdyStone ~= true then
      player:GetData().HasHadSturdyStone = true
    end
    if player:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) == false then
      player:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
      player:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    end
  else
    if player:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) and player:GetData().HasHadSturdyStone then
      player:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
      player:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Ritual Candle")) then
    Exodus.NumRitualCandles = 0
    for _,entity in pairs(Isaac.GetRoomEntities()) do 
      if entity.Type == 1000 and entity.Variant == 93 and entity:GetData().IsFromRitual then
        entity:Remove()
      end
      local range = 107
      if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        range = 150
      end
      if Exodus.RitualCandleBonus and entity.Position:Distance(player.Position) <= range and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and game:GetFrameCount() % math.floor(player.MaxFireDelay/3) == 0 then
        entity:TakeDamage((player.Damage/4)*(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)+1),0,EntityRef(player),0)
      end
      if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Isaac.GetEntityVariantByName("Candle") and entity:GetData().IsLit then
        Exodus.NumRitualCandles = Exodus.NumRitualCandles + 1
      end
      if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Isaac.GetEntityVariantByName("Candle") and entity:GetData().IsLit then
        if Exodus.RitualCandleBonus and entity:GetData().LitTimer > 120 then
          entity:GetSprite():Play("Lit All",false)
        else
          entity:GetSprite():Play("Lit",false)
        end
      elseif entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Isaac.GetEntityVariantByName("Candle") and entity:GetData().IsLit == false then
        entity:GetSprite():Play("Idle",false)
      end
    end
    if Exodus.NumRitualCandles == 5 then
      Exodus.RitualCandlePentagram = Isaac.Spawn(1000,93,0,player.Position,NullVector,player)
      Exodus.RitualCandlePentagram:GetSprite():Load("gfx/pentagram.anm2",true)
      Exodus.RitualCandlePentagram:GetSprite():Play("Idle",false)
      Exodus.RitualCandlePentagram:GetSprite():SetFrame("Idle",(game:GetFrameCount() % 5))
      Exodus.RitualCandlePentagram:ToEffect():FollowParent(player)
      Exodus.RitualCandlePentagram.SpriteRotation = player.FrameCount*-2
      Exodus.RitualCandlePentagram:GetData().IsFromRitual = true
      if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        Exodus.RitualCandlePentagram.SpriteScale = Vector(1.45,1.45)
      end
      Exodus.RitualCandleBonus = true
      if Exodus.RitualCandlePlayedSound == false then
        SFXManager():Play(SoundEffect.SOUND_SATAN_GROW,1,0,false,1)
        Exodus.RitualCandlePlayedSound = true
      end
    else
      Exodus.RitualCandleBonus = false
      if Exodus.RitualCandlePlayedSound then
        SFXManager():Play(SoundEffect.SOUND_SATAN_HURT,1,0,false,1)
        Exodus.RitualCandlePlayedSound = false
      end
    end	
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Forget Me Later")) and Exodus.HasForgetMeLater == false then
    Exodus.ForgetMeLtrNumberFloors = level:GetAbsoluteStage() + math.random(2)
    Exodus.HasForgetMeLater = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Forget Me Later")) and player:GetSprite():IsPlaying("Trapdoor") and level:GetAbsoluteStage() >= Exodus.ForgetMeLtrNumberFloors then
    player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW,false,false,false,false)
    player:RemoveCollectible(Isaac.GetItemIdByName("Forget Me Later"))
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Pig Blood")) then
    if Exodus.HasPigBlood == false then
      Exodus.HasPigBlood = true
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Pig Blood.anm2"))
    end
    if game:GetRoom():GetType() == RoomType.ROOM_DEVIL then
      for i = 1,#entities do
        local e = entities[i]
        if e.Type == 5 and e:IsDead() and e:GetData().IsRestocked == nil and (e.Variant == 100 or e.Variant == 150) then 
          e:GetData().IsRestocked = true
          Isaac.Spawn(5,150,0,e.Position,NullVector,e)
        end
      end
    end
  else
    if Exodus.HasPigBlood then
      Exodus.HasPigBlood = false
    end
  end
  local posPlayer = player.Position
  if Exodus.MatPosition ~= nil then
    if (posPlayer:Distance(Exodus.MatPosition) <= 100) then
      Exodus.CloseToMat = true
       player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
       player:EvaluateItems()
    else
      Exodus.CloseToMat = false
      player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
      player:EvaluateItems()
    end
  end
  local currentSoulHearts = player:GetSoulHearts()
  if player:HasCollectible(Isaac.GetItemIdByName("Mysterious Mustache")) then
	if player:GetCollectibleCount() > Exodus.PlayerItemCount and game:GetRoom():GetType() == RoomType.ROOM_SHOP and 1 == math.random(2) then
      player:AddHearts(1)
		if currentSoulHearts ~= player:GetSoulHearts() then
		  currentSoulHearts = player:GetSoulHearts()
			player:AddHearts(-1 * currentSoulHearts)
			player:AddHearts(1)
			player:AddSoulHearts(currentSoulHearts)
		  end
		end
	if Exodus.PlayerCoinCount > player:GetNumCoins() and game:GetRoom():GetType() == RoomType.ROOM_SHOP and 1 == math.random(100) then
	  player:AddCoins(Exodus.PlayerCoinCount - player:GetNumCoins())
	end
  end
  Exodus.PlayerItemCount = player:GetCollectibleCount()
  Exodus.PlayerCoinCount = player:GetNumCoins()
  if player:HasTrinket(Isaac.GetTrinketIdByName("Burlap Sack")) then
    for i = 1,#entities do
      local e = entities[i]
      if e.Type == 5 and e.Variant == 69 and e:IsDead() and e:GetData().IsSacked == nil then 
        e:GetData().IsSacked = true
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SACK_HEAD) and math.random(6) == 1 then
          Isaac.Spawn(5,69,0,e.Position,RandomVector()*5,player)
        else
          Isaac.Spawn(5,0,0,e.Position,RandomVector()*5,player)
        end
      end
    end
  end
if Exodus.WotlFrameCount ~= nil and player:HasCollectible(Isaac.GetItemIdByName("Wrath of the Lamb")) then
	local summonMark = Isaac.Spawn(Isaac.GetEntityTypeByName("Summoning Mark"),0,0,Exodus.WotlPosition,NullVector,player)
	local sprite = summonMark:GetSprite()
	sprite:Play("Idle",false)
	sprite:SetFrame("Idle",(game:GetFrameCount() % 21))
	summonMark:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
	game:GetRoom():SetClear(false)
    if game:GetFrameCount() >= Exodus.WotlFrameCount + 65 and Exodus.HasWotlBossSpawned == false then
		if MusicManager():GetCurrentMusicID() ~= Isaac.GetMusicIdByName("Locus") then
			MusicManager():PitchSlide(1)
			MusicManager():Play(Isaac.GetMusicIdByName("Locus"),0.15)
		end
		Exodus.HasWotlBossSpawned = true
		Exodus.WotlBossroomIndex = game:GetLevel():GetCurrentRoomIndex()
		for i,entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 64337 then
				if game:GetLevel():GetAbsoluteStage() == 1 or game:GetLevel():GetAbsoluteStage() == 2 then
					enemyPool = {EntityType.ENTITY_THE_HAUNT, EntityType.ENTITY_DINGLE, EntityType.ENTITY_MONSTRO, EntityType.ENTITY_LITTLE_HORN,
					EntityType.ENTITY_GURDY_JR, EntityType.ENTITY_FISTULA_BIG, EntityType.ENTITY_DUKE, EntityType.ENTITY_GEMINI, EntityType.ENTITY_RAG_MAN,
					EntityType.ENTITY_PIN, EntityType.ENTITY_WIDOW, EntityType.ENTITY_FAMINE, EntityType.ENTITY_GREED}
				elseif game:GetLevel():GetAbsoluteStage() == 3 or game:GetLevel():GetAbsoluteStage() == 4 then
					enemyPool = {EntityType.ENTITY_CHUB, EntityType.ENTITY_POLYCEPHALUS, EntityType.ENTITY_RAG_MEGA, EntityType.ENTITY_DARK_ONE,
					EntityType.ENTITY_MEGA_FATTY, EntityType.ENTITY_BIG_HORN, EntityType.ENTITY_MEGA_MAW, EntityType.ENTITY_PESTILENCE, EntityType.ENTITY_PEEP,
					EntityType.ENTITY_GURDY }
				elseif game:GetLevel():GetAbsoluteStage() == 5 or game:GetLevel():GetAbsoluteStage() == 6 then
					enemyPool = {EntityType.ENTITY_MONSTRO2, EntityType.ENTITY_ADVERSARY, EntityType.ENTITY_GATE, EntityType.ENTITY_LOKI, EntityType.ENTITY_MONSTRO2,
					EntityType.ENTITY_ADVERSARY, EntityType.ENTITY_BROWNIE, EntityType.ENTITY_WAR, EntityType.ENTITY_URIEL }
				elseif game:GetLevel():GetAbsoluteStage() == 7 or game:GetLevel():GetAbsoluteStage() == 8 then
					enemyPool = {EntityType.ENTITY_MR_FRED, EntityType.ENTITY_BLASTOCYST_BIG, EntityType.ENTITY_CAGE, EntityType.ENTITY_MASK_OF_INFAMY,
					EntityType.ENTITY_GABRIEL, EntityType.ENTITY_MAMA_GURDY}
				elseif game:GetLevel():GetAbsoluteStage() == 9 then
					enemyPool = {EntityType.ENTITY_FORSAKEN, EntityType.ENTITY_STAIN}
				elseif game:GetLevel():GetAbsoluteStage() == 10 then
					enemyPool = {EntityType.ENTITY_DEATH, EntityType.ENTITY_DADDYLONGLEGS, EntityType.ENTITY_SISTERS_VIS}
				elseif game:GetLevel():GetAbsoluteStage() == 11 then
					if level:GetStageType() == StageType.STAGETYPE_WOTL then
						Exodus.HasWotlBossSpawned = false
						Exodus.WotlFrameCount = nil
						entity:Remove()
						Isaac.ExecuteCommand("stage 11")
					else
						Exodus.HasWotlBossSpawned = false
						Exodus.WotlFrameCount = nil
						entity:Remove()
						player:UseCard(Card.CARD_EMPEROR)
					end
				else
					enemyPool = {EntityType.ENTITY_MOMS_HEART, EntityType.ENTITY_SATAN, EntityType.ENTITY_ISAAC}
				end
				Isaac.Spawn(enemyPool[math.random(#enemyPool)],0,0,entity.Position,NullVector,nil)
				Exodus.WotlFrameCount = nil
				Exodus.HasWotlBossSpawned = false
				entity:Remove()
			end
		end
	end
end
if game:GetRoom():IsClear() and Exodus.WotlBossroomIndex == game:GetLevel():GetCurrentRoomIndex() and player:HasCollectible(Isaac.GetItemIdByName("Wrath of the Lamb")) then
  MusicManager():Play(Music.MUSIC_BOSS_OVER,0.1)
  	local payout = math.random(1, 100)
	if payout < 70 then
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	elseif payout < 75 then
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	elseif payout < 80 then
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	elseif payout < 85 then
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	elseif payout < 90 then
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	elseif payout < 95 then
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	else
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
	  local payout = math.random(1, 100)
	  if payout < 70 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  elseif payout < 75 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  elseif payout < 80 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  elseif payout < 85 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  elseif payout < 90 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  elseif payout < 95 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  else
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(Exodus.WotlPosition, 20), Vector(0, 0), entity)
	  end
	end
  Exodus.WotlBossroomIndex = nil
end
  if Exodus.IsIsaacScissored and 1 == math.random(3) then
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 3, player.Position, Vector(0, 0), player)
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Cursed Metronome")) and not Exodus.HasCursedMetronome then
	local maxhp = player:GetMaxHearts() - 2
	player:AddHearts(maxhp * -1)
	for i = 1, math.random(0, maxhp / 2) do
		Isaac.Spawn(5, 10, 1, room:FindFreePickupSpawnPosition(player.Position, 5, true), Vector(0, 0), player)
	end
	player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/CursedMetronome.anm2"))
	Exodus.HasCursedMetronome = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Mysterious Mustache")) and not Exodus.HasMysteriousMoustache then
	player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/MysteriousMustache.anm2"))
	Exodus.HasMysteriousMoustache = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Tech Y")) then
    if Exodus.HasTechY == false then
      Exodus.HasTechY = true
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_TechY.anm2"))
    end
    for k,v in pairs(entities) do 
      if v.Type == 7 and v:GetData().TechY == true then
        v.Position = player.Position
        v.Velocity = player.Velocity
      end
      if v.Type == 2 and v.Variant ~= 9 and v.Variant ~= 4 and v.SpawnerType == 1 then
        v:Remove()
        local laser = player:FireTechXLaser(player.Position,player.Velocity,1)
        laser.TearFlags = laser.TearFlags + TearFlags.TEAR_CONTINUUM
        laser.Color = player.TearColor
        laser:GetData().TechY = true
        v.SpawnerType = 2
      end
      if v.Type == 7 and v.SpawnerType == 1 and v.Variant == 2 and (v:GetData().TechY or player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)) then
        v.Color = player.TearColor
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) and v:ToLaser().Radius > math.abs(player.TearHeight*6) then
          v:Remove()
          for i = 1,6 do
            local laser = player:FireTechLaser(v.Position,3193,Vector.FromAngle(i*(60+math.random(-5,5))),false,false)
            laser.TearFlags = laser.TearFlags + TearFlags.TEAR_SPECTRAL
            laser.Color = player.TearColor
            laser.DisableFollowParent = true
          end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) and v.FrameCount == 30 then
          v:Remove()
          local laser = player:FireTechXLaser(v.Position,RandomVector()*(v:ToLaser().Radius/20),v:ToLaser().Radius)
          laser.TearFlags = laser.TearFlags + TearFlags.TEAR_CONTINUUM
          laser.Color = player.TearColor
          laser:GetData().TechY = true
          laser:GetData().TechX = true
        end
        if v:ToLaser().Radius > math.abs(player.TearHeight*3) and player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) == false then
          v:Remove()
          for i = 1,6 do
            local laser = player:FireTechLaser(v.Position,3193,Vector.FromAngle(i*(60+math.random(-5,5))),false,false)
            laser.TearFlags = laser.TearFlags + TearFlags.TEAR_SPECTRAL
            laser.Color = player.TearColor
            laser.DisableFollowParent = true
          end
        else
          if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) and v.FrameCount < 80 then
            v:ToLaser().Radius = 10
          else
            v:ToLaser().Radius = v:ToLaser().Radius + Exodus:GetTechYSize()
          end
        end
      end
    end
  end
  if player:HasTrinket(Isaac.GetTrinketIdByName("Grid Worm")) then
    for k,v in pairs(entities) do
      local rand = math.random(4)
      if v.Type == 2 and v.SpawnerType == 1 then
        if v.FrameCount > player.TearHeight*-3 then
          v:Die()
        end
        if v.FrameCount % 10 == 1 and v.FrameCount > 10 or v.FrameCount == 4 then
          if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
            if rand == 1 then
              v.Velocity = Vector(player.ShotSpeed*10,player.ShotSpeed*10)
            elseif rand == 2 then
              v.Velocity = Vector(-player.ShotSpeed*10,player.ShotSpeed*10)
            elseif rand == 3 then
              v.Velocity = Vector(player.ShotSpeed*10,-player.ShotSpeed*10)
            elseif rand == 4 then
              v.Velocity = Vector(-player.ShotSpeed*10,-player.ShotSpeed*10)
            end
          else
            if rand == 1 then
              v.Velocity = Vector(player.ShotSpeed*10,0)
            elseif rand == 2 then
              v.Velocity = Vector(-player.ShotSpeed*10,0)
            elseif rand == 3 then
              v.Velocity = Vector(0,player.ShotSpeed*10)
            elseif rand == 4 then
              v.Velocity = Vector(0,-player.ShotSpeed*10)
            end
          end
        end
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Sad Tears")) then
    local rng = player:GetCollectibleRNG(Isaac.GetItemIdByName("Sad Tears"))
    for i=1,#entities do
      if entities[i].Type == EntityType.ENTITY_TEAR and entities[i]:GetData().IsSadTear ~= true then
        if player.FireDelay == player.MaxFireDelay and rng:RandomInt(math.max(1,5 - player.Luck)) == 0 and entities[i].FrameCount > 1 then
          local shot_tear = player:FireTear(entities[i].Position,RandomVector()*entities[i].Velocity:Length()*((player.ShotSpeed + 0.4)/player.ShotSpeed),false,false,false)
          shot_tear:GetData().IsSadTear = true
        end
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Busted Pipe")) then
    if Exodus.HasBustedPipe == false then
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Busted Pipe.anm2"))
      Exodus.HasBustedPipe = true
    end
    for k,v in pairs(entities) do
      if v.Type == 7 and v.FrameCount == 1 and Exodus:HasPlayerChance(7) and not v:ToLaser().IsCircleLaser then
        for i = 1,10 do
          local creep = Isaac.Spawn(1000,EffectVariant.PLAYER_CREEP_GREEN,0,v.Position+(Vector.FromAngle(v:ToLaser().Direction)*i*40),NullVector,player):ToEffect()
          creep:SetTimeout(20)
          creep.Color = player.TearColor
          creep.CollisionDamage = player.Damage
          creep:SetColor(Color(0.5,0.5,1,1,0,0,255),-1,1,false,false)
        end
      elseif (v.Type == 2 or (v.Type == 7 and v:ToLaser().IsCircleLaser)) and v.SpawnerType == 1 then
        if Exodus:HasPlayerChance(7) and v.FrameCount == 1 then
          v:GetData().IsLeakyTear = true
          v:SetColor(Color(0.5,0.5,1,1,0,0,0),-1,1,false,false)
        end
        if v:GetData().IsLeakyTear then
          if v.FrameCount == 1 then
            v.Velocity = v.Velocity*1.6
          end
          if math.random(3) == 1 and v.Position:Distance(player.Position) > 30 then
            for i = 1,player:GetCollectibleNum(Isaac.GetItemIdByName("Busted Pipe")) do
              local creep = Isaac.Spawn(1000,EffectVariant.PLAYER_CREEP_GREEN,0,v.Position+(RandomVector()*(i-1)*30),NullVector,v):ToEffect()
              creep:SetTimeout(20)
              creep.Color = player.TearColor
              creep.CollisionDamage = player.Damage*2
              creep:SetColor(Color(0.5,0.5,1,1,0,0,255),-1,1,false,false)
            end
          end
        end
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Beenades")) then
    if Exodus.HasBeenades == false then
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Beenades.anm2"))
      Exodus.HasBeenades = true
    end
    for k,v in pairs(entities) do
      if v.Type == 1000 and v.Variant == EffectVariant.ROCKET and v:IsDead() and player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
        if not string.find(v:GetSprite():GetFilename(),"gfx/effects/bee") then
          v:GetSprite():ReplaceSpritesheet(0,"gfx/effects/effect_035_beemissile.png")
          v:GetSprite():LoadGraphics()
        end
        Exodus:FireXHoney(15,v)
      end
      if v.Type == EntityType.ENTITY_BOMBDROP and (v.SpawnerType == 1 or v.SpawnerType == 4) then
        if string.find(v:GetSprite():GetFilename(),"gfx/004") then
          v:GetSprite():ReplaceSpritesheet(0,"gfx/items/pick ups/pickup_016_beebomb.png")
          v:GetSprite():LoadGraphics()
        end
        if v:IsDead() then
          v:Remove()
          Exodus:FireXHoney(15,v)
        end
      end
      if v.Type == 1000 and v.Variant == Isaac.GetEntityVariantByName("Honey Poof") and v:GetSprite():IsFinished("Poof") then
        v:Remove()
      end
      if v.Type == 1000 and v.Variant == Isaac.GetEntityVariantByName("Honey Splat") then
        v.SpriteRotation = v.Velocity:GetAngleDegrees()
        if v:CollidesWithGrid() or v.FrameCount > 15 then
          Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Honey Poof"),0,v.Position,NullVector,v)
          local creep = Isaac.Spawn(1000,EffectVariant.PLAYER_CREEP_BLACK,0,v.Position,NullVector,player):ToEffect()
          creep:SetTimeout(200)
          creep:SetColor(Color(0,0,0,1,math.random(200,250),math.random(150,200),math.random(0,10)),-1,1,false,false)
          creep:GetData().IsHoneyCreep = true
          v:Remove()
          if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
            creep.Velocity = v.Velocity*100
          end
          if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
            local brim = player:FireBrimstone(RandomVector())
            brim.Position = v.Position
            brim.DisableFollowParent = true
          end
          if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
            local tech = player:FireTechLaser(v.Position,0,RandomVector(),false,false)
            tech.DisableFollowParent = true
          end
        end
      end
      if player:HasCollectible(CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD) and v.Type == 2 and v.Variant == 4 and v:IsDead() then
        Exodus:FireXHoney(15,v)
      end
      if v:GetData().IsHoneyCreep and v.Type == 1000 and v.Variant == EffectVariant.PLAYER_CREEP_BLACK then
        for k,e in pairs(entities) do
          if e:IsVulnerableEnemy() and e:IsActiveEnemy() and not e:IsFlying() then
            if e:HasEntityFlags(EntityFlag.FLAG_SLOW) then
              e:GetSprite():Stop()
              e.Velocity = NullVector
              e.Friction = e.Friction/2
            end
          end
        end
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Queen Bee")) then
    if player.FrameCount % (math.random(14,16)) == 0 then
      local creep = Isaac.Spawn(1000,EffectVariant.PLAYER_CREEP_BLACK,0,player.Position,NullVector,player)
      creep:SetColor(Color(0,0,0,1,math.random(200,250),math.random(150,200),math.random(0,10)),-1,1,false,false)
    end
    if Exodus.HasQueenBee == false then
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Queen Bee.anm2"))
      Exodus.HasQueenBee = true
    end
    player.TearFallingAcceleration = -0.1
    if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER) then
      player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER,false)
    end
    if SFXManager():IsPlaying(SoundEffect.SOUND_TEARS_FIRE) then
      SFXManager():Stop(SoundEffect.SOUND_TEARS_FIRE)
      SFXManager():Play(SoundEffect.SOUND_INSECT_SWARM_LOOP,1,0,true,0.8)
    end
    if SFXManager():IsPlaying(SoundEffect.SOUND_TEARIMPACTS) then
      SFXManager():Stop(SoundEffect.SOUND_TEARIMPACTS)
      SFXManager():Play(SoundEffect.SOUND_INSECT_SWARM_LOOP,1,0,true,0.8)
    end
    if player.FrameCount % 5 == 0 or game:GetRoom():GetFrameCount() == 1 then
      if variable[3] then
        player.TearColor = Color(0.1,0.1,0.1,1,0,0,0)
        player.LaserColor = Color(0.1,0.1,0.1,1,0,0,0)
        variable[3] = false
      else
        player.TearColor = Color(1,1,0,1,0,0,0)
        player.LaserColor = Color(1,1,0,1,0,0,0)
        variable[3] = true
      end
    end
    for i = 1,#entities do
      local e = entities[i]
      if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) and e.Type == 8 then
        if e.SpawnerType == 1 then
          e.Visible = false
          local knife = player:FireKnife(nil,math.random(360),true,0)
          knife.SpriteRotation = e.SpriteRotation+e.Position:Distance(player.Position)-30
          knife.Position = e.Position+RandomVector()
          knife:GetSprite().FlipY = true
        end
      end
      if e.Type == 7 and e.SpawnerType == 1 and e.Variant ~= 5 then
        if variable[3] then
          e.Color = Color(0,0,0,1,0,0,0)
          e.SplatColor = Color(0,0,0,1,0,0,0) 
        else
          e.Color = Color(1,1,0,1,255,255,0)
          e.SplatColor = Color(1,1,0,1,255,255,0)
        end
      end
      if e.Type == 1000 and e.Variant == EffectVariant.ROCKET and player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
        if not string.find(e:GetSprite():GetFilename(),"gfx/effects/bee") then
          e:GetSprite():ReplaceSpritesheet(0,"gfx/effects/effect_035_beemissile.png")
          e:GetSprite():LoadGraphics()
        end
        if e:IsDead() then
          Exodus:FireXHoney(15,e)
        end
      end
      if e.Type == 4 and e.SpawnerType == 1 and e:ToBomb().IsFetus then
        e.Velocity = e.Velocity + RandomVector()
      end
      if e.Type == 2 and e.SpawnerType == 1 or e.Type == 2 and e.SpawnerType == 3 and e.SpawnerType == 120 or e.Type == 2 and e.SpawnerType == 3 and e.SpawnerVariant == 80 then
        e.Color = player.TearColor
        e.Velocity = e.Velocity - RandomVector()
        if e.FrameCount == 1 and player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
          e.CollisionDamage = e.CollisionDamage*2
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and math.random(6) == 1 then
          for i2 = 1,#entities do
            local f = entities[i2]
            if f.Type == 1000 and f.Velocity ~= NullVector and f.Variant == 30 then
              e.Velocity = (f.Position-e.Position)/30 + RandomVector()*3
            end
          end
        end
        if e.FrameCount == 1 then
          e.Velocity = e.Velocity + RandomVector()*3
          e.Color = player.TearColor
        end
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) then
    if Exodus.HasWinStreak == false then
      Isaac.Spawn(Isaac.GetEntityTypeByName("Score Display"),Isaac.GetEntityVariantByName("Score Display"),0,player.Position+Vector(0,-69),NullVector,player)
      Exodus.WinStreakNum = -1
      Exodus.HasWinStreak = true
    end
    if room:IsClear() then
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
      if Exodus.IsWinStreakRoomClear == false then
        if room:GetRoomShape() == RoomShape.ROOMSHAPE_2x2 then
          Exodus.WinStreakNum = Exodus.WinStreakNum + 2
        else
          Exodus.WinStreakNum = Exodus.WinStreakNum + 1
        end
        Exodus.IsWinStreakRoomClear = true
      end
    else
      Exodus.IsWinStreakRoomClear = false
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Unholy Mantle")) and Exodus.HasUnholyMantle == false then
    player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2"))
    Exodus.HasUnholyMantle = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Paper Cut")) and Exodus.HasPaperCut == false then
    player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Paper Cut.anm2"))
    Exodus.HasPaperCut = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Dragon Breath")) then
    if Exodus.DragonBreathCharge >= 10 then
      player:SetColor(Color(1+math.abs(math.sin(player.FrameCount/5)*2),1,1,1,math.abs(math.ceil(math.cos(player.FrameCount/5)*50)),0,0),-1,1,false,false)
    else
      player:SetColor(Color(1,1,1,1,0,0,0),-1,1,false,false)
    end
    if Exodus.HasDragonBreath == false then
      bar = Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Charge Bar"),0,player.Position,NullVector,player)
      bar:GetData().IsFireball = true
      bar.Visible = false
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Dragon Breath.anm2"))
      Exodus.HasDragonBreath = true
    end
    player.FireDelay = 10
    if Exodus.DragonBreathCharge >= 10 then
      if player:GetFireDirection() > -1 then
        Exodus.FireBreathChargeDir = player:GetShootingJoystick()
      else
        Exodus:FireFire(Exodus.FireBreathChargeDir,false,false,false)
      end
    end
    if room:GetFrameCount() == 1 then
      bar = Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Charge Bar"),0,player.Position,NullVector,player)
      bar:GetData().IsFireball = true
      bar.Visible = false
    end
    if player:GetFireDirection() > -1 then
      if Exodus.DragonBreathCharge < 10 then
        Exodus.DragonBreathCharge = Exodus.DragonBreathCharge + (1/player.MaxFireDelay)*8
      end
    else
      Exodus.DragonBreathCharge = -1
    end
  end
  for i = 1,#entities do
    local e = entities[i]
      if e:GetData().IsPseudobulbarTurret then
        if player.FireDelay == player.MaxFireDelay then
          if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
            Exodus:FireTurretBullet(e.Position + Vector(-1 * e.Size, 0) , Vector(-15, 0) * player.ShotSpeed + e.Velocity, e)
          elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
              Exodus:FireTurretBullet(e.Position + Vector(e.Size, 0), Vector(15, 0) * player.ShotSpeed + e.Velocity, e)
            elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
            Exodus:FireTurretBullet(e.Position + Vector(0, -1 * e.Size), Vector(0, -15) * player.ShotSpeed + e.Velocity, e)
          elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
            Exodus:FireTurretBullet(e.Position + Vector(0, e.Size), Vector(0, 15) * player.ShotSpeed + e.Velocity, e)
          end
        end
      end
      if e.Type == 2 and e.Variant == Isaac.GetEntityVariantByName("Baseball") and e:IsDead() then
        local hit = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Baseball Hit"), 0, e.Position, NullVector, nil)
        hit:ToEffect():SetTimeout(20)
        hit.SpriteRotation = math.random(360)
      end
      if e:GetData().IsFromHushedHorfTear then
        local degress = 0
        if e.Position.X < player.Position.X and not player:IsDead() then
          degress = math.random(6,8)
        else
          degress = math.random(6,8)*-1
        end
        e.Velocity = Vector.FromAngle(e.Velocity:GetAngleDegrees()+degress):Resized(1.5*(math.sqrt(player.Position:Distance(e.Position)/10))) + (player.Position-e.Position):Resized(0.5)
      if e.FrameCount > 10 then
        e:Remove()
        local tear = Isaac.Spawn(9,6,0,e.Position+Vector(0,6),e.Velocity,e)
        tear:GetData().IsFromHushedHorfTear = true
        tear.Color = Color(0.83529411764,0.7294117647,0,1,0,0,0)
      end
    end
    if e.Type == 9 and e.Variant == 0 and e.SpawnerType == 12 and e.SpawnerVariant == Isaac.GetEntityVariantByName("Hushed Horf") then
      e:Remove()
      local tear = Isaac.Spawn(9,6,0,e.Position,e.Velocity,e)
      tear:GetData().IsFromHushedHorfTear = true
      tear.Color = Color(0.83529411764,0.7294117647,0,1,0,0,0)
    end
    if e.Type == 1000 and e.Variant == EffectVariant.CREEP_SLIPPERY_BROWN and e.SpawnerVariant == Isaac.GetEntityVariantByName("Drowned Mushroom") then
      e.Color = Color( 1, 1, 1, 1, 0, 255, 255)
      if e.FrameCount > 1 then
        e.Visible = true
      end
    end
    if player:HasTrinket(Isaac.GetTrinketIdByName("Rotten Penny")) then
      if e.Type == 5 and e.Variant == 20 and e:IsDead() and e:GetData().HasSpawnedFly == nil then 
        e:GetData().HasSpawnedFly = true
        local rep = 1
        if e.SubType == 2 then
          rep = 5
        elseif e.SubType == 3 then
          rep = 10
        elseif e.SubType == 4 then
          rep = 2
        elseif e.SubType == 5 then
          rep = 3
        end
        player:AddBlueFlies(rep,player.Position,nil)
      end
    end
    if e.Type == 23 and e.Variant == 1 then
      e.Velocity = e.Velocity*1.10
      if e.FrameCount == 1 then
        e.HitPoints = 12
        e.MaxHitPoints = 12
      end
    end
    if (e.Type == 85 and e.SpawnerType == 24 and e.SpawnerVariant == 2) or 
    (e.Type == 217 and player:GetCollectibleRNG(1):RandomInt(10) ~= 1 and e.Variant ~= 2 and e.Variant ~= Isaac.GetEntityVariantByName("Dank Dip") and
    (level:GetAbsoluteStage() == 5 or level:GetAbsoluteStage() == 6) and e.FrameCount == 1) then
      e:Remove()
      Isaac.Spawn(Isaac.GetEntityTypeByName("Dank Dip"),Isaac.GetEntityVariantByName("Dank Dip"),0,e.Position,NullVector,e)
    end
    if e.Type == 212 and e.Variant == 1 and math.random(8) == 1 then
      Isaac.Spawn(1000,EffectVariant.CREEP_BLACK,0,e.Position,NullVector,e)
    end
    if e.Type == 9 and e.SpawnerType == Isaac.GetEntityTypeByName("Drowned Mushroom") and 
    e.SpawnerVariant == Isaac.GetEntityVariantByName("Drowned Mushroom") or
    e.SpawnerVariant == Isaac.GetEntityVariantByName("Scary Shroomman") then
      e:Remove()
    end
    if e.Type == 1000 and e.Variant == EffectVariant.CREEP_BLACK and e.SpawnerType == Isaac.GetEntityTypeByName("Dank Dip") and e.SpawnerVariant == Isaac.GetEntityVariantByName("Dank Dip") then
      if e.FrameCount > 1 then
        e.Visible = true
      end
      if player.Position:Distance(e.Position) < 13 and e:IsDead() == false then
        player:AddSlowing(EntityRef(e),10,0.5,Color(1,1,1,1,0,0,0))
      end
    end
    if e.Type == Isaac.GetEntityTypeByName("Fireball 2") and e.Variant == Isaac.GetEntityVariantByName("Fireball 2") then
      e.SpriteRotation = e.FrameCount*8
      if e.FrameCount > player.TearHeight*-1 then
        e:Die()
      end
      if e:IsDead() then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) and player.Position:Distance(e.Position) < 70 and player:HasFullHearts() == false then
          Isaac.Spawn(1000,49,0,player.Position,NullVector,e)
          player:AddHearts(2)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) == false then
          Isaac.Explode(e.Position,nil,player.Damage*7)
        end
      end
    end
    if e.Type == Isaac.GetEntityTypeByName("Fireball") and e.Variant == Isaac.GetEntityVariantByName("Fireball") then
      e.Velocity = e.Velocity*1.01
      e.SpriteRotation = e.Velocity:GetAngleDegrees()-90
      if e:IsDead() or e.FrameCount > 100 then
        e:Die()
        if e:CollidesWithGrid() then
          local fire2 = Isaac.Spawn(Isaac.GetEntityTypeByName("Fireball 2"),Isaac.GetEntityVariantByName("Fireball 2"),0,e.Position,Vector.FromAngle(e.Velocity:GetAngleDegrees()+math.random(-45,45))*-10,e):ToTear()
          fire2.TearFlags = player.TearFlags + TearFlags.TEAR_PIERCING
          fire2.FallingAcceleration = -0.1
          fire2.CollisionDamage = player.Damage*2
          fire2.GridCollisionClass = GridCollisionClass.COLLISION_NONE
          fire2.Color = player.TearColor
        else
          local fire2 = Isaac.Spawn(Isaac.GetEntityTypeByName("Fireball 2"),Isaac.GetEntityVariantByName("Fireball 2"),0,e.Position,Vector.FromAngle(e.Velocity:GetAngleDegrees()+math.random(-45,45))*10,e):ToTear()
          fire2.TearFlags = player.TearFlags + TearFlags.TEAR_PIERCING
          fire2.FallingAcceleration = -0.1
          fire2.CollisionDamage = player.Damage*2
          fire2.Color = player.TearColor
          fire2.GridCollisionClass = GridCollisionClass.COLLISION_NONE
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
          for i=1,math.random(3,5) do
            player:FireTechLaser(e.Position,0,RandomVector(),false,false)
          end
        end
      end
    end
    if e.Type == Isaac.GetEntityTypeByName("Charge Bar") and e.Variant == Isaac.GetEntityVariantByName("Charge Bar") and e:GetData().IsFireball then
      e.Velocity = (player.Position-e.Position)/2
      e.Position = player.Position
      if Exodus.DragonBreathCharge ~= 10 and Exodus.DragonBreathCharge ~= -1 then
        e:GetSprite():Play(""..tostring(math.floor(Exodus.DragonBreathCharge)),false)
      end
      if Exodus.DragonBreathCharge >= 10 then
        e:GetSprite():Play("Charged",false)
      end
      if Exodus.DragonBreathCharge < 0 then
        e.Visible = false
      else
        e.Visible = true
      end
    end
    if e.Type == 9 and e.Variant == 6 then
      if e.SpawnerType == 1 then
        e.Velocity = (player.Position - e.Position)/50 + (e.Velocity*0.8)
        if player.FrameCount % 101 == 1 then
          e:Die()
        end
        if e.FrameCount > 10 then
          e:Remove()
          local tear = Isaac.Spawn(9,6,0,e.Position,RandomVector()*10,nil)
          tear.SpawnerType = 1
        end
      end
    end
    if e.SpawnerVariant == Isaac.GetEntityVariantByName("Silent Host") and e.SpawnerType == Isaac.GetEntityTypeByName("Silent Host") and e.Type == 9 then
      if e.Variant == 6 then
        e.Velocity = Vector.FromAngle(e.Velocity:GetAngleDegrees()+15)*e.FrameCount
      else
        e:Remove()
        for i = 1,4 do
          local tear = Isaac.Spawn(9,6,0,e.Position,Vector.FromAngle(e.Velocity:GetAngleDegrees()+(i*90))*10,e)
          tear.SpawnerVariant = Isaac.GetEntityVariantByName("Silent Host")
          tear.SpawnerType = Isaac.GetEntityTypeByName("Silent Host")
        end
      end
    end
    if e.SpawnerVariant == Isaac.GetEntityVariantByName("Silent Fatty") and e.SpawnerType == Isaac.GetEntityTypeByName("Silent Fatty") and e.Type == 9 then
      e:Remove()
      for i = 1,8 do
        local tear = Isaac.Spawn(9,6,0,e.Position,Vector.FromAngle(e.Velocity:GetAngleDegrees()+(i*45))*6,player)
      end
    end
    if e.Type == 57 and e.FrameCount == 1 and math.random(13) == 1 and e.Variant ~= Isaac.GetEntityVariantByName("Poison Hemisphere") then
      e:Remove()
      Isaac.Spawn(57,Isaac.GetEntityVariantByName("Poison Mastermind"),0,e.Position,NullVector,nil)
    end
    if e.SpawnerVariant == Isaac.GetEntityVariantByName("Poison Hemisphere") and e.Type == 9 then
      e:Remove()
      if math.random(100) <= 25 then
        local tear = Isaac.Spawn(2,0,0,e.Position,e.Velocity+(RandomVector()*2),e):ToTear()
        tear:GetSprite():ReplaceSpritesheet(0,"gfx/Ipecac.png")
        tear:GetSprite():LoadGraphics()
        tear.Height = -40
        tear.FallingAcceleration = 0.5
        tear.FallingSpeed = 0
        tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        tear:GetData().IsIpecac = true
        tear.SpawnerType = Isaac.GetEntityTypeByName("Poison Mastermind")
      end
    end
    if e.Type == 2 and e:IsDead() and e:GetData().IsIpecac and e.SpawnerType == Isaac.GetEntityTypeByName("Poison Mastermind") then
      local boom = Isaac.Spawn(1000,1,0,e.Position,NullVector,e)
      boom:SetColor(Color(0,1,0,1,0,0,0),-1,1,false,false)
      if player.Position:Distance(e.Position) < 70 then
        player:TakeDamage(2,0,EntityRef(e),5)
      end
    end
    if e.SpawnerType == Isaac.GetEntityTypeByName("Poison Mastermind") then
      if (e.SpawnerVariant == Isaac.GetEntityVariantByName("Poison Hemisphere") or e.SpawnerVariant == Isaac.GetEntityVariantByName("Poison Mastermind")) and e.Type == 40 then
        e:Remove()
      end
      if e.SpawnerVariant == Isaac.GetEntityVariantByName("Poison Mastermind") and e.Type == 9 then
        e:Remove()
        if math.random(100) <= 50 then
          local tear = Isaac.Spawn(2,0,0,e.Position,e.Velocity+(RandomVector()*2),e):ToTear()
          tear:GetSprite():ReplaceSpritesheet(0,"gfx/Ipecac.png")
          tear:GetSprite():LoadGraphics()
          tear.Height = -40
          tear.FallingAcceleration = 0.5
          tear.FallingSpeed = 0
          tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
          tear:GetData().IsIpecac = true
          tear.SpawnerType = Isaac.GetEntityTypeByName("Poison Mastermind")
        end
      end
    end
  end
end
function Exodus:DetectDMG(target,amount,flag,source,cdframes)
	if target.Type == 25 and target.Variant == Isaac.GetEntityVariantByName("Flyerball") then
		if flag == DamageFlag.DAMAGE_FIRE then
			return false
		end
		target:GetData().SpeedMultiplier = target:GetData().SpeedMultiplier - math.random(11) / 5
	end
  if target.Variant == Isaac.GetEntityVariantByName("Canman") and target.Type == Isaac.GetEntityTypeByName("Canman") then
    if target:GetData().ExplosionTimer == nil then
      target:GetData().ExplosionTimer = 30
    end
  end
  if source.Type == EntityType.ENTITY_TEAR and source.Variant == Isaac.GetEntityVariantByName("Lantern Tear") then
		Exodus.LastOminousLanternHitEnemy = target
	end
  if target.Type == EntityType.ENTITY_PLAYER then
  if Exodus.BaseballMittUsed then
		return false
	end
  Exodus.FiredOminousLantern = true
  Exodus.LiftedOminousLantern = true
    if player:HasCollectible(Isaac.GetItemIdByName("Dad's Boots")) then
      if flag == DamageFlag.DAMAGE_SPIKES or flag == DamageFlag.DAMAGE_ACID then
        return false
      end
      for i=1, #Exodus.DBSquishables do
        if Exodus.DBSquishables[i].id == source.Type and
          (Exodus.DBSquishables[i].variant == source.Variant or Exodus.DBSquishables[i].variant == nil) and
          (Exodus.DBSquishables[i].subtype == source.SubType or Exodus.DBSquishables[i].subtype == nil) then
          if Exodus:PlayerIsMoving() then
            return false
          end
        end
      end
    end
    if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) then
      Exodus.WinStreakNum = 0
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
    end
    if player:HasCollectible(Isaac.GetItemIdByName("Unholy Mantle")) then
      if Exodus.HasUnholyMantleEffect then
        local id = Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2")
        player:TryRemoveNullCostume(id)
        for k,v in pairs(Isaac.GetRoomEntities()) do
          if v:IsVulnerableEnemy() then
            v:TakeDamage(math.ceil(100*(game:GetLevel():GetAbsoluteStage()^0.7)),0,EntityRef(player),3)
          end
        end
        Exodus.HasUnholyMantleEffect = false
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Cursed Metronome")) and target.Type == 1 then
    player:UseActiveItem(CollectibleType.COLLECTIBLE_METRONOME, false, false, false, false)
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Big Scissors")) and target.Type == 1 then
	Exodus.IsIsaacScissored = true
	player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	player:EvaluateItems()
  end
end 
function Exodus:newroom()
  local room = game:GetRoom()
  local entities = Isaac.GetRoomEntities()
  Exodus.FlyerballFires = {}
  if player:HasTrinket(Isaac.GetTrinketIdByName("Purple Moon")) then
    if room:GetType() == RoomType.ROOM_SECRET then
      for i = 1, room:GetGridSize() do
        if room:GetGridEntity(i) ~= nil then
          if room:GetGridEntity(i):ToDoor() == nil and room:GetGridEntity(i):ToWall() == nil then
            room:RemoveGridEntity(i,0,true)
          end
        end
      end
      if room:IsFirstVisit() then
        Isaac.Spawn(5,100,game:GetItemPool():GetCollectible(ItemPoolType.POOL_BOSS,true,game:GetSeeds():GetNextSeed()),
        Isaac.GetFreeNearPosition(room:GetCenterPos(),7),
        NullVector,
        nil)
        for i2 = 1, #entities do
          if entities[i2] ~= nil then
            if entities[i2].Type > 3 and entities[i2].Type ~= EntityType.ENTITY_EFFECT then
              entities[i2]:Remove()
            end
          end
        end
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) then
    local counter = Isaac.Spawn(Isaac.GetEntityTypeByName("Score Display"),Isaac.GetEntityVariantByName("Score Display"),0,player.Position+Vector(0,-69),NullVector,player)
    if Exodus.WinStreakNum <= 20 then
      counter:GetSprite():Play(""..tostring(Exodus.WinStreakNum),false)
    else
      counter:GetSprite():Play("Limitbreak",false)
    end
  end
  Exodus.IsIsaacScissored = false
  player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
  player:AddCacheFlags(CacheFlag.CACHE_SPEED)
  player:EvaluateItems()
  Exodus.UsedMutantClover = false
  player:AddCacheFlags(CacheFlag.CACHE_LUCK)
  player:EvaluateItems()
  if player:HasCollectible(Isaac.GetItemIdByName("Welcome Mat")) then
    local mat = Isaac.Spawn(742257, 0, 0, player.Position, Vector(0, 0), player)
    local sprite = mat:GetSprite()
    sprite:Play("Idle", false)
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
      local door = room:GetDoor(i)
        if(door ~= nil) then
          local posDoor = Vector(door.Position.X, door.Position.Y)
          local posPlayer = Vector(player.Position.X, player.Position.Y)
            if (posPlayer:Distance(posDoor) <= 100) then
              Exodus.MatDirection = door.Direction
            end
          end
        end
      if Exodus.MatDirection == Direction.LEFT then
        sprite.Rotation = sprite.Rotation + 90
      elseif Exodus.MatDirection == Direction.UP then
        sprite.Rotation = sprite.Rotation + 180
      elseif Exodus.MatDirection == Direction.RIGHT then
        sprite.Rotation = sprite.Rotation + 270
      end
    Exodus.MatPosition = player.Position
    mat:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
  end
end
function Exodus:newfloor()
  if player:HasCollectible(Isaac.GetItemIdByName("Unholy Mantle")) then
    if Exodus.HasUnholyMantleEffect then
      player:AddBlackHearts(4)
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2"))
    else
      Exodus.HasUnholyMantleEffect = true
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2"))
    end
  end
end
function Exodus:FireXHoney(margin,v)
  local dir = math.random(360)
  if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
    margin = 360
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_TRACTOR_BEAM) then
    margin = 0
    for i = 1,4 do
      EntityLaser.ShootAngle(7,v.Position,dir+(i*90),10,NullVector,v)
    end
  end
  for i = 1,4 do
    Exodus:FireHoney(Vector.FromAngle(dir+math.random(((i-1)*90)-margin,((i-1)*90)+margin))*10,v)
  end
end
function Exodus:FireHoney(dir,v)
  if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
    dir = dir/100
  end
  local honey = Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Honey Splat"),0,v.Position,dir,v)
  honey.SpriteRotation = honey.Velocity:GetAngleDegrees()
  honey.GridCollisionClass = GridCollisionClass.COLLISION_WALL
end
function Exodus:cache(player,Flag)
  if player:HasCollectible(Isaac.GetItemIdByName("Dad's Boots")) then
		if Flag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.1
		end
	elseif Exodus.HasDBCostume then
		Exodus.HasDBCostume = false
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Dad's Boots.anm2"))
	end
	if Exodus.HasDBCostume == false and player:HasCollectible(Isaac.GetItemIdByName("Dad's Boots")) then
		player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Dad's Boots.anm2"))
		Exodus.HasDBCostume = true
	end
  if player:HasTrinket(Isaac.GetTrinketIdByName("Grid Worm")) and Flag == CacheFlag.CACHE_RANGE then
    player.TearFallingSpeed = 10
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Sad Tears")) and Flag == CacheFlag.CACHE_SHOTSPEED then
    player.ShotSpeed = math.max(player.ShotSpeed - 0.4,0.4)
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Tech Y")) and Flag == CacheFlag.CACHE_FIREDELAY then
    player.MaxFireDelay = player.MaxFireDelay*3-2
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) and Flag == CacheFlag.CACHE_DAMAGE and Exodus.WinStreakNum >= 0 then
    player.Damage = player.Damage + (math.floor(((Exodus.WinStreakNum*0.7)^0.7)*100))/150*player:GetCollectibleNum(Isaac.GetItemIdByName("Win Streak"))
  end
  if player:HasCollectible(Isaac.GetItemIdByName("The Forbidden Fruit")) and Flag == CacheFlag.CACHE_DAMAGE then
    player.Damage = player.Damage + (math.floor((Exodus.NumForbFruitUses^0.7)*100))/101
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Dragon Breath")) and Flag == CacheFlag.CACHE_FIREDELAY then
    player.MaxFireDelay = player.MaxFireDelay*2-1
  end
  if Flag == CacheFlag.CACHE_RANGE then
    player.TearHeight = player.TearHeight + Exodus.RangeLostWotl
  end
  if Flag == CacheFlag.CACHE_DAMAGE then
    player.Damage = player.Damage - Exodus.DmgLostWotl
  end
  if Flag == CacheFlag.CACHE_SPEED then
    player.MoveSpeed = player.MoveSpeed - Exodus.SpeedLostWotl
  end
  if Flag == CacheFlag.CACHE_FIREDELAY then
    player.MaxFireDelay = player.MaxFireDelay + Exodus.FDelayLostWotl
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Cursed Metronome")) then
    if Flag == CacheFlag.CACHE_LUCK then
      player.Luck = player.Luck - 2
	end
  end
  if Exodus.UsedTragicMushroom then
    if Flag == CacheFlag.CACHE_DAMAGE then
      player.Damage = (player.Damage + 0.8) * 2
	end
	if Flag == CacheFlag.CACHE_RANGE then
      player.TearHeight = player.TearHeight - 7.25
	end
	if Flag == CacheFlag.CACHE_SPEED then
      player.MoveSpeed = player.MoveSpeed + 0.6
	end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Mutant Clover")) and Exodus.UsedMutantClover then
    if Flag == CacheFlag.CACHE_LUCK then
      player.Luck = player.Luck + 10
	end
  end
  if Flag == CacheFlag.CACHE_FAMILIARS and player:HasCollectible(Isaac.GetItemIdByName("Hungry Hippo")) then
    if player:GetCollectibleNum(Isaac.GetItemIdByName("Hungry Hippo")) > 0 then
      local count = 0
      local entities = Isaac.GetRoomEntities()
      for i=1,#entities do
        local e = entities[i]
        if e.Type == 3 and e.Variant == Isaac.GetEntityVariantByName("Hungry Hippo") then
          count = count + 1
        end
      end
      for i=count+1,player:GetCollectibleNum(Isaac.GetItemIdByName("Hungry Hippo")) do
        local e = Isaac.Spawn(3,Isaac.GetEntityVariantByName("Hungry Hippo"),0,player.Position,NullVector,player):ToFamiliar()
        e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
      end
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Ritual Candle")) then
    if Flag == CacheFlag.CACHE_FAMILIARS then
      player:CheckFamiliar(Isaac.GetEntityVariantByName("Candle"),5,player:GetCollectibleRNG(Isaac.GetItemIdByName("Ritual Candle")))
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Astro Baby")) then
    if Flag == CacheFlag.CACHE_FAMILIARS then
      player:CheckFamiliar(Isaac.GetEntityVariantByName("Astro Baby"), player:GetCollectibleNum(Isaac.GetItemIdByName("Astro Baby")), player:GetCollectibleRNG(Isaac.GetItemIdByName("Astro Baby")))
    end
  end
  if Flag == CacheFlag.CACHE_FIREDELAY then
	if player:HasCollectible(Isaac.GetItemIdByName("Defecation")) then
      player.MaxFireDelay = player.MaxFireDelay + 12
	end
  end
  if Flag == CacheFlag.CACHE_DAMAGE then
	if player:HasCollectible(Isaac.GetItemIdByName("Defecation")) then
	  player.Damage = player.Damage + 5
	end
  end
  if Flag == CacheFlag.CACHE_RANGE then
	if player:HasCollectible(Isaac.GetItemIdByName("Defecation")) then
	  player.TearHeight = player.TearHeight + 12
	end
  end
  if Flag == CacheFlag.CACHE_TEARCOLOR then
	if player:HasCollectible(Isaac.GetItemIdByName("Defecation")) then
	  player.TearColor = Color(0.545, 0.27, 0.075, 1, 0, 0, 0)
	end
  end
  if Flag == CacheFlag.CACHE_SPEED then
	if player:HasCollectible(Isaac.GetItemIdByName("Big Scissors")) and not Exodus.IsIsaacScissored then
	  player.MoveSpeed = player.MoveSpeed + 0.4
	end
  end
  if Flag == CacheFlag.CACHE_FIREDELAY then
	if Exodus.IsIsaacScissored then
	  player.MaxFireDelay = player.MaxFireDelay - 3
	end
  end
  if Exodus.MatPosition ~= nil then
    if Flag == CacheFlag.CACHE_FIREDELAY and player:HasCollectible(Isaac.GetItemIdByName("Welcome Mat")) and Exodus.CloseToMat then
      player.MaxFireDelay = player.MaxFireDelay - 4
    end
  end
end
function Exodus:carduse()
  local entities = Isaac.GetRoomEntities()
  if player:HasCollectible(Isaac.GetItemIdByName("Paper Cut")) then
    for i = 1,#entities do
      if entities[i]:IsVulnerableEnemy() then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
          entities[i]:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
          entities[i]:TakeDamage(20,0,EntityRef(player),0)
        else
          entities[i]:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
          entities[i]:TakeDamage(10,0,EntityRef(player),0)
        end
      end
      if entities[i].Type == EntityType.ENTITY_STONEY then
        entities[i]:Kill()
      end
    end
  end
end
function Exodus:HungryHippo(v)
  if v.FrameCount >= 1 then
    v.Visible = true
  else
    v.Visible = false
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Hungry Hippo")) == false then
    v:Remove()
  end
  if v.FrameCount == 1 then
    v.SpawnerVariant = 0
    v.SpawnerType = 0
  end
  v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
  v.OrbitDistance = Vector(35+(v.State*15),35+(v.State*15))
  if player:HasTrinket(TrinketType.TRINKET_CHILD_LEASH) then
    v.OrbitDistance = v.OrbitDistance/2
  end
  v.OrbitSpeed = 0.03
  v.FireCooldown = 32
  if Exodus:PlayerIsMoving() == false then
    v.Position = v:GetOrbitPosition(player.Position + player.Velocity)
  end
  v.Velocity = v:GetOrbitPosition(player.Position + player.Velocity) - v.Position
  v.GridCollisionClass = 0
  v.CollisionDamage = v.State*(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)+1)
  local sprite = v:GetSprite()
  local closestEnemyPosition = 999999
  local closestEnemy = nil
  local entities = Isaac.GetRoomEntities()
  if v:GetData().HasFired ~= 0 and v:GetData().HasFired ~= nil then
    v:GetData().HasFired = v:GetData().HasFired - 1
  end
  if v:GetData().HasSucc then
    sprite:Play("Succ "..tostring(math.floor(v.SpawnerVariant/15)+1),false)
  else
    sprite:Play(""..tostring(math.floor(v.SpawnerVariant/15)+1),false)
  end
  if v.State > 4 then v.State = 4 elseif v.State == 0 then v.State = 1 end
  for i=1,#entities do
    local e = entities[i]
    local distance = (e.Position - v.Position):Length()
    if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
      if closestEnemyPosition > distance then
        closestEnemyPosition = distance
        closestEnemy = e
      end
    end
    if v.State == 4 and e.Type == 4 and e.SpawnerType ~= 1 then
      if distance < 24 then
        e:Remove()
        Isaac.Explode(v.Position,player,60)
      end
      e.Velocity = e.Velocity + (v.Position - e.Position)/25
    end
    if e.Type == EntityType.ENTITY_PROJECTILE then
      if distance < 24 then
        e:Die()
        if v.State ~= 4 then
          v.SpawnerVariant = v.SpawnerVariant + 1
          v.State = math.floor(v.SpawnerVariant/15)+1
        end
        if v.State == 1 then
          v.SpawnerType = 0
        else
          v.SpawnerType = v.SpawnerType + 1
        end
      end
      if distance < 75 and v.State >= 3 then
        e.Velocity = e.Velocity + (v.Position - e.Position)/25
      end
    end
  end
  if v.SpawnerType >= v.FireCooldown then
    v.SpawnerType = v.FireCooldown - 1
  end
  local canShoot = false
  local shootDir
  if closestEnemy and v.FrameCount % (v.FireCooldown - v.SpawnerType) == 0 and v.SpawnerType ~= 0 and v.State ~= 1 then
    v:GetData().HasSucc = true
    canShoot = true
    v.SpawnerType = v.SpawnerType - 1
    v:GetData().HasFired = 4
    shootDir = (closestEnemy.Position - v.Position):Normalized()
  else
    if v:GetData().HasFired == 0 or v:GetData().HasFired == nil then
      v:GetData().HasSucc = false
    end
  end
  if canShoot then
    local tear = v:FireProjectile(shootDir)
    tear:ChangeVariant(1)
    tear.Scale = 1*(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)/4+1)
    tear.CollisionDamage = 2*(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)+1)
    tear.TearFlags = TearFlags.TEAR_SPECTRAL
  end
end
function Exodus:CandleInit(Candle)
  for _,entity in pairs(Isaac.GetRoomEntities()) do 
    if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Isaac.GetEntityVariantByName("Candle") then
      Candle.Parent = player
    end
  end
  Candle.OrbitDistance = Vector(120,120)
  Candle.OrbitSpeed = 0.015
  Candle.OrbitLayer = 6012
end
function Exodus:UpdateCandle(Candle)
  if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
    Candle.OrbitDistance = Vector(150,150)
  else
    Candle.OrbitDistance = Vector(107,107)
  end
  Candle.OrbitSpeed = 0.015
  Candle.OrbitLayer = 6012
  Candle.Velocity = Candle:GetOrbitPosition(player.Position + player.Velocity) - Candle.Position
  for _,entity in pairs(Isaac.GetRoomEntities()) do 
    if (entity.Type == EntityType.ENTITY_TEAR or (entity.Type == EntityType.ENTITY_FIREPLACE and (entity.Variant == 0 or entity.Variant == 1))) then
      if entity.Position:Distance(Candle.Position) < entity.Size + Candle.Size then
        if Candle:GetData().IsLit ~= true then
          Candle:GetData().IsLit = true
          SFXManager():Play(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
        end
        Candle:GetData().LitTimer = 600
      end
    end
  end
  if Candle:GetData().LitTimer ~= nil then
    if Candle:GetData().LitTimer <= 0 and Candle:GetData().IsLit then
      Candle:GetData().IsLit = false
      SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS,1,0,false,1)
    end
    if Candle:GetData().IsLit and Game():GetRoom():IsClear() == false then
      Candle:GetData().LitTimer = Candle:GetData().LitTimer - 1
    end
  end
end
function Exodus:DankDip(e)
  if e.Variant == Isaac.GetEntityVariantByName("Dank Dip") then
    local sprite = e:GetSprite()
    if sprite:IsPlaying("Move") then
      e.Velocity = Vector.FromAngle(e.Velocity:GetAngleDegrees()+5):Resized(6) + (player.Position-e.Position):Resized(1)
    end
    if e:IsDead() then
      Isaac.Spawn(1000,EffectVariant.CREEP_BLACK,0,e.Position,NullVector,e):ToEffect().Scale = 1.3
    end
    if e.FrameCount == 1 then
      local rand = math.random(3)
      if rand == 1 then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/Dank Dip 1.png")
      elseif rand == 2 then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/Dank Dip 2.png")
      elseif rand == 3 then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/Dank Dip 3.png")
      end
	end
    sprite:LoadGraphics()
    if math.random(10) == 1 then
      local creep = Isaac.Spawn(1000,EffectVariant.CREEP_BLACK,0,e.Position,NullVector,e):ToEffect()
      creep.Scale = 0.7
      creep.Visible = false
      creep:SetTimeout(20)
    end
  end
end
function Exodus:DrownedShroomman(e)
  local sprite = e:GetSprite()
  if e:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) == false then
    e:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
  end
  if e.Variant == Isaac.GetEntityVariantByName("Drowned Mushroom") then
    if e:IsDead() then
      Isaac.Spawn(23,1,0,e.Position,NullVector,e)
    end
    if sprite:IsPlaying("Reveal") then
      if e:GetData().HasFarted ~= true then
        for i = 1, 3 do
          local creep = Isaac.Spawn(1000,EffectVariant.CREEP_SLIPPERY_BROWN,0,e.Position+(Vector.FromAngle(i*math.random(110,120))*30),NullVector,e)
          creep.Color = Color(0.4,0.4,1,1,0,0,255)
          creep:ToEffect().Scale = 2
          creep.Visible = false
        end
        e:GetData().HasFarted = true
      end
    else
      e:GetData().HasFarted = false
    end
  elseif e.Variant == Isaac.GetEntityVariantByName("Scary Shroomman") then
    if sprite:IsPlaying("Reveal") and player:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) == false then
      player.Velocity = ((player.Position - e.Position)/(player.Position:Distance(e.Position)*2))*5 + player.Velocity
    end
  end
end
function Exodus:PoisonMastermind(e)
  local sprite = e:GetSprite()
  if e.Variant == Isaac.GetEntityVariantByName("Poison Hemisphere") then
    e.SplatColor = Color(0,0.9,0,1,0,0,0)
    if e:IsDead() then
      Isaac.Spawn(301,0,0,e.Position,NullVector,e)
    end
    if e:HasEntityFlags(EntityFlag.FLAG_POISON) and e.HitPoints < e.MaxHitPoints then
      e.HitPoints = e.HitPoints+1
    end
    if math.random(10) == 1 then
      local creep = Isaac.Spawn(1000,EffectVariant.CREEP_GREEN,0,e.Position,NullVector,e):ToEffect()
      creep:SetTimeout(100)
    end
  end
  if e.Variant == Isaac.GetEntityVariantByName("Poison Mastermind") then
    e.SplatColor = Color(0,0.9,0,1,0,0,0)
    e.Velocity = e.Velocity*0.9
    if e:IsDead() then
      Isaac.Spawn(301,0,0,e.Position,NullVector,e)
      Isaac.Spawn(301,0,0,e.Position,NullVector,e)
    end
  end
end
function Exodus:Newents(e)
  local sprite = e:GetSprite()
  local data = e:GetData()
  local target = e:GetPlayerTarget()
  if e.Variant == Isaac.GetEntityVariantByName("Canman") then
    if sprite:IsPlaying("Idle") == false or e.FrameCount == 1 then
      sprite:Play("Idle",true)
    end
    if e:HasEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) == false then
      e:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
    end
    if e:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) == false then
      e:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
    end
    if e:HasEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH) == false then
      e:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
    end
    if (player.Position:Distance(e.Position) < 70 or math.random(200) == 1 and e.FrameCount > 200) and e:GetData().ExplosionTimer == nil then
      e:GetData().ExplosionTimer = 30
    end
    if e:GetData().ExplosionTimer ~= nil then
      e.Color = Color(1,1,1,1,math.abs(math.ceil(math.sin(e:GetData().ExplosionTimer/2)*100)),0,0)
      if e:GetData().ExplosionTimer > 0 then
        e:GetData().ExplosionTimer = e:GetData().ExplosionTimer - 1
      else
        e:Die()
      end
    end
    if e:IsDead() then
      Isaac.Explode(e.Position,e,60)
    end
  end
  if e.Variant == Isaac.GetEntityVariantByName("Spook") then
    local angle = (target.Position - e.Position):GetAngleDegrees()
    if e:IsDead() then
      for i=1,math.random(10,20) do
        local ectoexplosion = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_PARTICLE  ,0,e.Position,Vector(math.random(-5,5),math.random(-5,5)),player)
        ectoexplosion:GetSprite().Color = Color(1,1,1,0.4,50,128,128)
        ectoexplosion:GetSprite().Scale = ectoexplosion:GetSprite().Scale * 0.5
        ectoexplosion:GetSprite().Rotation = math.random(1,3600) / 10
        ectoexplosion:GetSprite():Update()
      end
    end
    if e.State ~= 4 then
      data.State4Frame = 0
    end
    if e.FrameCount <= 1 then
      e.State = 2
      data.State0Frame = 0
      data.State3Countdown = 0
    end
    if e.State == 2 then
      sprite:Play("Appear",false)
      if sprite:IsFinished("Appear") then
        e.State = 0
      end
    elseif e.State == 0 then
      data.State0Frame = data.State0Frame + 1
      e:AnimWalkFrame("Float","Float",0.1)
      if (data.State0Frame % 30 or data.State0Frame == 0) and data.State0Frame <= 90 then
        e:AddVelocity((target.Position - e.Position):Normalized() * 0.2)
      elseif data.State0Frame > 90 then
        e.Velocity = (target.Position - e.Position):Normalized() * 3
        if player:GetHeadDirection() == Direction.LEFT or player:GetMovementDirection() == Direction.LEFT then
          if e.Position.X < player.Position.X and math.abs(player.Position.Y - e.Position.Y) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        elseif player:GetHeadDirection() == Direction.RIGHT or player:GetMovementDirection() == Direction.RIGHT then
          if e.Position.X > player.Position.X and math.abs(player.Position.Y - e.Position.Y) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        elseif player:GetHeadDirection() == Direction.UP or player:GetMovementDirection() == Direction.UP then
          if e.Position.Y < player.Position.Y and math.abs(player.Position.X - e.Position.X) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        elseif (player:GetHeadDirection() == Direction.DOWN or player:GetMovementDirection() == Direction.DOWN) or player:GetHeadDirection() == Direction.NO_DIRECTION then
          if e.Position.Y > player.Position.Y and math.abs(player.Position.X - e.Position.X) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        end
      end
    elseif e.State == 3 then
      e:AnimWalkFrame("FloatHide","FloatHide",0.1)
      e.Velocity = (e.Position-player.Position):Resized(1)
      data.State3Countdown = data.State3Countdown - 1
      if data.State3Countdown <= 0 then
        e.State = 4
        data.State0Frame = 0
        data.State3Countdown = 60
      end
      if player:GetHeadDirection() == Direction.LEFT or player:GetMovementDirection() == Direction.LEFT then
        if e.Position.X < player.Position.X and math.abs(player.Position.Y - e.Position.Y) < 40 then
          data.State3Countdown = 60
        end
      elseif player:GetHeadDirection() == Direction.RIGHT or player:GetMovementDirection() == Direction.RIGHT then
        if e.Position.X > player.Position.X and math.abs(player.Position.Y - e.Position.Y) < 40 then
          data.State3Countdown = 60
        end
      elseif player:GetHeadDirection() == Direction.UP or player:GetMovementDirection() == Direction.UP then
        if e.Position.Y < player.Position.Y and math.abs(player.Position.X - e.Position.X) < 40 then
          data.State3Countdown = 60
        end
      elseif (player:GetHeadDirection() == Direction.DOWN or player:GetMovementDirection() == Direction.DOWN) or player:GetHeadDirection() == Direction.NO_DIRECTION then
        if e.Position.Y > player.Position.Y and math.abs(player.Position.X - e.Position.X) < 40 then
          data.State3Countdown = 60
        end
      end
    elseif e.State == 4 then
      data.State4Frame = data.State4Frame + 1
      if data.State4Frame < 31 or data.State4Frame > 63 then
        e.Velocity = (target.Position - e.Position):Normalized() * 3
        e:AnimWalkFrame("Float","Float",0.1)
      end
      if data.State4Frame % 10 == 0 and data.State4Frame <= 30 then
        local offset = Vector(0,28)
        if sprite.FlipX then
          offset = Vector(-15,28)
        else
          offset = Vector(15,28)
        end
        sprite:Play("Shoot",false)
        local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,e.Position+offset,Vector.FromAngle(1*angle):Resized(10),e)
        local color = shot:GetSprite().Color
        shot:GetSprite().Color = Color(color.R,color.G,color.B,0.5,0,0,0)
        shot:GetSprite():ReplaceSpritesheet(0,"gfx/Ghost Tear.png")
        shot:GetSprite():LoadGraphics()
        shot.SplatColor = Color(0,1000,1000,0.5,0,0,0)
        shot.GridCollisionClass = GridCollisionClass.COLLISION_NONE
        SFXManager():Play(SoundEffect.SOUND_LITTLE_SPIT,1,0,false,0.8)
      end
      if data.State4Frame >= 31 and data.State4Frame < 60 then
        if data.State4Frame == 31 then
          e.Velocity = NullVector
          sprite:Play("Disappear",false)
        end
        if sprite:IsFinished("Disappear") then
          sprite:Play("Appear",false)
          e.Position = game:GetRoom():GetRandomPosition(1)
          e.CollisionDamage = 0
        end
      end
      if data.State4Frame > 70 or data.State4Frame == 0 then
        e.CollisionDamage = 1
      end
      if data.State4Frame > 80 then
        if player:GetHeadDirection() == Direction.LEFT or player:GetMovementDirection() == Direction.LEFT then
          if e.Position.X < player.Position.X and math.abs(player.Position.Y - e.Position.Y) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        elseif player:GetHeadDirection() == Direction.RIGHT or player:GetMovementDirection() == Direction.RIGHT then
          if e.Position.X > player.Position.X and math.abs(player.Position.Y - e.Position.Y) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        elseif player:GetHeadDirection() == Direction.UP or player:GetMovementDirection() == Direction.UP then
          if e.Position.Y < player.Position.Y and math.abs(player.Position.X - e.Position.X) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        elseif (player:GetHeadDirection() == Direction.DOWN or player:GetMovementDirection() == Direction.DOWN) or player:GetHeadDirection() == Direction.NO_DIRECTION then
          if e.Position.Y > player.Position.Y and math.abs(player.Position.X - e.Position.X) < 40 then
            e.State = 3
            data.State0Frame = 0
            data.State3Countdown = 60
          end
        end
      end
    end
  end
  if e.Variant == Isaac.GetEntityVariantByName("Gridsie") or e.Variant == Isaac.GetEntityVariantByName("Polyp Gridsie") or e.Variant == Isaac.GetEntityVariantByName("Bomb Gridsie") then
    if e:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
      e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end
    if e:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) == false then
      e:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
    end
    if e:IsDead() then
      Isaac.Spawn(1000,4,0,e.Position,NullVector,e)
      SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
    end
    if (player:HasCollectible(CollectibleType.COLLECTIBLE_LEO) or player:HasCollectible(CollectibleType.COLLECTIBLE_THUNDER_THIGHS)) and e.Position:Distance(player.Position) < 30 then
      e:Die()
    end
    if sprite:IsFinished("Appear") then
      e.CollisionDamage = 0
      e.Velocity = NullVector
      e.Friction = e.Friction/2
      if (e.FrameCount > 130 and e.Position:Distance(player.Position) < 100) or e.HitPoints <= e.MaxHitPoints/2 then
        sprite:Play("Stand",true)
      end
    end
    if sprite:IsFinished("Stand") or sprite:IsPlaying("WalkVert") or sprite:IsPlaying("WalkHori") then
      if e.Friction ~= 1 then e.Friction = 1 end
      if e.CollisionDamage ~= 1 then e.CollisionDamage = 1 end
      if data.GridCountdown == nil then data.GridCountdown = 0 end
      if e.Velocity:GetAngleDegrees() >= 45 and e.Velocity:GetAngleDegrees() <= 135 then
        sprite:Play("WalkVert",false)
      else
        sprite:Play("WalkHori",false)
      end
      if e.Position.X < player.Position.X then
        sprite.FlipX = false
      else
        sprite.FlipX = true
      end
      if e:CollidesWithGrid() or data.GridCountdown > 0 then
        if e.Variant == Isaac.GetEntityVariantByName("Polyp Gridsie") then
          e.Pathfinder:FindGridPath(player.Position,0.8,1,false)
        else
          e.Pathfinder:FindGridPath(player.Position,0.5,1,false)
        end
        if data.GridCountdown <= 0 then
          data.GridCountdown = 30
        else
          data.GridCountdown = data.GridCountdown - 1
        end
      else
        if e.Variant == Isaac.GetEntityVariantByName("Polyp Gridsie") then
          e.Velocity = (player.Position-e.Position):Resized(5)
        else
          e.Velocity = (player.Position-e.Position):Resized(3.5)
        end
      end
      if e.Variant == Isaac.GetEntityVariantByName("Bomb Gridsie") and e.Position:Distance(player.Position) <= 30 then
        e:Die()
      end
    end
    if e.Variant == Isaac.GetEntityVariantByName("Gridsie") then
      if e:GetData().HasStateChange ~= true then
        if math.random(20) == 1 then
          e:Remove()
          Isaac.Spawn(Isaac.GetEntityTypeByName("Bomb Gridsie"),Isaac.GetEntityVariantByName("Bomb Gridsie"),0,e.Position,NullVector,e)
        else
          local rand = math.random(3)
          if rand == 1 then
            sprite:ReplaceSpritesheet(1,"gfx/monsters/Gridsie 1.png")
            sprite:LoadGraphics()
          elseif rand == 2 then
            sprite:ReplaceSpritesheet(1,"gfx/monsters/Gridsie 2.png")
            sprite:LoadGraphics()
          elseif rand == 3 then
            sprite:ReplaceSpritesheet(1,"gfx/monsters/Gridsie 3.png")
            sprite:LoadGraphics()
          end
        end
        e:GetData().HasStateChange = true
      end
    elseif e.Variant == Isaac.GetEntityVariantByName("Polyp Gridsie") then
      if e.FrameCount == 1 then
        local rand = math.random(2)
        if rand == 1 then
          sprite:ReplaceSpritesheet(1,"gfx/monsters/Gridsie Polyp.png")
          sprite:LoadGraphics()
        elseif rand == 2 then
          sprite:ReplaceSpritesheet(1,"gfx/monsters/Gridsie Polyp 2.png")
          sprite:LoadGraphics()
        end
      end
      if e:IsDead() then
        for i = 1,8 do
          Isaac.Spawn(9,0,0,e.Position,Vector.FromAngle(i*45):Resized(9),e)
        end
      end
    elseif e.Variant == Isaac.GetEntityVariantByName("Bomb Gridsie") then
      if e.FrameCount == 1 then
        sprite:ReplaceSpritesheet(1,"gfx/monsters/Bomb Gridsie.png")
        sprite:LoadGraphics()
      end
      if e:IsDead() then
        Isaac.Explode(e.Position,e,60)
      end
    end
  end
end
function Exodus:UseForbFruit()
  if player:GetName() ~= "The Lost" and player:GetName() ~= "Keeper" then
  SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
    Exodus.NumForbFruitUses = Exodus.NumForbFruitUses + 1
    player:AddHearts(24)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
    if player:GetSoulHearts() > 4 or player:GetMaxHearts() > 2 then
      if player:GetSoulHearts() == 0 then
        player:AddMaxHearts(-2)
      else
        player:AddSoulHearts(-4)
      end
    else
      player:Die()
      player:AddMaxHearts(-2)
      player:AddSoulHearts(-4)
    end
  end
  return true
end
function Exodus:FireFire(vector,wiz,double,two)
  if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE) and Exodus:HasPlayerChance(2) then
    Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()+180))
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) and Exodus:HasPlayerChance(7) then
    Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()+90))
    Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()+180))
    Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()-90))
  end
  if player:GetCollectibleNum(Isaac.GetItemIdByName("Dragon Breath")) > 1 and two == false then
    for i = 1,player:GetCollectibleNum(Isaac.GetItemIdByName("Dragon Breath")) do
      Exodus:FireFire(Vector.FromAngle(vector:GetAngleDegrees()+(((i-math.floor(player:GetCollectibleNum(Isaac.GetItemIdByName("Dragon Breath"))/2))*2)-1)*2),wiz,double,true)
    end
  else
    if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) and double == false then
      for i = 1,2 do
        Exodus:FireFire(Vector.FromAngle(vector:GetAngleDegrees()+(((i-1)*2)-1)*3),wiz,true,two)
      end
    else
      if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and wiz == false then
        for i = 1,2 do
          Exodus:FireFire(Vector.FromAngle(vector:GetAngleDegrees()+(((i-1)*2)-1)*45),true,double,two)
        end
      else
        if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
          Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()-10))
          Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()+10))
        end
        if player:GetName() == "Keeper" then
          Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()-10))
          Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()+10))
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
          Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()-7))
          Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()+7))
          Exodus:ShootFireball(player.Position,Vector.FromAngle(vector:GetAngleDegrees()-13))
        end
        Exodus:ShootFireball(player.Position,vector)
      end
    end
  end
end
function Exodus:ShootFireball(position,vector)
  local fire = Isaac.Spawn(Isaac.GetEntityTypeByName("Fireball"),Isaac.GetEntityVariantByName("Fireball"),0,position,vector:Resized(1)*player.ShotSpeed*10+(player.Velocity/2),player):ToTear()
  fire.Color = player.TearColor
  fire.CollisionDamage = player.Damage*4
  fire.TearFlags = fire.TearFlags + player.TearFlags
  fire.FallingAcceleration = -0.1
  fire.SpriteRotation = fire.Velocity:GetAngleDegrees()-90
end
function Exodus:GetTechYSize()
  local size = 1
  if player:HasCollectible(Isaac.GetItemIdByName("Queen Bee")) then
    size = math.random(-3,5)
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_LUMP_OF_COAL) then
    size = size + 2
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_PROPTOSIS) then
    size = size/2
  end
  return math.ceil(size*player.ShotSpeed)
end
function Exodus:HasPlayerChance(luckcap)
  local luck = player.Luck
  if luck < 0 then
    luck = 0
  end
  if player.Luck > luckcap then
    luckcap = player.Luck
  end
  if math.random(luckcap-luck+1) == 1 then
    return true
  else
    return false
  end
end
function Exodus:OnRender()
  local entities = Isaac.GetRoomEntities()
  if player:HasCollectible(Isaac.GetItemIdByName("The Pseudobulbar Affect")) then
    for i=1, #entities do
      if entities[i]:GetData().IsPseudobulbarTurret then
        Exodus.PseudobulbarIconSprite.Color = Color(1,1,1, 0.5, 0, 0, 0)
        Exodus.PseudobulbarIconSprite:Update()
        Exodus.PseudobulbarIconSprite:LoadGraphics()
        Exodus.PseudobulbarIconSprite:Render(game:GetRoom():WorldToScreenPosition(entities[i].Position + Vector(0, entities[i].Size)), NullVector, NullVector)
      end
    end
  end
  if Exodus.RitualCandleBonus == false and Exodus.RitualCandlePentagram ~= nil then
    Exodus.RitualCandlePentagram:Remove()
    Exodus.RitualCandlePentagram = nil
  end
  for i = 1,#entities do
    local e = entities[i]
    if e.Type == Isaac.GetEntityTypeByName("Score Display") and e.Variant == Isaac.GetEntityVariantByName("Score Display") then
      if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) == false then
        e:Remove()
      end
      e.GridCollisionClass = GridCollisionClass.COLLISION_NONE
      e.Velocity = player.Position+Vector(0,-69+( math.sin(e.FrameCount/2)*2))-e.Position+player.Velocity
      if Exodus.WinStreakNum ~= 10 and Exodus.IsWinStreakRoomClear > 0 then
        e:GetSprite():Play(""..tostring(Exodus.WinStreakNum),false)
      end
    end
		if entities[i] ~= nil then
			if entities[i].Type == 1000 and entities[i].Variant == 5673 then
        if entities[i]:GetData().Offset ~= nil then
          if entities[i].Velocity.Y < entities[i]:GetData().Offset and entities[i]:GetData().Resting ~= true then
            entities[i].Velocity = entities[i].Velocity + Vector(0,1)
          end
        end
				if entities[i].Velocity.X < 0 then
					entities[i].Velocity = entities[i].Velocity + Vector(1,0)
				end
				if entities[i].Velocity.X > 0 then
					entities[i].Velocity = entities[i].Velocity + Vector(-1,0)
				end
				if entities[i].Velocity.Y >= entities[i]:GetData().Offset then
					entities[i].Velocity = Vector(entities[i].Velocity.X,0)	
					entities[i]:GetData().Resting = true
				end	
			elseif entities[i].Type == 1000 and entities[i].Variant == 5674 then
				local npc = entities[i]
				if npc.FrameCount <= 1 then
					npc:GetData().ExistingFrames = 0
					npc:GetSprite():Play("Idle",false)
					npc:GetData().SFXcd = 0
					if Exodus.LastOminousLanternHitEnemy ~= nil then
						npc:GetData().IsLatchedToEnemy = Exodus.LastOminousLanternHitEnemy
					end
				end
        if npc:GetData().SFXcd ~= nil then
          if npc:GetData().SFXcd >= 1 then
            npc:GetData().SFXcd = npc:GetData().SFXcd - 1
          end
        end
				if npc:GetData().IsLatchedToEnemy ~= nil then
					npc.Position = npc:GetData().IsLatchedToEnemy.Position
					if npc:GetData().IsLatchedToEnemy:IsDead() then
						npc:GetData().IsLatchedToEnemy = nil
					end
				else
					npc.Velocity = NullVector
				end
				if game:GetFrameCount() % math.random(30,80) == 0 then
					Exodus:SpawnCandleTear(npc)
				end
				for v=1,#entities do
					local entity = entities[v]
					if entity:IsVulnerableEnemy() then
						if entity.Position:Distance(npc.Position) < entity.Size + npc.Size then
							entity:AddFear(EntityRef(player),30)
							entity:TakeDamage(2,DamageFlag.DAMAGE_FIRE ,EntityRef(npc),90)
							if npc:GetData().IsLatchedToEnemy == nil and npc:GetData().SFXcd == 0 then
								SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS,0.7,0,false,1)
								npc:GetData().SFXcd = 30
							end
						end
					elseif entity.Type == 2 and entity.Variant ~= Isaac.GetEntityVariantByName("Lantern Tear") then
						if entity.Position:Distance(npc.Position) < entity.Size + npc.Size and entity:GetData().AddedFireBonus ~= true and entity:GetData().IsCandleTear ~= true then
							entity:GetData().AddedFireBonus = true
							entity:ToTear().TearFlags = entity:ToTear().TearFlags | TearFlags.TEAR_HOMING
							entity:ToTear().Scale = entity:ToTear().Scale * 1.5
							entity.CollisionDamage = entity.CollisionDamage * 1.5
							Exodus:PlayCandleTearSprite(entity)
							entity.Velocity = entity.Velocity * 0.8
						elseif entity.Position:Distance(npc.Position) < entity.Size + npc.Size and entity:GetData().AddedFireBonus ~= true and entity:GetData().IsCandleTear then
							entity:GetData().AddedFireBonus = true
							entity:ToTear().TearFlags = entity:ToTear().TearFlags + TearFlags.TEAR_HOMING
							entity.Color = Color(1,1,1,1,80,0,80)
						end
					elseif entity.Type == EntityType.ENTITY_PROJECTILE then
						if entity.Position:Distance(npc.Position) < entity.Size + npc.Size then	
							entity:Die()
							npc:GetData().ExistingFrames = npc:GetData().ExistingFrames + 50
						end
					elseif entity.Type == EntityType.ENTITY_BOMBDROP then
						local Bomb = entity:ToBomb()
						local BombData = entity:GetData()
						if Bomb.IsFetus and BombData.MadeHoming ~= true then
							if entity.Position:Distance(npc.Position) < entity.Size + npc.Size then
								Bomb.Flags = Bomb.Flags + TearFlags.TEAR_HOMING
								entity.Color = Color(1,1,1,1,80,0,80)
								BombData.MadeHoming = true
							end
						end
					elseif entity.Type == EntityType.ENTITY_KNIFE and entity:ToKnife():IsFlying() then
						if entity.Position:Distance(npc.Position) < entity.Size + npc.Size then
							Exodus:SpawnCandleTear(entity)
						end
					end
				end
			end
		end
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) == false then
		if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT,player.ControllerIndex) then
			Exodus:FireLantern(player.Position,Vector(-15,0),true)
		elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT,player.ControllerIndex) then
			Exodus:FireLantern(player.Position,Vector(15,0),true)
		elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP,player.ControllerIndex) then
			Exodus:FireLantern(player.Position,Vector(0,-15),true)
		elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN,player.ControllerIndex) then
			Exodus:FireLantern(player.Position,Vector(0,15),true)
		end
	end
	for _,item in pairs(Exodus.SubRoomChargeItems) do
		if player:GetActiveItem() == item.id then
      if player:GetActiveItem() > 0 then
        Exodus.FakeChargeBar:SetFrame("BarEmpty",0)
        Exodus.FakeChargeBar.Scale = Vector(1,1)
        Exodus.FakeChargeBar:Render(Vector(36,17),NullVector,NullVector)
      end
			Exodus.FakeChargeBar:SetFrame("BarFull",0)
			Exodus.ChargeScale.Y = item.curCharge / Exodus.LanternFrameModifier
			Exodus.FakeChargeBar.Scale = Exodus.ChargeScale
			local ChargePos = Vector(36,17)
			ChargePos.Y = ChargePos.Y + 10 * (1 - Exodus.ChargeScale.Y)
			Exodus.FakeChargeBar:Render(ChargePos,NullVector,NullVector)
		end
	end
end
function Exodus:WrathOfTheLamb(collectibleType,rng)
	local player = Isaac.GetPlayer(0)
	statdown = rng:RandomInt(4)
	if statdown == 1 then
		Exodus.DmgLostWotl = Exodus.DmgLostWotl + 0.5
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
	elseif statdown == 2 then
		Exodus.FDelayLostWotl = Exodus.FDelayLostWotl + 2
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	elseif statdown == 3 then
		Exodus.RangeLostWotl = Exodus.RangeLostWotl + 2.5
		player:AddCacheFlags(CacheFlag.CACHE_RANGE)
	elseif statdown == 4 then
		Exodus.SpeedLostWotl = Exodus.SpeedLostWotl + 0.15
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	end
	player:EvaluateItems()
	MusicManager():PitchSlide(0.5)
	for i = 0,DoorSlot.NUM_DOOR_SLOTS - 1 do
		if game:GetRoom():GetDoor(i) ~= nil then
			game:GetRoom():GetDoor(i):Bar()
		end
	end
    local summonMark = Isaac.Spawn(Isaac.GetEntityTypeByName("Summoning Mark"),0,0,player.Position,NullVector,player)
	local sprite = summonMark:GetSprite()
	sprite:Play("Idle",false)
	summonMark:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
	Exodus.WotlPosition = summonMark.Position
	game:GetRoom():SetClear(false)
	Exodus.WotlFrameCount = game:GetFrameCount()
end
function Exodus:Birdbath()
  Isaac.Spawn(Isaac.GetEntityTypeByName("Birdbath"),Isaac.GetEntityVariantByName("Birdbath"),0,Isaac.GetFreeNearPosition(player.Position,7),NullVector,player)
end
function Exodus:UpdateBirdbath(v)
  if v.Variant == Isaac.GetEntityVariantByName("Birdbath") then
    v.Velocity = NullVector
    v.Friction = v.Friction/100
    if v:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) == false then
      v:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
    end
    if v:GetData().SuckTimer == nil then
      v:GetData().SuckTimer = 60
    end
    if math.random(200) == 1 and v:GetData().IsSucking ~= true then
      v:GetData().IsSucking = true
      v:GetData().SuckTimer = 60
    end
    if v:GetData().IsSucking ~= false and v:GetData().SuckTimer == 0 then
      v:GetData().IsSucking = false
    end
    if v:GetData().SuckTimer > 0 then
      v:GetData().SuckTimer = v:GetData().SuckTimer - 1
    end
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
      local e = entities[i]
      if e:IsActiveEnemy() and e:IsVulnerableEnemy() and e:IsFlying() then
        if v:GetData().IsSucking then
          if e.Velocity:Length() < 3 then
            e.Velocity = (v.Position - e.Position):Resized(3)
          else
            e.Velocity = (v.Position - e.Position):Resized(e.Velocity:Length())
          end
        end
        if e.Position:Distance(v.Position) < e.Size + v.Size then
          e:AddPoison(EntityRef(v),30,e.MaxHitPoints)
        end
      end
    end
  end
end
function Exodus:OnUseLantern(_,RNG)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		if Exodus.FiredOminousLantern == false then
			Exodus.FiredOminousLantern = true
			Exodus.LiftedOminousLantern = true
			Exodus.HidOminousLantern = true
			player:AnimateCollectible(Isaac.GetItemIdByName("Ominous Lantern"),"HideItem","PlayerPickupSparkle")
		else
			Exodus.FiredOminousLantern = false
			Exodus.LiftedOminousLantern = false
		end
	else
		Exodus:FireLantern(player.Position,Vector.FromAngle(RNG:RandomInt(360)):Resized(RNG:RandomInt(10) + 3),false)
		Exodus:FireLantern(player.Position,Vector.FromAngle(RNG:RandomInt(360)):Resized(RNG:RandomInt(10) + 3),false)
		return true
	end
end
function Exodus:HippoInit(e)
  e.OrbitLayer = 98
  e.Position = e:GetOrbitPosition(player.Position + player.Velocity)
  e.Visible = false
end
function Exodus:AstroInit(e)
  e.IsFollower = true
  e:GetData().FireDelay = 10
  local sprite = e:GetSprite()
  sprite:Play("IdleDown")
end
function Exodus:activateMitt(collectibleType)
  Exodus.BaseballMittUsed = true
  Exodus.NumBaseballsSucked = 0
  Exodus.BaseballMittUseDelay = game:GetFrameCount()
  player:AnimateCollectible(collectibleType,"LiftItem","PlayerPickupSparkle")
end
function Exodus:UseClover(collectibleType)
  Exodus.UsedMutantClover = true
  player:AnimateCollectible(collectibleType,"UseItem","Idle")
  player:AddCacheFlags(CacheFlag.CACHE_LUCK)
  player:EvaluateItems()
end
function Exodus:UseTragicMushroom(collectibleType)
  player:AnimateCollectible(collectibleType,"UseItem","Idle")
  if player:GetPlayerType() == PlayerType.PLAYER_XXX then
	local maxhp = player:GetSoulHearts() - 2
	player:AddSoulHearts(maxhp * -1)
  else
    local maxhp = player:GetSoulHearts()
    player:AddSoulHearts(maxhp * -1)
    maxhp = player:GetMaxHearts() - 2
    player:AddMaxHearts(maxhp * -1)
  end
  Exodus.UsedTragicMushroom = true
  SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
  Isaac.ExecuteCommand("remove Tragic Mushroom")
  player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
  player:AddCacheFlags(CacheFlag.CACHE_RANGE)
  player:AddCacheFlags(CacheFlag.CACHE_SPEED)
  player:EvaluateItems()
end
function Exodus:UsePseudobulbar()
	local player = Isaac.GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	for i=1, #entities do
		if entities[i]:IsActiveEnemy() then
			entities[i]:GetData().IsPseudobulbarTurret = true
		end
	end
	return true
end
function Exodus:AstroUpdate(e)
  local sprite = e:GetSprite()
  local entities = Isaac.GetRoomEntities()
  e:FollowParent()
  for i = 1, #entities do
    local e = entities[i]
    if e.Type == 2 and e:GetData().IsFromAstroBaby == true then
      e.Velocity = (e.Velocity:Rotated(e:GetData().RotateAmount)):Resized(10)
      if e:GetData().RotateAmount < 10 then
	    e:GetData().RotateAmount = e:GetData().RotateAmount / 1.01
      else
	    e:GetData().RotateAmount = e:GetData().RotateAmount / 1.1
      end
    end
  end
  if e:GetData().FireDelay == 0 then
    if player:GetFireDirection() > -1 then
      e:GetData().FireDelay = 10
      local dir = Vector(0,0)
      if player:GetHeadDirection() == Direction.DOWN then
        dir = Vector(0,10)+(e.Velocity/3)
		sprite:Play("ShootDown")
      elseif player:GetHeadDirection() == Direction.LEFT then
        dir = Vector(-10,0)+(e.Velocity/3)
        sprite:Play("ShootSide2")
      elseif player:GetHeadDirection() == Direction.RIGHT then
        dir = Vector(10,0)+(e.Velocity/3)
		sprite:Play("ShootSide")
      elseif player:GetHeadDirection() == Direction.UP then
        dir = Vector(0,-10)+(e.Velocity/3)
		sprite:Play("ShootUp")
      end
      local tear = Isaac.Spawn(2,0,0,e.Position,dir,e):ToTear()
      tear:GetData().IsFromAstroBaby = true
      tear:GetData().Parent = e
	  tear:GetData().RotateAmount = 30
      tear.FallingAcceleration = -0.1
      tear.FallingSpeed = 0
    else
	  if player:GetMovementDirection() == Direction.UP then
        sprite:Play("IdleUp")
      elseif player:GetMovementDirection() == Direction.LEFT then
        sprite:Play("IdleSide2")
      elseif player:GetMovementDirection() == Direction.RIGHT then
	    sprite:Play("IdleSide")
      else
        sprite:Play("IdleDown")
	  end
	end
  else
    e:GetData().FireDelay = e:GetData().FireDelay - 1
  if e:GetData().FireDelay <= 7 and player:GetFireDirection() == -1 then
      if player:GetMovementDirection() == Direction.UP then
        sprite:Play("IdleUp")
      elseif player:GetMovementDirection() == Direction.LEFT then
        sprite:Play("IdleSide2")
      elseif player:GetMovementDirection() == Direction.RIGHT then
	    sprite:Play("IdleSide")
      else
        sprite:Play("IdleDown")
	  end
	end
  end
end

function Exodus:OnBlockage(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local room = Game():GetRoom()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if entity.State ~= 2 then
		data.State2Frames = 0
	end
	if entity.State ~= 3 then
		data.State3Frames = 0
	end
	if entity.State ~= 4 then
		data.State4Frames = 0
	end
	if entity.State == 0 then -- Appearing and Burrowing - Initialization
		if sprite:IsFinished("Appear") then
			sprite:Play("Burrow", false)
			SFXManager():Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
		end
		if sprite:IsFinished("Burrow") then
			entity.Visible = false
			entity.State = 2
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
	elseif entity.State == 2 then -- Burrowed
		data.State2Frames = data.State2Frames + 1
		if data.State2Frames == 1 then
			data.State2SpikeTime = math.random(20,100)
		end
		if data.State2Frames == data.State2SpikeTime then
			entity.State = 3
			entity.Visible = true
		end
	elseif entity.State == 3 then -- Attacking
		data.State3Frames = data.State3Frames + 1
		sprite:Play("Spike", false)
		if sprite:IsEventTriggered("Spike") then
			SFXManager():Play(SoundEffect.SOUND_GOOATTACH0, 1, 0, false, 1)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif sprite:IsEventTriggered("Retreat") then
			SFXManager():Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		elseif sprite:IsEventTriggered("Spike Pop") and data.State3Frames < 170 then
			entity.Position = player.Position
		elseif sprite:IsEventTriggered("Spike Pop Initial") and data.State3Frames < 40 then
			entity.Position = player.Position
		end
		if data.State3Frames == 179 then
			entity.State = 4
			entity.Position = room:FindFreeTilePosition(room:GetRandomPosition(40), 5)
		end
	elseif entity.State == 4 then -- Watching
		data.State4Frames = data.State4Frames + 1
		if data.State4Frames == 1 then
			data.State4BurrowTime = math.random(40,200)
			sprite:Play("Emerge", false)
			SFXManager():Play(SoundEffect.SOUND_MAGGOT_BURST_OUT, 1, 0, false, 1)
		end
		if data.State4Frames == 13 then
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		end
		if sprite:IsFinished("Emerge") then
			sprite:Play("Watching", false)
		end
		if data.State4Frames == data.State4BurrowTime then
			sprite:Play("Burrow", false)
			SFXManager():Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)	
		end
		if data.State4Frames > 30 and data.State4Frames < data.State4BurrowTime then
			if entity.Position.X < player.Position.X then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
		end
		if sprite:IsFinished("Burrow") and data.State4Frames >= data.State4BurrowTime then
			entity.Visible = false
			entity.State = 2
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
	end
end

function Exodus:OnCloster(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if entity.FrameCount <= 1 then
		sprite:Play("Appear", false)
		entity.State = 0
		entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	end
	if sprite:IsFinished("Appear") then
		entity.Pathfinder:MoveRandomly(false)
		sprite:Play("Idle", false)
	end
	if sprite:IsFinished("Idle") then
		entity.Pathfinder:Reset()
		entity.Velocity = Vector(0,0)
		sprite:Play("Attack", false)
	end
	if sprite:IsEventTriggered("Stomp") then
		SFXManager():Play(SoundEffect.SOUND_MEAT_IMPACTS ,1,0,false,0.7)
		if math.random(2) == 1 then
			for i=1, 6 do 
				local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position + Vector(math.random(-20,20), math.random(-20,20)), Vector(0,0), entity)
				creep:ToEffect().Scale = creep:ToEffect().Scale * 1.2
			end
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position , Vector(0,0), entity)
			creep:ToEffect().Scale = creep:ToEffect().Scale * 1.2
		else
			Isaac.Spawn(Isaac.GetEntityTypeByName("Dank Dip"), Isaac.GetEntityVariantByName("Dank Dip"), 0, entity.Position + Vector(math.random(-2,2), math.random(-2,2)), Vector(0,0), entity)
		end
		sprite:Play("Idle", false) 
		entity.Pathfinder:MoveRandomly(false)
	end
	entity.Velocity = entity.Velocity:Resized(math.random(1,2))
	if entity:IsDead() then
		for i=1, 2 do
			Isaac.Spawn(15, 1, 0, entity.Position + Vector(math.random(-2,2), math.random(-2,2)), Vector(0,0), entity)
		end
	end
end

function Exodus:OnFlyerball(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Flyerball") then
		local player = Isaac.GetPlayer(0)
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local angle = (target.Position - entity.Position):GetAngleDegrees()
		if entity.FrameCount == 1 then
			sprite:Play("Appear", false)
			entity.State = 0
			data.FlyFrames = 1
			data.SpeedMultiplier = 1
			data.AngryNoise = false
		end
		if entity:IsFrame(40, 0) then
			data.SpeedMultiplier = data.SpeedMultiplier + math.random(11) / 10
		end
		if data.SpeedMultiplier <= 1 then
			data.SpeedMultiplier = 1
		end
		if data.SpeedMultiplier >= 3 then
			data.SpeedMultiplier = 3
		end
		data.FlyFrames = data.FlyFrames + 1
		if data.FlyFrames >= 7 then
			data.FlyFrames = 1
		end
		if entity.FrameCount > 28 then
			if entity.HitPoints <= entity.MaxHitPoints / 2 then
				if data.AngryNoise == false then
					SFXManager():Play(SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1)
					data.AngryNoise = true
				end
				entity.Velocity = entity.Velocity:Resized(data.SpeedMultiplier * 6)
				sprite:Play("Fury" .. tostring(data.FlyFrames), true)
			else
				data.AngryNoise = false
				entity.Velocity = entity.Velocity:Resized(data.SpeedMultiplier * 4)
			end
		end
		local entities = Isaac.GetRoomEntities()
		for i=1, #entities do
			if entities[i].Type == EntityType.ENTITY_PROJECTILE and entities[i].SpawnerType == 25 and entities[i].SpawnerVariant == Isaac.GetEntityVariantByName("Flyerball") then
				entities[i]:Remove()
			end
		end
		if entity:IsDead() then
			Isaac.Explode(entity.Position, entity, 40)
			local Fire = Isaac.Spawn(1000, 51, 0, entity.Position, Vector(0,0), entity)
			table.insert(Exodus.FlyerballFires, Fire)
			Fire:GetData().CountDown = 300
		end
	end
end

function Exodus:OnIronLung(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local room = Game():GetRoom()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if entity.FrameCount <=1 then
		sprite:Play("Appear", false)
		data.DirectionMultiplier = math.random(5)
	end
	if entity.State ~= 2 then
		data.State2Frames = 0
		data.IsCharging = false
	end
	if data.IsCharging == true then
		if entity:IsFrame(2, 0) then
			Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Iron Lung Gas"), 0, entity.Position, Vector(0,0), entity)
		end
		entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	elseif entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
		entity:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	end
	if entity.State == 0 then -- Move around
		if math.random(50) == 1 or entity:CollidesWithGrid() then
			data.DirectionMultiplier = math.random(5)
		end
		entity.Velocity = Vector.FromAngle(data.DirectionMultiplier * 90):Resized(7)
		if entity.Velocity.Y > 0 then
			entity:AnimWalkFrame("Hori", "Down", 0)
		elseif entity.Velocity.Y < 0 then
			entity:AnimWalkFrame("Hori", "Up", 0)
		end
		if angle % 90 < 10 and angle % 90 > -10 then
			entity.State = 2
		end
	elseif entity.State == 2 then -- Charge
		data.State2Frames = data.State2Frames + 1
		if data.State2Frames == 1 then
			SFXManager():Play(SoundEffect.SOUND_DEATH_BURST_SMALL , 1, 0, false, 1)
			SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS  , 1, 0, false, 1)
			SFXManager():Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1, 0, false, 2)
			data.IsCharging = false
			if angle > -45 and angle < 45 then -- Player is on the right
				sprite:Play("HoriPrep", false)
				sprite.FlipX = false
				data.Direction = Direction.RIGHT
			elseif angle > 45 and angle < 135 then -- Player is under
				sprite:Play("DownPrep", false)
				data.Direction = Direction.DOWN
			elseif angle < -45 and angle > -135 then -- Player is above
				sprite:Play("UpPrep", false)
				data.Direction = Direction.UP
			else -- Player is on the left
				sprite:Play("HoriPrep", false)
				sprite.FlipX = true
				data.Direction = Direction.LEFT
			end
		end
		if sprite:IsFinished("HoriPrep") and data.Direction == Direction.LEFT then
				data.IsCharging = true
				sprite:Play("HoriCharge", false)
				sprite.FlipX = true
			elseif sprite:IsFinished("HoriPrep") and data.Direction == Direction.RIGHT then
				data.IsCharging = true
				sprite:Play("HoriCharge", false)
				sprite.FlipX = false
			elseif sprite:IsFinished("DownPrep") then
				data.IsCharging = true
				sprite:Play("DownCharge", false)
			elseif sprite:IsFinished("UpPrep") then
				data.IsCharging = true
				sprite:Play("UpCharge", false)
			end
			if data.IsCharging == true and entity:CollidesWithGrid() then
			SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS , 2, 0, false, 0.8)
			SFXManager():Play(SoundEffect.SOUND_POT_BREAK , 2, 0, false, 0.8)
			data.IsCharging = false
				if data.Direction == Direction.LEFT then
					sprite:Play("HoriSlam", false)
					sprite.FlipX = true
				elseif data.Direction == Direction.RIGHT then
					sprite:Play("HoriSlam", false)
					sprite.FlipX = false
				elseif data.Direction == Direction.UP then
					sprite:Play("UpSlam", false)
				elseif data.Direction == Direction.DOWN then
					sprite:Play("DownSlam", false)
				end
			end
			if sprite:IsEventTriggered("Decelerate") then
				entity.Velocity = entity.Velocity * 0.8
			elseif sprite:IsEventTriggered("Stop") then
				entity.Velocity = Vector(0,0)
			elseif sprite:IsEventTriggered("Charge") then
				if data.Direction == Direction.RIGHT then
					entity.Velocity = Vector(25, 0)
				elseif data.Direction == Direction.LEFT then
					entity.Velocity = Vector(-25, 0)
				elseif data.Direction == Direction.UP then
					entity.Velocity = Vector(0, -25)
				elseif data.Direction == Direction.DOWN then
					entity.Velocity = Vector(0, 25)
				end
			elseif sprite:IsEventTriggered("BackUp") then
				if data.Direction == Direction.LEFT then
					entity.Velocity = Vector(10, 0)
				elseif data.Direction == Direction.RIGHT then
					entity.Velocity = Vector(-10, 0)
				elseif data.Direction == Direction.DOWN then
					entity.Velocity = Vector(0, -10)
				elseif data.Direction == Direction.UP then
					entity.Velocity = Vector(0, 10)
				end
			elseif sprite:IsEventTriggered("Reverse") then
				if data.Direction == Direction.LEFT then
					entity.Velocity = Vector(5, 0)
				elseif data.Direction == Direction.RIGHT then
					entity.Velocity = Vector(-5, 0)
				elseif data.Direction == Direction.DOWN then
					entity.Velocity = Vector(0, -5)
				elseif data.Direction == Direction.UP then
					entity.Velocity = Vector(0, 5)
				end
			end
		if sprite:IsFinished("HoriSlam") or sprite:IsFinished("UpSlam") or sprite:IsFinished("DownSlam") then
			entity.State = 0
		end
	end
end

function Exodus:OnOccultist(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local room = Game():GetRoom()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if sprite:IsEventTriggered("Decelerate") then
		entity.Velocity = entity.Velocity * 0.8
	elseif sprite:IsEventTriggered("Flap") then
		SFXManager():Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 0.7)
	elseif sprite:IsEventTriggered("Stop") then
		entity.Velocity = Vector(0,0)
	elseif sprite:IsEventTriggered("Invisible") then
		SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 0.3)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	elseif sprite:IsEventTriggered("Visible") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	elseif sprite:IsEventTriggered("Teleport") then
		SFXManager():Play(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, 0.6)
		entity.Position = room:FindFreeTilePosition(room:GetRandomPosition(40), 5)
	elseif sprite:IsEventTriggered("Shoot") then
		for i = -1, 1 do
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, Vector.FromAngle(angle + i * 20):Resized(10), entity)
			SFXManager():Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
		end
	elseif sprite:IsEventTriggered("AOESpawn") then
		SFXManager():Play(SoundEffect.SOUND_HUSH_CHARGE, 1, 0, false, 1)
		for i=1, math.random(15,30) do
			local Marker = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Occultist Tear Marker"), 0, room:FindFreeTilePosition(room:GetRandomPosition(40), 5), Vector(0,0), entity)
			Marker:GetSprite():Play("Idle", false)
		end
	elseif sprite:IsEventTriggered("AOEActivate") then
		SFXManager():Play(SoundEffect.SOUND_SATAN_BLAST, 1, 0, false, 1)
		local entities = Isaac.GetRoomEntities()
		for i=1, #entities do
			if entities[i].Type == EntityType.ENTITY_EFFECT and entities[i].Variant == Isaac.GetEntityVariantByName("Occultist Tear Marker") then
				local OccultistProjectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entities[i].Position, Vector(0,0), entity)
				OccultistProjectile:GetData().IsOccultistAOE = true
				OccultistProjectile:GetData().AOEFrames = 0
				entities[i]:Remove()
			end
		end
	end
	if entity.State == 0 then -- Spawn & Animate Appear
		if sprite:IsFinished("Appear") then
			entity.State = 2
		end
	elseif entity.State == 2 then -- Wander
		entity:AnimWalkFrame("Walk", "Walk", 0)
		if math.random(20) == 1 or entity.FrameCount == 40 then
			entity.Pathfinder:MoveRandomly()
		end
		entity.Velocity = entity.Velocity:Resized(2)
		if math.random(80) == 1 then
			entity.State = 3
		end
	elseif entity.State == 3 then -- Teleport
		sprite:Play("Teleport", false)
		if sprite:IsFinished("Teleport") then
			if Exodus:IsAOEFree() == false then
				entity.State = 2
			else
				entity.State = math.random(2,5)
			end
		end
	elseif entity.State == 4 then -- Shoot
		sprite:Play("Projectiles")
		if sprite:IsFinished("Projectiles") then
			entity.State = 3
		end
	elseif entity.State == 5 then -- AOE Attack
		sprite:Play("AOE")
		if sprite:IsFinished("AOE") then
			entity.State = 3
		end
	end
end

function Exodus:InputAction(entity, hook, action)
	  if entity ~= nil then
        local player = Isaac.GetPlayer(0)
        if entity:ToPlayer() and player:HasTrinket(Isaac.GetTrinketIdByName("Broken Glasses")) and hook == InputHook.GET_ACTION_VALUE then
            if action == ButtonAction.ACTION_LEFT then
                return Input.GetActionValue(ButtonAction.ACTION_RIGHT, entity:ToPlayer().ControllerIndex)
            elseif action == ButtonAction.ACTION_RIGHT then
                return Input.GetActionValue(ButtonAction.ACTION_LEFT, entity:ToPlayer().ControllerIndex)
            elseif action == ButtonAction.ACTION_UP then
                return Input.GetActionValue(ButtonAction.ACTION_DOWN, entity:ToPlayer().ControllerIndex)
            elseif action == ButtonAction.ACTION_DOWN then
                return Input.GetActionValue(ButtonAction.ACTION_UP, entity:ToPlayer().ControllerIndex)
            end
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                if action == ButtonAction.ACTION_SHOOTLEFT then
                    return Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT, entity:ToPlayer().ControllerIndex)
                elseif action == ButtonAction.ACTION_SHOOTRIGHT then
                    return Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT, entity:ToPlayer().ControllerIndex)
                elseif action == ButtonAction.ACTION_SHOOTUP then
                    return Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN, entity:ToPlayer().ControllerIndex)
                elseif action == ButtonAction.ACTION_SHOOTDOWN then
                    return Input.GetActionValue(ButtonAction.ACTION_SHOOTUP, entity:ToPlayer().ControllerIndex)
                end
            end
        end
    end
end

function Exodus:HalfBlindProtection(target,amount,flag,source,cdframes)
	local data = target:GetData()
	if source.Type == 2 then -- Is tear
		if data.FacingDirection == Direction.RIGHT then -- Block shots from the right
			if source.Position.X > target.Position.X then
				return false
			end
		elseif data.FacingDirection == Direction.LEFT then -- Block shots from the left
			if source.Position.X < target.Position.X then
				return false
			end
		elseif data.FacingDirection == Direction.UP then -- Block shots from up
			if source.Position.Y < target.Position.Y then
				return false
			end
		elseif data.FacingDirection == Direction.DOWN then -- Block shots from down
			if source.Position.Y > target.Position.Y then
				return false
			end
		end
	end
end

function Exodus:OnHalfBlind(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local room = Game():GetRoom()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	local entities = Isaac.GetRoomEntities()
	for i=1, #entities do
		if entities[i].Type == 2 then
			entities[i]:GetData().LastVelocity = entity.Velocity
		end
	end
	if sprite:IsEventTriggered("Decelerate") then -- Decelerate
		entity.Velocity = entity.Velocity * 0.8
	elseif sprite:IsEventTriggered("Stop") then -- Stop Velocity
		entity.Velocity = Vector(0,0)
	elseif sprite:IsEventTriggered("Brimstone Up") then -- Shoot up
		EntityLaser.ShootAngle(1, entity.Position, -90, 30, Vector(0,-30), entity)
	elseif sprite:IsEventTriggered("Brimstone Down") then -- Shoot down
		EntityLaser.ShootAngle(1, entity.Position, 90, 30, Vector(0,-30), entity)
	elseif sprite:IsEventTriggered("Brimstone Hori") then -- Shoot horizontal
		if sprite.FlipX == false then
			EntityLaser.ShootAngle(1, entity.Position, 180, 30, Vector(0,-30), entity)
		else
			EntityLaser.ShootAngle(1, entity.Position, 0, 30, Vector(0,-30), entity)
		end
	end -- Brimstone other event
	if entity.FrameCount <=1 then
		sprite:Play("Appear", false)
		data.DirectionMultiplier = math.random(5)
		data.AttackCooldown = 0
	end
	if entity.State == 0 then -- Move around
		if data.AttackCooldown > 0 then
			data.AttackCooldown = data.AttackCooldown - 1
		end
		if math.random(50) == 1 or entity:CollidesWithGrid() then
			data.DirectionMultiplier = math.random(5)
		end
		entity.Velocity = Vector.FromAngle(data.DirectionMultiplier * 90):Resized(7)
		if entity.Velocity.Y > 0 then
			entity:AnimWalkFrame("Hori", "Down", 0)
		elseif entity.Velocity.Y < 0 then
			entity:AnimWalkFrame("Hori", "Up", 0)
		end
		if data.AttackCooldown == 0 then
			if sprite:IsPlaying("Hori") and sprite.FlipX == false then -- Facing Right
				if target.Position.X < entity.Position.X and target.Position.Y - 10 < entity.Position.Y and target.Position.Y + 10 > entity.Position.Y then
					entity.State = 2
				end
				data.FacingDirection = Direction.RIGHT
			elseif sprite:IsPlaying("Hori") and sprite.FlipX == true then -- Facing Left
				if target.Position.X > entity.Position.X and target.Position.Y - 10 < entity.Position.Y and target.Position.Y + 10 > entity.Position.Y then
					entity.State = 3
				end
				data.FacingDirection = Direction.LEFT
			elseif sprite:IsPlaying("Down") then
				if target.Position.Y < entity.Position.Y and target.Position.X - 10 < entity.Position.X and target.Position.X + 10 > entity.Position.X then -- Facing Down
					entity.State = 4
				end
				data.FacingDirection = Direction.DOWN
			elseif sprite:IsPlaying("Up") then
				if target.Position.Y > entity.Position.Y and target.Position.X - 10 < entity.Position.X and target.Position.X + 10 > entity.Position.X then -- Facing Up
					entity.State = 5
				end
				data.FacingDirection = Direction.UP
			end
		end
	elseif entity.State == 2 then -- Right Facing Attack
		sprite:Play("ShootHori", false)
		if sprite:IsFinished("ShootHori") then
			entity.State = 0
		end
		data.AttackCooldown = 60
	elseif entity.State == 3 then -- Left Facing Attack
		sprite:Play("ShootHori", false)
		sprite.FlipX = true
		if sprite:IsFinished("ShootHori") then
			entity.State = 0
		end
		data.AttackCooldown = 60
	elseif entity.State == 4 then -- Upwards Attack
		sprite:Play("ShootDown", false)
		if sprite:IsFinished("ShootDown") then
			entity.State = 0
		end
		data.AttackCooldown = 60
	elseif entity.State == 5 then -- Downwards Attack
		sprite:Play("ShootUp", false)
		if sprite:IsFinished("ShootUp") then
			entity.State = 0
		end
		data.AttackCooldown = 60
	end
end

function Exodus:OnHeadCase(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local room = Game():GetRoom()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if entity.FrameCount <= 1 then
		sprite:Play("Appear", false)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
	if sprite:IsEventTriggered("Vulnerable") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif sprite:IsEventTriggered("Invulnerable") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	elseif sprite:IsEventTriggered("Decel") then
		entity.Velocity = entity.Velocity * 0.8
	elseif sprite:IsEventTriggered("Stop") then
		entity.Velocity = Vector(0,0)
	elseif sprite:IsEventTriggered("Stomp") then
		if entity.Position:Distance(player.Position) < 20 then
			player:TakeDamage(2, 0, EntityRef(entity), 30)
		end
		for i=1, math.random(4) do
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position + Vector(math.random(-5,5), math.random(-5,5)), Vector(0,0), entity)
		end
		for i=0, 7 do
			local boom = Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, entity.Position, Vector.FromAngle(i * 45):Resized(10), entity)
			boom:ToTear().FallingSpeed = -10
			boom:ToTear().FallingAcceleration = 1
			boom:GetData().IsExodusLobbed = true
			boom.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		end
		SFXManager():Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 4, 0, false, 1)
	end
	if entity.State == 0 then
		if entity.FrameCount > 1 then
			sprite:Play("Idle", false)
		end
		entity.Velocity = (target.Position - entity.Position):Resized(30)
		if entity.Position:Distance(target.Position) < 20 then
			entity.State = 2
			SFXManager():Play(SoundEffect.SOUND_BOSS_GURGLE_ROAR , 2, 0, false, 0.8)
		end
	elseif entity.State == 2 then
		sprite:Play("Stomp", false)
		if sprite:IsFinished("Stomp") then
			entity.State = 0
		end
	end
end

function Exodus:OnHollowhead(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if data.TelegraphLaser ~= nil then
		if data.StopFollowing ~= true then
			data.TelegraphLaser.Angle = angle
		end
	end
	if data.TelegraphLaser1 ~= nil then
		if data.StopFollowing ~= true then
			data.TelegraphLaser1.Angle = angle + 180
		end
	end
	if sprite:IsEventTriggered("Decelerate") then
		entity.Velocity = entity.Velocity * 0.8
	elseif sprite:IsEventTriggered("Telegraph") then
		local telegraph = EntityLaser.ShootAngle(2, entity.Position, angle, 34, Vector(0,-40), entity)
		telegraph.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		telegraph.Color = Color(telegraph.Color.R, telegraph.Color.G, telegraph.Color.B, 0.7, 0, 0, 100)
		telegraph:SetMaxDistance(80)
		local telegraph1 = EntityLaser.ShootAngle(2, entity.Position, angle + 180, 34, Vector(0,-40), entity)
		telegraph1.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		telegraph1.Color = Color(telegraph1.Color.R, telegraph1.Color.G, telegraph1.Color.B, 0.7, 0, 0, 100)
		telegraph1:SetMaxDistance(80)
		data.TelegraphLaser = telegraph
		data.TelegraphLaser1 = telegraph1
	elseif sprite:IsEventTriggered("Stop Follow") then
		data.StopFollowing = true
	elseif sprite:IsEventTriggered("Shoot") then
		SFXManager():Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 2, 0, false, 0.8)
		local real_laser = EntityLaser.ShootAngle(9, entity.Position, data.TelegraphLaser:ToLaser().AngleDegrees, 13, Vector(0,-45), entity)
		local real_laser1 = EntityLaser.ShootAngle(9, entity.Position, data.TelegraphLaser:ToLaser().AngleDegrees + 180, 13, Vector(0,-45), entity)
		real_laser.Color = Color(real_laser.Color.R, real_laser.Color.G, real_laser.Color.B, 1, 0, 0, 70)
		real_laser1.Color = Color(real_laser1.Color.R, real_laser1.Color.G, real_laser1.Color.B, 1, 0, 0, 70)
	end
	if entity.State == 0 then -- Follow (Inbetween attacks)
		entity:AnimWalkFrame("Fly", "Fly", 0)
		data.StopFollowing = false
		if entity.Position:Distance(target.Position) > 100 then
			entity.Velocity = (target.Position - entity.Position):Resized(5)
		else
			entity.Velocity = (target.Position - entity.Position):Resized(2)
		end
		if math.random(100) == 1 then
			entity.State = 2
		end
	elseif entity.State == 2 then -- Attack
		if entity.Position.X < target.Position.X then
			sprite.FlipX = true
		else
			sprite.FlipX = false
		end
		sprite:Play("Telegraph and Shoot", false)
		if sprite:IsFinished("Telegraph and Shoot") then
			entity.State = 3
		end
	elseif entity.State == 3 then
		sprite:Play("Telegraph and Shoot", false)
		if sprite:IsFinished("Telegraph and Shoot") then
			entity.State = 0
		end
	end
end

function Exodus:OnWombshroom(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if entity.FrameCount <= 1 then
		data.State0Frames = 0
		data.State2Frames = 0
		data.StartShroomPosition = entity.Position
	end
	entity.Velocity = Vector(0,0)
	entity.Position = data.StartShroomPosition
	if sprite:IsEventTriggered("Shoot") then
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, Vector.FromAngle(data.ShotAngle * 45 + 90):Resized(10), entity)
		SFXManager():Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1)
		data.ShotAngle = data.ShotAngle + 1
	elseif sprite:IsEventTriggered("Splash") then
		for i=0, 8 do
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, Vector.FromAngle(i * 45 + 90):Resized(10), entity)
		end
		SFXManager():Play(SoundEffect.SOUND_MEAT_IMPACTS, 2, 0, false, 0.8)
	end
	if entity.State == 0 then -- Hiding
		data.ShotAngle = 0
		sprite:Play("Blocking", false)
		data.State0Frames = data.State0Frames + 1
		if data.State0Frames == 10 then
			entity.State = 2
			data.State0Frames = 0
		end
	elseif entity.State == 2 then -- Attacking
		data.State2Frames = data.State2Frames + 1
		if data.State2Frames == 1 then
			sprite:Play("Reveal", false)
		end
		if sprite:IsFinished("Reveal") then
			sprite:Play("Hide", false)
		end
		if sprite:IsFinished("Hide") then
			entity.State = 0
			data.State2Frames = 0
		end
	end
end

function Exodus:OnCarrionPrince(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if entity.FrameCount <= 1 then
		data.DirectionMultiplier = math.random(5)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		data.BombTimer = -1
	end
	if entity.State >= 7 then
		entity.Velocity = Vector(0,0)
		if data.BombTimer > 0 then
			data.BombTimer = data.BombTimer - 1
		end
		if data.BombTimer == 0 then
			Isaac.Explode(entity.Position, player, 60)
			entity:GetData().Butt:TakeDamage(60, DamageFlag.DAMAGE_EXPLOSION, EntityRef(player), 0)
			data.BombTimer = -1
			entity.State = 2
		end
	end
	if entity.State >= 3 then
		local entities = Isaac.GetRoomEntities()
		for i=1, #entities do
			if entities[i].Type == EntityType.ENTITY_BOMBDROP and entities[i].Variant == BombVariant.BOMB_NORMAL then
				if entities[i].Position:Distance(entity.Position) < entity.Size + entities[i].Size then
					entity.State = entity.State + 4
					data.BombTimer = 15
					entities[i]:Remove()
				end
			end
		end
	end
	if entity.State == 0 then -- Spawn Stuff
		if entity:GetData().MainNPC == nil then
			local Body1 = Isaac.Spawn(Isaac.GetEntityTypeByName("Carrion Prince"), 0, 0, entity.Position, Vector(0,0), entity)
			Body1.Parent = entity
			Body1:GetData().IsBody = true
			Body1:GetData().MainNPC = entity
			local Body2 = Isaac.Spawn(Isaac.GetEntityTypeByName("Carrion Prince"), 0, 0, entity.Position, Vector(0,0), entity)
			Body2.Parent = Body1
			Body2:GetData().IsBody = true
			Body2:GetData().MainNPC = entity
			local Body3 = Isaac.Spawn(Isaac.GetEntityTypeByName("Carrion Prince"), 0, 0, entity.Position, Vector(0,0), entity)
			Body3.Parent = Body2
			Body3:GetData().IsBody = true
			Body3:GetData().MainNPC = entity
			local Butt = Isaac.Spawn(Isaac.GetEntityTypeByName("Carrion Prince"), 0, 0, entity.Position, Vector(0,0), entity)
			Butt.Parent = Body3
			Butt:GetData().IsButt = true
			Butt:GetData().MainNPC = entity
			entity:GetData().IsHead = true
			entity:GetData().Butt = Butt
			entity.State = 2
		else
			entity.State = 2
		end
	elseif entity.State == 2 then -- Move Around
		if entity:GetData().IsHead ~= true then
			if entity.Position:Distance(entity.Parent.Position) > 30 then
				entity.Position = entity.Parent.Position + (entity.Position - entity.Parent.Position):Resized(30)
			end
		else
			if entity.Velocity.Y > 0 then
				entity:AnimWalkFrame("WalkHeadHori", "WalkHeadDown", 0)
			elseif entity.Velocity.Y < 0 then
				entity:AnimWalkFrame("WalkHeadHori", "WalkHeadUp", 0)
			end
			if math.random(50) == 1 or entity:CollidesWithGrid() then
				data.DirectionMultiplier = math.random(5)
			end
			entity.Velocity = Vector.FromAngle(data.DirectionMultiplier * 90):Resized(7)
			if target.Position.X < entity.Position.X and target.Position.Y - 10 < entity.Position.Y and target.Position.Y + 10 > entity.Position.Y then
				entity.State = 3
				SFXManager():Play(SoundEffect.SOUND_MONSTER_ROAR_2   , 1, 0, false, 1)
			end
			if target.Position.X > entity.Position.X and target.Position.Y - 10 < entity.Position.Y and target.Position.Y + 10 > entity.Position.Y then
				entity.State = 4
				SFXManager():Play(SoundEffect.SOUND_MONSTER_ROAR_1   , 1, 0, false, 1)
			end
			if target.Position.Y < entity.Position.Y and target.Position.X - 10 < entity.Position.X and target.Position.X + 10 > entity.Position.X then -- Facing Up
				entity.State = 5
				SFXManager():Play(SoundEffect.SOUND_MONSTER_ROAR_0   , 1, 0, false, 1)
			end
			if target.Position.Y > entity.Position.Y and target.Position.X - 10 < entity.Position.X and target.Position.X + 10 > entity.Position.X then -- Facing Down
				entity.State = 6
				SFXManager():Play(SoundEffect.SOUND_MONSTER_ROAR_0   , 1, 0, false, 1)
			end
		end
		if entity:GetData().IsBody then
			if math.abs(entity:GetData().MainNPC.Velocity.Y) > math.abs(entity:GetData().MainNPC.Velocity.X) then
				sprite:Play("WalkBodyVert", false)
			else	
				sprite:Play("WalkBodyHori", false)
				if entity:GetData().MainNPC.Velocity.X > 0 then
					sprite.FlipX = false
				else
					sprite.FlipX = true
				end
			end
		elseif entity:GetData().IsButt then
			if math.abs(entity:GetData().MainNPC.Velocity.Y) > math.abs(entity:GetData().MainNPC.Velocity.X) then
				if entity:GetData().MainNPC.Velocity.Y > 0 then
					sprite:Play("WalkButtDown", false)
				else
					sprite:Play("WalkButtUp", false)
				end
			else	
				if entity:GetData().MainNPC.Velocity.X > 0 then
					sprite.FlipX = false
				else
					sprite.FlipX = true
				end
				sprite:Play("WalkButtHori", false)
			end
		end
	elseif entity.State == 3 then -- Left
		sprite:Play("AngryHeadHori", false)
		sprite.FlipX = true
		entity.Velocity = Vector.FromAngle(180):Resized(10)
		if entity:CollidesWithGrid() then
			entity.State = 2
		end
	elseif entity.State == 4 then -- Right
		sprite:Play("AngryHeadHori", false)
		sprite.FlipX = false
		entity.Velocity = Vector.FromAngle(0):Resized(10)
		if entity:CollidesWithGrid() then
			entity.State = 2
		end
	elseif entity.State == 5 then -- Up
		sprite:Play("AngryHeadUp", false)
		entity.Velocity = Vector.FromAngle(-90):Resized(10)
		if entity:CollidesWithGrid() then
			entity.State = 2
		end
	elseif entity.State == 6 then -- Down
		sprite:Play("AngryHeadDown", false)
		entity.Velocity = Vector.FromAngle(90):Resized(10)
		if entity:CollidesWithGrid() then
			entity.State = 2
		end
	elseif entity.State == 7 then -- Left Eat Bomb
		sprite:Play("SadHeadHori", false)
		sprite.FlipX = true
	elseif entity.State == 8 then -- Right Eat Bomb
		sprite:Play("SadHeadHori", false)
		sprite.FlipX = false
	elseif entity.State == 9 then -- Up Eat Bomb
		sprite:Play("SadHeadUp", false)
	elseif entity.State == 10 then -- Down Eat Bomb
		sprite:Play("SadHeadDown", false)
	end
	if entity:IsDead() then
		if entity.Parent ~= nil then
			entity.Parent:Die()
		end
	end
end

function Exodus:OnCarrionTakeDMG(target, amount, flag, source, cd)
	if target:GetData().IsButt ~= true then
		return false
	end
end

function Exodus:OnLithopedion(entity)
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local angle = (target.Position - entity.Position):GetAngleDegrees()
	if entity.FrameCount <= 1 then
		sprite:Play("Appear", false)
		entity.State = 0
		entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	end
	if sprite:IsFinished("Appear") then
		entity.Pathfinder:MoveRandomly(false)
		sprite:Play("Idle", false)
	end
	if sprite:IsFinished("Idle") then
		entity.Pathfinder:Reset()
		entity.Velocity = Vector(0,0)
		sprite:Play("Attack", false)
	end
	if sprite:IsEventTriggered("Stomp") then
		SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS , 2, 0, false, 0.8)
		if math.random(2) == 1 then
			local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, entity.Position, Vector(0,0), entity)
			shockwave:ToEffect():SetRadii(20,100)
		else
			local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE_RANDOM , 0, entity.Position, Vector(0,0), entity)
			shockwave:ToEffect():SetTimeout(200)
		end
		sprite:Play("Idle", false) 
		entity.Pathfinder:MoveRandomly(false)
	end
	entity.Velocity = entity.Velocity:Resized(math.random(1,2))
	if entity:IsDead() then
		for i=1, 2 do
			Isaac.Spawn(Isaac.GetEntityTypeByName("Blockage"), 0, 0, entity.Position + Vector(math.random(-2,2), math.random(-2,2)), Vector(0,0), entity)
		end
	end
end

function Exodus:LithResistance(target, amount, flag, source, cd)
	if source.Type == 0 and source.Variant == 0 and flag == 4 then
		return false
	end
end

function Exodus:OnFleshDeathsEye(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Flesh Death's Eye") then
		local player = Isaac.GetPlayer(0)
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local angle = (target.Position - entity.Position):GetAngleDegrees()
		if sprite:IsEventTriggered("Shoot") then
			SFXManager():Play(SoundEffect.SOUND_GURG_BARF , 1, 0, false, 1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0 , 0, entity.Position, Vector.FromAngle(angle + 10):Resized(10), entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0 , 0, entity.Position, Vector.FromAngle(angle - 10):Resized(10), entity)
		end
	end
end

function Exodus:DetectDeadFleshEye()
	local entities = Isaac.GetRoomEntities()
	for i=1, #entities do
		if entities[i].Type == Isaac.GetEntityTypeByName("Flesh Death's Eye") and entities[i].Variant == Isaac.GetEntityVariantByName("Flesh Death's Eye") and entities[i]:HasMortalDamage() then
			for v=0, 7 do
				Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entities[i].Position, Vector.FromAngle(v * 45):Resized(10), entities[i])
			end
		end
	end
end

function Exodus:OnDeathsEye(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Death's Eye") then
		local player = Isaac.GetPlayer(0)
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local angle = (target.Position - entity.Position):GetAngleDegrees()
		if sprite:IsEventTriggered("Shoot") then
			SFXManager():Play(SoundEffect.SOUND_FIRE_RUSH , 1, 0, false, 1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2 , 0, entity.Position, Vector.FromAngle(angle):Resized(10), entity)
		end
		entity.Velocity = entity.Velocity:Resized(5)
	end
end

function Exodus:DeathsEyeProtection(target,amount,flag,source,cdframes)
	if target.Variant == Isaac.GetEntityVariantByName("Death's Eye") then
		return false
	end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.DeathsEyeProtection, Isaac.GetEntityTypeByName("Death's Eye"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnDeathsEye, Isaac.GetEntityTypeByName("Death's Eye"))
Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.DetectDeadFleshEye)
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnFleshDeathsEye, Isaac.GetEntityTypeByName("Flesh Death's Eye"))
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.LithResistance, Isaac.GetEntityTypeByName("Lithopedion"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnLithopedion, Isaac.GetEntityTypeByName("Lithopedion"))
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.OnCarrionTakeDMG, Isaac.GetEntityTypeByName("Carrion Prince"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnCarrionPrince, Isaac.GetEntityTypeByName("Carrion Prince"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnWombshroom, Isaac.GetEntityTypeByName("Wombshroom"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnHollowhead, Isaac.GetEntityTypeByName("Hollowhead"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnHeadCase, Isaac.GetEntityTypeByName("Headcase"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnHalfBlind, Isaac.GetEntityTypeByName("Halfblind"))
Exodus:AddCallback(ModCallbacks.MC_INPUT_ACTION, Exodus.InputAction)
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnOccultist, Isaac.GetEntityTypeByName("Occultist"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnIronLung, Isaac.GetEntityTypeByName("Iron Lung"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnFlyerball, 25)
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnCloster, Isaac.GetEntityTypeByName("Closter"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.OnBlockage, Isaac.GetEntityTypeByName("Blockage"))
Exodus:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE,Exodus.update)
Exodus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL,Exodus.newfloor)
Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,Exodus.newroom)
Exodus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED,Exodus.newgame)
Exodus:AddCallback(ModCallbacks.MC_POST_RENDER,Exodus.OnRender)
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE,Exodus.DrownedShroomman,Isaac.GetEntityTypeByName("Drowned Mushroom"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE,Exodus.DankDip,Isaac.GetEntityTypeByName("Dank Dip"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE,Exodus.PoisonMastermind,Isaac.GetEntityTypeByName("Poison Mastermind"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.UpdateBirdbath, Isaac.GetEntityTypeByName("Birdbath"))
Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE,Exodus.Newents,901)
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM,Exodus.UseForbFruit,Isaac.GetItemIdByName("The Forbidden Fruit"))
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM,Exodus.WrathOfTheLamb,Isaac.GetItemIdByName("Wrath of the Lamb"))
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.Birdbath, Isaac.GetItemIdByName("Birdbath"))
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM,Exodus.OnUseLantern,Isaac.GetItemIdByName("Ominous Lantern"))
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.activateMitt, Isaac.GetItemIdByName("Baseball Mitt"))
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.UsePseudobulbar, Isaac.GetItemIdByName("The Pseudobulbar Affect"))
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.UseClover, Isaac.GetItemIdByName("Mutant Clover"))
Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.UseTragicMushroom, Isaac.GetItemIdByName("Tragic Mushroom"))
Exodus:AddCallback(ModCallbacks.MC_USE_CARD,Exodus.carduse)
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,Exodus.HungryHippo,Isaac.GetEntityVariantByName("Hungry Hippo"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,Exodus.UpdateCandle,Isaac.GetEntityVariantByName("Candle"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Exodus.AstroUpdate, Isaac.GetEntityVariantByName("Astro Baby"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT,Exodus.HippoInit,Isaac.GetEntityVariantByName("Hungry Hippo"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT,Exodus.CandleInit,Isaac.GetEntityVariantByName("Candle"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Exodus.AstroInit, Isaac.GetEntityVariantByName("Astro Baby"))
Exodus:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,Exodus.oninit)
Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,Exodus.cache)
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Exodus.DetectDMG)
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Exodus.NewEntDamage,901)
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.HalfBlindProtection, Isaac.GetEntityTypeByName("Halfblind"))