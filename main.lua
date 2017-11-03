local Exodus = RegisterMod("Exodus", 1)
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()
local itemPool = game:GetItemPool()
local NullVector = Vector(0, 0)

--<<<VARIABLE DECLARATION>>>--
local ProjectileVariant = {
    BLOOD = 0,
    BONE = 1,
    FIRE = 2,
    PUKE = 3,
    TEAR = 4,
    CORN = 5,
    HUSH = 6,
    COIN = 7
}

local ItemId = {
    ---<<PASSIVES>>---
    BEEHIVE = Isaac.GetItemIdByName("Beehive"),
    SAD_TEARS = Isaac.GetItemIdByName("Sad Tears"),
    BUSTED_PIPE = Isaac.GetItemIdByName("Busted Pipe"),
    UNHOLY_MANTLE = Isaac.GetItemIdByName("Unholy Mantle"),
    TECH_360 = Isaac.GetItemIdByName("Tech 360"),
    PAPER_CUT = Isaac.GetItemIdByName("Paper Cut"),
    FORGET_ME_LATER = Isaac.GetItemIdByName("Forget Me Later"),
    DRAGON_BREATH = Isaac.GetItemIdByName("Dragon Breath"),
    COBALT_NECKLACE = Isaac.GetItemIdByName("Cobalt Necklace"),
    PIG_BLOOD = Isaac.GetItemIdByName("Pig Blood"),
    DADS_BOOTS = Isaac.GetItemIdByName("Dad's Boots"),
    MYSTERIOUS_MUSTACHE = Isaac.GetItemIdByName("Mysterious Mustache"),
    CURSED_METRONOME = Isaac.GetItemIdByName("Cursed Metronome"),
    BIG_SCISSORS = Isaac.GetItemIdByName("Big Scissors"),
    WELCOME_MAT = Isaac.GetItemIdByName("Welcome Mat"),
    GLUTTONYS_STOMACH = Isaac.GetItemIdByName("Gluttony's Stomach"),
    POSSESSED_BOMBS = Isaac.GetItemIdByName("Possessed Bombs"),
    BUTTROT = Isaac.GetItemIdByName("Buttrot"),
    SLING = Isaac.GetItemIdByName("Sling"),
    YIN = Isaac.GetItemIdByName("Yin"),
    YANG = Isaac.GetItemIdByName("Yang"),
    DEJA_VU = Isaac.GetItemIdByName("Deja Vu"),
    FOOLS_GOLD = Isaac.GetItemIdByName("Fool's Gold"),
    MAKEUP_REMOVER = Isaac.GetItemIdByName("Makeup Remover"),
    ARCADE_TOKEN = Isaac.GetItemIdByName("Arcade Token"),
    HAND_OF_GREED = Isaac.GetItemIdByName("Hand of Greed"),
    CLOCK_PIECE_1 = Isaac.GetItemIdByName("Clock Piece 1"),
    CLOCK_PIECE_2 = Isaac.GetItemIdByName("Clock Piece 2"),
    CLOCK_PIECE_3 = Isaac.GetItemIdByName("Clock Piece 3"),
    CLOCK_PIECE_4 = Isaac.GetItemIdByName("Clock Piece 4"),
    
    ---<<ACTIVES>>---
    FORBIDDEN_FRUIT = Isaac.GetItemIdByName("The Forbidden Fruit"),
    WRATH_OF_THE_LAMB = Isaac.GetItemIdByName("Wrath of the Lamb"),
    BIRDBATH = Isaac.GetItemIdByName("Birdbath"),
    OMINOUS_LANTERN = Isaac.GetItemIdByName("Ominous Lantern"),
    BASEBALL_MITT = Isaac.GetItemIdByName("Baseball Mitt"),
    PSEUDOBULBAR_AFFECT = Isaac.GetItemIdByName("The Pseudobulbar Affect"),
    MUTANT_CLOVER = Isaac.GetItemIdByName("Mutant Clover"),
    TRAGIC_MUSHROOM = Isaac.GetItemIdByName("Tragic Mushroom"),
    ANAMNESIS = Isaac.GetItemIdByName("Anamnesis"),
    HURDLE_HEELS = Isaac.GetItemIdByName("Hurdle Heels"),
    
    ---<<FAMILIARS>>---
    HUNGRY_HIPPO = Isaac.GetItemIdByName("Hungry Hippo"),
    RITUAL_CANDLE = Isaac.GetItemIdByName("Ritual Candle"),
    ASTRO_BABY = Isaac.GetItemIdByName("Astro Baby"),
    LIL_RUNE = Isaac.GetItemIdByName("Lil Rune"),
    SUNDIAL = Isaac.GetItemIdByName("Sundial"),
    
    ---<<TRINKETS>>---
    GRID_WORM = Isaac.GetTrinketIdByName("Grid Worm"),
    BURLAP_SACK = Isaac.GetTrinketIdByName("Burlap Sack"),
    PET_ROCK = Isaac.GetTrinketIdByName("Pet Rock"),
    ROTTEN_PENNY = Isaac.GetTrinketIdByName("Rotten Penny"),
    PURPLE_MOON = Isaac.GetTrinketIdByName("Purple Moon"),
    BROKEN_GLASSES = Isaac.GetTrinketIdByName("Broken Glasses"),
    BOMBS_SOUL = Isaac.GetTrinketIdByName("Bomb's Soul"),
    CLAUSTROPHOBIA = Isaac.GetTrinketIdByName("Claustrophobia"),
    FLYDER = Isaac.GetTrinketIdByName("Flyder")
}

local function getEntity(stringName, intSubtype)
    if intSubtype == nil then 
        intSubtype = 0 
    end
    
    return { id = Isaac.GetEntityTypeByName(stringName), variant = Isaac.GetEntityVariantByName(stringName), subtype = intSubtype, name = stringName }
end

local Entities = {
    ---<<EFFECTS>>---
    HONEY_SPLAT = getEntity("Honey Splat"),
    HONEY_POOF = getEntity("Honey Poof"),
    SCORE_DISPLAY = getEntity("Score Display"),
    CHARGE_BAR = getEntity("Charge Bar"),
    PENTAGRAM = getEntity("Pentagram"),
    SUMMONING_MARK = getEntity("Summoning Mark"),
    LANTERN_GIBS = getEntity("Lantern Gibs"),
    LANTERN_FIRE = getEntity("Lantern Fire"),
    PORTAL_DOOR = getEntity("Portal Door"),
    BASEBALL_HIT = getEntity("Baseball Hit"),
    IRON_LUNG_GAS = getEntity("Iron Lung Gas"),
    OCCULTIST_TEAR_MARKER = getEntity("Occultist Tear Marker"),
    PART_UP = getEntity("Part Up"),
    PART_UP_UP = getEntity("Part Up Up"),
    PART_UP_UP_UP = getEntity("Part Up Up Up"),
    PIT_GIBS = getEntity("Pit Gibs"),
    BLIGHT_SPLASH = getEntity("Blight Splash"),
    BLIGHT_STATUS_EFFECT = getEntity("Blight Status Effect"),
    HURDLE_JUMP = getEntity("Hurdle Jump"),
    
    ---<<FAMILIARS>>---
    HUNGRY_HIPPO = getEntity("Hungry Hippo"),
    CANDLE = getEntity("Candle"),
    ASTRO_BABY = getEntity("Astro Baby"),
    LIL_RUNE = getEntity("Lil Rune"),
    SUN = getEntity("Sundial Sun"),
    SHADOW = getEntity("Sundial Shadow"),
    
    ---<<ENEMIES>>---
    POISON_MASTERMIND = getEntity("Poison Mastermind"),
    POISON_HEMISPHERE = getEntity("Poison Hemisphere"),
    DANK_DIP = getEntity("Dank Dip"),
    DROWNED_SHROOMMAN = getEntity("Drowned Mushroom"),
    SCARY_SHROOMMAN = getEntity("Scary Shroomman"),
    BLOCKAGE = getEntity("Blockage"),
    CLOSTER = getEntity("Closter"),
    FLYERBALL = getEntity("Flyerball"),
    IRON_LUNG = getEntity("Iron Lung"),
    OCCULTIST = getEntity("Occultist"),
    HALFBLIND = getEntity("Halfblind"),
    HEADCASE = getEntity("Headcase"),
    HOLLOWHEAD = getEntity("Hollowhead"),
    WOMBSHROOM = getEntity("Wombshroom"),
    CARRION_PRINCE = getEntity("Carrion Prince"),
    LITHOPEDION = getEntity("Lithopedion"),
    DEATHS_EYE = getEntity("Death's Eye"),
    FLESH_DEATHS_EYE = getEntity("Flesh Death's Eye"),
    LOVELY_FLY = getEntity("Lovely Fly"),
    SOULFUL_FLY = getEntity("Soulful Fly"),
    HATEFUL_FLY = getEntity("Hateful Fly"),
    HATEFUL_FLY_GHOST = getEntity("Hateful Fly Ghost"),
    HOTHEAD = getEntity("Hothead"),
    WINGLEADER = getEntity("Wingleader"),
    BROOD = getEntity("Brood"),
    PATRIARCH = getEntity("Patriarch"),
    
    ---<<OTHERS>>---
    BIRDBATH = getEntity("Birdbath"),
    LANTERN_TEAR = getEntity("Lantern Tear"),
    BASEBALL = getEntity("Baseball"),
    SCARED_HEART = getEntity("Exodus Scared Heart", 653),
    WELCOME_MAT = getEntity("Welcome Mat"),
    KEYHOLE = getEntity("Keyhole"),
    CLOCK_KEEPER = getEntity("Clock Keeper"),
    FIREBALL = getEntity("Fireball"),
    FIREBALL_2 = getEntity("Fireball 2"),
    BLIGHT_TEAR = getEntity("Blight Tear")
}

for i, entity in pairs(Entities) do
    if entity.id == -1 then
        error("Could not find a type for entity " .. entity.name, 1)
    elseif entity.variant == -1 then
        error("Could not find a variant for entity " .. entity.name, 1)
    end
end

local CostumeId = {
    BEEHIVE = Isaac.GetCostumeIdByPath("gfx/characters/costume_Beehive.anm2"),
    SAD_TEARS = Isaac.GetCostumeIdByPath("gfx/characters/costume_Sad Tears.anm2"),
    BUSTED_PIPE = Isaac.GetCostumeIdByPath("gfx/characters/costume_Busted Pipe.anm2"),
    UNHOLY_MANTLE = Isaac.GetCostumeIdByPath("gfx/characters/costume_Unholy Mantle.anm2"),
    TECH_360 = Isaac.GetCostumeIdByPath("gfx/characters/costume_TechY.anm2"),
    PAPER_CUT = Isaac.GetCostumeIdByPath("gfx/characters/costume_Paper Cut.anm2"),
    DRAGON_BREATH = Isaac.GetCostumeIdByPath("gfx/characters/costume_Dragon Breath.anm2"),
    PIG_BLOOD = Isaac.GetCostumeIdByPath("gfx/characters/costume_Pig Blood.anm2"),
    DADS_BOOTS = Isaac.GetCostumeIdByPath("gfx/characters/costume_Dad's Boots.anm2"),
    CURSED_METRONOME = Isaac.GetCostumeIdByPath("gfx/characters/costume_Cursed Metronome.anm2"),
    MYSTERIOUS_MUSTACHE = Isaac.GetCostumeIdByPath("gfx/characters/costume_Mysterious Mustache.anm2"),
    POSSESSED_BOMBS = Isaac.GetCostumeIdByPath("gfx/characters/costume_Possessed Bombs.anm2"),
    BUTTROT = Isaac.GetCostumeIdByPath("gfx/characters/costume_Buttrot.anm2"),
    KEEPER_HAND_OF_GREED = Isaac.GetCostumeIdByPath("gfx/characters/costume_Keeper Hand of Greed.anm2"),
    HAND_OF_GREED = Isaac.GetCostumeIdByPath("gfx/characters/costume_Hand of Greed.anm2"),
    MAKEUP_REMOVER = Isaac.GetCostumeIdByPath("gfx/characters/costume_MakeupRemover.anm2"),
    MAKEUP_REMOVER_BLACK = Isaac.GetCostumeIdByPath("gfx/characters/costume_MakeupRemover_black.anm2"),
    MAKEUP_REMOVER_BLUE = Isaac.GetCostumeIdByPath("gfx/characters/costume_MakeupRemover_blue.anm2"),
    MAKEUP_REMOVER_GRAY = Isaac.GetCostumeIdByPath("gfx/characters/costume_MakeupRemover_grey.anm2"),
    MAKEUP_REMOVER_WHITE = Isaac.GetCostumeIdByPath("gfx/characters/costume_MakeupRemover_white.anm2")
}

local MusicId = {
    LOCUS = Isaac.GetMusicIdByName("Locus"),
    TYRANNICIDE = Isaac.GetMusicIdByName("Tyrannicide")
}

SoundEffect.SOUND_SUPER_JUMP = Isaac.GetSoundIdByName("Super Jump")

local ItemVariables = {}
local EntityVariables = {}
local GameState = {}
local json = require("json")

function Exodus:newGame(fromSave)
    if not fromSave then
        ItemVariables = {
            ---<<PASSIVES>>---
            BEEHIVE = { HasBeehive = false, ColourIsBlack = false },
            SAD_TEARS = { HasSadTears = false },
            BUSTED_PIPE = { HasBustedPipe = false },
            UNHOLY_MANTLE = { HasUnholyMantle = false, HasEffect = true },
            TECH_360 = { HasTech360 = false },
            PAPER_CUT = { HasPaperCut = false },
            FORGET_ME_LATER = { HasForgetMeLater = false, NumberFloors = 0 },
            DRAGON_BREATH = { HasDragonBreath = false, Charge = 0, ChargeDirection = NullVector },
            RITUAL_CANDLE = { LitCandles = 0, HasBonus = false, Pentagram = nil, SoundPlayed = false },
            PIG_BLOOD = { HasPigBlood = false },
            COBALT_NECKLACE = { HasCobaltNecklace = false, Count = 0, IsRoomClear = true, Counter = nil  },
            BIG_SCISSORS = { Triggered = false },
            CURSED_METRONOME = { HasCursedMetronome = false },
            MYSTERIOUS_MUSTACHE = { HasMysteriousMustache = false, ItemCount = 0, CoinCount = 0 },
            WELCOME_MAT = { HasWelcomeMat = false, Position = NullVector, Direction = 0, CloseToMat = false, Placed = true, AppearFrame = nil },
            GLUTTONYS_STOMACH = { Parts = 0, RenderBar = Sprite() },
            ASTRO_BABY = { UsedBox = 0 },
            LIL_RUNE = { UsedBox = 0, State = "Purple", RuneType = 0 },
            POSSESSED_BOMBS = { HasPossessedBombs = false },
            MOLDY_BREAD = { GotFlies = false },
            BUTTROT = { HasButtrot = false },
            CLAUSTROPHOBIA = { Triggered = false },
            ROTTEN_PENNY = { HasQuarter = false, HasDollar = false },
            SLING = { Icon = Sprite() },
            HOLY_WATER = { Splashed = false },
            FOOLS_GOLD = { HasFoolsGold = false },
            ARCADE_TOKEN = { HasArcadeToken = false },
            MAKEUP_REMOVER = { HasMakeupRemover = false },
            HAND_OF_GREED = { RedHearts = 3, SoulHearts = 0, ActiveItem = 0, HasGreedHand = false },
            DADS_BOOTS = { HasDadsBoots = false,
                Squishables = {
                    { id = EntityType.ENTITY_MAGGOT }, --ID 21
                    { id = EntityType.ENTITY_CHARGER }, --ID 23
                    { id = EntityType.ENTITY_BOIL }, --ID 30
                    { id = EntityType.ENTITY_SPITY }, --ID 31
                    { id = EntityType.ENTITY_BRAIN }, --ID 32
                    { id = EntityType.ENTITY_LUMP }, --ID 56
                    { id = EntityType.ENTITY_PARA_BITE }, --ID 58
                    { id = EntityType.ENTITY_EMBRYO }, --ID 77
                    { id = EntityType.ENTITY_SPIDER }, --ID 85
                    { id = EntityType.ENTITY_BIGSPIDER }, --ID 94
                    { id = EntityType.ENTITY_BABY_LONG_LEGS, variant = (Isaac.GetEntityVariantByName("Small Baby Long Legs")) }, --ID 206, Variant 1
                    { id = EntityType.ENTITY_CRAZY_LONG_LEGS, variant = (Isaac.GetEntityVariantByName("Small Crazy Long Legs")) }, --ID 207, Variant 1
                    { id = EntityType.ENTITY_SPIDER_L2 }, --ID 215
                    { id = EntityType.ENTITY_CORN_MINE }, --ID 217
                    { id = EntityType.ENTITY_CONJOINED_SPITTY }, --ID 243
                    { id = EntityType.ENTITY_ROUND_WORM }, --ID 244
                    { id = EntityType.ENTITY_RAGLING }, --ID 246
                    { id = EntityType.ENTITY_NIGHT_CRAWLER } --ID 255
                } 
            },
            
            ---<<ACTIVES>>---
            MUTANT_CLOVER = { Used = 0 },
            TRAGIC_MUSHROOM = { Uses = 0 },
            FORBIDDEN_FRUIT = { UseCount = 0 },
            BASEBALL_MITT = { Used = false, Lifted = true, BallsCaught = 0, UseDelay = 0 },
            PSEUDOBULBAR_AFFECT = { Icon = Sprite() },
            OMINOUS_LANTERN = { Fired = true, Lifted = false, Hid = false, LastEnemyHit = nil, FrameModifier = 300 },
            HURDLE_HEELS = { JumpState = 0, FrameUsed = 0, Icon = Sprite() },
            WRATH_OF_THE_LAMB = { 
                Uses = {}, 
                Stats = {
                    Damage = 0,
                    Speed = 0,
                    Range = 0,
                    FireDelay = 0
                },
                Bosses = {
                    -- Stages 1 and 2
                    { EntityType.ENTITY_THE_HAUNT, EntityType.ENTITY_DINGLE, EntityType.ENTITY_MONSTRO, EntityType.ENTITY_LITTLE_HORN, EntityType.ENTITY_GURDY_JR, EntityType.ENTITY_FISTULA_BIG, EntityType.ENTITY_DUKE, EntityType.ENTITY_GEMINI, EntityType.ENTITY_RAG_MAN, EntityType.ENTITY_PIN, EntityType.ENTITY_WIDOW, EntityType.ENTITY_FAMINE, EntityType.ENTITY_GREED },
                    -- Stages 3 and 4
                    { EntityType.ENTITY_CHUB, EntityType.ENTITY_POLYCEPHALUS, EntityType.ENTITY_RAG_MEGA, EntityType.ENTITY_DARK_ONE, EntityType.ENTITY_MEGA_FATTY, EntityType.ENTITY_BIG_HORN, EntityType.ENTITY_MEGA_MAW, EntityType.ENTITY_PESTILENCE, EntityType.ENTITY_PEEP, EntityType.ENTITY_GURDY },
                    -- Stages 5 and 6
                    { EntityType.ENTITY_MONSTRO2, EntityType.ENTITY_ADVERSARY, EntityType.ENTITY_GATE, EntityType.ENTITY_LOKI, EntityType.ENTITY_MONSTRO2, EntityType.ENTITY_ADVERSARY, EntityType.ENTITY_BROWNIE, EntityType.ENTITY_WAR, EntityType.ENTITY_URIEL },
                    -- Stages 7 and 8
                    { EntityType.ENTITY_MR_FRED, EntityType.ENTITY_BLASTOCYST_BIG, EntityType.ENTITY_CAGE, EntityType.ENTITY_MASK_OF_INFAMY, EntityType.ENTITY_GABRIEL, EntityType.ENTITY_MAMA_GURDY },
                    -- Stage 9
                    { EntityType.ENTITY_FORSAKEN, EntityType.ENTITY_STAIN },
                    -- Stage 10
                    { EntityType.ENTITY_DEATH, EntityType.ENTITY_DADDYLONGLEGS, EntityType.ENTITY_SISTERS_VIS },
                    -- Others
                    { EntityType.ENTITY_MOMS_HEART, EntityType.ENTITY_SATAN, EntityType.ENTITY_ISAAC }
                }
            },
            ANAMNESIS = { IsHolding = false, Charge = 0 },
            
            ---<<MISCELLANEOUS>>--
            CHARGE_BAR = { Bar = Sprite(), Scale = Vector(1, 1) },
            
            SUBROOM_CHARGE = {
                OMINOUS_LANTERN = { id = ItemId.OMINOUS_LANTERN, frames = 0, Charge = 0 }
            }
        }
        
        ---<<PRE-START VARIABLE HANDLING>>---
        ItemVariables.PSEUDOBULBAR_AFFECT.Icon:Load("gfx/effects/Pseudobulbar Icon.anm2", true)
        ItemVariables.PSEUDOBULBAR_AFFECT.Icon:Play("Idle", true)
        
        ItemVariables.GLUTTONYS_STOMACH.RenderBar:Load("gfx/effects/Gluttony Stomach Bar.anm2", true)
        
        ItemVariables.SLING.Icon:Load("gfx/effects/Sling_marker_effect.anm2", true)
        ItemVariables.SLING.Icon:Play("Idle", true)

        ItemVariables.HURDLE_HEELS.Icon:Load("gfx/effects/Jump.anm2", true)
        ItemVariables.HURDLE_HEELS.Icon:Play("Idle", true)
        
        ItemVariables.CHARGE_BAR.Bar:Load("gfx/ui/ui_chargebar2.anm2", true)
        
        ItemVariables.SUBROOM_CHARGE.OMINOUS_LANTERN.frames = ItemVariables.OMINOUS_LANTERN.FrameModifier
        
        EntityVariables = {
            ---<<ENEMIES>>---
            FLYERBALL = { Fires = {} },
            
            ---<<CHARACTERS>>---
            KEEPER = { ThirdHeart = 2, CurrentCoins = 0 },
            
            ---<<BETTER LOOPS>>---
            LOOPS = { Loop = 0, KeyFrame = 0, Keyhole = nil, IgnoreNegativeIndex = false, SSIndex = 0 }
        }
        
        local player = Isaac.GetPlayer(0)
        
        if player then
            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end
    end
    
    itemPool = game:GetItemPool()
    rng:SetSeed(game:GetSeeds():GetStartSeed(), 0)
    math.randomseed(game:GetSeeds():GetStartSeed())
end
Exodus.newGame(false)
Exodus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Exodus.newGame)

-------------------
--<<<FUNCTIONS>>>--
-------------------

--<<<ENTITY REGISTRATION>>>--
function Exodus:RemoveFromRegister(entity)
    for i=1, #GameState.Register do
        if GameState.Register[i].Room == game:GetLevel():GetCurrentRoomIndex() 
        and GameState.Register[i].Position.X == entity.Position.X 
        and GameState.Register[i].Position.Y == entity.Position.Y
        and GameState.Register[i].Entity.Type == entity.Type
        and GameState.Register[i].Entity.Variant == entity.Variant
        then
            table.remove(GameState.Register, i)
            break
        end
    end
end

function Exodus:SpawnRegister()
    for i=1, #GameState.Register do
        if GameState.Register[i].Room == game:GetLevel():GetCurrentRoomIndex() then
            local entity = Isaac.Spawn(GameState.Register[i].Type, GameState.Register[i].Variant, 0, GameState.Register[i].Position, NullVector, nil)
        end
    end
end

function Exodus:AddToRegister(entity)
    table.insert(GameState.Register, {
            Room = game:GetLevel():GetCurrentRoomIndex(),
            Position = entity.Position,
            Entity = {Type = entity.Type, Variant = entity.Variant}
        }
    )
end

--<<<SAVING MOD DATA>>>--
function Exodus:OnStart()
    GameState = json.decode(Exodus:LoadData())
    if GameState.Register == nil then GameState.Register = {} end
end

Exodus:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Exodus.OnStart)

function Exodus:OnExit()
    Exodus:SaveData(json.encode(GameState))
end

Exodus:AddCallback(ModCallbacks.MC_POST_GAME_END, Exodus.OnExit)
Exodus:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Exodus.OnExit)

function Exodus:OnNewGame(fromSave)
    local player = Isaac.GetPlayer(0)
    if not fromSave then
        GameState.Register = {}
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Exodus.OnNewGame)

--[[
function Exodus:TestData()
    local entities = Isaac.GetRoomEntities()
    for i=1, #entities do    
        if entities[i]:IsVulnerableEnemy() and entities[i]:GetData().AddedToRegister ~= true then
            Exodus:AddToRegister(entities[i])
            entities[i]:GetData().AddedToRegister = true
        end
    end
    if GameState.Register[1] ~= nil then
        Isaac.DebugString("The Entity Register: " .. tostring(GameState.Register[1].Entity.Type))
    end
    if GameState.Register[2] ~= nil then
        Isaac.DebugString("The Entity Register: " .. tostring(GameState.Register[2].Entity.Type))
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.TestData)
--]]

--<<<OTHER FUNCTIONS>>>--
local function Error(string)
    Isaac.DebugString("[ExodusERROR] " .. tostring(string))
end

function Exodus:PlayerIsMoving()
    local player = Isaac.GetPlayer(0)
    
    for i = 0, 3 do
        if Input.IsActionPressed(i, player.ControllerIndex) then
            return true
        end
    end
    
    return false
end

function Exodus:IsProperEnemy(ent)
    if ent ~= nil then
        if ent:IsActiveEnemy(false) and ent:CanShutDoors() then
            return true
        end
    end
    
    return false
end

function Exodus:GetRandomEnemyInTheRoom(entity) 
    local index = 1
    local possible = {}
  
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if Exodus:IsProperEnemy(entity) and entity.Position:DistanceSquared(entity.Position) < 250^2 then
            possible[index] = entity
            index = index + 1
        end
    end
  
    return possible[math.random(1, index)]
end

function Exodus:PlayTearSprite(tear, anm2)
    local sprite = tear:GetSprite()
    
    if anm2 then
        sprite:Load("gfx/" .. anm2, true)
    end
    
    if tear.CollisionDamage <= 0.5 then
        sprite:Play("RegularTear1", true)
    elseif tear.CollisionDamage <= 1 then
        sprite:Play("RegularTear2", true)
    elseif tear.CollisionDamage <= 1.5 then
        sprite:Play("RegularTear3", true)
    elseif tear.CollisionDamage <= 2 then
        sprite:Play("RegularTear4", true)
    elseif tear.CollisionDamage <= 3 then
        sprite:Play("RegularTear5", true)
    elseif tear.CollisionDamage <= 4.5 then
        sprite:Play("RegularTear6", true)
    elseif tear.CollisionDamage <= 6 then
        sprite:Play("RegularTear7", true)
    elseif tear.CollisionDamage <= 7.5 then
        sprite:Play("RegularTear8", true)
    elseif tear.CollisionDamage <= 9 then
        sprite:Play("RegularTear9", true)
    elseif tear.CollisionDamage <= 10.5 then
        sprite:Play("RegularTear10", true)
    elseif tear.CollisionDamage <= 15 then
        sprite:Play("RegularTear11", true)
    elseif tear.CollisionDamage < 20 then
        sprite:Play("RegularTear12", true)
    elseif tear.CollisionDamage >= 20 then
        sprite:Play("RegularTear13", true)
    end
end

function Exodus:IsAOEFree()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:GetData().IsOccultistAOE then
            return false
        end
    end
end

function Exodus:SpawnCandleTear(npc, isNormal)
    local target = Exodus:GetRandomEnemyInTheRoom(npc)

    if target ~= nil then
        local angle = (target.Position - npc.Position):GetAngleDegrees()
        local candleTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, npc.Position, Vector.FromAngle(1 * angle):Resized(5), player):ToTear()
        
        candleTear.TearFlags = candleTear.TearFlags | TearFlags.TEAR_HOMING
        Exodus:PlayTearSprite(candleTear, "Psychic Tear.anm2")
        candleTear:GetData().AddedFireBonus = true
    end
end

function Exodus:SpawnGib(position, spawner, big)
    local YOffset = math.random(5, 20)
    local LanternGibs = Isaac.Spawn(EntityType.ENTITY_EFFECT, Entities.LANTERN_GIBS.variant, 0, position, Vector(math.random(-20, 20), -1 * YOffset), spawner)
    local sprite = LanternGibs:GetSprite()
    
    LanternGibs:GetData().Offset = YOffset
    LanternGibs.SpriteRotation = math.random(360)
    
    if LanternGibs.FrameCount == 0 then
        if not big then
            sprite:Play("Gib0" .. tostring(math.random(2, 4)),false)
            sprite:Stop()
        elseif big then
            sprite:Play("Gib01",false)
            sprite:Stop()
        end
    end
end

function Exodus:FireTurretBullet(pos, vel, spawner)
    local player = Isaac.GetPlayer(0)
    local TurretBullet = player:FireTear(pos, vel, false, true, false)
    
    if spawner:IsBoss() then
        TurretBullet.CollisionDamage = TurretBullet.CollisionDamage * 1.5
        TurretBullet.Scale = TurretBullet.Scale * 1.5
    end
    
    local sprite = TurretBullet:GetSprite()
    sprite.Color = Color(sprite.Color.R, sprite.Color.G, sprite.Color.B, sprite.Color.A, 100, 0, 0)
    
    Exodus:PlayTearSprite(TurretBullet, "Blood Tear.anm2")
end

function Exodus:FireLantern(pos, vel, anim)
    local player = Isaac.GetPlayer(0)
    
    if (ItemVariables.OMINOUS_LANTERN.Fired == false or player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)) and player:HasCollectible(ItemId.OMINOUS_LANTERN) then 
        ItemVariables.OMINOUS_LANTERN.LastEnemyHit = nil
        player:DischargeActiveItem()
        ItemVariables.OMINOUS_LANTERN.Fired = true
        ItemVariables.OMINOUS_LANTERN.Lifted = true
        
        local lantern = Isaac.Spawn(EntityType.ENTITY_TEAR, Entities.LANTERN_TEAR.variant, 0, pos, vel + player.Velocity, player):ToTear()
        lantern.FallingSpeed = -10
        lantern.FallingAcceleration = 1
        
        if anim then
            player:AnimateCollectible(ItemId.OMINOUS_LANTERN, "HideItem", "PlayerPickupSparkle")
        end
    end
end

