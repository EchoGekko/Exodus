local Exodus = RegisterMod("Exodus",1)
local variable = {}
local game = Game()
local NullVector = Vector(0,0)
local player = Isaac.GetPlayer(0)
function Exodus:oninit()
  player = Isaac.GetPlayer(0)
end
function Exodus:newgame(fromSave)
  variable[1] = false --Has Queen Bee.
  variable[2] = false --Has Beenades.
  variable[4] = false --Has Busted Pipe.
  variable[5] = true
  variable[6] = false --Has Unholy Mantle.
  variable[7] = false --Has Tech Y.
  variable[8] = false --Has Paper Cut.
  variable[9] = false --Has Forget Me Later.
  variable[10] = false --Room is clear with Win Streak.
  variable[11] = false --Has Win Streak.
  variable[12] = 0 --Dragon Breath charge,
  variable[13] = NullVector --Charge direction.
  variable[14] = false --Has Dragon Breath.
  variable[15] = 0 --Number of floors before Forget Me Later activates.
  variable[16] = 0 --Number of lit up candles with Ritual Candle.
  variable[17] = false
  variable[18] = nil --Pentagram entity.
  variable[20] = false
  variable[21] = false
  variable[22] = false --Boss spawned?
  variable[23] = nil
  variable[24] = nil --Frame count for WotL.
  variable[25] = 0 --Damage lost from WotL.
  variable[26] = 0 --Fire Delay lost from WotL.
  variable[27] = 0 --Range lost from WotL.
  variable[28] = 0 --Speed lost from WotL.
  variable[29] = true
  variable[30] = true
  variable[31] = false
  variable[32] = nil
  variable[33] = 300 -- Lantern frame modifier
  variable[34] = Vector(1,1)
  variable[35] = false
  variable[36] = { -- Subroom Charge items
	{id = Isaac.GetItemIdByName("Ominous Lantern"),
  frames = variable[33],
  curCharge = 0}
  }
  variable[37] = { --Squishable Enemies for dad's boots
	{id = 85,
  variant = 0},
  {id = 246},
  {id = 21},
  {id = 23},
  {id = 30},
  {id = 31},
  {id = 32},
  {id = 58,
  variant = 0},
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
	{id = 206,
  variant = 1},
	{id = 207,
  variant = 1}
  }
  variable[38] = Sprite()
  variable[38]:Load("gfx/ui/ui_chargebar2.anm2",true)
  variable[39] = false
  variable[40] = 0
  variable[41] = 0
  variable[42] = Sprite()
  variable[42]:Load("gfx/Pseudobulbar Icon.anm2", true)
  variable[42]:Play("Idle", true)
  variable[43] = 0
  variable[44] = 0
end
local function PlayerIsMoving()
	if Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex) then
		return true
	elseif Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex) then
		return true
	elseif Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex) then
		return true
	elseif Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex) then
		return true
	else
		return false
	end
end
local function IsProperEnemy(ent)
  if ent~=nil then
    if ent:IsActiveEnemy(false) and ent:CanShutDoors() then
      return true
    end
  end
  return false
end
local function GetRandomEnemyInTheRoom(entity) 
  local index = 1
  local possible = {}
  for i = 1,#entities do
		if IsProperEnemy(entities[i]) and entity.Position:Distance(entities[i].Position) < 250 then
			possible[index] = entities[i]
      index = index + 1
		end
	end
  return possible[math.random(1,index)]
end
local function PlayCandleTearSprite(candletear)
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
local function SpawnCandleTear(npc,isnormal)
local target = GetRandomEnemyInTheRoom(npc)
  if target ~= nil then
    local angle = (target.Position - npc.Position):GetAngleDegrees()
    local candletear = Isaac.Spawn(EntityType.ENTITY_TEAR,0,0,npc.Position,Vector.FromAngle(1*angle):Resized(5),player)
    candletear:ToTear().TearFlags = candletear:ToTear().TearFlags | TearFlags.TEAR_HOMING
    PlayCandleTearSprite(candletear)
    candletear:GetData().AddedFireBonus = true
  end
