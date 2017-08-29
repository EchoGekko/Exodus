--<<<DEFECATION>>>--
    DEFECATION = Isaac.GetItemIdByName("Defecation"),
            DEFECATION = { HasDefecation = false },

function Exodus:defecationUpdate()
    local player = Isaac.GetPlayer(0)
    
	if player:HasCollectible(ItemId.DEFECATION) and not ItemVariables.DEFECATION.HasDefecation then
		ItemVariables.DEFECATION.HasDefecation = true
        
		if player:GetPlayerType() == PlayerType.PLAYER_THELOST then
			player:AddNullCostume(CostumeId.OWW_WHITE)
		elseif player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_APOLLYON then
			player:AddNullCostume(CostumeId.OWW_GRAY)
		elseif player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS then
			player:AddNullCostume(CostumeId.OWW_BLACK)
		elseif player:GetPlayerType() == PlayerType.PLAYER_XXX then
			player:AddNullCostume(CostumeId.OWW_BLUE)
		elseif player:GetPlayerType() == PlayerType.PLAYER_AZAZEL then
			player:AddNullCostume(CostumeId.OWW_BLACK_RED_EYES)
		else
			player:AddNullCostume(CostumeId.OWW)
		end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
			if entity:ToTear() then
                local data = entity:GetData()
				entity = entity:ToTear()
                
				if data.HasReversed == nil then
					entity.Velocity = entity.Velocity * -1
					entity.Position = entity.Position + entity.Velocity
                    data.HasReversed = true
				end
			end
		end
	end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.defecationUpdate)

function Exodus:defecationCache(player, flag)
    if flag == CacheFlag.CACHE_FIREDELAY then
        if player:HasCollectible(ItemId.DEFECATION) then
            player.MaxFireDelay = player.MaxFireDelay + 12
        end
    end
    if flag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(ItemId.DEFECATION) then
            player.Damage = player.Damage + 5
        end
    end
    if flag == CacheFlag.CACHE_RANGE then
        if player:HasCollectible(ItemId.DEFECATION) then
            player.TearHeight = player.TearHeight + 12
        end
    end
    if flag == CacheFlag.CACHE_TEARCOLOR then
        if player:HasCollectible(ItemId.DEFECATION) then
            player.TearColor = Color(0.545, 0.27, 0.075, 1, 0, 0, 0)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.defecationCache)

--<<<BEENADES>>>--
    BEENADES = Isaac.GetItemIdByName("Beenades"),
    BEENADES = Isaac.GetCostumeIdByPath("gfx/characters/costume_Beenades.anm2"),
            BEENADES = { HasBeenades = false },