function Exodus:FireXHoney(margin, v)
    local dir = rng:RandomInt(360)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
        margin = 360
    end
      
    if player:HasCollectible(CollectibleType.COLLECTIBLE_TRACTOR_BEAM) then
        margin = 0
        
        for i = 1, 4 do
            EntityLaser.ShootAngle(7, v.Position, dir + (i * 90), 10, NullVector, v)
        end
    end
    
    for i = 1, 4 do
        Exodus:FireHoney(Vector.FromAngle(dir + math.random(((i - 1) * 90) - margin,((i - 1) * 90) + margin)) * 10, v)
    end
end

function Exodus:FireHoney(dir, v)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
        dir = dir / 100
    end
  
    local honey = Isaac.Spawn(EntityType.ENTITY_EFFECT, Entities.HONEY_SPLAT.variant, 0, v.Position, dir, v)
    honey.SpriteRotation = honey.Velocity:GetAngleDegrees()
    honey.GridCollisionClass = GridCollisionClass.COLLISION_WALL
end

function Exodus:ShootFireball(position, vector)
    local player = Isaac.GetPlayer(0)
    local fire = Isaac.Spawn(Entities.FIREBALL.id, Entities.FIREBALL.variant, 0, position, vector:Resized(10) * player.ShotSpeed + (player.Velocity / 2), player):ToTear()
    fire.Color = player.TearColor
    fire.CollisionDamage = player.Damage * 4
    fire.TearFlags = fire.TearFlags | player.TearFlags
    fire.FallingAcceleration = -0.1
    fire.SpriteRotation = fire.Velocity:GetAngleDegrees() - 90
end

function Exodus:GetTech360Size()
    local size = 1
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.BEEHIVE) then
        size = math.random(-3, 5)
    end
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LUMP_OF_COAL) then
        size = size + 2
    end
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_PROPTOSIS) then
        size = size / 2
    end
    
    return math.ceil(size * player.ShotSpeed)
end

function Exodus:HasPlayerChance(luckcap)
    local player = Isaac.GetPlayer(0)
    local luck = player.Luck
    
    if luck < 0 then
        luck = 0
    end
    
    if player.Luck > luckcap then
        luckcap = player.Luck
    end
    
    if math.random(luckcap - luck + 1) == 1 then
        return true
    else
        return false
    end
end

function Exodus:FireFire(vector, wiz, double, two)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE) and Exodus:HasPlayerChance(2) then
        Exodus:ShootFireball(player.Position, vector:Rotated(180))
    end
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) and Exodus:HasPlayerChance(7) then
        Exodus:ShootFireball(player.Position, vector:Rotated(90))
        Exodus:ShootFireball(player.Position, vector:Rotated(180))
        Exodus:ShootFireball(player.Position, vector:Rotated(90))
    end
    
    if player:GetCollectibleNum(ItemId.DRAGON_BREATH) > 1 and two == false then
        for i = 1, player:GetCollectibleNum(ItemId.DRAGON_BREATH) do
            Exodus:FireFire(vector:Rotated(((i - math.floor(player:GetCollectibleNum(ItemId.DRAGON_BREATH) / 2)) * 2) - 1):Resized(2), wiz, double, true)
        end
    else
        if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) and double == false then
            for i = 1, 2 do
                Exodus:FireFire(vector:Rotated(((i - 1) * 2) - 1):Resized(3), wiz, true, two)
            end
        else
            if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and wiz == false then
                for i = 1, 2 do
                    Exodus:FireFire(vector:Rotated(((i - 1) * 2) - 1):Resized(45), true, double, two)
                end
            else
                if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
                    Exodus:ShootFireball(player.Position, vector:Rotated(-10))
                    Exodus:ShootFireball(player.Position, vector:Rotated(10))
                end
                
                if player:GetName() == "Keeper" then
                    Exodus:ShootFireball(player.Position, vector:Rotated(-10))
                    Exodus:ShootFireball(player.Position, vector:Rotated(10))
                end
                
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
                    Exodus:ShootFireball(player.Position, vector:Rotated(-7))
                    Exodus:ShootFireball(player.Position, vector:Rotated(7))
                    Exodus:ShootFireball(player.Position, vector:Rotated(-13))
                end
                
                Exodus:ShootFireball(player.Position, vector)
            end
        end
    end
end

local function getEntityFromRef(entityRef)
    for i, ent in pairs(Isaac.GetRoomEntities()) do
        if ent.Index == entityRef.Entity.Index and ent.InitSeed == entityRef.Entity.InitSeed then
            return ent
        end
    end
end

--<<<MISCELLANEOUS>>>--
function Exodus:fakeChargeBarRender()
    local player = Isaac.GetPlayer(0)
    
    for i, item in pairs(ItemVariables.SUBROOM_CHARGE) do
        if player:GetActiveItem() == item.id then
            if player:GetActiveItem() > 0 then
                ItemVariables.CHARGE_BAR.Bar:SetFrame("BarEmpty",0)
                ItemVariables.CHARGE_BAR.Bar.Scale = Vector(1, 1)
                ItemVariables.CHARGE_BAR.Bar:Render(Vector(36, 17), NullVector, NullVector)
            end
            
            ItemVariables.CHARGE_BAR.Bar:SetFrame("BarFull",0)
            ItemVariables.CHARGE_BAR.Scale.Y = item.Charge / item.frames
            ItemVariables.CHARGE_BAR.Bar.Scale = ItemVariables.CHARGE_BAR.Scale
            
            local ChargePos = Vector(36, 17)
            ChargePos.Y = ChargePos.Y + 10 * (1 - ItemVariables.CHARGE_BAR.Scale.Y)
            ItemVariables.CHARGE_BAR.Bar:Render(ChargePos, NullVector, NullVector)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.fakeChargeBarRender)

--<<<RITUAL CANDLE>>>--
function Exodus:ritualCandleUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.RITUAL_CANDLE) then
        ItemVariables.RITUAL_CANDLE.LitCandles = 0
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do 
            local data = entity:GetData()
            local sprite = entity:GetSprite()
            
            if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.PENTAGRAM_BLACKPOWDER and data.IsFromRitual then
                entity:Remove()
            end
            
            local range = 107
            
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                range = 150
            end
            
            if ItemVariables.RITUAL_CANDLE.HasBonus and entity.Position:Distance(player.Position) <= range and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and game:GetFrameCount() % math.floor(player.MaxFireDelay / 3) == 0 then
                entity:TakeDamage((player.Damage / 4) * (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS) + 1), 0, EntityRef(player), 0)
            end
            
            if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Entities.CANDLE.variant then
                if data.IsLit then
                    ItemVariables.RITUAL_CANDLE.LitCandles = ItemVariables.RITUAL_CANDLE.LitCandles + 1
                    
                    if ItemVariables.RITUAL_CANDLE.HasBonus and data.LitTimer > 120 then
                        sprite:Play("Lit All", false)
                    else
                        sprite:Play("Lit", false)
                    end
                elseif not data.IsLit then
                    sprite:Play("Idle", false)
                end
            end
        end
        
        if ItemVariables.RITUAL_CANDLE.LitCandles == 5 then
            ItemVariables.RITUAL_CANDLE.Pentagram = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PENTAGRAM_BLACKPOWDER, 0, player.Position, NullVector, player)
            
            local sprite = ItemVariables.RITUAL_CANDLE.Pentagram:GetSprite()
            sprite:Load("gfx/effects/pentagram.anm2", true)
            sprite:Play("Idle", true)
            sprite:SetFrame("Idle", game:GetFrameCount() % 5)
            ItemVariables.RITUAL_CANDLE.Pentagram:ToEffect():FollowParent(player)
            ItemVariables.RITUAL_CANDLE.Pentagram.SpriteRotation = player.FrameCount*-2
            ItemVariables.RITUAL_CANDLE.Pentagram:GetData().IsFromRitual = true
            ItemVariables.RITUAL_CANDLE.HasBonus = true
            
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                ItemVariables.RITUAL_CANDLE.Pentagram.SpriteScale = Vector(1.45, 1.45)
            end
            
            if ItemVariables.RITUAL_CANDLE.SoundPlayed == false then
                sfx:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)
                ItemVariables.RITUAL_CANDLE.SoundPlayed = true
            end
        else
            ItemVariables.RITUAL_CANDLE.HasBonus = false
            
            if ItemVariables.RITUAL_CANDLE.SoundPlayed then
                sfx:Play(SoundEffect.SOUND_SATAN_HURT, 1, 0, false, 1)
                ItemVariables.RITUAL_CANDLE.SoundPlayed = false
            end
        end    
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.ritualCandleUpdate)

function Exodus:randomiseCandleSprites()
    local count = 1
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Entities.CANDLE.variant then
            local data = entity:GetData()
            
            if not data.RandomSpritesheet then
                local sprite = entity:GetSprite()
                
                data.RandomSpritesheet = true
                sprite:ReplaceSpritesheet(0, "gfx/familiar/candle" .. math.min(count, 5) .. ".png")
                sprite:LoadGraphics()
                count = count + 1
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.randomiseCandleSprites)

function Exodus:ritualCandleCache(player, flag)
    if player:HasCollectible(ItemId.RITUAL_CANDLE) and flag == CacheFlag.CACHE_FAMILIARS then
        player:CheckFamiliar(Entities.CANDLE.variant, 5, rng)
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.ritualCandleCache)

function Exodus:ritualCandleInit(candle)
    candle.Parent = player
    candle.OrbitDistance = Vector(120, 120)
    candle.OrbitSpeed = 0.015
    candle.OrbitLayer = 6012
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Exodus.ritualCandleInit, Entities.CANDLE.variant)

function Exodus:ritualCandleFamiliarUpdate(candle)
    local data = candle:GetData()
    local sprite = candle:GetSprite()
    local player = Isaac.GetPlayer(0)

    if not player:HasCollectible(ItemId.RITUAL_CANDLE) then
        candle:Remove()
    end
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        candle.OrbitDistance = Vector(150, 150)
    else
        candle.OrbitDistance = Vector(107, 107)
    end
    
    candle.OrbitSpeed = 0.015
    candle.OrbitLayer = 6012
    candle.Velocity = candle:GetOrbitPosition(player.Position + player.Velocity) - candle.Position
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do 
        if (entity.Type == EntityType.ENTITY_TEAR or entity.Type == EntityType.ENTITY_KNIFE or (entity.Type == EntityType.ENTITY_FIREPLACE and (entity.Variant == 0 or entity.Variant == 1))) then
            if entity.Position:DistanceSquared(candle.Position) < (entity.Size + candle.Size)^2 then
                if data.IsLit ~= true then
                    data.IsLit = true
                    sfx:Play(SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1)
                end

                data.LitTimer = 600
            end
        end
    end
        
    if data.LitTimer ~= nil then
        if data.LitTimer <= 0 and data.IsLit then
            data.IsLit = false
            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
        end
            
        if data.IsLit and not game:GetRoom():IsClear() then
            data.LitTimer = data.LitTimer - 1
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Exodus.ritualCandleFamiliarUpdate, Entities.CANDLE.variant)

function Exodus:ritualCandleRender()
    if ItemVariables.RITUAL_CANDLE.HasBonus == false and ItemVariables.RITUAL_CANDLE.Pentagram ~= nil then
        ItemVariables.RITUAL_CANDLE.Pentagram:Remove()
        ItemVariables.RITUAL_CANDLE.Pentagram = nil
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.ritualCandleRender)

--<<<SCARED HEART>>>--
function Exodus:newScaredHeartLogic()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_HEART and entity.SubType == HeartSubType.HEART_SCARED then
            entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, Entities.SCARED_HEART.subtype, true)
        elseif entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_HEART and entity.SubType == Entities.SCARED_HEART.subtype then
            local sprite = entity:GetSprite()
            local data = entity:GetData()
            
            if entity.FrameCount <= 1 then
                if not data.HasPlayedAppear then
                    sprite:Play("Appear", false)
                end
                
                data.FleeingFrames = 0
            end
            
            if entity.FrameCount >= 34 or data.HasPlayedAppear == true then
                if sprite:IsFinished("Appear") then
                    data.HasPlayedAppear = true
                end
                
                if player.Position:DistanceSquared(entity.Position) < 2500 and player.Position:DistanceSquared(entity.Position) > 625 then
                    data.FleeingFrames = 60
                    entity.Velocity = (player.Position - entity.Position):Resized(-250 / player.Position:Distance(entity.Position))
                end
                
                if data.FleeingFrames > 0 then
                    data.FleeingFrames = data.FleeingFrames - 1
                    sprite:Play("Flee", false)
                else
                    sprite:Play("Idle", false)
                end
                
                if player.Position:DistanceSquared(entity.Position) < (player.Size + entity.Size)^2 and player:GetMaxHearts() > player:GetHearts() and data.Collected ~= true then
                    player:AddHearts(2)
                    data.Collected = true
                    data.CollectedFrames = 0
                    local heart = entity:ToPickup()
                    heart:PlayPickupSound()
                end
                
                if data.CollectedFrames ~= nil then
                    if data.CollectedFrames <= 14 then
                        sprite:SetFrame("Collect", data.CollectedFrames)
                        data.CollectedFrames = data.CollectedFrames + 1
                        
                        if data.CollectedFrames > 4 then
                            entity.Visible = false
                        end
                    else
                        entity:Remove()
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.newScaredHeartLogic)

--<<<???>>>--
function Exodus:lobbedShotCollision()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do 
        if entity.Type == EntityType.ENTITY_TEAR and entity:GetData().IsExodusLobbed == true then
            if entity.Position:DistanceSquared(player.Position) < 18^2 and entity:ToTear().Height < 5 then
                entity:Die()
                player:TakeDamage(1, 0, EntityRef(entity), 0)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.lobbedShotCollision)

--<<<OCCULTIST>>>--
function Exodus:occultistAOEMarkTrigger()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        
        if data.IsOccultistAOE == true then
            if data.OccultistParent and not data.OccultistParent:IsDead() then
                if data.AOEFrames < 120 then
                    if entity.FrameCount >= 2 then
                        local NewAOETear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.BLOOD, 0, entity.Position, Vector(0, 0), entity):GetData()
                        
                        NewAOETear.IsOccultistAOE = true
                        NewAOETear.AOEFrames = data.AOEFrames + 1
                        NewAOETear.OccultistParent = data.OccultistParent
                        entity:Remove()
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.occultistAOEMarkTrigger)

function Exodus:occultistEntityUpdate(entity)
    local player = Isaac.GetPlayer(0)
    local data = entity:GetData()
    local sprite = entity:GetSprite()
    local target = entity:GetPlayerTarget()
    local room = Game():GetRoom()
    
    local angle = (target.Position - entity.Position):GetAngleDegrees()
    
    if sprite:IsEventTriggered("Decelerate") then
        entity.Velocity = entity.Velocity * 0.8
    elseif sprite:IsEventTriggered("Flap") then
        sfx:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 0.7)
    elseif sprite:IsEventTriggered("Stop") then
        entity.Velocity = Vector(0, 0)
    elseif sprite:IsEventTriggered("Invisible") then
        sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 0.3)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    elseif sprite:IsEventTriggered("Visible") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    elseif sprite:IsEventTriggered("Teleport") then
        sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, 0.6)
        entity.Position = room:FindFreeTilePosition(room:GetRandomPosition(40), 5)
    elseif sprite:IsEventTriggered("Shoot") then
        for i = -1, 1 do
            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.BLOOD, 0, entity.Position, Vector.FromAngle(angle + i * 20):Resized(10), entity)
            sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
        end
    elseif sprite:IsEventTriggered("AOESpawn") then
        sfx:Play(SoundEffect.SOUND_HUSH_CHARGE, 1, 0, false, 1)
        
        for i = 1, math.random(15, 30) do
            local Marker = Isaac.Spawn(EntityType.ENTITY_EFFECT, Entities.OCCULTIST_TEAR_MARKER.variant, 0, room:FindFreeTilePosition(room:GetRandomPosition(40), 5), Vector(0,0), entity)
            Marker:GetSprite():Play("Idle", false)
        end
    elseif sprite:IsEventTriggered("AOEActivate") then
        sfx:Play(SoundEffect.SOUND_SATAN_BLAST, 1, 0, false, 1)
        
        for i, ent in pairs(Isaac.GetRoomEntities()) do
            if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == Entities.OCCULTIST_TEAR_MARKER.variant then
                local OccultistProjectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, ent.Position, Vector(0,0), entity):GetData()
                OccultistProjectile.IsOccultistAOE = true
                OccultistProjectile.AOEFrames = 0
                OccultistProjectile.OccultistParent = entity
                ent:Remove()
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
                entity.State = math.random(2, 5)
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

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.occultistEntityUpdate, Entities.OCCULTIST.id)

--<<<IRON LUNG>>>--
function Exodus:ironLungGasLogic()
    local entities = Isaac.GetRoomEntities()
    
    for i, entity in pairs(entities) do
        if entity.Type == Entities.IRON_LUNG_GAS.id and entity.Variant == Entities.IRON_LUNG_GAS.variant then
            local sprite = entity:GetSprite()
            
            if sprite:IsFinished("Appear") then
                sprite:Play("Pyroclastic Flow", false)
            end
            
            if sprite:IsFinished("Pyroclastic Flow") then
                sprite:Play("Fade", false)
            end
            
            for v, tear in pairs(entities) do
                if tear:ToTear() then
                    if tear.Position:Distance(entity.Position) < entity.Size + tear.Size then
                        tear.Velocity = tear.Velocity * 0.8
                    end
                end
            end
            
            if sprite:IsFinished("Fade") then
                entity:Remove()
                entity.Visible = false
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.ironLungGasLogic)

function Exodus:ironLungEntityUpdate(entity)
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
            Isaac.Spawn(EntityType.ENTITY_EFFECT, Entities.IRON_LUNG_GAS.variant, 0, entity.Position, Vector(0, 0), entity)
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
            sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL , 1, 0, false, 1)
            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS  , 1, 0, false, 1)
            sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1, 0, false, 2)
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
                sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS , 2, 0, false, 0.8)
                sfx:Play(SoundEffect.SOUND_POT_BREAK , 2, 0, false, 0.8)
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
                entity.Velocity = Vector(0, 0)
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

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.ironLungEntityUpdate, Entities.IRON_LUNG.id)

---<<FLYERBALL>>---
function Exodus:flyerballFires()
    local player = Isaac.GetPlayer(0)
    
    for i, fire in ipairs(EntityVariables.FLYERBALL.Fires) do
        if fire then
            local data = fire:GetData()
            
            if player.Position:DistanceSquared(fire.Position) < (fire.Size + player.Size)^2 then
                player:TakeDamage(1, DamageFlag.DAMAGE_FIRE, EntityRef(fire), 30)
            end
            
            if data.CountDown ~= nil then
                data.CountDown = data.CountDown - 1
                if data.CountDown <= 0 then
                    fire:Remove()
                    table.remove(EntityVariables.FLYERBALL.Fires, i)
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.flyerballFires)

function Exodus:flyerballNewRoom()
    EntityVariables.FLYERBALL.Fires = {}
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.flyerballNewRoom)

function Exodus:flyerballTakeDamage(target, amount, flag, source, cdframes)
    local dmgSource = getEntityFromRef(source)
    
    if target.Variant == Entities.FLYERBALL.variant then
        local data = target:GetData()
        
        if flag == DamageFlag.DAMAGE_FIRE then
            return false
        end
        
        if dmgSource and dmgSource:ToTear() then
            target.Velocity = target.Velocity + dmgSource.Velocity
        end
        
        data.SpeedMultiplier = data.SpeedMultiplier - 0.75
        
        if target.HitPoints - amount <= 0.0 then
            local Fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, target.Position, Vector(0, 0), target)
            table.insert(EntityVariables.FLYERBALL.Fires, Fire)
            Fire:GetData().CountDown = 300
            Isaac.Explode(target.Position, target, 40)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.flyerballTakeDamage, Entities.FLYERBALL.id)

function Exodus:flyerballEntityUpdate(entity)
    if entity.Variant == Entities.FLYERBALL.variant then
        local player = Isaac.GetPlayer(0)
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        
        local angle = (target.Position - entity.Position):GetAngleDegrees()
        
        if entity.FrameCount == 1 then
            sprite:Play("Appear", false)
            entity.State = 0
            data.SpeedMultiplier = 1.0
            data.PhaseChanged = false
            data.UpperBound = 2.5
            data.LowerBound = 1.0
            data.Appeared = false
        end
        
        data.SpeedMultiplier = math.min(math.max(data.LowerBound, data.SpeedMultiplier + 0.05), data.UpperBound)
        
        if sprite:IsFinished("Appear") and not data.Appeared then
            data.Appeared = true
            sprite:Play("Fly", true)
        end
        
        if data.Appeared then
            if not data.PhaseChanged then
                if entity.HitPoints < entity.MaxHitPoints / 2 then
                    data.PhaseChanged = true
                    data.UpperBound = 4.0
                    sfx:Play(SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1)
                end
                
                entity.Velocity = entity.Velocity:Resized(data.SpeedMultiplier * 3.5)
            else
                sprite:SetFrame("Fury", entity.FrameCount % 6)
                
                entity.Velocity = entity.Velocity:Resized(data.SpeedMultiplier * 5.0)
            end
        end
        
        local entities = Isaac.GetRoomEntities()
        
        for i, ent in pairs(Isaac.GetRoomEntities()) do
            if ent.Type == EntityType.ENTITY_PROJECTILE and ent.SpawnerType == Entities.FLYERBALL.id and ent.SpawnerVariant == Entities.FLYERBALL.variant then
                ent:Remove()
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.flyerballEntityUpdate, Entities.FLYERBALL.id)

--<<KEEPER>>--
function Exodus:keeperRender(t)
    local player = Isaac.GetPlayer(0)
    local level = game:GetLevel()
    local room = game:GetRoom()
    if player:GetName() == "Keeper" and (level:GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN ~= LevelCurse.CURSE_OF_THE_UNKNOWN) and (room:GetType() ~= RoomType.ROOM_BOSS or room:GetFrameCount() >= 1) then
        local hearts = player:GetMaxHearts()/2
        local sprite = Sprite()
        sprite:Load("gfx/ui/ui_hearts.anm2", true)
        if EntityVariables.KEEPER.ThirdHeart == 1 then
            sprite:Play("CoinEmpty")
            sprite:Update()
            sprite:Render(Vector((hearts*12)+12*1+36,12), Vector(0,0), Vector(0,0))
        elseif EntityVariables.KEEPER.ThirdHeart == 2 then
            sprite:Play("CoinHeartFull")
            sprite:Update()
            sprite:Render(Vector((hearts*12)+12*1+36,12), Vector(0,0), Vector(0,0))
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.keeperRender)

function Exodus:keeperUpdate(t)
    local player = Isaac.GetPlayer(0)
    local coins = player:GetNumCoins()
    local hearts = player:GetHearts()
    local maxhearts = player:GetMaxHearts()
    if player:GetName() == "Keeper" then
        if maxhearts == 4 and EntityVariables.KEEPER.ThirdHeart == 0 then
            player:AddMaxHearts(-2, false)
            EntityVariables.KEEPER.ThirdHeart = 2
        end
        if maxhearts == 0 and EntityVariables.KEEPER.ThirdHeart == 2 then
            EntityVariables.KEEPER.ThirdHeart = 0
            player:AddMaxHearts(2, false)
            player:AddHearts(4)
        end
        if coins > EntityVariables.KEEPER.CurrentCoins then
            if hearts == maxhearts and EntityVariables.KEEPER.ThirdHeart == 1 then
                player:AddCoins(-1)
                EntityVariables.KEEPER.ThirdHeart = 2
            end
        end
    end
    EntityVariables.KEEPER.CurrentCoins = coins
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.keeperUpdate)

function Exodus:keeperHit(t)
    local player = Isaac.GetPlayer(0)
    if player:GetName() == "Keeper" then
        if EntityVariables.KEEPER.ThirdHeart == 2 then
            EntityVariables.KEEPER.ThirdHeart = 1
            player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, false, false, false)
            return false
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.keeperHit, EntityType.ENTITY_PLAYER)

--<<BETTER LOOPS>>--

function loop()
    local player = Isaac.GetPlayer(0)
    EntityVariables.LOOPS.Loop = EntityVariables.LOOPS.Loop + 1
    local seeds = game:GetSeeds()
    local seed = seeds:GetNextSeed()
    seeds:SetStartSeed(seed)
    Isaac.ExecuteCommand("stage 1")
    player:AnimateAppear()
end

function Exodus:loopUpdate()
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    local level = game:GetLevel()
    if room:GetType() == RoomType.ROOM_SUPERSECRET then
        if EntityVariables.LOOPS.Keyhole and player.Position:DistanceSquared(EntityVariables.LOOPS.Keyhole.Position) < 16^2 and player:GetNumKeys() > 0 and EntityVariables.LOOPS.KeyFrame == nil then
            player:AddKeys(-1)
            for i, entity in pairs(Isaac.GetRoomEntities()) do
                if entity.Type == Entities.KEYHOLE.id and entity.Variant == Entities.KEYHOLE.variant then
                    if player:HasGoldenKey() then
                        EntityVariables.LOOPS.Keyhole:GetSprite():Play("Open With GOLD", true)
                    else
                        EntityVariables.LOOPS.Keyhole:GetSprite():Play("Open", true)
                    end
                end
            end
            EntityVariables.LOOPS.KeyFrame = game:GetFrameCount() + 27
        elseif EntityVariables.LOOPS.KeyFrame ~= nil then
            if EntityVariables.LOOPS.KeyFrame ~= 0 and EntityVariables.LOOPS.KeyFrame <= game:GetFrameCount() then
                for i, entity in pairs(Isaac.GetRoomEntities()) do
                    if entity.Type == Entities.KEYHOLE.id and entity.Variant == Entities.KEYHOLE.variant then
                        entity:Remove()
                        EntityVariables.LOOPS.IgnoreNegativeIndex = true
                        EntityVariables.LOOPS.SSIndex = level:GetCurrentRoomIndex()
                        Isaac.ExecuteCommand("goto s.curse.0")
                    end
                end
            end
        end
    elseif EntityVariables.LOOPS.KeyFrame ~= nil then
        if EntityVariables.LOOPS.KeyFrame ~= 0 and EntityVariables.LOOPS.KeyFrame <= game:GetFrameCount() then
            for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
                local door = room:GetDoor(i)
                if door ~= nil then
                    door:SetRoomTypes(RoomType.ROOM_SACRIFICE, RoomType.ROOM_SACRIFICE)
                end
            end
            keeper = Isaac.Spawn(Entities.CLOCK_KEEPER.id, Entities.CLOCK_KEEPER.variant, 0, Vector(320, 196), Vector(0, 0), nil)
            keeper:GetSprite():Play("Idle", true)
            EntityVariables.LOOPS.KeyFrame = 0
        end
    end
    if room:IsClear() and room:GetType() == RoomType.ROOM_BOSS and player:HasCollectible(ItemId.CLOCK_PIECE_1) and player:HasCollectible(ItemId.CLOCK_PIECE_2) and player:HasCollectible(ItemId.CLOCK_PIECE_3) and player:HasCollectible(ItemId.CLOCK_PIECE_4) then
        if Game():IsGreedMode() then
            if level:GetStage() == 7 and room:GetRoomShape() == 4 then
                loop()
            end
        else
            if level:GetStage() == 11 then
                loop()
            elseif level:GetStage() == 10 then
                if level:IsAltStage() then
                    if not Player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
                        loop()
                    end
                else
                    if not Player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
                        loop()
                    end
                end
            elseif level:GetStage() == 12 then
                if room:GetBossID() == 70 then
                    loop()
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.loopUpdate)

function Exodus:loopNewRoom()
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    local level = game:GetLevel()
    local bigRooms = { [RoomShape.ROOMSHAPE_2x2] = true, [RoomShape.ROOMSHAPE_LBL] = true, [RoomShape.ROOMSHAPE_LBR] = true, [RoomShape.ROOMSHAPE_LTL] = true, [RoomShape.ROOMSHAPE_LTR] = true }
    
    if EntityVariables.LOOPS.Loop > 0 then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy() then
                entity.MaxHitPoints = entity.MaxHitPoints^(EntityVariables.LOOPS.Loop + 0.5) / EntityVariables.LOOPS.Loop
                entity.HitPoints = entity.MaxHitPoints
                if 1 == math.random(10) then
                    game:RerollEnemy(entity)
                end
                if EntityVariables.LOOPS.Loop >= math.random(10) and entity:GetData().IsDuplicate == nil then
                    for i = 1, math.random(1, EntityVariables.LOOPS.Loop) do
                        dup = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, Isaac.GetFreeNearPosition(entity.Position, 16), Vector(0,0), entity)
                        dup:GetData().IsDuplicate = true
                        dup.MaxHitPoints = entity.MaxHitPoints^(EntityVariables.LOOPS.Loop + 0.5) / EntityVariables.LOOPS.Loop
                        dup.HitPoints = dup.MaxHitPoints
                    end
                end
            end
        end
    end
    
    if room:GetType() == RoomType.ROOM_SUPERSECRET and room:IsFirstVisit() then
        local mainDoor
        local checkDist = math.huge
        
        for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            local door = room:GetDoor(i)
            if door then
                local newDist = player.Position:DistanceSquared(door.Position)
                if newDist < checkDist then
                    checkDist = newDist
                    mainDoor = door 
                end
            end
        end
        
        local factor = 2
        
        if bigRooms[room:GetRoomShape()] then
            factor = 1
        end
        
        local oppositeDoorSlot = (mainDoor.Slot + 2 + (DoorSlot.NUM_DOOR_SLOTS / 2) * (2 - factor)) % (DoorSlot.NUM_DOOR_SLOTS / factor)
        local keyhole = Isaac.Spawn(Entities.KEYHOLE.id, Entities.KEYHOLE.variant, 0, room:GetDoorSlotPosition(oppositeDoorSlot), Vector(0, 0), nil)
        local sprite = keyhole:GetSprite()
        
        keyhole:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        
        sprite:Play("Idle", true)
        sprite.Rotation = (mainDoor.Direction + 1) * 90
        
        EntityVariables.LOOPS.KeyFrame = nil
        EntityVariables.LOOPS.Keyhole = keyhole
    elseif EntityVariables.LOOPS.KeyFrame == nil then
        EntityVariables.LOOPS.KeyFrame = 0
    end
    
    if room:GetType() == RoomType.ROOM_CURSE then
        if not EntityVariables.LOOPS.IgnoreNegativeIndex and level:GetCurrentRoomDesc().GridIndex < 0 then
            if EntityVariables.LOOPS.SSIndex and EntityVariables.LOOPS.SSIndex > 0 then
                level:ChangeRoom(EntityVariables.LOOPS.SSIndex)
            else
                level:ChangeRoom(level:GetStartingRoomIndex())
            end
        end
    end
    
    EntityVariables.LOOPS.IgnoreNegativeIndex = false
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.loopNewRoom)