end
local function SpawnGib(position,spawner,big)
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
local function FireTurretBullet(pos, vel, spawner)
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
local function FireLantern(pos,vel,anim)
	if (variable[29] == false or player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)) and player:HasCollectible(Isaac.GetItemIdByName("Ominous Lantern")) then 
		variable[32] = nil
		player:DischargeActiveItem()
		variable[29] = true
		variable[30] = true
		local lantern = Isaac.Spawn(2,Isaac.GetEntityVariantByName("Lantern Tear"),0,pos,vel + player.Velocity,player):ToTear()
		lantern.FallingSpeed = -10
		lantern.FallingAcceleration = 1
		if anim then
			player:AnimateCollectible(Isaac.GetItemIdByName("Ominous Lantern"),"HideItem","PlayerPickupSparkle")
		end
	end
end
function Exodus:update(player)
  local entities = Isaac.GetRoomEntities()
  local room = game:GetRoom()
  local level = game:GetLevel()
  if variable[12] == nil then variable[12] = 0 end
  if game:GetFrameCount() == 1 then
		for i=1,#variable[36] do
			variable[36][i].curCharge = 0
		end
	end
	local room = game:GetRoom()
	if player:GetActiveCharge() == 0 then
		for i,item in pairs(variable[36]) do
			if player:GetActiveItem() == item.id then
				variable[36][i].curCharge = variable[36][i].curCharge + 1
				if variable[36][i].curCharge >= variable[33] then
					variable[36][i].curCharge = 0
					player:FullCharge()
				end
			end
		end
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
		variable[33] = 100
	else
		variable[33] = 300
	end
	if game:GetFrameCount() <= 1 or game:GetRoom():GetFrameCount() <= 1 then
		variable[29] = true
		variable[30] = true
	end	
	if variable[29] == false then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
			player:FullCharge()
		end
		if variable[30] == false then
			player:AnimateCollectible(Isaac.GetItemIdByName("Ominous Lantern"),"LiftItem","PlayerPickupSparkle")
			variable[30] = true
		end
	end
	if variable[31] then
		variable[31] = false
		player:FullCharge()
	end
	for i=1,#entities do
		if entities[i].Type == EntityType.ENTITY_TEAR and entities[i].Variant == Isaac.GetEntityVariantByName("Lantern Tear") then
			if entities[i]:IsDead() then
				SFXManager():Play(SoundEffect.SOUND_METAL_BLOCKBREAK,1,0,false,1.5)
				SpawnGib(entities[i].Position,entities[i],true)
				SpawnGib(entities[i].Position,entities[i],false)
				SpawnGib(entities[i].Position,entities[i],false)
				SpawnGib(entities[i].Position,entities[i],false)
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
  if variable[39] and player:HasCollectible(Isaac.GetItemIdByName("Baseball Mitt")) then
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
					variable[40] = variable[40] + 1
				end
			end
		end
		if game:GetFrameCount() >= variable[41] + 120 then
			player:AnimateCollectible(Isaac.GetItemIdByName("Baseball Mitt"), "HideItem", "PlayerPickupSparkle")
			variable[39] = false
			if variable[40] > 0 then
				repeat
					player:FireTear(player.Position, Vector(10, 1):Rotated(math.random(360)), false, true, false)
					variable[40] = variable[40] - 1
				until variable[40] == 0
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
  if player:HasCollectible(Isaac.GetItemIdByName("Dad's Boots")) then
		for i=1, #entities do
			if entities[i]:IsActiveEnemy() then
				for v=1, #variable[37] do
					if variable[37][v].id == entities[i].Type and
					(variable[37][v].variant == entities[i].Variant or variable[37][v].variant == nil) and
					(variable[37][v].subtype == entities[i].SubType or variable[37][v].subtype == nil) and
					entities[i].Position:Distance(player.Position) < player.Size + entities[i].Size and player.Velocity ~= NullVector and PlayerIsMoving() then
						entities[i]:Die()
						SFXManager():Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, entities[i].Size / 8)
					end
				end
			end
		end
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
    variable[16] = 0
    for _,entity in pairs(Isaac.GetRoomEntities()) do 
      if entity.Type == 1000 and entity.Variant == 93 and entity:GetData().IsFromRitual then
        entity:Remove()
      end
      local range = 107
      if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        range = 150
      end
      if variable[17] and entity.Position:Distance(player.Position) <= range and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and game:GetFrameCount() % math.floor(player.MaxFireDelay/3) == 0 then
        entity:TakeDamage((player.Damage/4)*(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)+1),0,EntityRef(player),0)
      end
      if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Isaac.GetEntityVariantByName("Candle") and entity:GetData().IsLit then
        variable[16] = variable[16] + 1
      end
      if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Isaac.GetEntityVariantByName("Candle") and entity:GetData().IsLit then
        if variable[17] and entity:GetData().LitTimer > 120 then
          entity:GetSprite():Play("Lit All",false)
        else
          entity:GetSprite():Play("Lit",false)
        end
      elseif entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Isaac.GetEntityVariantByName("Candle") and entity:GetData().IsLit == false then
        entity:GetSprite():Play("Idle",false)
      end
    end
    if variable[16] == 5 then
      variable[18] = Isaac.Spawn(1000,93,0,player.Position,NullVector,player)
      variable[18]:GetSprite():Load("gfx/pentagram.anm2",true)
      variable[18]:GetSprite():Play("Idle",false)
      variable[18]:GetSprite():SetFrame("Idle",(game:GetFrameCount() % 5))
      variable[18]:ToEffect():FollowParent(player)
      variable[18].SpriteRotation = player.FrameCount*-2
      variable[18]:GetData().IsFromRitual = true
      if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        variable[18].SpriteScale = Vector(1.45,1.45)
      end
      variable[17] = true
      if variable[20] == false then
        SFXManager():Play(SoundEffect.SOUND_SATAN_GROW,1,0,false,1)
        variable[20] = true
      end
    else
      variable[17] = false
      if variable[20] then
        SFXManager():Play(SoundEffect.SOUND_SATAN_HURT,1,0,false,1)
        variable[20] = false
      end
    end	
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Forget Me Later")) and variable[9] == false then
    variable[15] = level:GetAbsoluteStage() + math.random(2)
    variable[9] = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Forget Me Later")) and player:GetSprite():IsPlaying("Trapdoor") and level:GetAbsoluteStage() >= variable[15] then
    player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW,false,false,false,false)
    player:RemoveCollectible(Isaac.GetItemIdByName("Forget Me Later"))
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Pig Blood")) then
    if variable[21] == false then
      variable[21] = true
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
    if variable[21] then
      variable[21] = false
    end
  end
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
if variable[24] ~= nil and player:HasCollectible(Isaac.GetItemIdByName("Wrath of the Lamb")) then
  if game:GetFrameCount() >= variable[24] + 65 and variable[22] == false then
		if MusicManager():GetCurrentMusicID() ~= Isaac.GetMusicIdByName("Locus") then
			MusicManager():PitchSlide(1)
			MusicManager():Play(Isaac.GetMusicIdByName("Locus"),0.15)
		end
		variable[22] = true
		bossroom = game:GetLevel():GetCurrentRoomIndex()
		for i,entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 64337 then
				if game:GetLevel():GetAbsoluteStage() == 1 or game:GetLevel():GetAbsoluteStage() == 2 then
					enemyPool = {EntityType.ENTITY_THE_HAUNT,EntityType.ENTITY_DINGLE,EntityType.ENTITY_MONSTRO,EntityType.ENTITY_LITTLE_HORN}
				elseif game:GetLevel():GetAbsoluteStage() == 3 or game:GetLevel():GetAbsoluteStage() == 4 then
					enemyPool = {EntityType.ENTITY_CHUB,EntityType.ENTITY_POLYCEPHALUS,EntityType.ENTITY_RAG_MEGA,EntityType.ENTITY_DARK_ONE}
				elseif game:GetLevel():GetAbsoluteStage() == 5 or game:GetLevel():GetAbsoluteStage() == 6 then
					enemyPool = {EntityType.ENTITY_MONSTRO2,EntityType.ENTITY_ADVERSARY,EntityType.ENTITY_GATE,EntityType.ENTITY_LOKI}
				elseif game:GetLevel():GetAbsoluteStage() == 7 or game:GetLevel():GetAbsoluteStage() == 8 then
					enemyPool = {EntityType.ENTITY_MR_FRED,EntityType.ENTITY_BLASTOCYST_BIG,EntityType.ENTITY_CAGE,EntityType.ENTITY_MASK_OF_INFAMY}
				elseif game:GetLevel():GetAbsoluteStage() == 9 then
					enemyPool = {EntityType.ENTITY_FORSAKEN,EntityType.ENTITY_STAIN}
				elseif game:GetLevel():GetAbsoluteStage() == 11 then
					if level:GetStageType() == StageType.STAGETYPE_WOTL then
						variable[22] = false
						variable[24] = nil
						entity:Remove()
						Isaac.ExecuteCommand("stage 11")
					else
						variable[22] = false
						variable[24] = nil
						entity:Remove()
						player:UseCard(Card.CARD_EMPEROR)
					end
				else
					enemyPool = {EntityType.ENTITY_MOM,EntityType.ENTITY_MOMS_HEART,EntityType.ENTITY_SATAN}
				end
				Isaac.Spawn(enemyPool[math.random(#enemyPool)],0,0,entity.Position,NullVector,nil)
				variable[24] = nil
				variable[22] = false
				entity:Remove()
			end
		end
	end
end
if game:GetRoom():IsClear() and bossroom == game:GetLevel():GetCurrentRoomIndex() and player:HasCollectible(Isaac.GetItemIdByName("Wrath of the Lamb")) then
  MusicManager():Play(Music.MUSIC_BOSS_OVER,0.1)
  Isaac.ExecuteCommand("spawn 5.100")
  bossroom = nil
end
  if player:HasCollectible(Isaac.GetItemIdByName("Tech Y")) then
    if variable[7] == false then
      variable[7] = true
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
    if variable[4] == false then
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Busted Pipe.anm2"))
      variable[4] = true
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
    if variable[2] == false then
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Beenades.anm2"))
      variable[2] = true
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
    if variable[1] == false then
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Queen Bee.anm2"))
      variable[1] = true
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
    if variable[11] == false then
      Isaac.Spawn(Isaac.GetEntityTypeByName("Score Display"),Isaac.GetEntityVariantByName("Score Display"),0,player.Position+Vector(0,-69),NullVector,player)
      variable[43] = -1
      variable[11] = true
    end
    if room:IsClear() then
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
      if variable[10] == false then
        if room:GetRoomShape() == RoomShape.ROOMSHAPE_2x2 then
          variable[43] = variable[43] + 2
        else
          variable[43] = variable[43] + 1
        end
        variable[10] = true
      end
    else
      variable[10] = false
    end
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Unholy Mantle")) and variable[6] == false then
    player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2"))
    variable[6] = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Paper Cut")) and variable[8] == false then
    player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Paper Cut.anm2"))
    variable[8] = true
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Dragon Breath")) then
    if variable[12] >= 10 then
      player:SetColor(Color(1+math.abs(math.sin(player.FrameCount/5)*2),1,1,1,math.abs(math.ceil(math.cos(player.FrameCount/5)*50)),0,0),-1,1,false,false)
    else
      player:SetColor(Color(1,1,1,1,0,0,0),-1,1,false,false)
    end
    if variable[14] == false then
      bar = Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Charge Bar"),0,player.Position,NullVector,player)
      bar:GetData().IsFireball = true
      bar.Visible = false
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Dragon Breath.anm2"))
      variable[14] = true
    end
    player.FireDelay = 10
    if variable[12] >= 10 then
      if player:GetFireDirection() > -1 then
        variable[13] = player:GetShootingJoystick()
      else
        Exodus:FireFire(variable[13],false,false,false)
      end
    end
    if room:GetFrameCount() == 1 then
      bar = Isaac.Spawn(1000,Isaac.GetEntityVariantByName("Charge Bar"),0,player.Position,NullVector,player)
      bar:GetData().IsFireball = true
      bar.Visible = false
    end
    if player:GetFireDirection() > -1 then
      if variable[12] < 10 then
        variable[12] = variable[12] + (1/player.MaxFireDelay)*8
      end
    else
      variable[12] = -1
    end
  end
  for i = 1,#entities do
    local e = entities[i]
      if e:GetData().IsPseudobulbarTurret then
        if player.FireDelay == player.MaxFireDelay then
          if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
            FireTurretBullet(e.Position + Vector(-1 * e.Size, 0) , Vector(-15, 0) * player.ShotSpeed + e.Velocity, e)
          elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
              FireTurretBullet(e.Position + Vector(e.Size, 0), Vector(15, 0) * player.ShotSpeed + e.Velocity, e)
            elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
            FireTurretBullet(e.Position + Vector(0, -1 * e.Size), Vector(0, -15) * player.ShotSpeed + e.Velocity, e)
          elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
            FireTurretBullet(e.Position + Vector(0, e.Size), Vector(0, 15) * player.ShotSpeed + e.Velocity, e)
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
      e.Color = Color(0.4,0.4,1,1,0,0,255)
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
          Isaac.Explode(e.Position,player,player.Damage*7)
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
      if variable[12] ~= 10 and variable[12] ~= -1 then
        e:GetSprite():Play(""..tostring(math.floor(variable[12])),false)
      end
      if variable[12] >= 10 then
        e:GetSprite():Play("Charged",false)
      end
      if variable[12] < 0 then
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
  if target.Variant == Isaac.GetEntityVariantByName("Canman") and target.Type == Isaac.GetEntityTypeByName("Canman") then
    if target:GetData().ExplosionTimer == nil then
      target:GetData().ExplosionTimer = 30
    end
  end
  if source.Type == EntityType.ENTITY_TEAR and source.Variant == Isaac.GetEntityVariantByName("Lantern Tear") then
		variable[32] = target
	end
  if target.Type == EntityType.ENTITY_PLAYER then
  if variable[39] then
		return false
	end
  variable[29] = true
  variable[30] = true
    if player:HasCollectible(Isaac.GetItemIdByName("Dad's Boots")) then
      if flag == DamageFlag.DAMAGE_SPIKES or flag == DamageFlag.DAMAGE_ACID then
        return false
      end
      for i=1, #variable[37] do
        if variable[37][i].id == source.Type and
          (variable[37][i].variant == source.Variant or variable[37][i].variant == nil) and
          (variable[37][i].subtype == source.SubType or variable[37][i].subtype == nil) then
          if PlayerIsMoving() then
            return false
          end
        end
      end
    end
    if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) then
      variable[43] = 0
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
    end
    if player:HasCollectible(Isaac.GetItemIdByName("Unholy Mantle")) then
      if variable[5] then
        local id = Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2")
        player:TryRemoveNullCostume(id)
        for k,v in pairs(Isaac.GetRoomEntities()) do
          if v:IsVulnerableEnemy() then
            v:TakeDamage(math.ceil(100*(game:GetLevel():GetAbsoluteStage()^0.7)),0,EntityRef(player),3)
          end
        end
        variable[5] = false
      end
    end
  end
end 
function Exodus:newroom()
  local room = game:GetRoom()
  local entities = Isaac.GetRoomEntities()
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
    if variable[43] <= 20 then
      counter:GetSprite():Play(""..tostring(variable[43]),false)
    else
      counter:GetSprite():Play("Limitbreak",false)
    end
  end
end
function Exodus:newfloor()
  if player:HasCollectible(Isaac.GetItemIdByName("Unholy Mantle")) then
    if variable[5] then
      player:AddBlackHearts(4)
      player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2"))
    else
      variable[5] = true
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
	elseif variable[35] then
		variable[35] = false
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Dad's Boots.anm2"))
	end
	if variable[35] == false and player:HasCollectible(Isaac.GetItemIdByName("Dad's Boots")) then
		player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/costume_Dad's Boots.anm2"))
		variable[35] = true
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
  if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) and Flag == CacheFlag.CACHE_DAMAGE and variable[43] >= 0 then
    player.Damage = player.Damage + (math.floor(((variable[43]*0.7)^0.7)*100))/150*player:GetCollectibleNum(Isaac.GetItemIdByName("Win Streak"))
  end
  if player:HasCollectible(Isaac.GetItemIdByName("The Forbidden Fruit")) and Flag == CacheFlag.CACHE_DAMAGE then
    player.Damage = player.Damage + (math.floor((variable[44]^0.7)*100))/101
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Dragon Breath")) and Flag == CacheFlag.CACHE_FIREDELAY then
    player.MaxFireDelay = player.MaxFireDelay*2-1
  end
  if player:HasCollectible(Isaac.GetItemIdByName("Wrath of the Lamb")) then
    if Flag == CacheFlag.CACHE_RANGE then
      player.TearHeight = player.TearHeight + variable[27]
    end
    if Flag == CacheFlag.CACHE_DAMAGE then
      player.Damage = player.Damage - variable[25]
    end
    if Flag == CacheFlag.CACHE_SPEED then
      player.MoveSpeed = player.MoveSpeed - variable[28]
    end
    if Flag == CacheFlag.CACHE_FIREDELAY then
      player.MaxFireDelay = player.MaxFireDelay + variable[26]
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
  if PlayerIsMoving == false then
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
        Isaac.Explode(v.Position,player,40)
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
    if Candle:GetData().IsLit then
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
      sprite:LoadGraphics()
    end
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
        Isaac.Explode(e.Position,e,40)
      end
    end
  end
end
function Exodus:UseForbFruit()
  if player:GetName() ~= "The Lost" and player:GetName() ~= "Keeper" then
    variable[44] = variable[44] + 1
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
        variable[42].Color = Color(1,1,1, 0.5, 0, 0, 0)
        variable[42]:Update()
        variable[42]:LoadGraphics()
        variable[42]:Render(game:GetRoom():WorldToScreenPosition(entities[i].Position + Vector(0, entities[i].Size)), NullVector, NullVector)
      end
    end
  end
  if variable[17] == false and variable[18] ~= nil then
    variable[18]:Remove()
    variable[18] = nil
  end
  for i = 1,#entities do
    local e = entities[i]
    if e.Type == Isaac.GetEntityTypeByName("Score Display") and e.Variant == Isaac.GetEntityVariantByName("Score Display") then
      if player:HasCollectible(Isaac.GetItemIdByName("Win Streak")) == false then
        e:Remove()
      end
      e.GridCollisionClass = GridCollisionClass.COLLISION_NONE
      e.Velocity = player.Position+Vector(0,-69+( math.sin(e.FrameCount/2)*2))-e.Position+player.Velocity
      if variable[43] ~= 10 and variable[10] > 0 then
        e:GetSprite():Play(""..tostring(variable[43]),false)
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
					if variable[32] ~= nil then
						npc:GetData().IsLatchedToEnemy = variable[32]
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
					SpawnCandleTear(npc)
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
							PlayCandleTearSprite(entity)
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
							SpawnCandleTear(entity)
						end
					end
				end
			end
		end
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) == false then
		if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT,player.ControllerIndex) then
			FireLantern(player.Position,Vector(-15,0),true)
		elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT,player.ControllerIndex) then
			FireLantern(player.Position,Vector(15,0),true)
		elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP,player.ControllerIndex) then
			FireLantern(player.Position,Vector(0,-15),true)
		elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN,player.ControllerIndex) then
			FireLantern(player.Position,Vector(0,15),true)
		end
	end
	for _,item in pairs(variable[36]) do
		if player:GetActiveItem() == item.id then
      if player:GetActiveItem() > 0 then
        variable[38]:SetFrame("BarEmpty",0)
        variable[38].Scale = Vector(1,1)
        variable[38]:Render(Vector(36,17),NullVector,NullVector)
      end
			variable[38]:SetFrame("BarFull",0)
			variable[34].Y = item.curCharge / variable[33]
			variable[38].Scale = variable[34]
			local ChargePos = Vector(36,17)
			ChargePos.Y = ChargePos.Y + 10 * (1 - variable[34].Y)
			variable[38]:Render(ChargePos,NullVector,NullVector)
		end
	end