function Exodus:beenadesUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.BEENADES) then
        if ItemVariables.BEENADES.HasBeenades == false then
          player:AddNullCostume(CostumeId.BEENADES)
          ItemVariables.BEENADES.HasBeenades = true
        end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            local sprite = entity:GetSprite()
            
            if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.ROCKET and entity:IsDead() and player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
                if not string.find(sprite:GetFilename(), "gfx/effects/bee") then
                    sprite:ReplaceSpritesheet(0, "gfx/effects/effect_035_beemissile.png")
                    sprite:LoadGraphics()
                end
                
                Exodus:FireXHoney(15, entity)
            end
            
            if entity.Type == EntityType.ENTITY_BOMBDROP and (entity.SpawnerType == EntityType.ENTITY_PLAYER or entity.SpawnerType == EntityType.ENTITY_BOMBDROP) then
                if string.find(sprite:GetFilename(), "gfx/004") then
                    sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/pickup_016_beebomb.png")
                    sprite:LoadGraphics()
                end
                
                if entity:IsDead() then
                    entity:Remove()
                    Exodus:FireXHoney(15, entity)
                end
            end
            
            if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == Entities.HONEY_POOF.variant and sprite:IsFinished("Poof") then
                entity:Remove()
            end
            
            if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == Entities.HONEY_POOF.variant then
                entity.SpriteRotation = entity.Velocity:GetAngleDegrees()
                
                if entity:CollidesWithGrid() or entity.FrameCount > 15 then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, Entities.HONEY_POOF.variant, 0, entity.Position, NullVector, entity)
                    
                    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, entity.Position, NullVector, player):ToEffect()
                    creep:SetTimeout(200)
                    creep:SetColor(Color(0, 0, 0, 1, math.random(200,250), math.random(150,200), math.random(0,10)), -1, 1, false, false)
                    creep:GetData().IsHoneyCreep = true
                    entity:Remove()
                    
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
                        creep.Velocity = entity.Velocity * 100
                    end
                    
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
                        local brim = player:FireBrimstone(RandomVector())
                        brim.Position = entity.Position
                        brim.DisableFollowParent = true
                    end
                    
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
                        local tech = player:FireTechLaser(entity.Position, 0, RandomVector(), false, false)
                        tech.DisableFollowParent = true
                    end
                end
            end
        
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD) and entity.Type == EntityType.ENTITY_TEAR and entity.Variant == EntityType.ENTITY_BOMBDROP and entity:IsDead() then
                Exodus:FireXHoney(15, entity)
            end
            
            if entity:GetData().IsHoneyCreep and entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.PLAYER_CREEP_BLACK then
                for u, enemy in pairs(Isaac.GetRoomEntities()) do
                    if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false) and not enemy:IsFlying() then
                        if enemy:HasEntityFlags(EntityFlag.FLAG_SLOW) then
                            enemy:GetSprite():Stop()
                            enemy.Velocity = NullVector
                            enemy.Friction = enemy.Friction / 2
                        end
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.beenadesUpdate)

--<<<CANMAN>>>--
function Exodus:canmanTakeDamage(target, amount, flags, source, cdtimer)
    if target.Variant == Entities.CANMAN.variant then
        local data = target:GetData()
        
        if data.ExplosionTimer == nil then
            data.ExplosionTimer = 30
        end
    end
end
  
Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.canmanTakeDamage, Entities.CANMAN.id)

function Exodus:canmanEntityUpdate(can)
    if can.Variant == Entities.CANMAN.variant then
        local sprite = can:GetSprite()
        local data = can:GetData()
        local player = Isaac.GetPlayer(0)
        
        if not sprite:IsPlaying("Idle") or can.FrameCount == 1 then
          sprite:Play("Idle",true)
        end
        
        if not can:HasEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) then
            can:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
        end
        
        if not can:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
            can:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end
        
        if not can:HasEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH) then
            can:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
        end
        
        if (player.Position:DistanceSquared(can.Position) < 70^2 or math.random(200) == 1 and can.FrameCount > 200) and data.ExplosionTimer == nil then
            data.ExplosionTimer = 30
        end
        
        if data.ExplosionTimer ~= nil then
            can.Color = Color(1, 1, 1, 1, math.abs(math.ceil(math.sin(data.ExplosionTimer / 2) * 100)), 0, 0)
            
            if data.ExplosionTimer > 0 then
                data.ExplosionTimer = data.ExplosionTimer - 1
            else
                can:Die()
            end
        end
        
        if can:IsDead() then
            Isaac.Explode(can.Position, can, 60)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.canmanEntityUpdate, Entities.CANMAN.id)