function Exodus:loopKeeperBoom(keeper)
    local player = Isaac.GetPlayer(0)
    if keeper.Variant == Entities.CLOCK_KEEPER.variant then
        item = ItemId.CLOCK_PIECE_1
        if player:HasCollectible(ItemId.CLOCK_PIECE_1) then
            item = ItemId.CLOCK_PIECE_2
        end
        if player:HasCollectible(ItemId.CLOCK_PIECE_2) then
            item = ItemId.CLOCK_PIECE_3
        end
        if player:HasCollectible(ItemId.CLOCK_PIECE_3) then
            item = ItemId.CLOCK_PIECE_4
        end
        if player:HasCollectible(ItemId.CLOCK_PIECE_4) then
            item = itemPool:GetCollectible(ItemPoolType.POOL_CURSE, true, game:GetSeeds():GetStartSeed())
        end
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, keeper.Position, Vector(0,0), keeper)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, Exodus.loopKeeperBoom, Entities.CLOCK_KEEPER.id)

--<<<TRINKETS>>>--
function Exodus:trinketUpdate()
    local player = Isaac.GetPlayer(0)
    local playerData = player:GetData()
    
    ---<<BOMBS SOUL>>---
    if player:HasTrinket(ItemId.BOMBS_SOUL) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            local data = entity:GetData()
            
            if entity:IsActiveEnemy(true) and entity:ToNPC() then
                if entity:IsDead() and data.BombSoulDied ~= true then
                    data.BombSoulDied = true
                    
                    if rng:RandomInt(4) == 1 then
                        if not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                            local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_NORMAL, 0, entity.Position, Vector(0, 0), player)
                        else
                            local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_MR_MEGA, 0, entity.Position, Vector(0, 0), player)
                        end
                    end
                    
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE_MIND, 0, entity.Position, (player.Position - entity.Position):Resized(10), player)
                    tear.CollisionDamage = player.Damage
                    tear:ToTear().Scale = 1 * player.Damage / 5
                end
            end
        end
    end
    
    ---<<BROKEN GLASSES>>---
    if player:HasTrinket(ItemId.BROKEN_GLASSES) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy() or entity.Type == EntityType.ENTITY_PICKUP then
                entity:GetSprite().Color = Color(0, 0, 0, 1, 0, 0, 0)
            elseif entity.Type == EntityType.ENTITY_TEAR and entity:GetData().FromBrokenGlasses == nil then
                if math.random(2) == 1 then
                    local tear = player:FireTear(Vector((entity.Position.X * 2) - player.Position.X, (entity.Position.Y * 2) - player.Position.Y), entity.Velocity, true, false, true)
                    tear:GetData().FromBrokenGlasses = true
                end
                entity:GetData().FromBrokenGlasses = true
            end
        end
    end
    
    ---<<PET ROCK>>---
    if player:HasTrinket(ItemId.PET_ROCK) then
        if playerData.HasHadPetRock ~= true then
            playerData.HasHadPetRock = true
        end
        
        if not player:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
            player:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK + EntityFlag.FLAG_NO_KNOCKBACK)
        end
        
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and not (Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex)
        or Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex))then
            player.Velocity = Vector(0,0)
        end
    else
        if player:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) and playerData.HasHadPetRock then
            player:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK + EntityFlag.FLAG_NO_KNOCKBACK)
            playerData.HasHadPetRock = false
        end
    end
    
    ---<<BURLAP SACK>>---
    if player:HasTrinket(ItemId.BURLAP_SACK) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            local data = entity:GetData()
            
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_GRAB_BAG and entity:IsDead() and data.IsSacked == nil then 
                data.IsSacked = true
                
                if player:HasCollectible(CollectibleType.COLLECTIBLE_SACK_HEAD) and rng:RandomInt(6) == 0 then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, entity.Position, RandomVector() * 5, player)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, entity.Position, RandomVector() * 5, player)
                end
            end
        end
    end
    
    ---<<GRID WORM>>---
    if player:HasTrinket(ItemId.GRID_WORM) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            local rand = rng:RandomInt(4) + 1
            
            if entity.Type == EntityType.ENTITY_TEAR and entity.SpawnerType == EntityType.ENTITY_PLAYER then
                if entity.FrameCount > player.TearHeight * -3 then
                    entity:Die()
                end
                
                if entity.FrameCount % 10 == 1 and entity.FrameCount > 10 or entity.FrameCount == 4 then
                    local signX = 10
                    local signY = 10
                    
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
                        if rand == 2 then
                            signX = -signX
                        elseif rand == 3 then
                            signY = -signY
                        elseif rand == 4 then
                            signX = -signX
                            signY = -signY
                        end
                    else
                        if rand == 1 then
                            signY = 0
                        elseif rand == 2 then
                            signX = -signX
                            signY = 0
                        elseif rand == 3 then
                            signX = 0
                        elseif rand == 4 then
                            signX = 0
                            signY = -signY
                        end
                    end
                    
                    entity.Velocity = Vector(player.ShotSpeed * signX, player.ShotSpeed * signY)
                end
            end
        end
    end
    
    ---<<ROTTEN PENNY>>---
    if player:HasTrinket(ItemId.ROTTEN_PENNY) then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_QUARTER) and not ItemVariables.ROTTEN_PENNY.HasQuarter then
            ItemVariables.ROTTEN_PENNY.HasQuarter = true
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                player:AddBlueFlies(50, player.Position, nil)
            else
                player:AddBlueFlies(25, player.Position, nil)
            end
        end

        if player:HasCollectible(CollectibleType.COLLECTIBLE_DOLLAR) and not ItemVariables.ROTTEN_PENNY.HasDollar then
            ItemVariables.ROTTEN_PENNY.HasDollar = true
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                player:AddBlueFlies(198, player.Position, nil)
            else
                player:AddBlueFlies(99, player.Position, nil)
            end
        end

        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COIN and entity:IsDead() and entity:GetData().HasSpawnedFly == nil then 
                entity:GetData().HasSpawnedFly = true
                local amount = 1
                
                if entity.SubType == CoinSubType.COIN_NICKEL then
                    amount = 5
                elseif entity.SubType == CoinSubType.COIN_DIME then
                    amount = 10
                elseif entity.SubType == CoinSubType.COIN_DOUBLEPACK then
                    amount = 2
                elseif entity.SubType == CoinSubType.COIN_LUCKYPENNY then
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                        Isaac.Spawn(3, 43, 2, entity.Position, Vector(0,0), player)
                        Isaac.Spawn(3, 43, 2, entity.Position, Vector(0,0), player)
                        return
                    else
                        Isaac.Spawn(3, 43, 2, entity.Position, Vector(0,0), player)
                        return
                    end
                end
                
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                    amount = amount * 2
                end
                
                player:AddBlueFlies(amount, player.Position, nil)
            end
        end
    end
    
    ---<<FLYDER>>---
    if player:HasTrinket(ItemId.FLYDER) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.BLUE_SPIDER and entity.FrameCount < 3 and entity:GetData().DontSwitch == nil then
                entity:Remove()
                local fly = player:AddBlueFlies(1, player.Position, player)
                fly:GetData().DontSwitch = true
            elseif entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.BLUE_FLY and entity.FrameCount < 3 and entity:GetData().DontSwitch == nil then
                entity:Remove()
                local spider = player:AddBlueSpider(entity.Position)
                spider:GetData().DontSwitch = true
            elseif entity.Type == EntityType.ENTITY_SPIDER and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and entity.FrameCount < 3 and entity:GetData().DontSwitch == nil then
                entity:Remove()
                local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, entity.Position, entity.Velocity, nil)
                fly:GetData().DontSwitch = true
            elseif entity.Type == EntityType.ENTITY_ATTACKFLY and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and entity.FrameCount < 3 and entity:GetData().DontSwitch == nil then
                entity:Remove()
                local spider = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0, 0, entity.Position, entity.Velocity, nil)
                spider:GetData().DontSwitch = true
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.trinketUpdate)

function Exodus:trinketCache(player, flag)
    ---<<GRID WORM>>---
    if player:HasTrinket(ItemId.GRID_WORM) and flag == CacheFlag.CACHE_RANGE then
        player.TearFallingSpeed = 10
    end

    --<<CLAUSTROPHOBIA>>--
    if player:HasTrinket(ItemId.CLAUSTROPHOBIA) and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
        if flag == CacheFlag.CACHE_SPEED then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.MoveSpeed = player.MoveSpeed + 0.5
            end
        end
        if flag == CacheFlag.CACHE_FIREDELAY then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.MaxFireDelay = player.MaxFireDelay - 4
            end
        end
        if flag == CacheFlag.CACHE_DAMAGE then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.Damage = player.Damage + 4
            end
        end
        if flag == CacheFlag.CACHE_LUCK then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.Luck = player.Luck + 2
            end
        end
        if flag == CacheFlag.CACHE_SHOTSPEED then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.ShotSpeed = player.ShotSpeed + 0.3
            end
        end
        if flag == CacheFlag.CACHE_RANGE then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.TearHeight = player.TearHeight - 3
            end
        end
    elseif player:HasTrinket(ItemId.CLAUSTROPHOBIA) then
        if flag == CacheFlag.CACHE_SPEED then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.MoveSpeed = player.MoveSpeed + 0.4
            end
        end
        if flag == CacheFlag.CACHE_FIREDELAY then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.MaxFireDelay = player.MaxFireDelay - 3
            end
        end
        if flag == CacheFlag.CACHE_DAMAGE then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.Damage = player.Damage + 3
            end
        end
        if flag == CacheFlag.CACHE_LUCK then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.Luck = player.Luck + 1
            end
        end
        if flag == CacheFlag.CACHE_SHOTSPEED then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.ShotSpeed = player.ShotSpeed + 0.2
            end
        end
        if flag == CacheFlag.CACHE_RANGE then
            if ItemVariables.CLAUSTROPHOBIA.Triggered then
                player.TearHeight = player.TearHeight - 2.5
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.trinketCache)

function Exodus:trinketNewRoom()
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    
    ---<<PURPLE MOON>>---
    if player:HasTrinket(ItemId.PURPLE_MOON) then
        if room:GetType() == RoomType.ROOM_SECRET then
            for i = 1, room:GetGridSize() do
                local gridEnt = room:GetGridEntity(i)
                
                if gridEnt then
                    if not gridEnt:ToDoor() and not gridEnt:ToWall() then
                        room:RemoveGridEntity(i, 0, true)
                    end
                end
            end
            
            if room:IsFirstVisit() then
                local item = itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, game:GetSeeds():GetStartSeed())
                
                for u, entity in pairs(Isaac.GetRoomEntities()) do
                    if entity ~= nil then
                        if entity.Type > 3 and entity.Type ~= EntityType.ENTITY_EFFECT then
                            entity:Remove()
                        end
                    end
                end
                
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, Isaac.GetFreeNearPosition(room:GetCenterPos(), 7), NullVector, nil)
            end
        end
    end

    if room:GetRoomShape() == RoomShape.ROOMSHAPE_IH or room:GetRoomShape() == RoomShape.ROOMSHAPE_IIH or room:GetRoomShape() == RoomShape.ROOMSHAPE_IV or room:GetRoomShape() == RoomShape.ROOMSHAPE_IIV then
        ItemVariables.CLAUSTROPHOBIA.Triggered = true
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:EvaluateItems()
    else
        ItemVariables.CLAUSTROPHOBIA.Triggered = false
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:EvaluateItems()
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.trinketNewRoom)

--<<<SUB ROOM CHARGE ITEMS>>>--
function Exodus:subRoomChargeItemsUpdate()
    local room = game:GetRoom()
    local player = Isaac.GetPlayer(0)
    
    if game:GetFrameCount() == 1 then
        for i, item in pairs(ItemVariables.SUBROOM_CHARGE) do
            item.Charge = 0
        end
    end
    
    if player:GetActiveCharge() == 0 then
        for i, item in pairs(ItemVariables.SUBROOM_CHARGE) do
            if item ~= nil and player:GetActiveItem() == item.id then
                item.Charge = item.Charge + 1
                
                if item.Charge >= item.frames then
                    item.Charge = 0
                    player:FullCharge()
                end
            end
        end
    end
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
        ItemVariables.SUBROOM_CHARGE.OMINOUS_LANTERN.frames = 100
    else
        ItemVariables.SUBROOM_CHARGE.OMINOUS_LANTERN.frames = 300
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.subRoomChargeItemsUpdate)

--<<<OMINOUS LANTERN>>>--
function Exodus:ominousLanternNewRoom()
    ItemVariables.OMINOUS_LANTERN.Fired = true
    ItemVariables.OMINOUS_LANTERN.Lifted = true
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.ominousLanternNewRoom)

function Exodus:ominousLanternUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.OMINOUS_LANTERN) then
        if ItemVariables.OMINOUS_LANTERN.Fired == false then
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
                player:FullCharge()
            end
            
            if ItemVariables.OMINOUS_LANTERN.Lifted == false then
                player:AnimateCollectible(ItemId.OMINOUS_LANTERN, "LiftItem", "PlayerPickupSparkle")
                ItemVariables.OMINOUS_LANTERN.Lifted = true
            end
        end
        
        if ItemVariables.OMINOUS_LANTERN.Hid then
            ItemVariables.OMINOUS_LANTERN.Hid = false
            player:FullCharge()
        end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_TEAR and entity.Variant == Entities.LANTERN_TEAR.variant then
                if entity:IsDead() then
                    sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1, 0, false, 1.5)
                    Exodus:SpawnGib(entity.Position, entity, true)
                    
                    for z = 1, 3 do
                        Exodus:SpawnGib(entity.Position, entity, false)
                    end
                    
                    local purpleFire = Isaac.Spawn(EntityType.ENTITY_EFFECT, Entities.LANTERN_FIRE.variant, 0, entity.Position, NullVector, player)
                    purpleFire:GetData().ExistingFrames = 0
                end
            elseif entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == Entities.LANTERN_FIRE.variant then
                local data = entity:GetData()
                local sprite = entity:GetSprite()
                
                data.ExistingFrames = data.ExistingFrames + 1
                
                if data.ExistingFrames >= 300 then
                    sprite:Play("Dying", false)
                    
                    if sprite:IsFinished("Dying") then
                        entity:Remove()
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.ominousLanternUpdate)

function Exodus:ominousLanternDamage(target, amount, flags, source, cdtimer)
    if source.Type == EntityType.ENTITY_TEAR and source.Variant == Entities.LANTERN_TEAR.variant then
        ItemVariables.OMINOUS_LANTERN.LastEnemyHit = target
    end
    
    if target.Type == EntityType.ENTITY_PLAYER then
        ItemVariables.OMINOUS_LANTERN.Fired = true
        ItemVariables.OMINOUS_LANTERN.Lifted = true  
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.ominousLanternDamage)

function Exodus:ominousLanternRender()
    local player = Isaac.GetPlayer(0)
    
    for i, ent in pairs(Isaac.GetRoomEntities()) do
        local data = ent:GetData()
        
        if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == Entities.LANTERN_GIBS.variant then
            if data.Offset ~= nil then
                if ent.Velocity.Y < data.Offset and data.Resting ~= true then
                    ent.Velocity = ent.Velocity + Vector(0, 1)
                end
            end
            
            if ent.Velocity.X < 0 then
                ent.Velocity = ent.Velocity + Vector(1, 0)
            end
            
            if ent.Velocity.X > 0 then
                ent.Velocity = ent.Velocity + Vector(-1, 0)
            end
            
            if ent.Velocity.Y >= data.Offset then
                ent.Velocity = Vector(ent.Velocity.X, 0)    
                data.Resting = true
            end    
        elseif ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == Entities.LANTERN_FIRE.variant then
            local npc = ent
            
            if npc.FrameCount <= 1 then
                data.ExistingFrames = 0
                npc:GetSprite():Play("Idle", false)
                data.SFXcd = 0
                
                if ItemVariables.OMINOUS_LANTERN.LastEnemyHit ~= nil then
                    data.IsLatchedToEnemy = ItemVariables.OMINOUS_LANTERN.LastEnemyHit
                end
            end
            
            if data.SFXcd ~= nil then
                if data.SFXcd >= 1 then
                    data.SFXcd = data.SFXcd - 1
                end
            end
            
            if data.IsLatchedToEnemy ~= nil then
                npc.Position = data.IsLatchedToEnemy.Position
                
                if data.IsLatchedToEnemy:IsDead() then
                    data.IsLatchedToEnemy = nil
                end
            else
                npc.Velocity = NullVector
            end
            
            if game:GetFrameCount() % math.random(30, 80) == 0 then
                Exodus:SpawnCandleTear(npc)
            end
            
            for u, entity in pairs(Isaac.GetRoomEntities()) do
                local edata = entity:GetData()
                
                if entity:IsVulnerableEnemy() then
                    if entity.Position:DistanceSquared(npc.Position) < (entity.Size + npc.Size)^2 then
                        entity:AddFear(EntityRef(player), 30)
                        entity:TakeDamage(2, DamageFlag.DAMAGE_FIRE, EntityRef(npc), 90)
                        if data.IsLatchedToEnemy == nil and data.SFXcd == 0 then
                            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.7, 0, false, 1)
                            data.SFXcd = 30
                        end
                    end
                elseif entity.Type == EntityType.ENTITY_TEAR and entity.Variant ~= Entities.LANTERN_TEAR.variant then
                    if entity.Position:DistanceSquared(npc.Position) < (entity.Size + npc.Size)^2 and edata.AddedFireBonus ~= true and edata.IsCandleTear ~= true then
                        local tear = entity:ToTear()
                        edata.AddedFireBonus = true
                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
                        tear.Scale = tear.Scale * 1.5
                        entity.CollisionDamage = entity.CollisionDamage * 1.5
                        Exodus:PlayTearSprite(entity, "Psychic Tear.anm2")
                        entity.Velocity = entity.Velocity * 0.8
                    elseif entity.Position:DistanceSquared(npc.Position) < (entity.Size + npc.Size)^2 and edata.AddedFireBonus ~= true and edata.IsCandleTear then
                        local tear = entity:ToTear()
                        edata.AddedFireBonus = true
                        tear.TearFlags = tear.TearFlags + TearFlags.TEAR_HOMING
                        entity.Color = Color(1, 1, 1, 1, 80, 0, 80)
                    end
                elseif entity.Type == EntityType.ENTITY_PROJECTILE then
                    if entity.Position:DistanceSquared(npc.Position) < (entity.Size + npc.Size)^2 then    
                        entity:Die()
                        data.ExistingFrames = data.ExistingFrames + 50
                    end
                elseif entity.Type == EntityType.ENTITY_BOMBDROP then
                    local Bomb = entity:ToBomb()
                    local BombData = entity:GetData()
                    
                    if Bomb.IsFetus and BombData.MadeHoming ~= true then
                        if entity.Position:DistanceSquared(npc.Position) < (entity.Size + npc.Size)^2 then
                            Bomb.Flags = Bomb.Flags + TearFlags.TEAR_HOMING
                            entity.Color = Color(1, 1, 1, 1, 80, 0, 80)
                            BombData.MadeHoming = true
                        end
                    end
                elseif entity.Type == EntityType.ENTITY_KNIFE and entity:ToKnife():IsFlying() then
                    if entity.Position:DistanceSquared(npc.Position) < (entity.Size + npc.Size)^2 then
                        Exodus:SpawnCandleTear(entity)
                    end
                end
            end
        end
    end
    
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) and ItemVariables.OMINOUS_LANTERN.Lifted then
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
            Exodus:FireLantern(player.Position, Vector(-15 ,0), true)
        elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
            Exodus:FireLantern(player.Position, Vector(15, 0), true)
        elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
            Exodus:FireLantern(player.Position, Vector(0, -15), true)
        elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
            Exodus:FireLantern(player.Position, Vector(0, 15), true)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.ominousLanternRender)

function Exodus:ominousLanternUse()
    local player = Isaac.GetPlayer(0)
    
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
        if ItemVariables.OMINOUS_LANTERN.Fired == false then
            ItemVariables.OMINOUS_LANTERN.Fired = true
            ItemVariables.OMINOUS_LANTERN.Lifted = true
            ItemVariables.OMINOUS_LANTERN.Hid = true
            player:AnimateCollectible(ItemId.OMINOUS_LANTERN, "HideItem", "PlayerPickupSparkle")
        else
            ItemVariables.OMINOUS_LANTERN.Fired = false
            ItemVariables.OMINOUS_LANTERN.Lifted = false
        end
    else
        Exodus:FireLantern(player.Position, Vector.FromAngle(rng:RandomInt(360)):Resized(rng:RandomInt(10) + 3), false)
        Exodus:FireLantern(player.Position, Vector.FromAngle(rng:RandomInt(360)):Resized(rng:RandomInt(10) + 3), false)
        return true
    end
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.ominousLanternUse, ItemId.OMINOUS_LANTERN)

--<<<BASEBALL MITT>>>--
function Exodus:baseballMittUpdate()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR and entity.Variant == Entities.BASEBALL.variant and entity:IsDead() then
            local hit = Isaac.Spawn(Entities.BASEBALL_HIT.id, Entities.BASEBALL_HIT.variant, 0, entity.Position, NullVector, nil)
            hit:ToEffect():SetTimeout(20)
            hit.SpriteRotation = rng:RandomInt(360)
        end
    end
    
    if ItemVariables.BASEBALL_MITT.Used and player:HasCollectible(ItemId.BASEBALL_MITT) then
        player:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        
        if ItemVariables.BASEBALL_MITT.Lifted == false then
            player:AnimateCollectible(ItemId.BASEBALL_MITT, "LiftItem", "PlayerPickupSparkle")
            ItemVariables.BASEBALL_MITT.Lifted = true
        end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PROJECTILE then
                local playerPos = player.Position
                local bulletPos = entity.Position
                local distance = (playerPos):Distance(bulletPos)
                
                if distance > player.Size + entity.Size and distance <= 120 then
                    local nudgeVector = (playerPos - bulletPos) / (distance)
                    entity.Velocity = (entity.Velocity + nudgeVector):Resized(entity.Velocity:Length())
                elseif distance <= player.Size + entity.Size then
                    entity:Remove()
                    ItemVariables.BASEBALL_MITT.BallsCaught = ItemVariables.BASEBALL_MITT.BallsCaught + 1
                end
            end
        end
        
        if game:GetFrameCount() >= ItemVariables.BASEBALL_MITT.UseDelay + 120 or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) or
            Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) or
            Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
            player:AnimateCollectible(ItemId.BASEBALL_MITT, "HideItem", "PlayerPickupSparkle")
            ItemVariables.BASEBALL_MITT.Used = false
            
            if ItemVariables.BASEBALL_MITT.BallsCaught > 0 then
                repeat
                    local tear = player:FireTear(player.Position, Vector(10, 0):Rotated(rng:RandomInt(360)), false, true, false)
                    tear:ChangeVariant(Entities.BASEBALL.variant)
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BOUNCE 
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_CONFUSION
                    tear.CollisionDamage = player.Damage * 3
                            
                    ItemVariables.BASEBALL_MITT.BallsCaught = ItemVariables.BASEBALL_MITT.BallsCaught  - 1
                until ItemVariables.BASEBALL_MITT.BallsCaught == 0
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.baseballMittUpdate)

function Exodus:baseballMittDamage(target, amount, flags, source, cdtimer)
    if ItemVariables.BASEBALL_MITT.Used then
        return false
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.baseballMittDamage, EntityType.ENTITY_PLAYER)

function Exodus:baseballMittUse()
    ItemVariables.BASEBALL_MITT.Used = true
    ItemVariables.BASEBALL_MITT.Lifted = false
    ItemVariables.BASEBALL_MITT.BallsCaught = 0
    ItemVariables.BASEBALL_MITT.UseDelay = game:GetFrameCount()
    return true
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.baseballMittUse, ItemId.BASEBALL_MITT)

--<<<HURDLE HEELS>>>--
function Exodus:hurdleHeelsUpdate()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(ItemId.HURDLE_HEELS) then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
    
    if ItemVariables.HURDLE_HEELS.JumpState == 1 and ItemVariables.HURDLE_HEELS.FrameUsed + 8 < game:GetFrameCount() then
        ItemVariables.HURDLE_HEELS.JumpState = 2
        player.Visible = false
        player:SetShootingCooldown(120)
        player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        ItemVariables.HURDLE_HEELS.Crosshair = Isaac.Spawn(1000, 30, 0, player.Position, Vector(0,0), player)
        ItemVariables.HURDLE_HEELS.Crosshair.GridCollisionClass = GridCollisionClass.GRIDCOLL_NOPITS
        ItemVariables.HURDLE_HEELS.Crosshair.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
    
    if ItemVariables.HURDLE_HEELS.JumpState == 2 then
        player.Position = ItemVariables.HURDLE_HEELS.Crosshair.Position
        if Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y - 5)
        end
        if Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y + 5)
        end
        if Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X - 5, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y)
        end
        if Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X + 5, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y)
        end
        if ItemVariables.HURDLE_HEELS.Crosshair.FrameCount > 50 then
            ItemVariables.HURDLE_HEELS.JumpState = 3
        end
    end

    if ItemVariables.HURDLE_HEELS.JumpState == 3 then
        player.Position = ItemVariables.HURDLE_HEELS.Crosshair.Position
        if Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y - 5)
        end
        if Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y + 5)
        end
        if Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X - 5, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y)
        end
        if Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex) then
            ItemVariables.HURDLE_HEELS.Crosshair.Position = Vector(ItemVariables.HURDLE_HEELS.Crosshair.Position.X + 5, ItemVariables.HURDLE_HEELS.Crosshair.Position.Y)
        end
        if ItemVariables.HURDLE_HEELS.Crosshair.FrameCount > 60 then
            player.Position = ItemVariables.HURDLE_HEELS.Crosshair.Position
            ItemVariables.HURDLE_HEELS.Crosshair:Remove()
            ItemVariables.HURDLE_HEELS.JumpState = 4
            ItemVariables.HURDLE_HEELS.FrameUsed = game:GetFrameCount()
            player.Visible = true
            player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            player:UseActiveItem(CollectibleType.COLLECTIBLE_WAIT_WHAT, false, false, false, false)
            player.Position = ItemVariables.HURDLE_HEELS.Crosshair.Position
            for i, entity in pairs(Isaac.GetRoomEntities()) do
                if player.Position:Distance(entity.Position) < 64 and entity:IsVulnerableEnemy() then
                    entity:TakeDamage(player.Damage * 4, 0, EntityRef(player), 3)
                end
            end
        end
    end
    if ItemVariables.HURDLE_HEELS.JumpState == 4 and ItemVariables.HURDLE_HEELS.FrameUsed + 20 < game:GetFrameCount() then
        ItemVariables.HURDLE_HEELS.JumpState = 0
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.hurdleHeelsUpdate)

function Exodus:hurdleHeelsUse()
    local player = Isaac.GetPlayer(0)
    if ItemVariables.HURDLE_HEELS.JumpState == 0 then
        ItemVariables.HURDLE_HEELS.JumpState = 1
        ItemVariables.HURDLE_HEELS.FrameUsed = game:GetFrameCount()
        player.Velocity = Vector(0,0)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP, true, false, false, false)
        sfx:Play(SoundEffect.SOUND_SUPER_JUMP, 1, 0, false, 1)
    end
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.hurdleHeelsUse, ItemId.HURDLE_HEELS)

function Exodus:hurdleHeelsRender()
    local player = Isaac.GetPlayer(0)
    if ItemVariables.HURDLE_HEELS.JumpState == 2 then
        ItemVariables.HURDLE_HEELS.Icon:Render(game:GetRoom():WorldToScreenPosition(Vector(player.Position.X, player.Position.Y - ((ItemVariables.HURDLE_HEELS.Crosshair.FrameCount) * 32))), NullVector, NullVector)
    end
    if ItemVariables.HURDLE_HEELS.JumpState == 3 then
        ItemVariables.HURDLE_HEELS.Icon:Render(game:GetRoom():WorldToScreenPosition(Vector(player.Position.X, player.Position.Y - ((ItemVariables.HURDLE_HEELS.Crosshair.FrameCount - 60) * -32))), NullVector, NullVector)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.hurdleHeelsRender)

function Exodus:hurdleHeelsDamage(target, amount, flags, source, cdtimer)
    if ItemVariables.HURDLE_HEELS.JumpState > 0 then
        return false
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.hurdleHeelsDamage, EntityType.ENTITY_PLAYER)

function Exodus:hurdleHeelsCache(player, flag)
    if player:HasCollectible(ItemId.HURDLE_HEELS) and flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.1
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.hurdleHeelsCache)

--<<<DAD'S BOOTS>>>--
function Exodus:dadsBootsUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.DADS_BOOTS) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy(false) then
                for v, squishy in pairs(ItemVariables.DADS_BOOTS.Squishables) do
                    if squishy.id == entity.Type and (squishy.variant == entity.Variant or squishy.variant == nil) and (squishy.subtype == entity.SubType or squishy.subtype == nil) and
                    entity.Position:DistanceSquared(player.Position) < (player.Size + entity.Size)^2 and player.Velocity ~= NullVector and Exodus:PlayerIsMoving() then
                        entity:Die()
                        sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, entity.Size / 8)
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.dadsBootsUpdate)

function Exodus:dadsBootsDamage(target, amount, flag, source, cdtimer)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.DADS_BOOTS) then
        if flag == DamageFlag.DAMAGE_SPIKES or flag == DamageFlag.DAMAGE_ACID then
            return false
        end
        
        for i, squishy in pairs(ItemVariables.DADS_BOOTS.Squishables) do
            if squishy.id == source.Type and (squishy.variant == source.Variant or squishy.variant == nil) and (squishy.subtype == source.SubType or squishy.subtype == nil) then
                if Exodus:PlayerIsMoving() then
                    return false
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.dadsBootsDamage, EntityType.ENTITY_PLAYER)

function Exodus:dadsBootsCache(player, flag)
    if player:HasCollectible(ItemId.DADS_BOOTS) then
        if not ItemVariables.DADS_BOOTS.HasDadsBoots then
            player:AddNullCostume(CostumeId.DADS_BOOTS)
            ItemVariables.DADS_BOOTS.HasDadsBoots = true
        end
        
        if flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.1
        end
    elseif ItemVariables.DADS_BOOTS.HasDadsBoots then
        ItemVariables.DADS_BOOTS.HasDadsBoots = false
        player:TryRemoveNullCostume(CostumeId.DADS_BOOTS)
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.dadsBootsCache)