end
function Exodus:WrathOfTheLamb(collectibleType,rng)
	local player = Isaac.GetPlayer(0)
	statdown = rng:RandomInt(4)
	if statdown == 1 then
		variable[25] = variable[25] + 0.5
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
	elseif statdown == 2 then
		variable[26] = variable[26] + 2
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	elseif statdown == 3 then
		variable[27] = variable[27] + 2.5
		player:AddCacheFlags(CacheFlag.CACHE_RANGE)
	elseif statdown == 4 then
		variable[28] = variable[28] + 0.15
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	end
	player:EvaluateItems()
	MusicManager():PitchSlide(0.5)
	for i = 0,DoorSlot.NUM_DOOR_SLOTS - 1 do
		if game:GetRoom():GetDoor(i) ~= nil then
			game:GetRoom():GetDoor(i):Bar()
		end
	end
	game:GetRoom():SetClear(false)
  local summonMark = Isaac.Spawn(Isaac.GetEntityTypeByName("Summoning Mark"),0,0,player.Position,NullVector,player)
	local sprite = summonMark:GetSprite()
	sprite:Play("Idle",false)
	variable[24] = game:GetFrameCount()
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
		if variable[29] == false then
			variable[29] = true
			variable[30] = true
			variable[31] = true
			player:AnimateCollectible(Isaac.GetItemIdByName("Ominous Lantern"),"HideItem","PlayerPickupSparkle")
		else
			variable[29] = false
			variable[30] = false
		end
	else
		FireLantern(player.Position,Vector.FromAngle(RNG:RandomInt(360)):Resized(RNG:RandomInt(10) + 3),false)
		FireLantern(player.Position,Vector.FromAngle(RNG:RandomInt(360)):Resized(RNG:RandomInt(10) + 3),false)
		return true
	end
end
function Exodus:HippoInit(e)
  e.OrbitLayer = 98
  e.Position = e:GetOrbitPosition(player.Position + player.Velocity)
  e.Visible = false
end
function Exodus:activateMitt(collectibleType)
	variable[39] = true
	variable[40] = 0
	variable[41] = game:GetFrameCount()
	player:AnimateCollectible(collectibleType,"LiftItem","PlayerPickupSparkle")
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
Exodus:AddCallback(ModCallbacks.MC_USE_CARD,Exodus.carduse)
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,Exodus.HungryHippo,Isaac.GetEntityVariantByName("Hungry Hippo"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE,Exodus.UpdateCandle,Isaac.GetEntityVariantByName("Candle"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT,Exodus.HippoInit,Isaac.GetEntityVariantByName("Hungry Hippo"))
Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT,Exodus.CandleInit,Isaac.GetEntityVariantByName("Candle"))
Exodus:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,Exodus.oninit)
Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,Exodus.cache)
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Exodus.DetectDMG)
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,Exodus.NewEntDamage,901)