--<<<SPOOK>>>--
function Exodus:spookEntityUpdate(spook)
    if spook.Variant == Entities.SPOOK.variant then
        local sprite = spook:GetSprite()
        local data = spook:GetData()
        local player = Isaac.GetPlayer(0)
        local target = spook:GetPlayerTarget()
        
        local angle = (target.Position - spook.Position):GetAngleDegrees()
        
        if spook:IsDead() then
            for i = 1, math.random(10, 20) do
                local ectoexplosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, spook.Position, Vector(math.random(-5, 5), math.random(-5, 5)), player):GetSprite()
                ectoexplosion.Color = Color(1, 1, 1, 0.4, 50, 128, 128)
                ectoexplosion.Scale = ectoexplosion.Scale * 0.5
                ectoexplosion.Rotation = math.random(1, 3600) / 10
                ectoexplosion:Update()
            end
        end
        
        if spook.State ~= 4 then
            data.State4Frame = 0
        end
        
        if spook.FrameCount <= 1 then
            spook.State = 2
            data.State0Frame = 0
            data.State3Countdown = 0
        end
        
        if spook.State == 2 then
            sprite:Play("Appear",false)
            
            if sprite:IsFinished("Appear") then
                spook.State = 0
            end
        elseif spook.State == 0 then
            if data.State0Frame then
                data.State0Frame = data.State0Frame + 1
                
                if (data.State0Frame % 30 or data.State0Frame == 0) and data.State0Frame <= 90 then
                    spook:AddVelocity((target.Position - spook.Position):Normalized() * 0.2)
                elseif data.State0Frame > 90 then
                    spook.Velocity = (target.Position - spook.Position):Normalized() * 3
                
                    if player:GetHeadDirection() == Direction.LEFT or player:GetMovementDirection() == Direction.LEFT then
                        if spook.Position.X < player.Position.X and math.abs(player.Position.Y - spook.Position.Y) < 40 then
                            spook.State = 3
                            data.State0Frame = 0
                            data.State3Countdown = 60
                        end
                    elseif player:GetHeadDirection() == Direction.RIGHT or player:GetMovementDirection() == Direction.RIGHT then
                        if spook.Position.X > player.Position.X and math.abs(player.Position.Y - spook.Position.Y) < 40 then
                            spook.State = 3
                            data.State0Frame = 0
                            data.State3Countdown = 60
                        end
                    elseif player:GetHeadDirection() == Direction.UP or player:GetMovementDirection() == Direction.UP then
                        if spook.Position.Y < player.Position.Y and math.abs(player.Position.X - spook.Position.X) < 40 then
                            spook.State = 3
                            data.State0Frame = 0
                            data.State3Countdown = 60
                        end
                    elseif (player:GetHeadDirection() == Direction.DOWN or player:GetMovementDirection() == Direction.DOWN) or player:GetHeadDirection() == Direction.NO_DIRECTION then
                        if spook.Position.Y > player.Position.Y and math.abs(player.Position.X - spook.Position.X) < 40 then
                            spook.State = 3
                            data.State0Frame = 0
                            data.State3Countdown = 60
                        end
                    end
                end
            else
                data.State0Frame = 0
            end
            
            spook:AnimWalkFrame("Float", "Float", 0.1)
            
            
        elseif spook.State == 3 then
            spook:AnimWalkFrame("FloatHide", "FloatHide", 0.1)
            spook.Velocity = (spook.Position - player.Position):Resized(1)
            data.State3Countdown = data.State3Countdown - 1
            
            if data.State3Countdown <= 0 then
                spook.State = 4
                data.State0Frame = 0
                data.State3Countdown = 60
            end
            
            if player:GetHeadDirection() == Direction.LEFT or player:GetMovementDirection() == Direction.LEFT then
                if spook.Position.X < player.Position.X and math.abs(player.Position.Y - spook.Position.Y) < 40 then
                    data.State3Countdown = 60
                end
            elseif player:GetHeadDirection() == Direction.RIGHT or player:GetMovementDirection() == Direction.RIGHT then
                if spook.Position.X > player.Position.X and math.abs(player.Position.Y - spook.Position.Y) < 40 then
                    data.State3Countdown = 60
                end
            elseif player:GetHeadDirection() == Direction.UP or player:GetMovementDirection() == Direction.UP then
                if spook.Position.Y < player.Position.Y and math.abs(player.Position.X - spook.Position.X) < 40 then
                    data.State3Countdown = 60
                end
            elseif (player:GetHeadDirection() == Direction.DOWN or player:GetMovementDirection() == Direction.DOWN) or player:GetHeadDirection() == Direction.NO_DIRECTION then
                if spook.Position.Y > player.Position.Y and math.abs(player.Position.X - spook.Position.X) < 40 then
                    data.State3Countdown = 60
                end
            end
        elseif spook.State == 4 then
            data.State4Frame = data.State4Frame + 1
            
            if data.State4Frame < 31 or data.State4Frame > 63 then
                spook.Velocity = (target.Position - spook.Position):Normalized() * 3
                spook:AnimWalkFrame("Float", "Float", 0.1)
            end
            
            if data.State4Frame % 10 == 0 and data.State4Frame <= 30 then
                local offset = Vector(0, 28)
                
                if sprite.FlipX then
                offset = Vector(-15, 28)
                else
                  offset = Vector(15, 28)
                end
                
                sprite:Play("Shoot", false)
                
                local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, spook.Position + offset, Vector.FromAngle(1 * angle):Resized(10), spook)
                local shotSprite = shot:GetSprite()
                local color = shotSprite.Color
                shotSprite.Color = Color(color.R, color.G, color.B, 0.5, 0, 0, 0)
                shotSprite:ReplaceSpritesheet(0,"gfx/Ghost Tear.png")
                shotSprite:LoadGraphics()
                shot.SplatColor = Color(0, 1, 1, 0.5, 0, 0, 0)
                shot.GridCollisionClass = GridCollisionClass.COLLISION_NONE
                sfx:Play(SoundEffect.SOUND_LITTLE_SPIT, 1, 0, false, 0.8)
            end
            
            if data.State4Frame >= 31 and data.State4Frame < 60 then
                if data.State4Frame == 31 then
                    spook.Velocity = NullVector
                    sprite:Play("Disappear", false)
                end
                
                if sprite:IsFinished("Disappear") then
                    sprite:Play("Appear", false)
                    spook.Position = game:GetRoom():GetRandomPosition(1)
                    spook.CollisionDamage = 0
                end
            end
            
            if data.State4Frame > 70 or data.State4Frame == 0 then
                spook.CollisionDamage = 1
            end
            
            if data.State4Frame > 80 then
                if player:GetHeadDirection() == Direction.LEFT or player:GetMovementDirection() == Direction.LEFT then
                    if spook.Position.X < player.Position.X and math.abs(player.Position.Y - spook.Position.Y) < 40 then
                        spook.State = 3
                        data.State0Frame = 0
                        data.State3Countdown = 60
                    end
                elseif player:GetHeadDirection() == Direction.RIGHT or player:GetMovementDirection() == Direction.RIGHT then
                    if spook.Position.X > player.Position.X and math.abs(player.Position.Y - spook.Position.Y) < 40 then
                        spook.State = 3
                        data.State0Frame = 0
                        data.State3Countdown = 60
                    end
                elseif player:GetHeadDirection() == Direction.UP or player:GetMovementDirection() == Direction.UP then
                    if spook.Position.Y < player.Position.Y and math.abs(player.Position.X - spook.Position.X) < 40 then
                        spook.State = 3
                        data.State0Frame = 0
                        data.State3Countdown = 60
                    end
                elseif (player:GetHeadDirection() == Direction.DOWN or player:GetMovementDirection() == Direction.DOWN) or player:GetHeadDirection() == Direction.NO_DIRECTION then
                    if spook.Position.Y > player.Position.Y and math.abs(player.Position.X - spook.Position.X) < 40 then
                        spook.State = 3
                        data.State0Frame = 0
                        data.State3Countdown = 60
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.spookEntityUpdate, Entities.SPOOK.id)