--<<<GLUTTONY'S STOMACH>>>--
function Exodus:gluttonysStomachUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.GLUTTONYS_STOMACH) and player:HasFullHearts() then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_HEART and player.Position:Distance(entity.Position) <= 32 then
                local sprite = entity:GetSprite()
                
                if sprite:IsPlaying("Idle") then 
                    local parts
                    local effect
                    
                    if entity.SubType == HeartSubType.HEART_HALF then
                        parts = 1
                        effect = Entities.PART_UP.variant
                    elseif entity.SubType == HeartSubType.HEART_FULL then
                        parts = 2
                        effect = Entities.PART_UP_UP.variant
                    elseif entity.SubType == HeartSubType.HEART_DOUBLEPACK then
                        parts = 4
                        effect = Entities.PART_UP_UP_UP.variant
                    else
                        return
                    end
                    
                    ItemVariables.GLUTTONYS_STOMACH.Parts = ItemVariables.GLUTTONYS_STOMACH.Parts + parts
                    
                    local heart = entity:ToPickup()
                    heart:PlayPickupSound()
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector(0, 0), entity)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, effect, 0, player.Position, Vector(0, 0), player)
                    entity:Remove()
                end
            end
        end    
    end
    
    if ItemVariables.GLUTTONYS_STOMACH.Parts >= 8 then
        ItemVariables.GLUTTONYS_STOMACH.Parts = ItemVariables.GLUTTONYS_STOMACH.Parts - 8
        player:AddMaxHearts(2, false)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.gluttonysStomachUpdate)

function Exodus:gluttonysStomachRender()
    local player = Isaac.GetPlayer(0)
    local playerType = player:GetPlayerType()
    local Hearts = player:GetMaxHearts() / 2
    local Bar = ItemVariables.GLUTTONYS_STOMACH.RenderBar
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    
    if player:HasCollectible(ItemId.GLUTTONYS_STOMACH) and playerType ~= PlayerType.PLAYER_THELOST and playerType ~= PlayerType.PLAYER_KEEPER and (level:GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN ~= LevelCurse.CURSE_OF_THE_UNKNOWN) and (room:GetType() ~= RoomType.ROOM_BOSS or room:GetFrameCount() >= 1) then
        Bar.Scale = Vector(1.3, 1.3)
        Bar:SetFrame("Heart", math.min(8, ItemVariables.GLUTTONYS_STOMACH.Parts))
        Bar:Render(Vector(36 + (12 * ((Hearts % 7) + math.floor(Hearts / 7))), 12 + (11 * math.floor(Hearts / 7))), Vector(0, 0), Vector(0, 0))
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.gluttonysStomachRender)

--<<<ARCADE TOKEN>>>--
function Exodus:arcadeTokenUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.ARCADE_TOKEN) and not ItemVariables.ARCADE_TOKEN.HasArcadeToken then
        ItemVariables.ARCADE_TOKEN.HasArcadeToken = true
        Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
    end
    
    if player:HasCollectible(ItemId.ARCADE_TOKEN) and player:GetNumCoins() == 99 then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COIN and entity:IsDead() and entity:GetData().Collected == nil then
                player:AddCoins(-99)
                player:AddCollectible(CollectibleType.COLLECTIBLE_ONE_UP, 0, false)
                entity:GetData().Collected = true
                local coin = entity:ToPickup()
                coin:PlayPickupSound()
                entity:Remove()
            end
        end    
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.arcadeTokenUpdate)

--<<<FORGET ME LATER>>>--
function Exodus:forgetMeLaterUpdate()
    local player = Isaac.GetPlayer(0)
    local level = game:GetLevel()
    
    if player:HasCollectible(ItemId.FORGET_ME_LATER) then
        if ItemVariables.FORGET_ME_LATER.HasForgetMeLater == false then
            ItemVariables.FORGET_ME_LATER.NumberFloors = level:GetAbsoluteStage() + math.random(2)
            ItemVariables.FORGET_ME_LATER.HasForgetMeLater = true
        end
    
        if player:GetSprite():IsPlaying("Trapdoor") and level:GetAbsoluteStage() >= ItemVariables.FORGET_ME_LATER.NumberFloors then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, false, false, false, false)
            player:RemoveCollectible(ItemId.FORGET_ME_LATER)
        end
    end  
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.forgetMeLaterUpdate)

--<<<THE FORBIDDEN FRUIT>>>--
function Exodus:forbiddenFruitCache(player, flag)
    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + (math.floor((ItemVariables.FORBIDDEN_FRUIT.UseCount^0.7) * 100)) / 101
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.forbiddenFruitCache)

function Exodus:forbiddenFruitUse()
    local player = Isaac.GetPlayer(0)
    
    if player:GetName() ~= "The Lost" and player:GetName() ~= "Keeper" then
        sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
        ItemVariables.FORBIDDEN_FRUIT.UseCount = ItemVariables.FORBIDDEN_FRUIT.UseCount + 1
        player:AddHearts(24)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()

        if player:GetSoulHearts() > 4 or player:GetMaxHearts() > 2 then
            if player:GetMaxHearts() == 0 then
                player:AddSoulHearts(-4)
                if math.random(2) == 1 then
                    Isaac.Spawn(5, 10, 7, player.Position, Vector(0, 0), player)
                end
            else
                player:AddMaxHearts(-2)
            end
        else
            player:Die()
            player:AddMaxHearts(-2)
            player:AddSoulHearts(-4)
        end
    end
    
    return true
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.forbiddenFruitUse, ItemId.FORBIDDEN_FRUIT)

--<<<PIG BLOOD>>>--
function Exodus:pigBloodUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.PIG_BLOOD) then
        if not ItemVariables.PIG_BLOOD.HasPigBlood then
            ItemVariables.PIG_BLOOD.HasPigBlood = true
            player:AddNullCostume(CostumeId.PIG_BLOOD)
            Isaac.Spawn(5, 10, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 10, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 10, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
        end
        
        if game:GetRoom():GetType() == RoomType.ROOM_DEVIL then
            for i, entity in pairs(Isaac.GetRoomEntities()) do
                local data = entity:GetData()
                
                if entity.Type == EntityType.ENTITY_PICKUP and entity:IsDead() and data.IsRestocked == nil and (entity.Variant == PickupVariant.PICKUP_COLLECTIBLE or entity.Variant == PickupVariant.PICKUP_SHOPITEM) then 
                    data.IsRestocked = true
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM, 0, entity.Position, NullVector, entity)
                end
            end
        end
    elseif ItemVariables.PIG_BLOOD.HasPigBlood then
        ItemVariables.PIG_BLOOD.HasPigBlood = false
        player:TryRemoveNullCostume(CostumeId.PIG_BLOOD)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.pigBloodUpdate)

--<<<HAND OF GREED>>>--
function Exodus:greedHandUpdate()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(ItemId.HAND_OF_GREED) then
        if not ItemVariables.HAND_OF_GREED.HasGreedHand then
            ItemVariables.HAND_OF_GREED.HasGreedHand = true
            if player:GetName() == "Keeper" then
                player:AddNullCostume(CostumeId.KEEPER_HAND_OF_GREED)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            else
                player:AddNullCostume(CostumeId.HAND_OF_GREED)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
                Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            end
        end

        if game:GetRoom():GetType() == RoomType.ROOM_DEVIL then
            for i, entity in pairs(Isaac.GetRoomEntities()) do
                if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity:ToPickup().Price ~= nil then
                    if entity:ToPickup().Price == PickupPrice.PRICE_ONE_HEART then
                        local price = 15
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                            price = 7
                        end
                        entity:ToPickup().Price = price
                    elseif entity:ToPickup().Price == PickupPrice.PRICE_TWO_HEARTS then
                        local price = 30
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                            price = 15
                        end
                        entity:ToPickup().Price = price
                    elseif entity:ToPickup().Price == PickupPrice.PRICE_THREE_SOULHEARTS then
                        local price = 15
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                            price = 7
                        end
                        entity:ToPickup().Price = price
                    end
                end
            end
        end
        ItemVariables.HAND_OF_GREED.RedHearts = player:GetMaxHearts()
        ItemVariables.HAND_OF_GREED.SoulHearts = player:GetSoulHearts()
        ItemVariables.HAND_OF_GREED.ActiveItem = player:GetActiveItem()
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.greedHandUpdate)

function Exodus:greedHandNewLevel()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.HAND_OF_GREED) then
        if player:GetName() == "Keeper" then
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
        else
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
            Isaac.Spawn(5, 20, 1, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Exodus.greedHandNewLevel)

local shopItems = {}
function Exodus:ShopInfo()
    local player = Isaac.GetPlayer(0)
    local entities = Isaac.GetRoomEntities()
    for i,entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP then
            local pickup = entity:ToPickup()
            if pickup:IsShopItem() then
                if shopItems[pickup.InitSeed] == nil then
                    local shopItemInfo = {}
                    local itemConfig = nil
                    if pickup.Variant == PickupVariant.PICKUP_TRINKET then
                        itemConfig = Isaac.GetItemConfig():GetTrinket(pickup.SubType)
                    elseif pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                        itemConfig = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
                    end
                    if itemConfig ~= nil then
                        shopItemInfo.pickup = pickup
                        shopItemInfo.variant = pickup.Variant
                        shopItemInfo.subType = pickup.SubType
                        shopItemInfo.value = pickup:GetCoinValue()
                        shopItemInfo.price = pickup.Price
                        shopItemInfo.devilPrice = itemConfig.DevilPrice
                        shopItemInfo.name = itemConfig.Name
                        shopItems[pickup.InitSeed] = shopItemInfo
                    end
                end
            end
        end
    end
    for initSeed,info in pairs(shopItems) do
        if (info.pickup:IsDead() == true or info.pickup:IsShopItem() == false or (info.pickup.Touched == true and info.subType ~= info.pickup.SubType)) and game:GetRoom():GetType() == RoomType.ROOM_DEVIL then
            if info.price == 15 then
                local price = 15
                if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                    price = 7
                end
                player:AddMaxHearts(2, false)
                player:AddHearts(2)
                if player:GetNumCoins() >= price then
                    player:AddCoins(-price)
                else
                    player:Die()
                end
            elseif info.price == 30 then
                local price = 30
                if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                    price = 15
                end
                player:AddMaxHearts(4, false)
                player:AddHearts(4)
                if player:GetNumCoins() >= price then
                    player:AddCoins(-price)
                else
                    player:Die()
                end
            elseif info.price == 15 then
                local price = 15
                if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                    price = 7
                end
                player:AddSoulHearts(6)
                if player:GetNumCoins() >= price then
                    player:AddCoins(-price)
                else
                    player:Die()
                end
            end
            shopItems[initSeed] = nil
        elseif info.pickup.Touched == false and info.subType ~= info.pickup.SubType then
            shopItems[initSeed] = nil
            -- Rerolled --
        elseif info.pickup:Exists() == false or (info.pickup.Touched == false and info.subType ~= info.pickup.SubType) then
            shopItems[initSeed] = nil
            -- Doesn't Exist --
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.ShopInfo)

function Exodus:greedHandNewRoom() shopItems = {} return nil end
Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.greedHandNewRoom)

--<<<YIN AND YANG>>>--
function Exodus:yinyangUpdate()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.YIN) or player:HasCollectible(ItemId.YANG) then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.yinyangUpdate)

function Exodus:yinyangCache(player, flag)
    local heartmap = player:GetBlackHearts()
    local blackhearts = 0
    while heartmap > 0 do
        heartmap = heartmap - 2^(math.floor(math.log(heartmap) / math.log(2)))
        blackhearts = blackhearts + 1
    end
    local soulhearts = player:GetSoulHearts() - (blackhearts * 2)
    if flag == CacheFlag.CACHE_FIREDELAY and player:HasCollectible(ItemId.YIN) then
        if player:HasCollectible(ItemId.YANG) then
            player.MaxFireDelay = player.MaxFireDelay - blackhearts
        else
            player.MaxFireDelay = player.MaxFireDelay - blackhearts + math.ceil(soulhearts / 2)
        end
    end
    if flag == CacheFlag.CACHE_DAMAGE and player:HasCollectible(ItemId.YANG) then
        if player:HasCollectible(ItemId.YIN) then
            player.Damage = player.Damage + (soulhearts / 2)
        else
            player.Damage = player.Damage + (soulhearts / 2) - blackhearts
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.yinyangCache)

--<<<WELCOME MAT>>>--
function Exodus:welcomeMatUpdate()
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()

    if player:HasCollectible(ItemId.WELCOME_MAT) then
        if ItemVariables.WELCOME_MAT.Position ~= nil then
            if (player.Position:DistanceSquared(ItemVariables.WELCOME_MAT.Position) <= 100^2) then
                ItemVariables.WELCOME_MAT.CloseToMat = true
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
            else
                ItemVariables.WELCOME_MAT.CloseToMat = false
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
            end
        end
    end
    
    if player:HasCollectible(ItemId.WELCOME_MAT) then
        if not ItemVariables.WELCOME_MAT.Placed then
            ItemVariables.WELCOME_MAT.Placed = true
            ItemVariables.WELCOME_MAT.AppearFrame = 0
            local mat = Isaac.Spawn(Entities.WELCOME_MAT.id, 0, 0, player.Position, Vector(0, 0), player)
            local sprite = mat:GetSprite()
            sprite:Play("Appear", false)
            mat.Visible = false
            
            ItemVariables.WELCOME_MAT.Position = mat.Position
            mat:Remove()
        elseif ItemVariables.WELCOME_MAT.AppearFrame ~= nil then
            local mat = Isaac.Spawn(Entities.WELCOME_MAT.id, 0, 0, ItemVariables.WELCOME_MAT.Position, Vector(0, 0), player)
            local sprite = mat:GetSprite()
            ItemVariables.WELCOME_MAT.AppearFrame = ItemVariables.WELCOME_MAT.AppearFrame + 1
            sprite:SetFrame("Appear", ItemVariables.WELCOME_MAT.AppearFrame)

            for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
                local door = room:GetDoor(i)
                
                if (door ~= nil) then
                    if (player.Position:DistanceSquared(door.Position) <= 100^2) then
                        ItemVariables.WELCOME_MAT.Direction = door.Direction
                    end
                end
            end
            
            if ItemVariables.WELCOME_MAT.Direction == Direction.LEFT then
                sprite.Rotation = sprite.Rotation + 90
            elseif ItemVariables.WELCOME_MAT.Direction == Direction.UP then
                sprite.Rotation = sprite.Rotation + 180
            elseif ItemVariables.WELCOME_MAT.Direction == Direction.RIGHT then
                sprite.Rotation = sprite.Rotation + 270
            end
            if ItemVariables.WELCOME_MAT.AppearFrame <= 3 then
                mat:Remove()
            elseif ItemVariables.WELCOME_MAT.AppearFrame == 11 then
                mat:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
                ItemVariables.WELCOME_MAT.AppearFrame = nil
            else
                mat:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Exodus.welcomeMatUpdate)

function Exodus:welcomeMatNewRoom()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.WELCOME_MAT) then
        ItemVariables.WELCOME_MAT.Placed = false
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.welcomeMatNewRoom)

function Exodus:welcomeMatNewLevel()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.WELCOME_MAT) then
        ItemVariables.WELCOME_MAT.Placed = true
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Exodus.welcomeMatNewLevel)

function Exodus:welcomeMatCache(player, flag)
    if ItemVariables.WELCOME_MAT.Position ~= nil then
        if flag == CacheFlag.CACHE_FIREDELAY and player:HasCollectible(ItemId.WELCOME_MAT) and ItemVariables.WELCOME_MAT.CloseToMat then
            player.MaxFireDelay = player.MaxFireDelay - 3
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.welcomeMatCache)

--<<<MYSTERIOUS MUSTACHE>>>--
function Exodus:mysteriousMustacheUpdate()
    local player = Isaac.GetPlayer(0)
    local currentSoulHearts = player:GetSoulHearts()
    
    if player:HasCollectible(ItemId.MYSTERIOUS_MUSTACHE) then
        if not ItemVariables.MYSTERIOUS_MUSTACHE.HasMysteriousMoustache then
            player:AddNullCostume(CostumeId.MYSTERIOUS_MUSTACHE)
            ItemVariables.MYSTERIOUS_MUSTACHE.HasMysteriousMoustache = true
        end
        
        if player:GetCollectibleCount() > ItemVariables.MYSTERIOUS_MUSTACHE.ItemCount and game:GetRoom():GetType() == RoomType.ROOM_SHOP and rng:RandomInt(2) == 1 then
            player:AddHearts(1)
            
            if currentSoulHearts ~= player:GetSoulHearts() then
                currentSoulHearts = player:GetSoulHearts()
                player:AddHearts(-1 * currentSoulHearts)
                player:AddHearts(1)
                player:AddSoulHearts(currentSoulHearts)
            end
        end
        
        if player:GetNumCoins() < ItemVariables.MYSTERIOUS_MUSTACHE.CoinCount and game:GetRoom():GetType() == RoomType.ROOM_SHOP and rng:RandomInt(100) == 1 then
            player:AddCoins(ItemVariables.MYSTERIOUS_MUSTACHE.CoinCount - player:GetNumCoins())
        end
    elseif ItemVariables.MYSTERIOUS_MUSTACHE.HasMysteriousMoustache then
        ItemVariables.MYSTERIOUS_MUSTACHE.HasMysteriousMoustache = false
        player:TryRemoveNullCostume(CostumeId.MYSTERIOUS_MUSTACHE)
    end
    
    ItemVariables.MYSTERIOUS_MUSTACHE.ItemCount = player:GetCollectibleCount()
    ItemVariables.MYSTERIOUS_MUSTACHE.CoinCount = player:GetNumCoins()
end
  
Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.mysteriousMustacheUpdate)

--<<<WRATH OF THE LAMB>>>--
function Exodus:wotlUse()
    local player = Isaac.GetPlayer(0)
    local level = game:GetLevel()
    local stat = rng:RandomInt(4)
    
    if stat == 0 then
        ItemVariables.WRATH_OF_THE_LAMB.Stats.Damage = ItemVariables.WRATH_OF_THE_LAMB.Stats.Damage + 1
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    elseif stat == 1 then
        ItemVariables.WRATH_OF_THE_LAMB.Stats.Speed = ItemVariables.WRATH_OF_THE_LAMB.Stats.Speed + 1
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    elseif stat == 2 then
        ItemVariables.WRATH_OF_THE_LAMB.Stats.Range = ItemVariables.WRATH_OF_THE_LAMB.Stats.Range + 1
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
    elseif stat == 3 then
        ItemVariables.WRATH_OF_THE_LAMB.Stats.FireDelay = ItemVariables.WRATH_OF_THE_LAMB.Stats.FireDelay + 1
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    else
        Error("Invalid stat rolled - Value: " .. tostring(stat))
    end
    
    music:PitchSlide(0.5)
    player:EvaluateItems()
    
    local mark = Isaac.Spawn(Entities.SUMMONING_MARK.id, Entities.SUMMONING_MARK.variant, 0, player.Position, Vector(0, 0), player)
    mark:GetSprite():SetFrame("Idle", 0)
    mark:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
    table.insert(ItemVariables.WRATH_OF_THE_LAMB.Uses, { Room = level:GetCurrentRoomIndex(), Mark = mark, BossSpawned = false, Countdown = 65 })
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.wotlUse, ItemId.WRATH_OF_THE_LAMB)

function Exodus:wotlCache(player, cacheFlag)
    local damageBonus = 0.5 * ItemVariables.WRATH_OF_THE_LAMB.Stats.Damage
    local speedBonus = 0.1 * ItemVariables.WRATH_OF_THE_LAMB.Stats.Speed
    local rangeBonus = 2 * ItemVariables.WRATH_OF_THE_LAMB.Stats.Range
    local fireDelayBonus = ItemVariables.WRATH_OF_THE_LAMB.Stats.FireDelay
    
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - damageBonus
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = math.max(0.6, player.MoveSpeed - speedBonus)
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight + rangeBonus
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay + fireDelayBonus
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.wotlCache)

function Exodus:wotlUpdate()
    local player = Isaac.GetPlayer(0)
    local level = game:GetLevel()
    local room = game:GetRoom()
    
    for i, tbl in pairs(ItemVariables.WRATH_OF_THE_LAMB.Uses) do
        if tbl then
            if tbl.Countdown >= 0 then
                tbl.Countdown = tbl.Countdown - 1
            elseif not tbl.BossSpawned then
                tbl.BossSpawned = true
                
                local stage = level:GetAbsoluteStage()
                local pool
                
                if stage == 11 then
                    if level:GetStageType() == StageType.STAGETYPE_WOTL then
                        Isaac.ExecuteCommand("stage 11")
                    else
                        player:UseCard(Card.CARD_EMPEROR)
                    end
                elseif stage <= 8 then
                    if stage % 2 == 1 then
                        pool = ItemVariables.WRATH_OF_THE_LAMB.Bosses[(stage + 1) / 2]
                    else
                        pool = ItemVariables.WRATH_OF_THE_LAMB.Bosses[stage / 2]
                    end
                elseif stage <= 10 then
                    pool = ItemVariables.WRATH_OF_THE_LAMB.Bosses[stage - 4]
                else
                    pool = ItemVariables.WRATH_OF_THE_LAMB.Bosses[#ItemVariables.WRATH_OF_THE_LAMB.Bosses]
                end
                
                tbl.Boss = Isaac.Spawn(pool[rng:RandomInt(#pool) + 1], 0, 0, tbl.Mark.Position, Vector(0, 0), nil)
                
                if music:GetCurrentMusicID() ~= MusicId.LOCUS then
                    music:Crossfade(MusicId.LOCUS)
                end
                
                music:PitchSlide(1)
                
                room:SetClear(false)
            elseif not tbl.Boss:IsDead() then
                for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
                    local door = room:GetDoor(i)
                    
                    if door ~= nil then
                        local tarType = door.TargetRoomType
                        local curType = door.CurrentRoomType
                        
                        if (tarType ~= RoomType.ROOM_SECRET and tarType ~= RoomType.ROOM_SUPERSECRET and curType ~= RoomType.ROOM_SECRET and curType ~= RoomType.ROOM_SUPERSECRET and not door:IsLocked()) or door:IsOpen() then
                            door:Bar()
                        end
                    end
                end
            elseif room:IsClear() then
                music:Play(Music.MUSIC_BOSS_OVER, 0.1)
                
                local payout = rng:RandomInt(100)
                
                if payout < 70 then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                elseif payout < 75 then
                    for i = 1, 2 do
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                    end
                elseif payout < 80 then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                elseif payout < 85 then
                    for i = 1, 2 do
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                    end
                elseif payout < 90 then
                    for i = 1, 3 do
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                    end
                elseif payout < 95 then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(tbl.Mark.Position, 20), Vector(0, 0), player)
                end
                
                table.remove(ItemVariables.WRATH_OF_THE_LAMB.Uses, i)
                
                i = i - 1
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.wotlUpdate)

function Exodus:wotlPEffectUpdate()
    for i, tbl in pairs(ItemVariables.WRATH_OF_THE_LAMB.Uses) do
        if tbl.Countdown >= 0 then
            local mark = Isaac.Spawn(Entities.SUMMONING_MARK.id, Entities.SUMMONING_MARK.variant, 0, tbl.Mark.Position, Vector(0, 0), nil)
            mark:GetSprite():SetFrame("Idle", 21 - (tbl.Countdown % 22))
            mark:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Exodus.wotlPEffectUpdate)

function Exodus:wotlNewRoom()
    ItemVariables.WRATH_OF_THE_LAMB.Uses = {}
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.wotlNewRoom)

--<<<BIG SCISSORS>>>--
function Exodus:bigScissorsUpdate()
    local player = Isaac.GetPlayer(0)
    
    if ItemVariables.BIG_SCISSORS.Triggered and rng:RandomInt(3) == 0 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 3, player.Position, Vector(0, 0), player)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.bigScissorsUpdate)

function Exodus:bigScissorsDamage(target, amount, flags, source, cdtimer)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.BIG_SCISSORS) then
        ItemVariables.BIG_SCISSORS.Triggered = true
        
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end 
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.bigScissorsDamage, EntityType.ENTITY_PLAYER)

function Exodus:bigScissorsNewRoom()
    local player = Isaac.GetPlayer(0)
    
    ItemVariables.BIG_SCISSORS.Triggered = false
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.bigScissorsNewRoom)

function Exodus:bigScissorsCache(player, flag)
    if player:HasCollectible(ItemId.BIG_SCISSORS) then
        if flag == CacheFlag.CACHE_SPEED then
            if not ItemVariables.BIG_SCISSORS.Triggered then
                player.MoveSpeed = player.MoveSpeed + 0.4
            end
        end
        if flag == CacheFlag.CACHE_FIREDELAY then
            if ItemVariables.BIG_SCISSORS.Triggered then
                player.MaxFireDelay = player.MaxFireDelay - 2
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.bigScissorsCache)
  
--<<<CURSED METRONOME>>>--
function Exodus:cursedMetronomeUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.CURSED_METRONOME) then
        if not ItemVariables.CURSED_METRONOME.HasCursedMetronome then
            local maxhp = player:GetMaxHearts() - 2
            player:AddHearts(maxhp * -1)
            maxhp = maxhp + 2
            for i = 1, rng:RandomInt(maxhp / 2) do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL,  Isaac.GetFreeNearPosition(player.Position, 20), Vector(0, 0), player)
            end
            
            player:AddNullCostume(CostumeId.CURSED_METRONOME)
            ItemVariables.CURSED_METRONOME.HasCursedMetronome = true
        end
    elseif ItemVariables.CURSED_METRONOME.HasCursedMetronome then
        ItemVariables.CURSED_METRONOME.HasCursedMetronome = false
        player:TryRemoveNullCostume(CostumeId.CURSED_METRONOME)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.cursedMetronomeUpdate)

function Exodus:cursedMetronomeDamage(target, amount, flags, source, cdtimer)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.CURSED_METRONOME) then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_METRONOME, false, false, false, false)
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.cursedMetronomeDamage, EntityType.ENTITY_PLAYER)

function Exodus:cursedMetronomeCache(player, flag)
    if player:HasCollectible(ItemId.CURSED_METRONOME) then
        if flag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck - 2
        end
    end
end
  
Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.cursedMetronomeCache)
  
--<<<TRAGIC MUSHROOM>>>--
function Exodus:tragicMushroomCache(player, flag)
    for i = 1, ItemVariables.TRAGIC_MUSHROOM.Uses do
        local ratio = 1 / (1<<(i - 1))
        
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = (player.Damage + (0.8 * ratio)) * (ratio + 1)
        elseif flag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - (7.25 * ratio)
        elseif flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (0.6 * ratio)
        end
    end
end
    
Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.tragicMushroomCache)

function Exodus:tragicMushroomUse()
    local player = Isaac.GetPlayer(0)
    
    if player:GetMaxHearts() == 2 and player:GetSoulHearts() == 0 then
        player:AddHearts(-player:GetHearts())
    else
        if player:GetPlayerType() == PlayerType.PLAYER_XXX then
            local maxhp = player:GetSoulHearts() - 2
            player:AddSoulHearts(-maxhp)
        else
            local maxhp = player:GetMaxHearts() - 2
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddMaxHearts(-maxhp)
        end
    end
    
    ItemVariables.TRAGIC_MUSHROOM.Uses = ItemVariables.TRAGIC_MUSHROOM.Uses + 1
    sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE + CacheFlag.CACHE_RANGE + CacheFlag.CACHE_SPEED)
    player:EvaluateItems()
    player:RemoveCollectible(ItemId.TRAGIC_MUSHROOM)
    
    return true
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.tragicMushroomUse, ItemId.TRAGIC_MUSHROOM)

--<<<TECH 360>>>--
function Exodus:tech360Update()
    local player = Isaac.GetPlayer(0)
    local entities = Isaac.GetRoomEntities()
    
    if player:HasCollectible(ItemId.TECH_360) then
        if not ItemVariables.TECH_360.HasTech360 then
            ItemVariables.TECH_360.HasTech360 = true
            player:AddNullCostume(CostumeId.TECH_360)
            player:AddCacheFlags(CacheFlag.CACHE_RANGE)
            player:EvaluateItems()
        end
    
        for i, entity in pairs(entities) do 
            local data = entity:GetData()
            
            if entity.Type == EntityType.ENTITY_LASER and data.Tech360 and data.LudoTear == nil then
                entity.Position = player.Position
                entity.Velocity = player.Velocity
            end

            if entity.Type == EntityType.ENTITY_TEAR and entity.Visible then
                if entity:ToTear().TearFlags & TearFlags.TEAR_LUDOVICO ~= 0 then
                    entity.Visible = false
                    local laser = player:FireTechXLaser(entity.Position, entity.Velocity, math.abs(player.TearHeight * 3))
                    laser.TearFlags = laser.TearFlags | TearFlags.TEAR_CONTINUUM
                    laser.Color = player.TearColor
                    laser:GetData().Tech360 = true
                    laser:GetData().LudoTear = entity
                    entity.SpawnerType = EntityType.ENTITY_TEAR
                end
            elseif entity.Type == EntityType.ENTITY_LASER and data.Tech360 and data.LudoTear ~= nil then
                entity.Position = entity:GetData().LudoTear.Position
                if entity.FrameCount % 50 == 0 then
                    for u = 1, 6 do
                        local laser = player:FireTechLaser(entity.Position, 3193, Vector.FromAngle(u * (60 + rng:RandomInt(11) - 5)), false, false)
                        laser.TearFlags = laser.TearFlags | TearFlags.TEAR_SPECTRAL
                        laser.Color = player.TearColor
                        laser.DisableFollowParent = true
                    end
                end
                return
            end

            if entity.Type == EntityType.ENTITY_TEAR and entity.Variant ~= TearVariant.CHAOS_CARD and entity.Variant ~= TearVariant.BOBS_HEAD and entity.SpawnerType == EntityType.ENTITY_PLAYER then
                entity:Remove()
                
                local laser = player:FireTechXLaser(player.Position, player.Velocity, 1)
                laser.TearFlags = laser.TearFlags | TearFlags.TEAR_CONTINUUM
                laser.Color = player.TearColor
                laser:GetData().Tech360 = true
                entity.SpawnerType = EntityType.ENTITY_TEAR
            end
      
            if entity.Type == EntityType.ENTITY_LASER and entity.SpawnerType == EntityType.ENTITY_PLAYER and entity.Variant == 2 and 
            (data.Tech360 or player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)) then
                entity.Color = player.TearColor
                entity = entity:ToLaser()
                    
                if (player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) and entity.Radius > math.abs(player.TearHeight * 6)) or
                (entity.Radius > math.abs(player.TearHeight * 3) and player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) == false) then
                    entity:Remove()
                    
                    for u = 1, 6 do
                        local laser = player:FireTechLaser(entity.Position, 3193, Vector.FromAngle(u * (60 + rng:RandomInt(11) - 5)), false, false)
                        laser.TearFlags = laser.TearFlags | TearFlags.TEAR_SPECTRAL
                        laser.Color = player.TearColor
                        laser.DisableFollowParent = true
                    end
                elseif not(entity.Radius > math.abs(player.TearHeight * 3) and player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) == false) then
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) and entity.FrameCount < 80 then
                        entity.Radius = 10
                    else
                        entity.Radius = entity.Radius + Exodus:GetTech360Size()
                    end
                end
            
                if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) and entity.FrameCount == 30 then
                    entity:Remove()
                    
                    local laser = player:FireTechXLaser(entity.Position, RandomVector() * (entity.Radius / 20), entity.Radius)
                    laser.TearFlags = laser.TearFlags | TearFlags.TEAR_CONTINUUM
                    laser.Color = player.TearColor
                    laser:GetData().Tech360 = true
                    laser:GetData().TechX = true
                end
            end
        end
    elseif ItemVariables.TECH_360.HasTech360 then
        ItemVariables.TECH_360.HasTech360 = false
        player:TryRemoveNullCostume(CostumeId.TECH_360)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.tech360Update)

function Exodus:tech360Cache(player, flag)
    if player:HasCollectible(ItemId.TECH_360) and flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay * 3 - 2
    end
    if player:HasCollectible(ItemId.TECH_360) and flag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight * 1.25
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.tech360Cache)

--<<<SAD TEARS>>>--
function Exodus:sadTearsUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.SAD_TEARS) then
        if not ItemVariables.SAD_TEARS.HasSadTears then
            ItemVariables.SAD_TEARS.HasSadTears = true
            player:AddNullCostume(CostumeId.SAD_TEARS)
        end
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_TEAR and entity:GetData().IsSadTear ~= true then
                if player.FireDelay == player.MaxFireDelay and rng:RandomInt(math.max(1, 5 - player.Luck)) == 0 and entity.FrameCount > 1 then
                    local shot_tear = player:FireTear(entity.Position, RandomVector() * entity.Velocity:Length() * ((player.ShotSpeed + 0.4) / player.ShotSpeed), false, false, false)
                    shot_tear:GetData().IsSadTear = true
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.sadTearsUpdate)

function Exodus:sadTearsCache(player, flag)
    if player:HasCollectible(ItemId.SAD_TEARS) and flag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = math.max(player.ShotSpeed - 0.35, 0.4)
    end
    if player:HasCollectible(ItemId.SAD_TEARS) and flag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight - 2.5
    end
end
    
Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.sadTearsCache)

--<<<DEJA VU>>>--
function Exodus:dejaVuUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.DEJA_VU) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_TEAR and entity:GetData().ReturnChance == nil and entity:IsDead() then
                entity:GetData().ReturnChance = 50 + player.Luck
                if rng:RandomInt(100) < entity:GetData().ReturnChance then
                    local tear = player:FireTear(player.Position, entity.Velocity, true, true, true)
                    tear:GetData().ReturnChance = entity:GetData().ReturnChance // 2
                else
                    entity:GetData().ReturnChance = 0
                end
            elseif entity.Type == EntityType.ENTITY_TEAR and entity:GetData().ReturnChance ~= nil and entity:IsDead() then
                if rng:RandomInt(100) < entity:GetData().ReturnChance then
                    local tear = player:FireTear(player.Position, entity.Velocity, true, true, true)
                    tear:GetData().ReturnChance = entity:GetData().ReturnChance // 2
                else
                    entity:GetData().ReturnChance = 0
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.dejaVuUpdate)

--<<<HUNGRY HIPPO>>>--
function Exodus:hungryHippoCache(player, flag)
    if flag == CacheFlag.CACHE_FAMILIARS and player:HasCollectible(ItemId.HUNGRY_HIPPO) then
        player:CheckFamiliar(Entities.HUNGRY_HIPPO.variant, player:GetCollectibleNum(ItemId.HUNGRY_HIPPO), rng)
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.hungryHippoCache)

function Exodus:hungryHippoInit(hippo)
    local player = Isaac.GetPlayer(0)
    
    hippo.OrbitLayer = 98
    hippo.Position = hippo:GetOrbitPosition(player.Position + player.Velocity)
    hippo.Visible = false
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Exodus.hungryHippoInit, Entities.HUNGRY_HIPPO.variant)

function Exodus:hungryHippoUpdate(hippo)
    local player = Isaac.GetPlayer(0)
    local data = hippo:GetData()
    local sprite = hippo:GetSprite()
    
    if hippo.FrameCount >= 1 then
        hippo.Visible = true
    else
        hippo.Visible = false
    end
    
    if hippo.FrameCount == 1 then
        hippo.SpawnerVariant = 0
        hippo.SpawnerType = 0
    end
    
    hippo.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
    hippo.OrbitDistance = Vector(35 + (hippo.State * 15), 35 + (hippo.State * 15))
    
    if player:HasTrinket(TrinketType.TRINKET_CHILD_LEASH) then
        hippo.OrbitDistance = hippo.OrbitDistance / 2
    end
    
    hippo.OrbitSpeed = 0.03
    hippo.FireCooldown = 32
    
    if not Exodus:PlayerIsMoving() then
        hippo.Position = hippo:GetOrbitPosition(player.Position + player.Velocity)
    end
    
    hippo.Velocity = hippo:GetOrbitPosition(player.Position + player.Velocity) - hippo.Position
    hippo.GridCollisionClass = 0
    hippo.CollisionDamage = hippo.State * (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS) + 1)
    
    local closestEnemyDistance = 999999999
    local closestEnemy = nil
    
    if data.HasFired ~= 0 and data.HasFired ~= nil then
        data.HasFired = data.HasFired - 1
    end
    
    if data.HasSucc then
        sprite:Play("Succ "..tostring(math.floor(hippo.SpawnerVariant / 15) + 1), false)
    else
        sprite:Play(tostring(math.floor(hippo.SpawnerVariant / 15) + 1), false)
    end
    
    if hippo.State > 4 then 
        hippo.State = 4 
    elseif hippo.State == 0 then 
        hippo.State = 1 
    end
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local checkDist = entity.Position:DistanceSquared(hippo.Position)
        
        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
            if checkDist < closestEnemyDistance then
                closestEnemyDistance = checkDist
                closestEnemy = entity
            end
        end
        
        if hippo.State == 4 and entity.Type == EntityType.ENTITY_BOMBDROP and entity.SpawnerType ~= EntityType.ENTITY_PLAYER then
            if checkDist < 24^2 then
                entity:Remove()
                Isaac.Explode(hippo.Position, player, 60)
            end
            
            entity.Velocity = entity.Velocity + (hippo.Position - entity.Position) / 25
        end
        
        if entity.Type == EntityType.ENTITY_PROJECTILE then
            if checkDist < 24^2 then
                entity:Die()
                
                if hippo.State ~= 4 then
                    hippo.SpawnerVariant = hippo.SpawnerVariant + 1
                    hippo.State = math.floor(hippo.SpawnerVariant / 15) + 1
                end
                
                if hippo.State == 1 then
                    hippo.SpawnerType = 0
                else
                    hippo.SpawnerType = hippo.SpawnerType + 1
                end
            end
            
            if checkDist < 75^2 and hippo.State >= 3 then
                entity.Velocity = entity.Velocity + (hippo.Position - entity.Position) / 25
            end
        end
    end
    
    if hippo.SpawnerType >= hippo.FireCooldown then
        hippo.SpawnerType = hippo.FireCooldown - 1
    end
    
    local canShoot = false
    local shootDir
    
    if closestEnemy and hippo.FrameCount % (hippo.FireCooldown - hippo.SpawnerType) == 0 and hippo.SpawnerType ~= 0 and hippo.State ~= 1 then
        data.HasSucc = true
        canShoot = true
        hippo.SpawnerType = hippo.SpawnerType - 1
        data.HasFired = 4
        shootDir = (closestEnemy.Position - hippo.Position):Normalized()
    else
        if data.HasFired == 0 or data.HasFired == nil then
            data.HasSucc = false
        end
    end
    
    if canShoot then
        local tear = hippo:FireProjectile(shootDir)
        tear:ChangeVariant(1)
        tear.Scale = 1 * (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS) / 4 + 1)
        tear.CollisionDamage = 2 * (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS) + 1)
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL
    end
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Exodus.hungryHippoUpdate, Entities.HUNGRY_HIPPO.variant)

--<<<SUNDIAL>>>--
function Exodus:sundialCache(player, flag)
    if flag == CacheFlag.CACHE_FAMILIARS and player:HasCollectible(ItemId.SUNDIAL) then
        player:CheckFamiliar(Entities.SUN.variant, player:GetCollectibleNum(ItemId.SUNDIAL), rng)
        player:CheckFamiliar(Entities.SHADOW.variant, player:GetCollectibleNum(ItemId.SUNDIAL), rng)
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.sundialCache)

function Exodus:sunInit(sun)
    local player = Isaac.GetPlayer(0)
    
    sun.OrbitLayer = 98
    sun.Position = sun:GetOrbitPosition(player.Position + player.Velocity)
    sun.Visible = false
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Exodus.sunInit, Entities.SUN.variant)

function Exodus:shadowInit(shadow)
    local player = Isaac.GetPlayer(0)
    
    shadow.OrbitLayer = 98
    shadow.Position = shadow:GetOrbitPosition(player.Position + player.Velocity)
    shadow.Visible = false
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Exodus.shadowInit, Entities.SHADOW.variant)

function Exodus:sunUpdate(sun)
    local player = Isaac.GetPlayer(0)
    
    if sun.FrameCount >= 1 then
        sun.Visible = true
    else
        sun.Visible = false
    end

    if not player:HasCollectible(ItemId.SUNDIAL) then
        sun:Remove()
    end
    
    if math.random(12) == 1 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, Vector(sun.Position.X, sun.Position.Y - 8), RandomVector() * ((math.random() * 4) + 1), player)
    end

    if sun.FrameCount == 1 then
        sun.SpawnerVariant = 0
        sun.SpawnerType = 0
    end

    sun.OrbitDistance = Vector(64, 64)
    
    if player:HasTrinket(TrinketType.TRINKET_CHILD_LEASH) then
        sun.OrbitDistance = sun.OrbitDistance / 2
    end
    
    sun.OrbitSpeed = 0.02

    if not Exodus:PlayerIsMoving() then
        sun.Position = sun:GetOrbitPosition(player.Position + player.Velocity)
    end
    
    sun.Velocity = sun:GetOrbitPosition(player.Position + player.Velocity) - sun.Position
    sun.GridCollisionClass = 0

    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
            if sun.Position:Distance(entity.Position) < 24 and entity:IsFlying() then
                entity:AddBurn(EntityRef(sun), 100, 1)
                entity:TakeDamage(2, 0, EntityRef(sun), 3)
                if math.random(4) == 1 then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, Vector(sun.Position.X, sun.Position.Y - 8), RandomVector() * ((math.random() * 4) + 1), player)
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Exodus.sunUpdate, Entities.SUN.variant)

function Exodus:shadowUpdate(shadow)
    local player = Isaac.GetPlayer(0)
    local sprite = shadow:GetSprite()
    
    if shadow.FrameCount >= 1 then
        shadow.Visible = true
    else
        shadow.Visible = false
    end

    if not player:HasCollectible(ItemId.SUNDIAL) then
        shadow:Remove()
    end

    if shadow.FrameCount == 1 then
        shadow.SpawnerVariant = 0
        shadow.SpawnerType = 0
    end

    shadow.OrbitDistance = Vector(64, 64)
    
    if player:HasTrinket(TrinketType.TRINKET_CHILD_LEASH) then
        shadow.OrbitDistance = shadow.OrbitDistance / 2
    end
    
    shadow.OrbitSpeed = 0.02

    if not Exodus:PlayerIsMoving() then
        shadow.Position = shadow:GetOrbitPosition(player.Position + player.Velocity)
    end
    
    shadow.Velocity = shadow:GetOrbitPosition(player.Position + player.Velocity) - shadow.Position
    shadow.GridCollisionClass = 0

    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
            if shadow.Position:Distance(entity.Position) < 24 and not entity:IsFlying() then
                entity:AddFear(EntityRef(shadow), 100)
                entity:TakeDamage(2, 0, EntityRef(shadow), 3)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Exodus.shadowUpdate, Entities.SHADOW.variant)

--<<<ASTRO BABY>>>--
function Exodus:astroBabyCache(player, flag)
    if player:HasCollectible(ItemId.ASTRO_BABY) and flag == CacheFlag.CACHE_FAMILIARS then
        player:CheckFamiliar(Entities.ASTRO_BABY.variant, player:GetCollectibleNum(ItemId.ASTRO_BABY) + ItemVariables.ASTRO_BABY.UsedBox, rng)
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.astroBabyCache)

function Exodus:astroBabyInit(astro)
    astro.IsFollower = true
    astro:GetData().FireDelay = 10
  
    local sprite = astro:GetSprite()
    sprite:Play("IdleDown")
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Exodus.astroBabyInit, Entities.ASTRO_BABY.variant)

function Exodus:astroBabyFamiliarUpdate(astro)
    local player = Isaac.GetPlayer(0)
    local sprite = astro:GetSprite()
    local data = astro:GetData()
    
    if not player:HasCollectible(ItemId.ASTRO_BABY) then
        astro:Remove()
    end

    astro:FollowParent()
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        
        if entity.Type == EntityType.ENTITY_TEAR and data.IsFromAstroBaby == true then
            if not entity:IsDead() then
                entity.Velocity = entity.Velocity:Rotated(data.RotateAmount)

                if data.RotateAmount < 10 then
                    data.RotateAmount = data.RotateAmount / 1.01
                else
                    data.RotateAmount = data.RotateAmount / 1.1
                end
            else
                for i = 1, 4 do
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, entity.Position, RandomVector() * ((math.random() * 4) + 1), player)
                end
            end
        end
    end
    
    if data.FireDelay == 0 then
        if player:GetFireDirection() > -1 then
            data.FireDelay = 10
            local dir = Vector(0,0)
            
            if player:GetHeadDirection() == Direction.DOWN then
                dir = Vector(0, 10) + (astro.Velocity / 3)
                sprite:Play("ShootDown", true)
            elseif player:GetHeadDirection() == Direction.LEFT then
                dir = Vector(-10, 0) + (astro.Velocity / 3)
                sprite:Play("ShootSide2", true)
            elseif player:GetHeadDirection() == Direction.RIGHT then
                dir = Vector(10, 0) + (astro.Velocity / 3)
                sprite:Play("ShootSide", true)
            elseif player:GetHeadDirection() == Direction.UP then
                dir = Vector(0, -10) + (astro.Velocity / 3)
                sprite:Play("ShootUp", true)
            end
            
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 619575, 0, astro.Position, dir, astro):ToTear()
            local tearData = tear:GetData()
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                tear.CollisionDamage = 6
            else
                tear.CollisionDamage = 3
            end
            tearData.IsFromAstroBaby = true
            tearData.Parent = astro
            tearData.RotateAmount = 30
            tear.FallingAcceleration = -0.1
            tear.FallingSpeed = 0
        else
            sprite:Play("IdleDown", true)
        end
    else
        data.FireDelay = data.FireDelay - 1

        if player:GetFireDirection() > -1 then
            if data.FireDelay < 7 then
                if player:GetHeadDirection() == Direction.UP then
                    sprite:Play("IdleUp", true)
                elseif player:GetHeadDirection() == Direction.LEFT then
                    sprite:Play("IdleSide2", true)
                elseif player:GetHeadDirection() == Direction.RIGHT then
                    sprite:Play("IdleSide", true)
                else
                    sprite:Play("IdleDown", true)
                end
            end
        else
            sprite:Play("IdleDown", true)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Exodus.astroBabyFamiliarUpdate, Entities.ASTRO_BABY.variant)

function Exodus:boxOfFriendsUse()
    local player = Isaac.GetPlayer(0)
    ItemVariables.ASTRO_BABY.UsedBox = ItemVariables.ASTRO_BABY.UsedBox + 1
    ItemVariables.LIL_RUNE.UsedBox = ItemVariables.LIL_RUNE.UsedBox + 1
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
    player:EvaluateItems()
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.boxOfFriendsUse, CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

function Exodus:astroBabyNewRoom()
    local player = Isaac.GetPlayer(0)
    ItemVariables.ASTRO_BABY.UsedBox = 0
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
    player:EvaluateItems()
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.astroBabyNewRoom)

--<<<LIL RUNE>>>--
function Exodus:lilRuneCache(player, flag)
    if player:HasCollectible(ItemId.LIL_RUNE) and flag == CacheFlag.CACHE_FAMILIARS then
        player:CheckFamiliar(Entities.LIL_RUNE.variant, player:GetCollectibleNum(ItemId.LIL_RUNE) + ItemVariables.LIL_RUNE.UsedBox, rng)
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.lilRuneCache)

function Exodus:lilRuneInit(rune)
    rune.IsFollower = true
  
    local sprite = rune:GetSprite()
    local data = rune:GetData()
    sprite:Play("PurpleDown")
    data.FireDelay = 20
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Exodus.lilRuneInit, Entities.LIL_RUNE.variant)

function Exodus:lilRuneFamiliarUpdate(rune)
    local player = Isaac.GetPlayer(0)
    local sprite = rune:GetSprite()
    local data = rune:GetData()

    if not player:HasCollectible(ItemId.LIL_RUNE) then
        rune:Remove()
    end

    rune:FollowParent()

    if ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        if ItemVariables.LIL_RUNE.RuneType == 1 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("AlgizTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 2 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("HaglazTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 3 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("JeraTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 4 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("PerthroTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 5 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("EhwazTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 6 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("AnsuzTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 7 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("DagazTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 8 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("BerkanoTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 9 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("BlackTransform", false)
        elseif ItemVariables.LIL_RUNE.RuneType == 10 and ItemVariables.LIL_RUNE.PlayAnim then
            sprite:Play("BlankTransform", false)
        end
        ItemVariables.LIL_RUNE.PlayAnim = false
    end
    
    if sprite:IsFinished("AlgizTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("HaglazTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("JeraTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("PerthroTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("EhwazTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("AnsuzTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("DagazTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("BerkanoTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("BlackTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    elseif sprite:IsFinished("BlankTransform") and ItemVariables.LIL_RUNE.PlayAnim ~= nil then
        ItemVariables.LIL_RUNE.PlayAnim = nil
        sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
    end

    local isblankrune = false

    if ItemVariables.LIL_RUNE.RuneType == 10 then
        isblankrune = true
        ItemVariables.LIL_RUNE.RuneType = rng:RandomInt(9)
    end

    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()

        if entity.Type == EntityType.ENTITY_TEAR then
            if data.IsFromLilRune == true then
                if entity:IsDead() then
                    for i = 1, 4 do
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, entity.Position, RandomVector() * ((math.random() * 4) + 1), player)
                    end
                elseif ItemVariables.LIL_RUNE.RuneType == 1 then
                    for i, shot in pairs(Isaac.GetRoomEntities()) do
                        if shot.Type == EntityType.ENTITY_PROJECTILE then
                            if shot.Position:Distance(entity.Position) < 12 then
                                shot:Kill()
                                entity:Kill()
                            end
                        end
                    end
                end
            elseif ItemVariables.RuneType == 5 then
                for i, fam in pairs(Isaac.GetRoomEntities()) do
                    if fam.Type == EntityType.ENTITY_FAMILIAR and fam.Variant == Entities.LIL_RUNE.variant then
                        if shot.Position:Distance(entity.Position) < 24 then
                            entity:ToTear().TearFlags = entity:ToTear().TearFlags + TearFlags.TEAR_CONTINUUM + TearFlags.TEAR_SPECTRAL + TearFlags.TEAR_PIERCING
                        end
                    end
                end
            end
        end
        if ItemVariables.LIL_RUNE.RuneType == 1 and entity.Type == EntityType.ENTITY_PROJECTILE then
            if entity.Position:Distance(rune.Position) < 16 then
                entity:Kill()
            end
        end
        if ItemVariables.LIL_RUNE.RuneType == 3 then
            if entity:IsEnemy() and entity:IsDead() and data.RuneSplitted == nil and entity:ToNPC().ParentNPC == nil and entity.Type ~= EntityType.ENTITY_SWARM and rng:RandomInt(8) == 1 then
                data.RuneSplitted = true
                if entity:ToNPC().ChildNPC ~= nil then
                    entity:ToNPC().ChildNPC:Kill()
                end
                local dup = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, Isaac.GetFreeNearPosition(entity.Position, 1), Vector(0,0), nil)
                dup:ToNPC().Scale = dup:ToNPC().Scale / 1.3
                dup.MaxHitPoints = dup.MaxHitPoints / 2
                local dup = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, Isaac.GetFreeNearPosition(entity.Position, 1), Vector(0,0), nil)
                dup:ToNPC().Scale = dup:ToNPC().Scale / 1.3
                dup.MaxHitPoints = dup.MaxHitPoints / 2
            elseif entity:IsEnemy() and entity:IsDead() and data.RuneSplitted == nil then
                data.RuneSplitted = true
            end
        end
    end

    if data.FireDelay == 0 and ItemVariables.LIL_RUNE.PlayAnim == nil then
        if player:GetFireDirection() > -1 then
            data.FireDelay = 20
            local dir = Vector(0,0)
            
            if player:GetHeadDirection() == Direction.DOWN then
                sprite:Play(ItemVariables.LIL_RUNE.State .. "DownShoot", true)
                dir = Vector(0, 10) + (rune.Velocity / 3)
            elseif player:GetHeadDirection() == Direction.LEFT then
                sprite:Play(ItemVariables.LIL_RUNE.State .. "LeftShoot", true)
                dir = Vector(-10, 0) + (rune.Velocity / 3)
            elseif player:GetHeadDirection() == Direction.RIGHT then
                sprite:Play(ItemVariables.LIL_RUNE.State .. "RightShoot", true)
                dir = Vector(10, 0) + (rune.Velocity / 3)
            elseif player:GetHeadDirection() == Direction.UP then
                sprite:Play(ItemVariables.LIL_RUNE.State .. "UpShoot", true)
                dir = Vector(0, -10) + (rune.Velocity / 3)
            end
            
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 619575, 0, rune.Position, dir, rune):ToTear()
            local tearData = tear:GetData()
            tear.CollisionDamage = 3
            if ItemVariables.LIL_RUNE.RuneType == 2 and rng:RandomInt(6) == 1 then
                tear.TearFlags = tear.TearFlags + TearFlags.TEAR_EXPLOSIVE
            elseif ItemVariables.LIL_RUNE.RuneType == 3 then
                tear.TearFlags = tear.TearFlags + TearFlags.TEAR_SPLIT
            elseif ItemVariables.LIL_RUNE.RuneType == 5 then
                tear.TearFlags = tear.TearFlags + TearFlags.TEAR_CONTINUUM + TearFlags.TEAR_SPECTRAL + TearFlags.TEAR_PIERCING
            elseif ItemVariables.LIL_RUNE.RuneType == 6 then
                local tear2 = Isaac.Spawn(EntityType.ENTITY_TEAR, 619575, 0, rune.Position, dir, rune):ToTear()
                local tearData2 = tear2:GetData()
                tear2.CollisionDamage = 3
                if player:GetHeadDirection() == Direction.DOWN then
                    tear.Position = tear.Position + Vector(-8, 0)
                    tear2.Position = tear2.Position + Vector(8, 0)
                elseif player:GetHeadDirection() == Direction.LEFT then
                    tear.Position = tear.Position + Vector(0, -8)
                    tear2.Position = tear2.Position + Vector(0, 8)
                elseif player:GetHeadDirection() == Direction.RIGHT then
                    tear.Position = tear.Position + Vector(0, 8)
                    tear2.Position = tear2.Position + Vector(0, -8)
                else
                    tear.Position = tear.Position + Vector(8, 0)
                    tear2.Position = tear2.Position + Vector(-8, 0)
                end
                tearData2.IsFromLilRune = true
            elseif ItemVariables.LIL_RUNE.RuneType == 8 and rng:RandomInt(2) == 1 then
                tear.TearFlags = tear.TearFlags + TearFlags.TEAR_EGG
            elseif ItemVariables.LIL_RUNE.RuneType == 9 then
                tear.TearFlags = tear.TearFlags + TearFlags.TEAR_HORN
            end
            tearData.IsFromLilRune = true
        else
            sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
        end
    elseif ItemVariables.LIL_RUNE.PlayAnim == nil then
        data.FireDelay = data.FireDelay - 1
        if player:GetFireDirection() > -1 then
            if data.FireDelay < 15 then
                if player:GetHeadDirection() == Direction.DOWN then
                    sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
                elseif player:GetHeadDirection() == Direction.LEFT then
                    sprite:Play(ItemVariables.LIL_RUNE.State .. "Left", true)
                elseif player:GetHeadDirection() == Direction.RIGHT then
                    sprite:Play(ItemVariables.LIL_RUNE.State .. "Right", true)
                elseif player:GetHeadDirection() == Direction.UP then
                    sprite:Play(ItemVariables.LIL_RUNE.State .. "Up", true)
                end
            end
        else
            sprite:Play(ItemVariables.LIL_RUNE.State .. "Down", true)
        end
    end

    if isblankrune then
        ItemVariables.LIL_RUNE.RuneType = 10
    end
end

Exodus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Exodus.lilRuneFamiliarUpdate, Entities.LIL_RUNE.variant)

function Exodus:lilRuneNewRoom()
    local player = Isaac.GetPlayer(0)
    ItemVariables.LIL_RUNE.UsedBox = 0
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
    player:EvaluateItems()
    if ItemVariables.LIL_RUNE.RuneType == 7 then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsEnemy() then
                if entity:ToNPC():IsChampion() then
                    entity:Remove()
                    Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, Vector(0,0), entity)
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.lilRuneNewRoom)

function Exodus:lilRuneUse(rune)
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.LIL_RUNE) then
        if rune == Card.RUNE_ALGIZ then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 1
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_HAGALAZ then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 2
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_JERA then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 3
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_PERTHRO then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 4
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_EHWAZ then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 5
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_ANSUZ then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 6
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_DAGAZ then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 7
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_BERKANO then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 8
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_BLACK then
            ItemVariables.LIL_RUNE.State = "Black"
            ItemVariables.LIL_RUNE.RuneType = 9
            ItemVariables.LIL_RUNE.PlayAnim = true
        elseif rune == Card.RUNE_BLANK then
            ItemVariables.LIL_RUNE.State = "Purple"
            ItemVariables.LIL_RUNE.RuneType = 10
            ItemVariables.LIL_RUNE.PlayAnim = true
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_USE_CARD, Exodus.lilRuneUse)

--<<<BUSTED PIPE>>>--
function Exodus:bustedPipeUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.BUSTED_PIPE) then
        if not ItemVariables.BUSTED_PIPE.HasBustedPipe then
            player:AddNullCostume(CostumeId.BUSTED_PIPE)
            ItemVariables.BUSTED_PIPE.HasBustedPipe = true
        end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            local data = entity:GetData()
            
            if entity.Type == EntityType.ENTITY_LASER and entity.FrameCount == 1 and Exodus:HasPlayerChance(7) and not entity:ToLaser().IsCircleLaser then
                for i = 1, 10 do
                    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, entity.Position + (Vector.FromAngle(entity:ToLaser().Direction) * i * 40), NullVector, player):ToEffect()
                    creep:SetTimeout(20)
                    creep.Color = player.TearColor
                    creep.CollisionDamage = player.Damage
                    creep:SetColor(Color(0.5, 0.5, 1, 1, 0, 0, 255), -1, 1, false, false)
                end
            elseif (entity.Type == EntityType.ENTITY_TEAR or (entity.Type == EntityType.ENTITY_LASER and entity:ToLaser().IsCircleLaser)) and entity.SpawnerType == EntityType.ENTITY_PLAYER then
                if Exodus:HasPlayerChance(7) and entity.FrameCount == 1 then
                    data.IsLeakyTear = true
                    entity:SetColor(Color(0.5, 0.5, 1, 1, 0, 0, 0), -1, 1, false, false)
                end
            
                if data.IsLeakyTear then
                    if entity.FrameCount == 1 then
                        entity.Velocity = entity.Velocity * 1.6
                    end
                    
                    if rng:RandomInt(3) == 0 and entity.Position:DistanceSquared(player.Position) > 30^2 then
                        for i = 1, player:GetCollectibleNum(ItemId.BUSTED_PIPE) do
                            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, entity.Position + (RandomVector() * (i - 1) * 30), NullVector, entity):ToEffect()
                            creep:SetTimeout(20)
                            creep.Color = player.TearColor
                            creep.CollisionDamage = player.Damage * 2
                            creep:SetColor(Color(0.5, 0.5, 1, 1, 0, 0, 255), -1, 1, false, false)
                        end
                    end
                end
            end
        end
    elseif ItemVariables.BUSTED_PIPE.HasBustedPipe then
        ItemVariables.BUSTED_PIPE.HasBustedPipe = false
        player:TryRemoveNullCostume(CostumeId.BUSTED_PIPE)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.bustedPipeUpdate)
  