--<<<GRIDSIES>>>--
function Exodus:gridsieEntityUpdate(entity)
    if entity.Variant == Entities.GRIDSIE.variant or entity.Variant == Entities.BOMB_GRIDSIE.variant or entity.Variant == Entities.POLYP_GRIDSIE.variant then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local target = entity:GetPlayerTarget()
        local player = Isaac.GetPlayer(0)
    
        if entity:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
        
        if not entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
            entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end
        
        if entity:IsDead() then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, NullVector, entity)
            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
        end
        
        if (player:HasCollectible(CollectibleType.COLLECTIBLE_LEO) or player:HasCollectible(CollectibleType.COLLECTIBLE_THUNDER_THIGHS)) and entity.Position:DistanceSquared(player.Position) < 30^2 then
            entity:Die()
        end
        
        if sprite:IsFinished("Appear") then
            entity.CollisionDamage = 0
            entity.Velocity = NullVector
            entity.Friction = entity.Friction / 2
            
            if (entity.FrameCount > 130 and entity.Position:DistanceSquared(player.Position) < 100^2) or entity.HitPoints <= entity.MaxHitPoints / 2 then
                sprite:Play("Stand",true)
            end
        end
        
        if sprite:IsFinished("Stand") or sprite:IsPlaying("WalkVert") or sprite:IsPlaying("WalkHori") then
            if entity.Friction ~= 1 then 
                entity.Friction = 1 
            end
            
            if entity.CollisionDamage ~= 1 then 
                entity.CollisionDamage = 1 
            end
                    
            if data.GridCountdown == nil then 
                data.GridCountdown = 0 
            end
                        
            if entity.Velocity:GetAngleDegrees() >= 45 and entity.Velocity:GetAngleDegrees() <= 135 then
                sprite:Play("WalkVert",false)
            else
                sprite:Play("WalkHori",false)
            end
            
            if entity.Position.X < player.Position.X then
                sprite.FlipX = false
            else
                sprite.FlipX = true
            end
            
            if entity:CollidesWithGrid() or data.GridCountdown > 0 then
                if entity.Variant == Entities.POLYP_GRIDSIE.variant then
                    entity.Pathfinder:FindGridPath(player.Position, 0.8, 1, false)
                else
                    entity.Pathfinder:FindGridPath(player.Position, 0.5, 1, false)
                end
                
                if data.GridCountdown <= 0 then
                    data.GridCountdown = 30
                else
                    data.GridCountdown = data.GridCountdown - 1
                end
            else
                if entity.Variant == Entities.POLYP_GRIDSIE.variant then
                    entity.Velocity = (player.Position - entity.Position):Resized(5)
                else
                    entity.Velocity = (player.Position - entity.Position):Resized(3.5)
                end
            end
            
            if entity.Variant == Entities.BOMB_GRIDSIE.variant and entity.Position:DistanceSquared(player.Position) <= 30^2 then
                entity:Die()
            end
        end
        
        if entity.Variant == Entities.GRIDSIE.variant then
            if data.HasStateChange ~= true then
                if math.random(20) == 1 then
                    entity:Remove()
                    Isaac.Spawn(Entities.BOMB_GRIDSIE.id, Entities.BOMB_GRISIDE.variant, 0, entity.Position, NullVector, entity)
                else
                    local rand = math.random(3)
                    sprite:ReplaceSpritesheet(1, "gfx/monsters/Gridsie " .. rand .. ".png")
                    sprite:LoadGraphics()
                end
                
                entity:GetData().HasStateChange = true
            end
        elseif entity.Variant == Entities.POLYP_GRIDSIE.variant then
            if entity.FrameCount == 1 then
                local rand = math.random(2)
                
                if rand == 1 then
                    sprite:ReplaceSpritesheet(1, "gfx/monsters/Gridsie Polyp.png")
                    sprite:LoadGraphics()
                elseif rand == 2 then
                    sprite:ReplaceSpritesheet(1, "gfx/monsters/Gridsie Polyp 2.png")
                    sprite:LoadGraphics()
                end
            end
            
            if entity:IsDead() then
                for i = 1, 8 do
                    Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.BLOOD, 0, entity.Position, Vector.FromAngle(i * 45):Resized(9), entity)
                end
            end
        elseif entity.Variant == Entities.BOMB_GRIDSIE.variant then
            if entity.FrameCount == 1 then
                sprite:ReplaceSpritesheet(1, "gfx/monsters/Bomb Gridsie.png")
                sprite:LoadGraphics()
            end
            
            if entity:IsDead() then
                Isaac.Explode(entity.Position, entity, 60)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.gridsieEntityUpdate, Entities.GRIDSIE.id)