--<<<BEE HIVE>>>--
function Exodus:beehiveUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.BEEHIVE) then
        if player.FrameCount % (math.random(18, 20)) == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, player.Position, NullVector, player)
            creep:SetColor(Color(0, 0, 0, 1, math.random(200, 250), math.random(150, 200), math.random(0, 10)), -1, 1, false, false)
        end
        
        if not ItemVariables.BEEHIVE.HasBeehive then
            player:AddNullCostume(CostumeId.BEEHIVE)
            ItemVariables.BEEHIVE.HasBeehive = true
        end
        
        player.TearFallingAcceleration = -0.1
        
        if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER) then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, false)
        end
        
        if sfx:IsPlaying(SoundEffect.SOUND_TEARS_FIRE) then
            sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
            sfx:Play(SoundEffect.SOUND_INSECT_SWARM_LOOP, 1, 0, true, 0.8)
        end
        
        if sfx:IsPlaying(SoundEffect.SOUND_TEARIMPACTS) then
            sfx:Stop(SoundEffect.SOUND_TEARIMPACTS)
            sfx:Play(SoundEffect.SOUND_INSECT_SWARM_LOOP, 1, 0, true, 0.8)
        end
        
        if player.FrameCount % 5 == 0 or game:GetRoom():GetFrameCount() == 1 then
            if ItemVariables.BEEHIVE.ColourIsBlack then
                player.TearColor = Color(0.1, 0.1, 0.1, 1, 0, 0, 0)
                player.LaserColor = Color(0.1, 0.1, 0.1, 1, 0, 0, 0)
                ItemVariables.BEEHIVE.ColourIsBlack = false
            else
                player.TearColor = Color(1, 1, 0, 1, 0, 0, 0)
                player.LaserColor = Color(1, 1, 0, 1, 0, 0, 0)
                ItemVariables.BEEHIVE.ColourIsBlack = true
            end
        end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            local sprite = entity:GetSprite()
            
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) and entity.Type == EntityType.ENTITY_KNIFE then
                if entity.SpawnerType == EntityType.ENTITY_PLAYER then
                    entity.Visible = false
                    
                    local knife = player:FireKnife(nil, rng:RandomInt(360), true, 0)
                    knife.SpriteRotation = entity.SpriteRotation + entity.Position:Distance(player.Position) - 30
                    knife.Position = entity.Position + RandomVector()
                    knife:GetSprite().FlipY = true
                end
            end
            
            if entity.Type == EntityType.ENTITY_LASER and entity.SpawnerType == EntityType.ENTITY_PLAYER and entity.Variant ~= 5 then
                if ItemVariables.BEEHIVE.ColourIsBlack then
                    entity.Color = Color(0, 0, 0, 1, 0, 0, 0)
                    entity.SplatColor = Color(0, 0, 0, 1, 0, 0, 0) 
                else
                    entity.Color = Color(1, 1, 0, 1, 255, 255, 0)
                    entity.SplatColor = Color(1, 1, 0, 1, 255, 255, 0)
                end
            end
            
            if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.ROCKET and player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
                if not string.find(sprite:GetFilename(), "gfx/effects/bee") then
                    sprite:ReplaceSpritesheet(0, "gfx/effects/effect_035_beemissile.png")
                    sprite:LoadGraphics()
                end
                
                if entity:IsDead() then
                    Exodus:FireXHoney(15, entity)
                end
            end
            
            if entity.Type == EntityType.ENTITY_BOMBDROP and entity.SpawnerType == EntityType.ENTITY_PLAYER and entity:ToBomb().IsFetus then
                entity.Velocity = entity.Velocity + RandomVector()
            end
            
            if entity.Type == EntityType.ENTITY_TEAR then
                if entity.SpawnerType == EntityType.ENTITY_PLAYER or entity.SpawnerType == EntityType.ENTITY_FAMILIAR then
                    if entity.SpawnerType == EntityType.ENTITY_PLAYER or entity.SpawnerVariant == 120 or entity.SpawnerVariant == 80 then
                        entity.Color = player.TearColor
                        entity.Velocity = entity.Velocity - RandomVector()
                        
                        if entity.FrameCount == 1 and player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
                            entity.CollisionDamage = entity.CollisionDamage * 2
                        end
                        
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and math.random(6) == 1 then
                            for u, effect in pairs(Isaac.GetRoomEntities()) do
                                if effect.Type == EntityType.ENTITY_EFFECT and effect.Velocity ~= NullVector and effect.Variant == EffectVariant.TARGET then
                                    entity.Velocity = (effect.Position - entity.Position) / 30 + RandomVector() * 3
                                end
                            end
                        end
                        
                        if entity.FrameCount == 1 then
                            entity.Velocity = entity.Velocity + RandomVector() * 3
                            entity.Color = player.TearColor
                        end
                    end
                end
            end
        end
    elseif ItemVariables.BEEHIVE.HasBeehive then
        ItemVariables.BEEHIVE.HasBeehive = false
        player:TryRemoveNullCostume(CostumeId.BEEHIVE)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.beehiveUpdate)

--<<<BUTTROT>>>--
function Exodus:buttrotUpdate()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.BUTTROT) then
        if not ItemVariables.BUTTROT.HasButtrot then
            player:AddNullCostume(CostumeId.BUTTROT)
            ItemVariables.BUTTROT.HasButtrot = true
        end
    end

    if player:HasCollectible(ItemId.BUTTROT) then
        local entities = Isaac.GetRoomEntities()
        for i = 1, #entities do
            if entities[i].Type == EntityType.ENTITY_TEAR and entities[i].Variant == Entities.BLIGHT_TEAR.variant then
                if entities[i]:IsDead() then
                    local splash = Isaac.Spawn(1000, 538978236, 0, entities[i].Position + Vector(0, entities[i]:ToTear().Height), Vector(0,0), nil):ToEffect()
                    splash:SetTimeout(30)                
                else
                    entities[i].Visible = true
                end
            end
            if entities[i].Type == 1000 and entities[i].Variant == 538978237 then
                entities[i].Position = entities[i]:GetData().parent.Position + Vector(0, entities[i]:GetData().parent.Size)
                if entities[i]:GetData().parent:IsDead() or entities[i]:GetData().parent:GetData().BlightedFrame == nil then
                    entities[i]:Remove()
                end
            end
            if entities[i]:GetData().BlightedFrame ~= nil then
                if entities[i]:GetData().BlightedFrame + 90 < game:GetFrameCount() then
                    entities[i]:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                    entities[i]:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                    entities[i]:ClearEntityFlags(EntityFlag.FLAG_SLOW)
                    entities[i]:GetData().BlightedFrame = nil
                end
            end
            if entities[i].Type == EntityType.ENTITY_LASER and entities[i].SpawnerType == EntityType.ENTITY_PLAYER and entities[i].Variant ~= 5 then
                player.TearColor = Color(0.5, 0.1, 0.8, 1, 125, 55, 225)
                player.LaserColor = Color(0.5, 0.1, 0.8, 1, 125, 55, 225)
                entities[i].Color = Color(0.5, 0.1, 0.8, 1, 125, 55, 225)
                entities[i].SplatColor = Color(0.5, 0.1, 0.8, 1, 125, 55, 225) 
            end
            if entities[i].Type == EntityType.ENTITY_TEAR and entities[i].Variant ~= Entities.BLIGHT_TEAR.variant then
                local tear = entities[i]:ToTear()
                local flags = tear.TearFlags
                local sprite = tear:GetSprite()
                if flags & TearFlags.TEAR_LUDOVICO ~= 0 then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SLOW
                    tear:ChangeVariant(Entities.BLIGHT_TEAR.variant)
                    sprite:Play("Shroom6")
                    if tear.FrameCount == 0 then
                        tear.Visible = false
                    end
                end
            end
            if entities[i].Type == EntityType.ENTITY_BOMBDROP and entities[i].SpawnerType == 1 and entities[i]:GetData().IsButtrotBomb == nil then
                entities[i]:GetSprite():Load("gfx/blight_bomb.anm2", true)
                entities[i]:GetData().IsButtrotBomb = true
                entities[i]:ToBomb().Flags = entities[i]:ToBomb().Flags | TearFlags.TEAR_SLOW
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.buttrotUpdate)

function Exodus.getSize(scale, flags)
    if flags & TearFlags.TEAR_LUDOVICO ~= 0 then
        return 6
    elseif scale < 0.675 then
        return 1
    elseif scale < 0.925 then
        return 2
    elseif scale < 1.175 then
        return 3
    elseif scale < 1.675 then
        return 4
    elseif scale < 2.175 then
        return 5
    else
        return 6
    end
end

function Exodus:buttrotTear(tear)
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.BUTTROT) then
        local buttchance = 12 - player.Luck
        if buttchance < 1 then
            buttchance = 1
        end
        if math.random(buttchance) == 1 then
            tear:ChangeVariant(Entities.BLIGHT_TEAR.variant)
            tear.CollisionDamage = tear.CollisionDamage + 2
            local sprite = tear:GetSprite()
            local flags = tear.TearFlags
            local size = Exodus.getSize(tear.Scale, flags)
            sprite:Play("Shroom" .. size)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Exodus.buttrotTear)

--<<<SLING + BUTTROT + LIL RUNE PRE_TEAR_COLLISION>>>--
function Exodus:buttrotShatter(tear, target)
    local player = Isaac.GetPlayer(0)
    local isblankrune = false
    if ItemVariables.LIL_RUNE.RuneType == 10 then
        isblankrune = true
        ItemVariables.LIL_RUNE.RuneType = rng:RandomInt(9)
    end
    if tear:GetData().IsFromLilRune and ItemVariables.LIL_RUNE.RuneType == 2 and target:IsVulnerableEnemy() then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsVulnerableEnemy() and entity ~= target then
                entity:TakeDamage(tear.CollisionDamage / 2, 0, EntityRef(tear), 3)
            end
        end
    end
    if tear:GetData().IsFromLilRune and ItemVariables.LIL_RUNE.RuneType == 4 and target:IsVulnerableEnemy() then
        if 1 == math.random(10) then
            game:RerollEnemy(target)
        end
    end
    if tear:GetData().IsFromLilRune and ItemVariables.LIL_RUNE.RuneType == 7 and target:IsActiveEnemy() then
        Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, tear.Position, Vector(0,0), tear)
    end
    if isblankrune then
        ItemVariables.LIL_RUNE.RuneType = 10
    end
    if target:IsVulnerableEnemy() and tear.Variant == Entities.BLIGHT_TEAR.variant then
        if tear.TearFlags & TearFlags.TEAR_LUDOVICO == 0 or rng:RandomInt(15) == 1 then
            game:ButterBeanFart(target.Position, 64, target, true)
        end
        if not target:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
            target:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            target:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            target:AddEntityFlags(EntityFlag.FLAG_SLOW)
            target:SetColor(Color(0.75, 0.17, 0.46, 1, 0, 0, 0), 90, 1, false, false)    
            local arrow = Isaac.Spawn(1000, 538978237, 0, target.Position + Vector(0, target.Size), Vector(0,0), nil)
            arrow:GetData().parent = target
            target:GetData().BlightedFrame = game:GetFrameCount()
        end
    end
    if player:HasCollectible(ItemId.SLING) and target:IsVulnerableEnemy() and (target.Size > 13 or target.Type == EntityType.ENTITY_FATTY or target.Type == EntityType.ENTITY_SWARMER
    or target.Type == EntityType.ENTITY_CRAZY_LONG_LEGS or target.Type == EntityType.ENTITY_DADDYLONGLEGS or target:IsBoss())
    and target.Type ~= EntityType.ENTITY_ATTACKFLY and target.Type ~= EntityType.ENTITY_HUSH_FLY and target.Type ~= EntityType.ENTITY_POOTER and target.Type ~= EntityType.ENTITY_FLY
    and target.Type ~= EntityType.ENTITY_RING_OF_FLIES and target.Type ~= EntityType.ENTITY_DART_FLY and target.Type ~= EntityType.ENTITY_SWARM and target.Type ~= EntityType.ENTITY_MOTER
    and target.Type ~= EntityType.ENTITY_FLY_L2 and target.Type ~= EntityType.ENTITY_ETERNALFLY then
        tear.CollisionDamage = player.Damage + (target.Size // 13)
    end
end

Exodus:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, Exodus.buttrotShatter)

function Exodus:slingRender()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.SLING) and not game:IsPaused() then
        ItemVariables.SLING.Icon.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
        ItemVariables.SLING.Icon:Update()
        ItemVariables.SLING.Icon:LoadGraphics()

        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsVulnerableEnemy() and (entity.Size > 13 or entity.Type == EntityType.ENTITY_FATTY or entity.Type == EntityType.ENTITY_SWARMER
            or entity.Type == EntityType.ENTITY_CRAZY_LONG_LEGS or entity.Type == EntityType.ENTITY_DADDYLONGLEGS or entity:IsBoss())
            and entity.Type ~= EntityType.ENTITY_ATTACKFLY and entity.Type ~= EntityType.ENTITY_HUSH_FLY and entity.Type ~= EntityType.ENTITY_POOTER and entity.Type ~= EntityType.ENTITY_FLY
            and entity.Type ~= EntityType.ENTITY_RING_OF_FLIES and entity.Type ~= EntityType.ENTITY_DART_FLY and entity.Type ~= EntityType.ENTITY_SWARM and entity.Type ~= EntityType.ENTITY_MOTER
            and entity.Type ~= EntityType.ENTITY_FLY_L2 and entity.Type ~= EntityType.ENTITY_ETERNALFLY then
                ItemVariables.SLING.Icon:Render(game:GetRoom():WorldToScreenPosition(entity.Position - Vector(0, (entity.SpriteScale.Y * entity.Size * 1.5) + 20)), NullVector, NullVector)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.slingRender)

--<<<THE LADDER>>>--
function Exodus:ladderUpdate()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_LADDER) then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.ladderUpdate)

function Exodus:ladderCache(player, flag)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LADDER) and flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.1
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.ladderCache)

--<<<FIRE MIND>>>--
function Exodus:fireMindUpdate()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
        player:EvaluateItems()
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.fireMindUpdate)

function Exodus:fireMindCache(player, flag)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) and flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 0.5
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) and flag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.35
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.fireMindCache)

--<<<LUCKY FOOT + LUCK TOE>>>--
function Exodus:luckUpdate()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
    if player:HasTrinket(TrinketType.TRINKET_LUCKY_TOE) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.luckUpdate)

function Exodus:luckCache(player, flag)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) and flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 2
    end
    if player:HasTrinket(TrinketType.TRINKET_LUCKY_TOE) and flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 1
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.luckCache)

--<<<MOLDY BREAD>>>--
function Exodus:breadUpdate()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOLDY_BREAD) and not ItemVariables.MOLDY_BREAD.GotFlies then
        player:AddBlueFlies(20, player.Position, player)
        ItemVariables.MOLDY_BREAD.GotFlies = true
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.breadUpdate)

--<<<FOOL'S GOLD>>>--
function Exodus:foolsGoldUpdate()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.FOOLS_GOLD) and not ItemVariables.FOOLS_GOLD.HasFoolsGold then
        player:AddGoldenHearts(1)
        Isaac.Spawn(5, 20, 6, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
        ItemVariables.FOOLS_GOLD.HasFoolsGold = true
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.foolsGoldUpdate)

--<<<MAKEUP REMOVER>>>--
function Exodus:makeupRemoverInit(entity)
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.MAKEUP_REMOVER) and (entity:IsEnemy() or entity:IsBoss()) and entity:GetData().FaceScared == nil then
        entity:GetData().FaceScared = true
        entity.HitPoints = entity.HitPoints * 0.9
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Exodus.makeupRemoverInit)

function Exodus:makeupRemoverUpdate()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(ItemId.MAKEUP_REMOVER) then
        if not ItemVariables.MAKEUP_REMOVER.HasMakeupRemover then
            ItemVariables.MAKEUP_REMOVER.HasMakeupRemover = true
            if player:GetName() == "The Lost" then
                player:AddNullCostume(CostumeId.MAKEUP_REMOVER_WHITE)
            elseif player:GetName() == "Azazel" or player:GetName() == "Lilith" then
                player:AddNullCostume(CostumeId.MAKEUP_REMOVER_BLACK)
            elseif player:GetName() == "???" then
                player:AddNullCostume(CostumeId.MAKEUP_REMOVER_BLUE)
            elseif player:GetName() == "Keeper" or player:GetName() == "Apollyon" then
                player:AddNullCostume(CostumeId.MAKEUP_REMOVER_GRAY)
            else
                player:AddNullCostume(CostumeId.MAKEUP_REMOVER)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.makeupRemoverUpdate)

--<<<HOLY WATER>>>--
function Exodus:holyWaterDamage(target, amount, flags, source, cdtimer)
    local player = Isaac.GetPlayer(0)
    local chance = game:GetRoom():GetDevilRoomChance()
    if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_WATER) and not ItemVariables.HOLY_WATER.Splashed then
        ItemVariables.HOLY_WATER.Splashed = true
        if player:GetSoulHearts() > 0 then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, false, false, false)
            player:AddSoulHearts(-1)
            return false
        else
            player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, false, false, false)
            player:AddHearts(-1)
            return false
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.holyWaterDamage, EntityType.ENTITY_PLAYER)

function Exodus:holyWaterRoom()
    ItemVariables.HOLY_WATER.Splashed = false
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.holyWaterRoom)

--<<<COBALT NECKLACE>>>--
function Exodus.setScoreDisplay()
    Isaac.ConsoleOutput("setScoreDisplay")
    
    if ItemVariables.COBALT_NECKLACE.Counter then
        local sprite = ItemVariables.COBALT_NECKLACE.Counter:GetSprite()
        Isaac.ConsoleOutput("Counter")
        if ItemVariables.COBALT_NECKLACE.Count <= 101 then
            sprite:SetFrame("Frames", ItemVariables.COBALT_NECKLACE.Count)
        else
            sprite:SetFrame("Frames", 102)
        end
        
        sprite:Stop()
    end
end

function Exodus:cobaltNecklaceUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.COBALT_NECKLACE) then
        local room = game:GetRoom()
        
        if ItemVariables.COBALT_NECKLACE.HasCobaltNecklace == false then
            ItemVariables.COBALT_NECKLACE.Counter = Isaac.Spawn(Entities.SCORE_DISPLAY.id, Entities.SCORE_DISPLAY.variant, 0, player.Position + Vector(0, -69), Vector(0, 0), player)
            ItemVariables.COBALT_NECKLACE.Count = 0
            ItemVariables.COBALT_NECKLACE.HasCobaltNecklace = true
            Exodus.setScoreDisplay()
        end
        
        if room:IsClear() then
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
            
            if ItemVariables.COBALT_NECKLACE.IsRoomClear == false then
                if room:GetRoomShape() == RoomShape.ROOMSHAPE_2x2 then
                    ItemVariables.COBALT_NECKLACE.Count = ItemVariables.COBALT_NECKLACE.Count + 2
                else
                    ItemVariables.COBALT_NECKLACE.Count = ItemVariables.COBALT_NECKLACE.Count + 1
                end
                
                Exodus.setScoreDisplay()  
                ItemVariables.COBALT_NECKLACE.IsRoomClear = true
            end
        else
            ItemVariables.COBALT_NECKLACE.IsRoomClear = false
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.cobaltNecklaceUpdate)

function Exodus:cobaltNecklaceNewRoom()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.COBALT_NECKLACE) and (ItemVariables.COBALT_NECKLACE.Counter == nil or not ItemVariables.COBALT_NECKLACE.Counter:Exists()) then
        ItemVariables.COBALT_NECKLACE.Counter = Isaac.Spawn(Entities.SCORE_DISPLAY.id, Entities.SCORE_DISPLAY.variant, 0, player.Position + Vector(0, -69), NullVector, player)
        Exodus.setScoreDisplay()
    end 
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.cobaltNecklaceNewRoom)

function Exodus:cobaltNecklaceDamage(target, amount, flags, source, cdtimer)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.COBALT_NECKLACE) then
        ItemVariables.COBALT_NECKLACE.Count = 0
        Exodus.setScoreDisplay()
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.cobaltNecklaceDamage, EntityType.ENTITY_PLAYER)

function Exodus:cobaltNecklaceCache(player, flag)
    if player:HasCollectible(ItemId.COBALT_NECKLACE) and flag == CacheFlag.CACHE_DAMAGE and ItemVariables.COBALT_NECKLACE.Count >= 0 then
        player.Damage = player.Damage + (math.floor(((ItemVariables.COBALT_NECKLACE.Count * 0.7)^0.7) * 100)) / 150 * player:GetCollectibleNum(ItemId.COBALT_NECKLACE)
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.cobaltNecklaceCache)

function Exodus:cobaltNecklaceRender()
    local player = Isaac.GetPlayer(0)
    
    if ItemVariables.COBALT_NECKLACE.Counter then
        if player:HasCollectible(ItemId.COBALT_NECKLACE) then
            ItemVariables.COBALT_NECKLACE.Counter.GridCollisionClass = GridCollisionClass.COLLISION_NONE
            ItemVariables.COBALT_NECKLACE.Counter.Position = player.Position + Vector(0, -69) + player.Velocity
        else
            ItemVariables.COBALT_NECKLACE.Counter:Remove()
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.cobaltNecklaceRender)

--<<<MUTANT CLOVER>>>--
function Exodus:mutantCloverNewRoom()
    local player = Isaac.GetPlayer(0)
    
    ItemVariables.MUTANT_CLOVER.Used = 0
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Exodus.mutantCloverNewRoom)

function Exodus:mutantCloverCache(player, flag)
    if player:HasCollectible(ItemId.MUTANT_CLOVER) and ItemVariables.MUTANT_CLOVER.Used > 0 then
        if flag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (10 * ItemVariables.MUTANT_CLOVER.Used)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.mutantCloverCache)

function Exodus:mutantCloverUse()
    local player = Isaac.GetPlayer(0)
    ItemVariables.MUTANT_CLOVER.Used = ItemVariables.MUTANT_CLOVER.Used + 1
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
    
    return true
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.mutantCloverUse, ItemId.MUTANT_CLOVER)

--<<<UNHOLY MANTLE>>>--
function Exodus:unholyMantleCostume()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.UNHOLY_MANTLE) then
        if not ItemVariables.UNHOLY_MANTLE.HasUnholyMantle then
            player:AddNullCostume(CostumeId.UNHOLY_MANTLE)
            ItemVariables.UNHOLY_MANTLE.HasUnholyMantle = true
        end
    elseif ItemVariables.UNHOLY_MANTLE.HasUnholyMantle then
        ItemVariables.UNHOLY_MANTLE.HasUnholyMantle = false
        player:TryRemoveNullCostume(CostumeId.UNHOLY_MANTLE)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.unholyMantleCostume)

function Exodus:unholyMantleDamage(target, amount, flags, source, cdtimer)
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.UNHOLY_MANTLE) then
        if ItemVariables.UNHOLY_MANTLE.HasEffect then
            player:TryRemoveNullCostume(CostumeId.UNHOLY_MANTLE)
            
            for i, entity in pairs(Isaac.GetRoomEntities()) do
                if entity:IsVulnerableEnemy() then
                    entity:TakeDamage(math.ceil(100 * (game:GetLevel():GetAbsoluteStage()^0.7)), 0, EntityRef(player), 3)
                end
            end
            
            ItemVariables.UNHOLY_MANTLE.HasEffect = false
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.unholyMantleDamage, EntityType.ENTITY_PLAYER)

function Exodus:unholyMantleNewFloor()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.UNHOLY_MANTLE) then
        if ItemVariables.UNHOLY_MANTLE.HasEffect then
            player:AddBlackHearts(4)
            player:AddNullCostume(CostumeId.UNHOLY_MANTLE)
        else
            ItemVariables.UNHOLY_MANTLE.HasEffect = true
            player:AddNullCostume(CostumeId.UNHOLY_MANTLE)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Exodus.unholyMantleNewFloor)

--<<<PAPER CUT>>>--
function Exodus:paperCutCostume()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.PAPER_CUT) then
        if not ItemVariables.PAPER_CUT.HasPaperCut then
            player:AddNullCostume(CostumeId.PAPER_CUT)
            ItemVariables.PAPER_CUT.HasPaperCut = true
            Isaac.Spawn(5, 300, 0, Isaac.GetFreeNearPosition(player.Position, 50), Vector(0, 0), nil)
        end
    elseif ItemVariables.UNHOLY_MANTLE.HasUnholyMantle then
        ItemVariables.UNHOLY_MANTLE.HasUnholyMantle = false
        player:TryRemoveNullCostume(CostumeId.PAPER_CUT)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.paperCutCostume)

function Exodus:paperCutCardUse()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.PAPER_CUT) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsVulnerableEnemy() then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) then
                    entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                    entity:TakeDamage(20, 0, EntityRef(player), 0)
                else
                    entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                    entity:TakeDamage(10, 0, EntityRef(player), 0)
                end
            end
            
            if entity.Type == EntityType.ENTITY_STONEY then
                entity:Kill()
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_USE_CARD, Exodus.paperCutCardUse)

--<<<DRAGON BREATH>>>--
function Exodus:dragonBreathUpdate()  
    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    
    if player:HasCollectible(ItemId.DRAGON_BREATH) then
        if ItemVariables.DRAGON_BREATH.Charge >= 10 then
            player:SetColor(Color(1 + math.abs(math.sin(player.FrameCount / 5) * 2), 1, 1, 1, math.abs(math.ceil(math.cos(player.FrameCount / 5) * 50)), 0, 0), -1, 1, false, false)
        else
            player:SetColor(Color(1, 1, 1, 1, 0, 0, 0), -1, 1, false, false)
        end
        
        local bar
        
        if not ItemVariables.DRAGON_BREATH.HasDragonBreath then
            bar = Isaac.Spawn(Entities.CHARGE_BAR.id, Entities.CHARGE_BAR.variant, 0, player.Position, NullVector, player)
            bar:GetData().IsFireball = true
            bar.Visible = false
            player:AddNullCostume(CostumeId.DRAGON_BREATH)
            ItemVariables.DRAGON_BREATH.HasDragonBreath = true
        end
        
        player.FireDelay = 10
        
        if ItemVariables.DRAGON_BREATH.Charge >= 10 then
            if player:GetFireDirection() > -1 then
                ItemVariables.DRAGON_BREATH.ChargeDirection = player:GetShootingJoystick()
            else
                Exodus:FireFire(ItemVariables.DRAGON_BREATH.ChargeDirection, false, false, false)
            end
        end
        
        if room:GetFrameCount() == 1 then
            bar = Isaac.Spawn(Entities.CHARGE_BAR.id, Entities.CHARGE_BAR.variant, 0, player.Position, NullVector, player)
            bar:GetData().IsFireball = true
            bar.Visible = false
        end
        
        if player:GetFireDirection() > -1 then
            if ItemVariables.DRAGON_BREATH.Charge < 10 then
                ItemVariables.DRAGON_BREATH.Charge = ItemVariables.DRAGON_BREATH.Charge + (1 / player.MaxFireDelay) * 8
            end
        else
            ItemVariables.DRAGON_BREATH.Charge = -1
        end
    elseif ItemVariables.DRAGON_BREATH.HasDragonBreath then
        ItemVariables.DRAGON_BREATH.HasDragonBreath = false
        player:TryRemoveNullCostume(CostumeId.DRAGON_BREATH)
    end
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == Entities.FIREBALL_2.id and entity.Variant == Entities.FIREBALL_2.variant then
            entity.SpriteRotation = entity.FrameCount * 8
            
            if entity.FrameCount > player.TearHeight * -1 then
                entity:Die()
            end
            
            if entity:IsDead() then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) and player.Position:DistanceSquared(entity.Position) < 70^2 and not player:HasFullHearts() then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, NullVector, entity)
                    player:AddHearts(2)
                end
                
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
                    Isaac.Explode(entity.Position, nil, player.Damage * 7)
                end
            end
        end
        
        if entity.Type == Entities.FIREBALL.id and entity.Variant == Entities.FIREBALL.variant then
            if math.random(3) == 1 then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, Vector(entity.Position.X, entity.Position.Y - 12), RandomVector() * ((math.random() * 4) + 1), player)
            end

            entity.Velocity = entity.Velocity * 1.01
            entity.SpriteRotation = entity.Velocity:GetAngleDegrees() - 90
            
            if entity:IsDead() or entity.FrameCount > 100 then
                entity:Die()

                for i, entityburn in pairs(Isaac.GetRoomEntities()) do
                    if entityburn:IsActiveEnemy() and entityburn:IsVulnerableEnemy() then
                        if entityburn.Position:Distance(entity.Position) < 48 then
                            entityburn:AddBurn(EntityRef(entity), 100, 1)
                        end
                    end
                end

                local fire2 = Isaac.Spawn(Entities.FIREBALL_2.id, Entities.FIREBALL_2.variant, 0, entity.Position, entity.Velocity, entity):ToTear()
                fire2.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
                fire2.FallingAcceleration = -0.1
                fire2.CollisionDamage = player.Damage * 2
                fire2.Color = player.TearColor
                fire2.GridCollisionClass = GridCollisionClass.COLLISION_NONE
                
                if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
                    for u = 1, math.random(3, 5) do
                        player:FireTechLaser(entity.Position, 0, RandomVector(), false, false)
                    end
                end
            end
        end
        
        if entity.Type == Entities.CHARGE_BAR.id and entity.Variant == Entities.CHARGE_BAR.variant and entity:GetData().IsFireball then
            local sprite = entity:GetSprite()
            
            entity.Velocity = (player.Position - entity.Position) / 2
            entity.Position = player.Position
            
            if ItemVariables.DRAGON_BREATH.Charge ~= 10 and ItemVariables.DRAGON_BREATH.Charge ~= -1 then
                sprite:Play(tostring(math.floor(ItemVariables.DRAGON_BREATH.Charge)), false)
            end
            
            if ItemVariables.DRAGON_BREATH.Charge >= 10 then
                sprite:Play("Charged",false)
            end
            
            if ItemVariables.DRAGON_BREATH.Charge < 0 then
                entity.Visible = false
            else
                entity.Visible = true
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.dragonBreathUpdate)  

function Exodus:dragonBreathCache(player, flag)
    if player:HasCollectible(ItemId.DRAGON_BREATH) and flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay * 2 - 1
    end
end

Exodus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Exodus.dragonBreathCache)

--<<<THE PSEUDOBULBAR EFFECT>>>--
function Exodus:pseudobulbarTurretUpdate()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        local level = game:GetLevel()
        local room = game:GetRoom()
        
        if data.IsPseudobulbarTurret then
            if player.FireDelay == player.MaxFireDelay then
                if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
                    Exodus:FireTurretBullet(entity.Position + Vector(-1 * entity.Size, 0) , Vector(-15, 0) * player.ShotSpeed + entity.Velocity, entity)
                elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
                    Exodus:FireTurretBullet(entity.Position + Vector(entity.Size, 0), Vector(15, 0) * player.ShotSpeed + entity.Velocity, entity)
                elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
                    Exodus:FireTurretBullet(entity.Position + Vector(0, -1 * entity.Size), Vector(0, -15) * player.ShotSpeed + entity.Velocity, entity)
                elseif Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
                    Exodus:FireTurretBullet(entity.Position + Vector(0, entity.Size), Vector(0, 15) * player.ShotSpeed + entity.Velocity, entity)
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.pseudobulbarTurretUpdate)

function Exodus:pseudobulbarAffectRender()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.PSEUDOBULBAR_AFFECT) then
        ItemVariables.PSEUDOBULBAR_AFFECT.Icon.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
        ItemVariables.PSEUDOBULBAR_AFFECT.Icon:Update()
        ItemVariables.PSEUDOBULBAR_AFFECT.Icon:LoadGraphics()
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:GetData().IsPseudobulbarTurret then
                ItemVariables.PSEUDOBULBAR_AFFECT.Icon:Render(game:GetRoom():WorldToScreenPosition(entity.Position + Vector(0, entity.Size)), NullVector, NullVector)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_RENDER, Exodus.pseudobulbarAffectRender)

function Exodus:pseudobulbarAffectUse()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy() then
            entity:GetData().IsPseudobulbarTurret = true
        end
    end
    
    return true
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.pseudobulbarAffectUse, ItemId.PSEUDOBULBAR_AFFECT)

--<<<ANAMNESIS>>>--
function Exodus:anamnesisUse()
    local player = Isaac.GetPlayer(0)
    local config = Isaac.GetItemConfig()
    local collectibleList = {}
    
    for i = 1, #config:GetCollectibles() do
        value = config:GetCollectible(i)
        
        if value and player:HasCollectible(value.ID) then
            table.insert(collectibleList, value.ID)
        end
    end
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == 5 and entity.Variant == 100 then
            entity:ToPickup():Morph(5, 100, collectibleList[math.random(#collectibleList)], true)
        end
    end

    return true
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.anamnesisUse, ItemId.ANAMNESIS)

function Exodus:anamnesisUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.ANAMNESIS) then
        if not ItemVariables.ANAMNESIS.IsHolding then
            if player:GetActiveCharge() == 6 and ItemVariables.ANAMNESIS.Charge ~= 6 then
                player:SetActiveCharge(0)
                ItemVariables.ANAMNESIS.Charge = 0  
            elseif player:GetActiveCharge() ~= ItemVariables.ANAMNESIS.Charge then
                player:SetActiveCharge(ItemVariables.ANAMNESIS.Charge)
            end    
            
            ItemVariables.ANAMNESIS.IsHolding = true
        else
            ItemVariables.ANAMNESIS.Charge = player:GetActiveCharge()
        end
    elseif ItemVariables.ANAMNESIS.IsHolding then
        ItemVariables.ANAMNESIS.IsHolding = false
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.anamnesisUpdate)

--<<<BIRDBATH>>>--
function Exodus:birdbathUse()
    local player = Isaac.GetPlayer(0)
    
    Isaac.Spawn(Entities.BIRDBATH.id, Entities.BIRDBATH.variant, 0, Isaac.GetFreeNearPosition(player.Position, 7), NullVector, player)
end

Exodus:AddCallback(ModCallbacks.MC_USE_ITEM, Exodus.birdbathUse, ItemId.BIRDBATH)

function Exodus:birdbathEntityUpdate(bath)
    if bath.Variant == Entities.BIRDBATH.variant then
        local data = bath:GetData()
        
        bath.Velocity = NullVector
        bath.Friction = bath.Friction / 100
        
        if not bath:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
            bath:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end
        
        if data.SuckTimer == nil then
            data.SuckTimer = 60
        end
        
        if math.random(200) == 1 and data.IsSucking ~= true then
            data.IsSucking = true
            data.SuckTimer = 60
        end
        
        if data.IsSucking ~= false and data.SuckTimer == 0 then
            data.IsSucking = false
        end
        
        if data.SuckTimer > 0 then
            data.SuckTimer = data.SuckTimer - 1
        end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() and entity:IsFlying() then
                if data.IsSucking then
                    if entity.Velocity:Length() < 3 then
                        entity.Velocity = (bath.Position - entity.Position):Resized(3)
                    else
                        entity.Velocity = (bath.Position - entity.Position):Resized(entity.Velocity:Length())
                    end
                end
                
                if entity.Position:DistanceSquared(bath.Position) < (entity.Size + bath.Size)^2 then
                    entity:AddPoison(EntityRef(bath), 30, entity.MaxHitPoints)
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.birdbathEntityUpdate, Entities.BIRDBATH.id)


--<<<POSSESSED BOMBS>>>--
function Exodus:possessedBombUpdate()
    local player = Isaac.GetPlayer(0)
    
    if player:HasCollectible(ItemId.POSSESSED_BOMBS) then
        if not ItemVariables.POSSESSED_BOMBS.HasPossessedBombs then
            ItemVariables.POSSESSED_BOMBS.HasPossessedBombs = true
            player:AddNullCostume(CostumeId.POSSESSED_BOMBS)
        end
        
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            local bomb = entity:ToBomb()
            
            if bomb then
                local data = bomb:GetData()
                
                if not data.isPossessed and bomb.SpawnerType == 1 then
                    bomb.Flags = bomb.Flags | (TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_FEAR)
                    bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                    bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
                    bomb:SetColor(Color(1, 1, 1, 0.7, 0, 0, 0), -1, 1, false, false)
                    bomb:GetSprite():Load("gfx/effects/Possessed Bombs.anm2", true)
                    
                    data.isPossessed = true
                elseif data.isPossessed then
                    bomb.Velocity = bomb.Velocity + Vector(Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) - Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex), Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) - Input.GetActionValue(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex))
                end
            end
        end
    elseif ItemVariables.POSSESSED_BOMBS.HasPossessedBombs then
        ItemVariables.POSSESSED_BOMBS.HasPossessedBombs = false
        player:TryRemoveNullCostume(CostumeId.POSSESSED_BOMBS)
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.possessedBombUpdate)

--<<<DROWNED CHARGER>>>--
function Exodus:drownedChargerUpdate(entity)        
    if entity.Variant == 1 then 
        if entity.FrameCount == 1 then
            entity.HitPoints = 13
            entity.MaxHitPoints = 14
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.drownedChargerUpdate, EntityType.ENTITY_CHARGER)

--<<<DANK DIP>>>--
function Exodus:makeDankDip(entity)
    local stage = game:GetLevel():GetAbsoluteStage()
    
    if (entity.Type == EntityType.ENTITY_SPIDER and entity.SpawnerType == EntityType.ENTITY_GLOBIN and entity.SpawnerVariant == 2) or 
        (entity.Type == Entities.DANK_DIP.id and rng:RandomInt(10) ~= 0 and entity.Variant ~= 2 and entity.Variant ~= Entities.DANK_DIP.variant and
        (stage == 5 or stage == 6) and entity.FrameCount == 1) then
        entity:ToNPC():Morph(Entities.DANK_DIP.id, Entities.DANK_DIP.variant, 0, -1)
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.makeDankDip)

function Exodus:dankDipUpdate(entity)
    local player = Isaac.GetPlayer(0)
    
    if entity.Variant == Entities.DANK_DIP.variant and rng:RandomInt(8) == 0 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position, NullVector, entity)
    end
    
    for i, creep in pairs(Isaac.GetRoomEntities()) do
        if creep.Type == EntityType.ENTITY_EFFECT and creep.Variant == EffectVariant.CREEP_BLACK and creep.SpawnerType == entity.Type and creep.SpawnerVariant == entity.Variant then
            if creep.FrameCount > 1 then
                creep.Visible = true
            end
            
            if player.Position:DistanceSquared(creep.Position) < 13^2 and not creep:IsDead() then
                player:AddSlowing(EntityRef(entity), 10, 0.5, Color(1, 1, 1, 1, 0, 0, 0))
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.dankDipUpdate, Entities.DANK_DIP.id)

function Exodus:dankDipEntityUpdate(dip)
    if dip.Variant == Isaac.GetEntityVariantByName("Dank Dip") then
        local player = Isaac.GetPlayer(0)
        local sprite = dip:GetSprite()
        
        if sprite:IsPlaying("Move") then
            dip.Velocity = dip.Velocity:Rotated(5):Resized(6) + (player.Position - dip.Position):Normalized()
        end
        
        if dip:IsDead() then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, dip.Position, NullVector, dip):ToEffect().Scale = 1.3
        end
        
        if dip.FrameCount == 1 then
            local rand = rng:RandomInt(3) + 1
            sprite:ReplaceSpritesheet(0, "gfx/monsters/Dank Dip " .. rand .. ".png")
            sprite:LoadGraphics()
        end
        
        if rng:RandomInt(10) == 0 then
          local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, dip.Position, NullVector, dip):ToEffect()
          creep.Scale = 0.7
          creep.Visible = false
          creep:SetTimeout(20)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.dankDipEntityUpdate, Entities.DANK_DIP.id)

--<<<PATRIARCH>>>--
function Exodus:patriarchUpdate(entity)
    local player = Isaac.GetPlayer(0)
    
    if entity.Variant == Entities.PATRIARCH.variant and entity.State == 8 and entity:GetData().HolyLightDirection == nil then
        entity:GetData().ShotFrom = entity.Position
        entity:GetData().HolyLightDirection = (player.Position - entity.Position):GetAngleDegrees() - 48
        entity:GetData().BeamNumber = -5
    end
    
    if entity:GetData().HolyLightDirection ~= nil and entity:GetData().BeamNumber >= 1 and entity:GetData().BeamNumber == math.floor(entity:GetData().BeamNumber) then
        local lightpos = entity:GetData().ShotFrom + Vector(48 * entity:GetData().BeamNumber, 48 * entity:GetData().BeamNumber):Rotated(entity:GetData().HolyLightDirection)
        entity:GetData().BeamNumber = entity:GetData().BeamNumber + 0.25
        Isaac.Spawn(1000, 19, 0, lightpos, Vector(0,0), nil)
        if entity:GetData().BeamNumber >= 8 then
            entity:GetData().HolyLightDirection = nil
            entity.State = 4
        end
    elseif entity:GetData().HolyLightDirection ~= nil then
        if entity:GetData().BeamNumber - 0.25 == math.floor(entity:GetData().BeamNumber) then
            entity:GetData().HolyLightDirection = (player.Position - entity.Position):GetAngleDegrees() - 48
        end
        entity:GetData().BeamNumber = entity:GetData().BeamNumber + 0.25
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.patriarchUpdate, Entities.PATRIARCH.id)

--<<<WINGLEADER>>>--
function Exodus:wingleaderUpdate(fly)
    local player = Isaac.GetPlayer(0)
    local data = fly:GetData()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == Entities.WINGLEADER.id then
            if fly.Position:DistanceSquared(entity.Position) <= 16384 then
                if not data.lockedToParent then
                    data.lockedToParent = true
                    data.orbitAngle = math.floor((fly.Position - entity.Position):GetAngleDegrees())
                    fly.Velocity = Vector(0, 0)
                else
                    data.orbitAngle = data.orbitAngle + 5
                    if data.orbitAngle >= 360 then
                        data.orbitAngle = data.orbitAngle % 360
                    elseif data.orbitAngle < 0 then
                        data.orbitAngle = 360 - (data.orbitAngle % 360)
                    end
                    fly.Velocity = Vector(0, 0)
                    fly.Position = entity.Position + Vector(entity:GetData().orbitDistance, 0):Rotated(data.orbitAngle)
                end
            else
                fly.Velocity = fly.Velocity:Rotated(5):Resized(6) + (entity.Position - fly.Position):Normalized()
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.wingleaderUpdate, EntityType.ENTITY_ATTACKFLY)

function Exodus:wingleaderEntityUpdate(wingleader)
    local player = Isaac.GetPlayer(0)
    local sprite = wingleader:GetSprite()
    local data = wingleader:GetData()

    wingleader.Velocity = (player.Position - wingleader.Position):Resized(data.wingSpeed)
    if wingleader.FrameCount > 47 and data.Done == nil then
        sprite:Play("Idle", false)
        data.Done = true
    end
    if wingleader.Position.X < player.Position.X then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end
    if data.orbitDistance == 32 then
        if rng:RandomInt(120) == 1 then
            data.orbitDistance = 34
            data.orbitDirection = 1
            data.wingSpeed = 0
            sprite:Play("Puff", false)
        else
            sprite:Play("Idle", false)
        end
    else
        if data.orbitDirection == 1 then
            data.orbitDistance = data.orbitDistance + 2
            data.wingSpeed = data.wingSpeed + 0.02
            if data.orbitDistance > 128 then
                data.orbitDirection = 0
            elseif data.orbitDistance > 62 then
                sprite:Play("Idle", false)
            end
        else
            data.orbitDistance = data.orbitDistance - 1
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.wingleaderEntityUpdate, Entities.WINGLEADER.id)

function Exodus:wingleaderInit(wingleader)
    wingleader.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    wingleader.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    wingleader:GetData().orbitDistance = 32
    wingleader:GetData().orbitDirection = 0
    wingleader:GetData().wingSpeed = 1
end

Exodus:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Exodus.wingleaderInit, Entities.WINGLEADER.id)

--<<<BOTH SHROOMMEN>>>--
function Exodus:shroommanUpdate()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PROJECTILE and entity.SpawnerType == Entities.DROWNED_SHROOMMAN.id and (entity.SpawnerVariant == Entities.DROWNED_SHROOMMAN.variant or entity.SpawnerVariant == Entities.SCARY_SHROOMMAN.variant) then
            entity:Remove()
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.shroommanUpdate)

function Exodus:shroommanEntityUpdate(shroom)
    local sprite = shroom:GetSprite()
    local data = shroom:GetData()
    local player = Isaac.GetPlayer(0)
    
    if not shroom:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
        shroom:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
    end
    
    if shroom.Variant == Entities.DROWNED_SHROOMMAN.variant then
        if shroom:IsDead() then
            Isaac.Spawn(EntityType.ENTITY_CHARGER, 1, 0, shroom.Position, NullVector, shroom)
        end
        
        if sprite:IsPlaying("Reveal") then
            if data.HasFarted ~= true then
                for i = 1, 3 do
                    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, shroom.Position + Vector(30, 0):Rotated(i * math.random(110,120)), NullVector, shroom):ToEffect()
                    creep.Scale = 2
                    creep:Update()
                    creep.Color = Color(0.4, 0.4, 1, 1, 100, 255, 255)
                end
                
                data.HasFarted = true
            end
        else
            data.HasFarted = false
        end
    elseif shroom.Variant == Entities.SCARY_SHROOMMAN.variant then
        if sprite:IsPlaying("Reveal") and not player:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
            player.Velocity = ((player.Position - shroom.Position) / (player.Position:Distance(shroom.Position) * 2)) * 5 + player.Velocity
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.shroommanEntityUpdate, Entities.DROWNED_SHROOMMAN.id)

--<<<BOTH POISON ENEMIES>>>--
function Exodus:poisonEnemiesUpdate()
    local player = Isaac.GetPlayer(0)
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        
        if entity.Type == EntityType.ENTITY_MEMBRAIN and entity.FrameCount == 1 and rng:RandomInt(13) == 0 and entity.Variant ~= Entities.POISON_HEMISPHERE.variant then
            entity:Remove()
            
            Isaac.Spawn(EntityType.ENTITY_MEMBRAIN, Entities.POISON_MASTERMIND.variant, 0, entity.Position, NullVector, nil)
        end
        
        if entity.SpawnerVariant == Entities.POISON_HEMISPHERE.variant and entity.Type == EntityType.ENTITY_PROJECTILE then
            entity:Remove()
            
            if rng:RandomInt(100) <= 25 then
                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, entity.Position, entity.Velocity + (RandomVector() * 2), entity):ToTear()
                local sprite = tear:GetSprite()
                
                sprite:ReplaceSpritesheet(0, "gfx/Ipecac.png")
                sprite:LoadGraphics()
                
                tear.Height = -40
                tear.FallingAcceleration = 0.5
                tear.FallingSpeed = 0
                tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                tear:GetData().IsIpecac = true
                tear.SpawnerType = Entities.POISON_MASTERMIND.id
            end
        end
        
        if entity.Type == EntityType.ENTITY_TEAR and entity:IsDead() and data.IsIpecac and entity.SpawnerType == Entities.POISON_MASTERMIND.id then
            local boom = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, NullVector, entity)
            boom:SetColor(Color(0, 1, 0, 1, 0, 0, 0), -1, 1, false, false)
            
            if player.Position:DistanceSquared(entity.Position) < 70^2 then
                player:TakeDamage(2, 0, EntityRef(entity), 5)
            end
        end
        
        if entity.SpawnerType == Entities.POISON_MASTERMIND.id then
            if (entity.SpawnerVariant == Entities.POISON_HEMISPHERE.variant or entity.SpawnerVariant == Entities.POISON_MASTERMIND.variant) and entity.Type == EntityType.ENTITY_GUTS then
                entity:Remove()
            end
            
            if entity.SpawnerVariant == Entities.POISON_MASTERMIND.variant and entity.Type == EntityType.ENTITY_PROJECTILE then
                entity:Remove()
                
                if rng:RandomInt(100) <= 50 then
                  local tear = Isaac.Spawn(2, 0, 0, entity.Position, entity.Velocity + (RandomVector() * 2), entity):ToTear()
                  local sprite = tear:GetSprite()
                  
                  sprite:ReplaceSpritesheet(0,"gfx/Ipecac.png")
                  sprite:LoadGraphics()
                  
                  tear.Height = -40
                  tear.FallingAcceleration = 0.5
                  tear.FallingSpeed = 0
                  tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                  tear:GetData().IsIpecac = true
                  tear.SpawnerType = Entities.POISON_MASTERMIND.id
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.poisonEnemiesUpdate)

function Exodus:poisonEntityUpdate(entity)
    local sprite = entity:GetSprite()
    
    if entity.Variant == Entities.POISON_HEMISPHERE.variant then
        entity.SplatColor = Color(0, 0.9, 0, 1, 0, 0, 0)
        
        if entity:IsDead() then
            Isaac.Spawn(EntityType.ENTITY_POISON_MIND, 0, 0, entity.Position, NullVector, entity)
        end
        
        if entity:HasEntityFlags(EntityFlag.FLAG_POISON) and entity.HitPoints < entity.MaxHitPoints then
            entity.HitPoints = entity.HitPoints + 1
        end
        
        if rng:RandomInt(10) == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_GREEN, 0, entity.Position, NullVector, entity):ToEffect()
            creep:SetTimeout(100)
        end
    end
    
    if entity.Variant == Entities.POISON_MASTERMIND.variant then
        entity.SplatColor = Color(0, 0.9, 0, 1, 0, 0, 0)
        entity.Velocity = entity.Velocity * 0.9
        
        if entity:IsDead() then
            Isaac.Spawn(EntityType.ENTITY_POISON_MIND, 0, 0, entity.Position, NullVector, entity)
            Isaac.Spawn(EntityType.ENTITY_POISON_MIND, 0, 0, entity.Position, NullVector, entity)
        end 
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.poisonEntityUpdate, Entities.POISON_MASTERMIND.id)

--<<<BLOCKAGE>>>--
function Exodus:blockageEntityUpdate(entity)
    local player = Isaac.GetPlayer(0)
    local data = entity:GetData()
    local sprite = entity:GetSprite()
    local target = entity:GetPlayerTarget()
    local room = game:GetRoom()
    
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
            sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
        end
        
        if sprite:IsFinished("Burrow") then
            entity.Visible = false
            entity.State = 2
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    elseif entity.State == 2 then -- Burrowed
        data.State2Frames = data.State2Frames + 1
        
        if data.State2Frames == 1 then
            data.State2SpikeTime = math.random(20, 100)
        end
        
        if data.State2Frames == data.State2SpikeTime then
            entity.State = 3
            entity.Visible = true
        end
    elseif entity.State == 3 then -- Attacking
        data.State3Frames = data.State3Frames + 1
        sprite:Play("Spike", false)
        
        if sprite:IsEventTriggered("Spike") then
            sfx:Play(SoundEffect.SOUND_GOOATTACH0, 1, 0, false, 1)
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        elseif sprite:IsEventTriggered("Retreat") then
            sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
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
            data.State4BurrowTime = math.random(40, 200)
            sprite:Play("Emerge", false)
            sfx:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT, 1, 0, false, 1)
        end
        
        if data.State4Frames == 13 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        
        if sprite:IsFinished("Emerge") then
            sprite:Play("Watching", false)
        end
        
        if data.State4Frames == data.State4BurrowTime then
            sprite:Play("Burrow", false)
            sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)    
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

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.blockageEntityUpdate, Entities.BLOCKAGE.id)

--<<<BROOD>>>--
local broodbehaviors = {}

function broodbehaviors.init(npc, data)
    local sprite = npc:GetSprite()
    if sprite:IsFinished("Appear") then
        data.state = "preidle"
    end
end

function broodbehaviors.preidle(npc, data)
    local sprite = npc:GetSprite()
    data.counter = 0
    data.state = "idle"
    sprite:Play("Idle", true)
end

function broodbehaviors.idle(npc, data)
    data.counter = data.counter + 1
    npc.Velocity = npc.Velocity * 0.8
    if data.counter > 30 and math.random() > 1.5-data.counter/60 then
        data.state = "prewalk"
    end
end

function broodbehaviors.prewalk(npc, data)
    local sprite = npc:GetSprite()
    data.state = "walk"
    local ang = math.random()*math.pi*2
    data.dir = Vector(math.sin(ang), math.cos(ang))
    data.duration = math.random()*40+10
    data.counter = 0
    sprite:Play("Walk")
end

function broodbehaviors.walk(npc, data)
    data.counter = data.counter + 1

    npc.Velocity = npc.Velocity * 0.6 + data.dir * 2

    if data.counter > data.duration then
        data.counter = 0
        data.state = "preidle"
    end
end

function broodUpdate(_, npc)
    if not npc:Exists() or npc:IsDead() then return end

    local data = npc:GetData()
    local f = broodbehaviors[data.state]
    if not f then
        Isaac.DebugString("Missing brood behavior: "..data.state)
        return
    end

    if npc:HasMortalDamage() then
        local pos = npc.Position
        for i = 1, math.random(5)+7 do
            EntityNPC.ThrowSpider(pos, npc, pos+RandomVector()*100*(math.random()*0.7+0.3), false, 0)
        end
        return
    end

    f(npc, data)
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, broodUpdate, Entities.BROOD.id)

function broodInit(_, npc)
    local data = npc:GetData()
    local sprite = npc:GetSprite()

    data.state = "init"

    sprite:Play("Appear", true)
end

Exodus:AddCallback(ModCallbacks.MC_POST_NPC_INIT, broodInit, Entities.BROOD.id)

--<<<CLOSTER>>>--
function Exodus:closterEntityUpdate(entity)
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
        sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS ,1,0,false,0.7)
        
        if math.random(2) == 1 then
            for i = 1, 6 do 
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position + Vector(math.random(-20, 20), math.random(-20, 20)), Vector(0, 0), entity):ToEffect()
                creep.Scale = creep.Scale * 1.2
            end
            
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position , Vector(0, 0), entity):ToEffect()
            creep.Scale = creep.Scale * 1.2
        else
            Isaac.Spawn(Entities.DANK_DIP.id, Entities.DANK_DIP.variant, 0, entity.Position + Vector(math.random(-2, 2), math.random(-2, 2)), Vector(0, 0), entity)
        end
        
        sprite:Play("Idle", false) 
        entity.Pathfinder:MoveRandomly(false)
    end
    
    entity.Velocity = entity.Velocity:Resized(math.random(1, 2))
    
    if entity:IsDead() then
        for i = 1, 2 do
            Isaac.Spawn(EntityType.ENTITY_CLOTTY, 1, 0, entity.Position + Vector(math.random(-2, 2), math.random(-2, 2)), Vector(0, 0), entity)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.closterEntityUpdate, Entities.CLOSTER.id)

--<<<HALFBLIND>>>--
function Exodus:halfblindTakeDamage(target, amount, flag, source, cdframes)
    local data = target:GetData()
    
    if source.Type == EntityType.ENTITY_TEAR then -- Is tear
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

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.halfblindTakeDamage, Entities.HALFBLIND.id)

function Exodus:halfblindEntityUpdate(entity)
    local player = Isaac.GetPlayer(0)
    local data = entity:GetData()
    local sprite = entity:GetSprite()
    local target = entity:GetPlayerTarget()
    local room = Game():GetRoom()
    
    local angle = (target.Position - entity.Position):GetAngleDegrees()
    
    for i, ent in pairs(Isaac.GetRoomEntities()) do
        if ent.Type == EntityType.ENTITY_TEAR then
            ent:GetData().LastVelocity = entity.Velocity
        end
    end
    
    if sprite:IsEventTriggered("Decelerate") then -- Decelerate
        entity.Velocity = entity.Velocity * 0.8
    elseif sprite:IsEventTriggered("Stop") then -- Stop Velocity
        entity.Velocity = Vector(0,0)
    elseif sprite:IsEventTriggered("Brimstone Up") then -- Shoot up
        EntityLaser.ShootAngle(1, entity.Position, -90, 30, Vector(0, -30), entity)
    elseif sprite:IsEventTriggered("Brimstone Down") then -- Shoot down
        EntityLaser.ShootAngle(1, entity.Position, 90, 30, Vector(0, -30), entity)
    elseif sprite:IsEventTriggered("Brimstone Hori") then -- Shoot horizontal
        if sprite.FlipX == false then
            EntityLaser.ShootAngle(1, entity.Position, 180, 30, Vector(0, -30), entity)
        else
            EntityLaser.ShootAngle(1, entity.Position, 0, 30, Vector(0, -30), entity)
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

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.halfblindEntityUpdate, Entities.HALFBLIND.id)

--<<<HEADCASE>>>--
function Exodus:headcaseEntityUpdate(entity)
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
        
        for i = 1, math.random(4) do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position + Vector(math.random(-5, 5), math.random(-5, 5)), Vector(0, 0), entity)
        end
        
        for i = 0, 7 do
            local boom = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, entity.Position, Vector.FromAngle(i * 45):Resized(10), entity)
            boom:ToTear().FallingSpeed = -10
            boom:ToTear().FallingAcceleration = 1
            boom:GetData().IsExodusLobbed = true
            boom.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        end
        
        sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 4, 0, false, 1)
    end
    
    if entity.State == 0 then
        if entity.FrameCount > 1 then
            sprite:Play("Idle", false)
        end
        
        entity.Velocity = (target.Position - entity.Position):Resized(30)
        
        if entity.Position:DistanceSquared(target.Position) < 20^2 then
            entity.State = 2
            sfx:Play(SoundEffect.SOUND_BOSS_GURGLE_ROAR , 2, 0, false, 0.8)
        end
    elseif entity.State == 2 then
        sprite:Play("Stomp", false)
        
        if sprite:IsFinished("Stomp") then
            entity.State = 0
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.headcaseEntityUpdate, Entities.HEADCASE.id)

--<<<HOLLOWHEAD>>>--
function Exodus:hollowheadEntityUpdate(entity)
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
        local telegraph = EntityLaser.ShootAngle(2, entity.Position, angle, 34, Vector(0, -40), entity)
        telegraph.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        telegraph.Color = Color(telegraph.Color.R, telegraph.Color.G, telegraph.Color.B, 0.7, 0, 0, 100)
        telegraph:SetMaxDistance(80)
        
        local telegraph1 = EntityLaser.ShootAngle(2, entity.Position, angle + 180, 34, Vector(0, -40), entity)
        telegraph1.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        telegraph1.Color = Color(telegraph1.Color.R, telegraph1.Color.G, telegraph1.Color.B, 0.7, 0, 0, 100)
        telegraph1:SetMaxDistance(80)
        data.TelegraphLaser = telegraph
        data.TelegraphLaser1 = telegraph1
    elseif sprite:IsEventTriggered("Stop Follow") then
        data.StopFollowing = true
    elseif sprite:IsEventTriggered("Shoot") then
        sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 2, 0, false, 0.8)
        
        local real_laser = EntityLaser.ShootAngle(9, entity.Position, data.TelegraphLaser:ToLaser().AngleDegrees, 13, Vector(0, -45), entity)
        local real_laser1 = EntityLaser.ShootAngle(9, entity.Position, data.TelegraphLaser:ToLaser().AngleDegrees + 180, 13, Vector(0, -45), entity)
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

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.hollowheadEntityUpdate, Entities.HOLLOWHEAD.id)

--<<<WOMBSHROOM>>>--
function Exodus:wombshroomEntityUpdate(entity)
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
        Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.BLOOD, 0, entity.Position, Vector.FromAngle(data.ShotAngle * 45 + 90):Resized(10), entity)
        sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1)
        data.ShotAngle = data.ShotAngle + 1
    elseif sprite:IsEventTriggered("Splash") then
        for i = 0, 8 do
            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.BLOOD, 0, entity.Position, Vector.FromAngle(i * 45 + 90):Resized(10), entity)
        end
        
        sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 2, 0, false, 0.8)
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

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.wombshroomEntityUpdate, Entities.WOMBSHROOM.id)