--<<<HUSHED HORF>>>--
function Exodus:hushedHorfUpdate()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        
        if data.IsFromHushedHorfTear then
            local degress = 0
            
            if entity.Position.X < player.Position.X and not player:IsDead() then
                degress = rng:RandomInt(3) + 6
            else
                degress = (rng:RandomInt(3) + 6) * -1
            end
            
            entity.Velocity = entity.Velocity:Rotated(degress):Resized(1.5 * (math.sqrt(player.Position:Distance(entity.Position) / 10))) + (player.Position - entity.Position):Resized(0.5)
            
            if entity.FrameCount > 10 then
                entity:Remove()
                
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.HUSH, 0, entity.Position + Vector(0, 6), entity.Velocity, entity)
                tear:GetData().IsFromHushedHorfTear = true
                tear.Color = Color(0.83529411764, 0.7294117647, 0, 1, 0, 0, 0)
            end
        end
        
        if entity.Type == EntityType.ENTITY_PROJECTILE and entity.Variant == 0 and entity.SpawnerType == EntityType.ENTITY_HORF and entity.SpawnerVariant == Entities.HUSHED_HORF.variant then
            entity:Remove()
            
            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.HUSH, 0, entity.Position, entity.Velocity, entity)
            tear:GetData().IsFromHushedHorfTear = true
            tear.Color = Color(0.83529411764, 0.7294117647, 0, 1, 0, 0, 0)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.hushedHorfUpdate)