--<<<CARRION PRINCE>>>--
function Exodus:carrionPrinceEntityUpdate(entity)
    local data = entity:GetData()
    local sprite = entity:GetSprite()
    local target = entity:GetPlayerTarget()
    local room = game:GetRoom()
    
    local angle = (target.Position - entity.Position):GetAngleDegrees()

    if entity.FrameCount <= 1 then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        data.DirectionMultiplier = math.random(5)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        data.BombTimer = -1
        data.ChargeCooldown = 0
    end
    
    if entity.State >= 7 then
        entity.Velocity = Vector(0, 0)
        
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
        for i, ent in pairs(Isaac.GetRoomEntities()) do
            if ent:ToBomb() then
                if ent.Position:DistanceSquared(entity.Position) < (entity.Size + ent.Size)^2 then
                    entity.State = entity.State + 4
                    data.BombTimer = 15
                    ent:Remove()
                end
            end
        end
    end
    
    if entity.State == 0 then -- Spawn Stuff
        if entity:GetData().MainNPC == nil then
            local Body1 = Isaac.Spawn(Entities.CARRION_PRINCE.id, 0, 0, entity.Position, Vector(0,0), entity)
            Body1.Parent = entity
            Body1:GetData().IsBody = true
            Body1:GetData().MainNPC = entity
            
            local Body2 = Isaac.Spawn(Entities.CARRION_PRINCE.id, 0, 0, entity.Position, Vector(0,0), entity)
            Body2.Parent = Body1
            Body2:GetData().IsBody = true
            Body2:GetData().MainNPC = entity
            
            local Body3 = Isaac.Spawn(Entities.CARRION_PRINCE.id, 0, 0, entity.Position, Vector(0,0), entity)
            Body3.Parent = Body2
            Body3:GetData().IsBody = true
            Body3:GetData().MainNPC = entity
            
            local Butt = Isaac.Spawn(Entities.CARRION_PRINCE.id, 0, 0, entity.Position, Vector(0,0), entity)
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
            if entity.Position:DistanceSquared(entity.Parent.Position) > 30^2 then
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
            
            local dirAngle = (target.Position - entity.Position):GetAngleDegrees()
            
            if entity:GetData().ChargeCooldown > 0 then
                entity:GetData().ChargeCooldown = entity:GetData().ChargeCooldown - 1
            end
            
            if dirAngle > 170 and dirAngle < 190 and room:CheckLine(entity.Position, target.Position, 0, 10, false, false) and entity:GetData().ChargeCooldown == 0 then -- Facing Left
                entity.State = 3
                sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_2, 1, 0, false, 1)
                entity:GetData().ChargeCooldown = 300
            elseif dirAngle > -10 and dirAngle < 10 and room:CheckLine(entity.Position, target.Position, 0, 10, false, false) and entity:GetData().ChargeCooldown == 0 then -- Facing Right
                entity.State = 4
                sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_1, 1, 0, false, 1)
                entity:GetData().ChargeCooldown = 300
            elseif dirAngle < -80 and dirAngle > -100 and room:CheckLine(entity.Position, target.Position, 0, 10, false, false) and entity:GetData().ChargeCooldown == 0 then -- Facing Up
                entity.State = 5
                sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_0, 1, 0, false, 1)
                entity:GetData().ChargeCooldown = 300
            elseif dirAngle > 80 and dirAngle < 100 and room:CheckLine(entity.Position, target.Position, 0, 10, false, false) and entity:GetData().ChargeCooldown == 0 then -- Facing Down
                entity.State = 6
                sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_0, 1, 0, false, 1)
                entity:GetData().ChargeCooldown = 300
            end
        end
        
        if data.IsBody then
            if math.abs(data.MainNPC.Velocity.Y) > math.abs(data.MainNPC.Velocity.X) then
                sprite:Play("WalkBodyVert", false)
            else    
                sprite:Play("WalkBodyHori", false)
                
                if data.MainNPC.Velocity.X > 0 then
                    sprite.FlipX = false
                else
                    sprite.FlipX = true
                end
            end
        elseif data.IsButt then
            if math.abs(data.MainNPC.Velocity.Y) > math.abs(data.MainNPC.Velocity.X) then
                if data.MainNPC.Velocity.Y > 0 then
                    sprite:Play("WalkButtDown", false)
                else
                    sprite:Play("WalkButtUp", false)
                end
            else    
                if data.MainNPC.Velocity.X > 0 then
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

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.carrionPrinceEntityUpdate, Entities.CARRION_PRINCE.id)

function Exodus:carrionPrinceTakeDamage(target, amount, flag, source, cd)
    if target:GetData().IsButt ~= true then
        return false
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.carrionPrinceTakeDamage, Entities.CARRION_PRINCE.id)

--<<<LITHOPEDION>>>--
function Exodus:lithopedionEntityUpdate(entity)
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
        entity.Velocity = Vector(0, 0)
        sprite:Play("Attack", false)
    end
    
    if sprite:IsEventTriggered("Stomp") then
        sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS , 2, 0, false, 0.8)
        
        if math.random(2) == 1 then
            local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, entity.Position, Vector(0,0), entity)
            shockwave:ToEffect():SetRadii(20, 100)
        else
            local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE_RANDOM , 0, entity.Position, Vector(0,0), entity)
            shockwave:ToEffect():SetTimeout(200)
        end
        
        sprite:Play("Idle", false) 
        entity.Pathfinder:MoveRandomly(false)
    end
    
    entity.Velocity = entity.Velocity:Resized(math.random(1, 2))
    
    if entity:IsDead() then
        for i = 1, 2 do
            Isaac.Spawn(Entities.BLOCKAGE.id, 0, 0, entity.Position + Vector(math.random(-2, 2), math.random(-2, 2)), Vector(0, 0), entity)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.lithopedionEntityUpdate, Entities.LITHOPEDION.id)

function Exodus:lithopedionTakeDamage(target, amount, flag, source, cd)
    if source.Type == 0 and source.Variant == 0 and flag == 4 then
        return false
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.lithopedionTakeDamage, Entities.LITHOPEDION.id)

--<<<FLESH DEATH'S EYE>>>--
function Exodus:fleshDeathsEyeEntityUpdate(entity)
    if entity.Variant == Entities.FLESH_DEATHS_EYE.variant then
        local player = Isaac.GetPlayer(0)
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        
        local angle = (target.Position - entity.Position):GetAngleDegrees()
        
        if sprite:IsEventTriggered("Shoot") then
            sfx:Play(SoundEffect.SOUND_GURG_BARF , 1, 0, false, 1)
            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.BLOOD, 0, entity.Position, Vector.FromAngle(angle + 10):Resized(10), entity)
            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.BLOOD, 0, entity.Position, Vector.FromAngle(angle - 10):Resized(10), entity)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.fleshDeathsEyeEntityUpdate, Entities.FLESH_DEATHS_EYE.id)

function Exodus:fleshDeathsEyeDeath()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == Entities.FLESH_DEATHS_EYE.id and entity.Variant == Entities.FLESH_DEATHS_EYE.variant and entity:HasMortalDamage() then
            for v = 0, 7 do
                Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, Vector.FromAngle(v * 45):Resized(10), entity)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.fleshDeathsEyeDeath)

--<<<DEATH'S EYE>>>--
function Exodus:deathsEyeEntityUpdate(entity)
    if entity.Variant == Entities.DEATHS_EYE.variant then
        local player = Isaac.GetPlayer(0)
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        
        local angle = (target.Position - entity.Position):GetAngleDegrees()
        
        if sprite:IsEventTriggered("Shoot") then
            sfx:Play(SoundEffect.SOUND_FIRE_RUSH , 1, 0, false, 1)
            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.FIRE, 0, entity.Position, Vector.FromAngle(angle):Resized(10), entity)
        end
        
        entity.Velocity = entity.Velocity:Resized(5)
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.deathsEyeEntityUpdate, Entities.DEATHS_EYE.id)

function Exodus:deathsEyeTakeDamage(target, amount, flag, source, cdframes)
    if target.Variant == Entities.DEATHS_EYE.variant then
        return false
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.deathsEyeTakeDamage, Entities.DEATHS_EYE.id)

--<<<LOVELY FLIES>>>--
local FLIES = {
    LOVELY_FLY = { 
        turnFactor = 1, --This value influences how fast the fly will turn towards the player when it can't find a mate
        velocityFactor = 1, --This value influences how fast the fly will move towards the player when it can't find a mate
        parentOffset = Vector(50, 0), --How far away the fly will orbit from the enemy, a normal room is 500x260 units
        orbitDamage = 0, --This value tells the game how much collision damage the fly should deal to the player when it's orbiting or finding a mate
        noMateDamage = 0, --This value tells the game how much collision damage the fly should deal to the player when it can't find a mate
        maxHealing = 15, --How much the Lovely Fly heals base damage tear deals 3.5 damage
        healDelay = 60, --How long between heals, in ticks, 30 ticks per second,
        healPercentage = 20, --The percentage of it's max health an enemy will gain when the Lovely Fly heals it
        healColour = Color(1, 1, 1, 1, 50, 50, 50), --The base colour that enemies will be set to when this fly heals them
    },
    
    SOULFUL_FLY = { 
        turnFactor = 1, --This value influences how fast the fly will turn towards the player when it can't find a mate
        velocityFactor = 1, --This value influences how fast the fly will move towards the player when it can't find a mate
        parentOffset = Vector(50, 0), --How far away the fly will orbit from the enemy, a normal room is 500x260 units
        orbitDamage = 0, --This value tells the game how much collision damage the fly should deal to the player when it's orbiting or finding a mate
        noMateDamage = 0, --This value tells the game how much collision damage the fly should deal to the player when it can't find a mate
        baseColour = Color(1, 1, 1, 1, 50, 50, 50), --The base colour that enemies will be set to while this fly is on them
        invincibilityColour = Color(1, 1, 1, 1, 125, 150, 200) --The colour that enemies will flash when this fly prevents damage
    },
    
    HATEFUL_FLY = { 
        turnFactor = 1, --This value influences how fast the fly will turn towards the player when it can't find a mate
        velocityFactor = 8, --This value influences how fast the fly will move towards the player when it can't find a mate
        parentOffset = Vector(50, 0), --How far away the fly will orbit from the enemy, a normal room is 500x260 units,
        orbitDamage = 0, --This value tells the game how much collision damage the fly should deal to the player when it's orbiting or finding a mate
        noMateDamage = 1, --This value tells the game how much collision damage the fly should deal to the player when it can't find a mate
        rotationAmount = 5, --This value influences by how many degrees the fly will rotate at a time to be pointed towards the player
        baseColour = Color(0.6, 0.6, 0.6, 1, 0, 0, 0), --The base colour that enemies will be set to while this fly is on them
    },
    
    HATEFUL_FLY_GHOST = { 
        turnFactor = 0.5, --This value influences how fast the fly will turn towards the player when it can't find a mate
        velocityFactor = 6, --This value influences how fast the fly will move towards the player when it can't find a mate
        baseColour = Color(0.6, 0.5, 0.5, 1, 0, 0, 0), --The base colour that enemies will be set to while this fly is on them
    }
}

local function getTableByVariant(variant)
    if variant == Entities.LOVELY_FLY.variant then
        return FLIES.LOVELY_FLY
    elseif variant == Entities.SOULFUL_FLY.variant then
        return FLIES.SOULFUL_FLY
    elseif variant == Entities.HATEFUL_FLY.variant then
        return FLIES.HATEFUL_FLY
    elseif variant == Entities.HATEFUL_FLY_GHOST.variant then
        return FLIES.HATEFUL_FLY_GHOST
    end
end

function Exodus:lovelyFlyLogic(fly)
    local data = fly:GetData()
    local sprite = fly:GetSprite()
    local player = Isaac.GetPlayer(0)
    local flyStats = getTableByVariant(fly.Variant)
    local noMate = "Alone"
    
    --[[
    This code covers the function of every fly except the Hateful Fly Ghost such as finding a parent enemy, lack of enemies, etc.
    ]]
    if fly.Variant ~= Entities.HATEFUL_FLY_GHOST.variant then
        if fly.FrameCount <= 1 then
            fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            fly.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            
            data.parentOffset = flyStats.parentOffset
            data.orbitAngle = 0
            data.lockedToParent = false
            data.parentEnemy = nil
            
            sprite:Play("Looking for a mate", true)
        end
        
        if not data.parentEnemy or data.parentEnemy == noMate then
            local nearEnemy
            local checkDist = 1000000000
            
            for i, entity in pairs(Isaac.GetRoomEntities()) do
                if entity:IsVulnerableEnemy() and entity.Index ~= fly.Index and entity.InitSeed ~= fly.InitSeed then
                    local newDist = fly.Position:DistanceSquared(entity.Position)
                    local entityData = entity:GetData()
                    
                    if newDist < checkDist then
                        local ignore = false
                        
                        if fly.Variant == Entities.LOVELY_FLY.variant and entity.Type == fly.Type and not ignore then
                            ignore = true
                        end
                        
                        if (fly.Variant == Entities.LOVELY_FLY.variant or Entities.SOULFUL_FLY.variant) and not ignore then
                            if entityData.childFlies and #entityData.childFlies >= 3 then
                                ignore = true
                            end
                        end
                        
                        if not ignore then
                            local recursion = true
                            local checkData = entityData
                            
                            while recursion do
                                if checkData.parentEnemy and checkData.parentEnemy ~= noMate then
                                    if checkData.parentEnemy.Index == fly.Index and checkData.parentEnemy.InitSeed == fly.InitSeed then
                                        recursion = false
                                        ignore = true
                                    else
                                        checkData = checkData.parentEnemy:GetData()
                                    end
                                else
                                    recursion = false
                                end
                            end
                        end
                        
                        if entityData.parentEnemy and entityData.parentEnemy.Index == fly.Index and entityData.parentEnemy.InitSeed == fly.InitSeed and not ignore then
                            ignore = true
                        end
                        
                        if fly.Variant == Entities.HATEFUL_FLY.variant and not ignore then
                            if entityData.hasHatefulFly then
                                ignore = true
                            end
                        end
                        
                        if not ignore then
                            nearEnemy = entity
                            checkDist = newDist
                        end
                    end
                end
            end
            
            if nearEnemy then
                if not sprite:IsPlaying("Looking for a mate") then
                    sprite:Play("Looking for a mate", true)
                end
                
                local entityData = nearEnemy:GetData()
                data.parentEnemy = nearEnemy
                
                if fly.Variant ~= Entities.HATEFUL_FLY.variant then
                    if entityData.childFlies then
                        table.insert(entityData.childFlies, fly)
                    else
                        entityData.childFlies = { fly }
                    end
                else
                    entityData.hasHatefulFly = true
                end
            else
                data.parentEnemy = noMate
            end
        else
            if data.parentEnemy:IsDead() or not data.parentEnemy:Exists() then
                data.parentEnemy = nil
                data.lockedToParent = false
            else
                if not data.lockedToParent then
                    fly.Velocity = (fly.Velocity + ((data.parentEnemy.Position - fly.Position):Normalized())):Normalized() * 5
                    
                    if fly.Position:DistanceSquared(data.parentEnemy.Position) <= 5625 then
                        data.lockedToParent = true
                        data.orbitAngle = math.floor((fly.Position - data.parentEnemy.Position):GetAngleDegrees())
                        fly.Velocity = Vector(0, 0)
                        
                        sprite:Play("Found a mate")
                    end
                 else
                    if fly.Position:DistanceSquared(data.parentEnemy.Position) > 6400 then
                        data.lockedToParent = false
                    else
                        local parentData = data.parentEnemy:GetData()
                        
                        if fly.Variant ~= Entities.HATEFUL_FLY.variant then
                            local index = 1
                            
                            for u, childEnt in ipairs(parentData.childFlies) do
                                if childEnt.Index == fly.Index and childEnt.InitSeed == fly.InitSeed then
                                    index = u
                                end
                            end
                            
                            if index == 1 then
                                data.orbitAngle = data.orbitAngle + 3
                            else
                                local targetAngle = (parentData.childFlies[index - 1]:GetData().orbitAngle + (360 / #parentData.childFlies)) % 360
                            
                                if math.abs(data.orbitAngle - targetAngle) > 6 or math.abs(data.orbitAngle - targetAngle) > 354 then
                                    data.orbitAngle = data.orbitAngle + 6
                                else
                                    data.orbitAngle = targetAngle
                                end
                            end
                            
                            if data.orbitAngle >= 360 then
                                data.orbitAngle = data.orbitAngle % 360
                            elseif data.orbitAngle < 0 then
                                data.orbitAngle = 360 - (data.orbitAngle % 360)
                            end
                            
                            fly.Velocity = Vector(0, 0)
                            fly.Position = data.parentEnemy.Position + data.parentOffset:Rotated(data.orbitAngle)
                        end
                    end
                end
            end
        end
        
        if data.parentEnemy == noMate then
            if not sprite:IsPlaying("I have no mate") then
                sprite:Play("I have no mate", true)
            end
            
            local turnFactor = flyStats.turnFactor
            local velFactor = math.min(flyStats.velocityFactor * player.MoveSpeed, flyStats.velocityFactor)
            
            fly.CollisionDamage = flyStats.noMateDamage
            fly.Velocity = (fly.Velocity + ((player.Position - fly.Position):Normalized() * turnFactor)):Normalized() * velFactor
        else
            fly.CollisionDamage = flyStats.orbitDamage
        end
    end
    
    --[[
    This code covers the special abilities for the Lovely Fly
    ]]
    if fly.Variant == Entities.LOVELY_FLY.variant then
        if fly.FrameCount <= 1 then
            data.healTimer = flyStats.healDelay
        end
        
        if data.parentEnemy and data.parentEnemy ~= noMate then
            if not data.parentEnemy:IsDead() and data.parentEnemy:Exists() then
                if data.lockedToParent then
                    if data.parentEnemy.HitPoints < data.parentEnemy.MaxHitPoints then
                        if data.healTimer > 0 then
                            data.healTimer = data.healTimer - 1
                        else
                            data.parentEnemy.HitPoints = data.parentEnemy.HitPoints + math.min(flyStats.maxHealing, math.ceil(data.parentEnemy.MaxHitPoints / (100 / flyStats.healPercentage)))
                            data.parentEnemy:SetColor(Color(1, 0.5, 0.5, 1, 50, 0, 0), 10, 1, true, false)
                            data.healTimer = flyStats.healDelay
                            
                            fly:SetColor(flyStats.healColour, 10, 1, true, false)
                        end
                    end
                end
            end
        end
        
    --[[
    This code covers the special abilites for the Soulful Fly
    ]]
    elseif fly.Variant == Entities.SOULFUL_FLY.variant then
        if data.parentEnemy and data.parentEnemy ~= noMate then
            if not data.parentEnemy:IsDead() and data.parentEnemy:Exists() then
                if data.lockedToParent then
                    local parentData = data.parentEnemy:GetData()
                    
                    if not parentData.invulnFrames then
                        data.parentEnemy:SetColor(flyStats.baseColour, 2, 1, true, false)
                    elseif parentData.invulnFrames > 0 then
                        parentData.invulnFrames = parentData.invulnFrames - 1
                    else
                        parentData.invulnFrames = false
                    end
                end
            end
        end
    
    --[[
    This code covers the special abilites for the Hateful Fly
    ]]
    elseif fly.Variant == Entities.HATEFUL_FLY.variant then
        if sprite:IsFinished("Wait what?") then
            local ghost = Isaac.Spawn(Entities.HATEFUL_FLY_GHOST.id, Entities.HATEFUL_FLY_GHOST.variant, 0, fly.Position, fly.Velocity, fly)
            
            ghost:GetData().tetherEnemy = data.parentEnemy
            fly:Kill()
        else
            if data.parentEnemy and data.parentEnemy ~= noMate then
                if not data.parentEnemy:IsDead() and data.parentEnemy:Exists() then
                    if data.lockedToParent then
                        local parentData = data.parentEnemy:GetData()
                            
                        local moveAngle = math.ceil(flyStats.rotationAmount * player.MoveSpeed)
                        local targetAngle = math.ceil((fly.Position - player.Position):GetAngleDegrees()) + 180
                        local angleDif = math.abs(data.orbitAngle - targetAngle)
                        
                        if (angleDif > moveAngle and angleDif < 360 - moveAngle) and player.Position:DistanceSquared(fly.Position) > 400 then
                            local sign = 1
                            
                            if angleDif > 180 then
                                if data.orbitAngle < targetAngle then
                                    sign = -1
                                end
                            else
                                if data.orbitAngle > targetAngle then
                                    sign = -1
                                end
                            end
                            
                            data.orbitAngle = math.ceil(data.orbitAngle + (moveAngle * sign))
                        end
                        
                        if data.orbitAngle >= 360 then
                            data.orbitAngle = data.orbitAngle % 360
                        elseif data.orbitAngle < 0 then
                            data.orbitAngle = 360 + (data.orbitAngle % 360)
                        end
                        
                        --data.parentEnemy:SetColor(flyStats.baseColour, 2, 1, false, false)
                        
                        fly.Velocity = Vector(0, 0)
                        fly.Position = data.parentEnemy.Position + data.parentOffset:Rotated(data.orbitAngle)
                    end
                end
            end
        end
        
    --[[
    This code covers the special abilities for the Hateful Fly Ghost
    ]]
    elseif fly.Variant == Entities.HATEFUL_FLY_GHOST.variant then
        if data.tetherEnemy and (data.tetherEnemy:IsDead() or not data.tetherEnemy:Exists()) then
            fly:Kill()
        else
            if fly.FrameCount <= 1 then
                fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                fly.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                
                sprite:Play("RIP", true)
            end
            
            data.tetherEnemy:SetColor(flyStats.baseColour, 2, 1, false, false)
            
            fly.Velocity = (fly.Velocity + ((player.Position - fly.Position):Normalized() * flyStats.turnFactor)):Normalized() * math.min(flyStats.velocityFactor * player.MoveSpeed, flyStats.velocityFactor)
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.lovelyFlyLogic, Entities.LOVELY_FLY.id)

function Exodus:moveFlyChildren(entity)
    local data = entity:GetData()
    
    if data.childFlies then
        for i, fly in ipairs(data.childFlies) do
            if fly:IsDead() or not fly:Exists() or fly:GetData().parentEnemy == "Alone" then
                table.remove(data.childFlies, i)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.moveFlyChildren)

function Exodus:soulfulFlyInvincibility(entity, dmgAmount, dmgFlags, dmgSource, invulnFrames)
    local data = entity:GetData()
    
    if data.childFlies then
        for i, fly in ipairs(data.childFlies) do
            if fly.Variant == Entities.SOULFUL_FLY.variant and fly:GetData().lockedToParent then
                local flyStats = getTableByVariant(fly.Variant)
                
                data.invulnFrames = 6
                entity:SetColor(flyStats.invincibilityColour, 10, 1, true, false)
                return false
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.soulfulFlyInvincibility)

function Exodus:hatefulFlyGhost(entity, dmgAmount, dmgFlags, dmgSource, invulnFrames)
    local data = entity:GetData()
    dmgSource = getEntityFromRef(dmgSource)
    
    if entity.Variant == Entities.HATEFUL_FLY.variant then
        if dmgSource:ToTear() and dmgSource:ToTear().TearFlags & TearFlags.TEAR_PIERCING == TearFlags.TEAR_PIERCING then
            dmgSource:Kill()
        end
        
        if entity.HitPoints - dmgAmount <= 0 and data.lockedToParent then
            data.parentEnemy:GetData().hasHatefulFly = false
            
            entity:GetSprite():Play("Wait what?", true)
            return false
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.hatefulFlyGhost, Entities.HATEFUL_FLY.id)

function Exodus:hatefulFlyLaserStop(fly)
    local player = Isaac.GetPlayer(0)
    local entities = Isaac.GetRoomEntities()
    
    for i, entity in pairs(entities) do
        if entity:ToLaser() and entity.Parent:ToPlayer() then
            local laser = entity:ToLaser()
            local data = laser:GetData()
            
            if data.flyStopped then 
                if laser.Radius <= 10 then
                    laser:Remove()
                elseif laser.Velocity:LengthSquared() < 0.5 then
                    laser.Velocity = data.flyStopped
                    data.flyStopped = false
                end
                
            end
            
            for u, fly in pairs(entities) do
                if fly.Type == Entities.HATEFUL_FLY.id and fly.Variant == Entities.HATEFUL_FLY.variant then
                    if not laser:IsCircleLaser() then
                        local angle = (fly.Position - laser.Position):GetAngleDegrees()
                        
                        if math.abs(math.abs(angle) - math.abs(laser.Angle)) < 20 then
                            local room = Game():GetLevel():GetCurrentRoom()
                            local centreY = room:GetCenterPos().Y
                            local centreX = room:GetCenterPos().X
                                
                            local x1 = laser.Position.X - centreX
                            local y1 = laser.Position.Y - centreY
                            local x2 = fly.Position.X - centreX
                            local y2 = fly.Position.Y - centreY
                            local a = math.tan((360 - laser.Angle) / 180 * math.pi)
                            local b = -1
                            local c = y1 - (a * x1)
                            
                            local perpendicularDist = math.abs((a * x2) + (b * y2) + c) / math.sqrt(a^2 + b^2)
                            local stopDist = 10
                            
                            if laser.Variant == 1 or laser.Variant == 9 then
                                stopDist = 30
                            end
                            
                            if perpendicularDist <= 30 then
                                laser:SetMaxDistance((laser.Position - fly.Position):Length() - stopDist)
                            end
                        end
                    else
                        if laser.FrameCount > 120 then
                            laser:Remove()
                        elseif fly.Position:DistanceSquared(laser.Position) < (laser.Radius^2 + 10) then
                            data.flyStopped = laser.Velocity
                            laser.Velocity = Vector(0, 0)
                            laser.Radius = laser.Radius * 0.9
                        end
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.hatefulFlyLaserStop)

--<<<HOTHEAD>>>--
function Exodus:hotheadEntityUpdate(hothead)
    local path = hothead.Pathfinder
    local sprite = hothead:GetSprite()
    local data = hothead:GetData()
    local target = hothead:GetPlayerTarget()
    local angleVec = target.Position - hothead.Position
    
    local room = game:GetRoom()
    
    if hothead.Variant == Entities.HOTHEAD.variant then
        if hothead.FrameCount <= 1 then
            sprite:ReplaceSpritesheet(0, "gfx/monsters/Hothead" .. math.random(1, 3) .. ".png")
            sprite:LoadGraphics()
            hothead.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            hothead:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            data.soundTimer = math.random(40, 100)
        end
        
        if not data.wakingUp then
            if path:HasPathToPos(target.Position, false) then
                data.wakingUp = true
                
                for i, entity in pairs(Isaac.GetRoomEntities()) do
                    if entity.Type == Entities.HOTHEAD.id and entity.Variant == Entities.HOTHEAD.variant then
                        entity:GetData().wakingUp = true
                    end
                end
            else
                sprite:Play("Sleeping", true)
            end
        else
            if not data.awake then
                if sprite:IsFinished("Awaken") then
                    data.awake = true
                    
                elseif not sprite:IsPlaying("Awaken") then
                    sprite:Play("Awaken", true)
                    sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_3, 1, 0, false, 0.7)
                end
            else
                if path:HasPathToPos(target.Position, false) and not sprite:IsPlaying("Jump") then
                    local directPath = true
                    
                    for i = 20, hothead.Position:Distance(target.Position), 20 do
                        local newPos = hothead.Position + Vector(i, 0):Rotated(angleVec:GetAngleDegrees())
                        local gridEnt = room:GetGridEntityFromPos(newPos)
                        
                        if gridEnt and (gridEnt:ToRock() or gridEnt:ToPit() or gridEnt:ToPoop() or gridEnt:ToTNT() or gridEnt:ToSpikes()) then
                            directPath = false
                            break
                        end
                    end
                    
                    if directPath then
                        local velLimit = 7
                        
                        if target:ToPlayer() then
                            velLimit = velLimit * math.min(math.max(target:ToPlayer().MoveSpeed, 0.7), 1.4)
                        end
                        
                        hothead.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                        hothead:AddVelocity(angleVec:Resized(math.min(150 / angleVec:Length(), 2)))
                        hothead.Velocity = hothead.Velocity:Resized(math.min(hothead.Velocity:Length(), velLimit))
                    else
                        path:FindGridPath(target.Position, 1.5, 0, true)
                    end
                    
                    local velAngle = hothead.Velocity:GetAngleDegrees()
                    
                    if (velAngle > -135 and velAngle < -45) or velAngle < 135 and velAngle > 45 then
                        if not sprite:IsPlaying("WalkVerti") then
                            sprite:Play("WalkVerti", true)
                        end
                    else
                        if velAngle < -90 or velAngle > 90 then
                            sprite.FlipX = true
                        else
                            sprite.FlipX = false
                        end
                    
                        if not sprite:IsPlaying("WalkHori") then
                            sprite:Play("WalkHori", true)
                        end
                    end
                    
                    for i, entity in pairs(Isaac.GetRoomEntities()) do
                        if entity.Type == Entities.HOTHEAD.id and entity.Variant == Entities.HOTHEAD.variant then
                            if entity.Position:DistanceSquared(hothead.Position) < 25^2 then
                                local vel = (entity.Position - hothead.Position):Resized(hothead.Velocity:Length() / 1.5)
                                entity:AddVelocity(vel)
                                hothead:AddVelocity(vel * -1)
                            end
                        end
                    end
                    
                    if data.soundTimer <= 0 then
                        sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_0, 0.8, 0, false, 0.6)
                        data.soundTimer = math.random(40, 100)
                    else
                        data.soundTimer = data.soundTimer - 1
                    end
                else
                    if not sprite:IsPlaying("Jump") then
                        sprite:Play("Jump", true)
                    elseif sprite:IsEventTriggered("Jump") then
                        local jumpPos = Isaac.GetFreeNearPosition(hothead.Position, 20)
                        
                        for i = 50, hothead.Position:Distance(target.Position), 10 do
                            local newPos = hothead.Position + Vector(i, 0):Rotated(angleVec:GetAngleDegrees())
                            local gridEnt = room:GetGridEntityFromPos(newPos)
                                
                            if not gridEnt or (gridEnt and not(gridEnt:ToRock() or gridEnt:ToPit() or gridEnt:ToPoop() or gridEnt:ToTNT() or gridEnt:ToSpikes())) then
                                jumpPos = Isaac.GetFreeNearPosition(newPos, 20)
                                break
                            end
                        end
                        
                        hothead.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                        hothead.Velocity = angleVec:Resized(hothead.Position:Distance(jumpPos) / 11)
                    elseif sprite:GetFrame() == 15 then
                        sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.5)
                    elseif sprite:GetFrame() > 15 then
                        hothead.Velocity = Vector(0, 0)
                    end
                end
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_NPC_UPDATE, Exodus.hotheadEntityUpdate, Entities.HOTHEAD.id)

function Exodus:hotheadTakeDamage(entity, dmgAmount, dmgFlags, dmgSource, invulnFrames)
    if entity.Variant == Entities.HOTHEAD.variant and entity.HitPoints - dmgAmount <= 0 then
        for i = 1, math.random(5, 8) do
            local gibs = Isaac.Spawn(Entities.PIT_GIBS.id, Entities.PIT_GIBS.variant, 0, entity.Position + Vector(0, -15), Vector(math.random(-20, 20), math.random(-20, 20)), entity):ToEffect()
            local sprite = gibs:GetSprite()
            
            gibs.SpriteRotation = math.random(360)
            
            local gib = rng:RandomInt(4)
            
            if gib == 0 then
                sprite:Play("BloodGib0" .. rng:RandomInt(3) + 1, true)
            elseif gib == 1 then
                sprite:Play("Bone0" .. rng:RandomInt(2) + 1, true)
            elseif gib == 2 then
                sprite:Play("Eye", true)
            elseif gib == 3 then
                sprite:Play("Guts0" .. rng:RandomInt(2) + 1, true)
            end
            
            sprite:Stop()
        end
        
        entity.HitPoints = 0
    end
end

Exodus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Exodus.hotheadTakeDamage, Entities.HOTHEAD.id)

function Exodus:hotheadUpdate()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == Entities.PIT_GIBS.id and entity.Variant == Entities.PIT_GIBS.variant then
            entity.Velocity = entity.Velocity / 1.3
            
            if entity.Velocity:LengthSquared() < 4 then
                entity.Velocity = Vector(0, 0)
                entity:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
            end
        end
    end
end

Exodus:AddCallback(ModCallbacks.MC_POST_UPDATE, Exodus.hotheadUpdate)