--<<<BOTH SILENT ENEMIES>>>--
function Exodus:silentEnemiesUpdate()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        
        if entity.SpawnerType == Entities.SILENT_FATTY.id and entity.SpawnerVariant == Entities.SILENT_FATTY.variant and entity.Type == EntityType.ENTITY_PROJECTILE and entity.Variant == 0 then
            entity:Remove()
            
            for u = 1, 8 do
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.HUSH, 0, entity.Position, entity.Velocity:Rotated(i * 45):Resized(6), entity)
                tear.SpawnerType = Entities.SILENT_FATTY.id
            end
        end
        
        if entity.Type == EntityType.ENTITY_PROJECTILE and entity.Variant == 6 then
            if entity.SpawnerType == Entities.SILENT_FATTY.id then
                entity.Velocity = (player.Position - entity.Position) / 50 + (entity.Velocity * 0.8)
                
                if entity.FrameCount % 100 == 0 then
                    entity:Die()
                elseif entity.FrameCount > 10 then
                    entity:Remove()
                    
                    local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.HUSH, 0, entity.Position, RandomVector() * 10, entity.Parent)
                    tear.SpawnerType = Entities.SILENT_FATTY.id
                end
            end
        end
        
        if entity.SpawnerType == Entities.SILENT_HOST.id and entity.SpawnerVariant == Entities.SILENT_HOST.variant and entity.Type == EntityType.ENTITY_PROJECTILE then
            if entity.Variant == 6 then
                entity.Velocity = entity.Velocity:Rotated(15):Resized(entity.FrameCount)
            else
                entity:Remove()
                
                for i = 1, 4 do
                    local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.HUSH, 0, entity.Position, entity.Velocity:Rotated(i * 90):Resized(10), entity)
                    tear.SpawnerType = Entities.SILENT_HOST.id
                    tear.SpawnerVariant = Entities.SILENT_HOST.variant
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.silentEnemiesUpdate)