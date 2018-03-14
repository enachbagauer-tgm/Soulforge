local Soulforge = RegisterMod("Soulforge",1);

local BumboSoul = Isaac.GetItemIdByName ("BumBo Soul")
local FlameThrower = Isaac.GetItemIdByName ("Flamethrower")
local AngelSoul = Isaac.GetItemIdByName ("Angel Soul")  --Hallo
local DemonSoul = Isaac.GetItemIdByName ("Demon Soul")
local DarkSoul = Isaac.GetItemIdByName ("Dark Soul")
local StainedSoul = Isaac.GetItemIdByName ("Stained Soul") -- Sample Image
local PureSoul = Isaac.GetItemIdByName ("Pure Soul") -- Sample Image

local repItem1 = true
local log = {}

local debugText = "";

local currCoins = 0;
local currKeys = 0;
local currBombs = 0;
local currHearts = 0;

--Function to set default values
function Soulforge:Reset()
  player = Isaac.GetPlayer(0);
  repItem1 = true
  currCoins = player:GetNumCoins();
  currKeys = player:GetNumKeys();
  currBombs = player:GetNumBombs();
  currHearts = player:GetHearts();

end

function Soulforge:debug()
  Isaac.RenderText(debugText,100,100,255,0,0,255)
end

--Function to check if any consumable changed
function Soulforge:checkConsumables()
  player = Isaac.GetPlayer(0);
 
  if(currCoins < player:GetNumCoins()) then
      debugText = "picked up a coin";
      bumboAfterPickup()
  end
 
  if(currKeys < player:GetNumKeys()) then
      debugText = "picked up a key"; -- HasGoldenKey()
  end
 
  if(currBombs < player:GetNumBombs()) then
      debugText = "picked up a bomb"; -- HasGoldenBomb()
  end
 
  if(currHearts < player:GetHearts()) then
      debugText = "picked up a heart";
      darkAfterPickup()
  end
 
  currCoins = player:GetNumCoins();
  currKeys = player:GetNumKeys();
  currBombs = player:GetNumBombs();
  currHearts = player:GetHearts(); -- GetMaxHearts(), GetSoulHearts(), GetBlackHearts(), GetEternalHearts(), GetGoldenHearts()
end


-- Code for the Flamethrower
function Soulforge:FlamethrowerF()
  if Isaac.GetPlayer(0):HasCollectible(FlameThrower) and repItem1 == true then
    
    Isaac.GetPlayer(0).Damage = Isaac.GetPlayer(0).Damage*2/3
    Isaac.GetPlayer(0).FireDelay = Isaac.GetPlayer(0).FireDelay-1
    Isaac.GetPlayer(0).TearHeight = Isaac.GetPlayer(0).TearHeight-3
    Isaac.GetPlayer(0).TearFlags = Isaac.GetPlayer(0).TearFlags + TearFlags.TEAR_PIERCING + TearFlags.TEAR_BURN
    
    pos = Vector(Isaac.GetPlayer(0).Position.X, Isaac.GetPlayer(0).Position.Y);
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_PYROMANIAC, pos, Vector(0,0), Isaac.GetPlayer(0))
    
    repItem1 = false
  end
end

--Bumbo Soul Function
function bumboAfterPickup()
  player = Isaac.GetPlayer(0);
  if Isaac.GetPlayer(0):HasCollectible(BumboSoul) == true then
    local rand = math.random(0,5)
    if rand==0 then
      player.Damage=player.Damage+0.3;
    elseif rand==1 then
      player.MoveSpeed=player.MoveSpeed+0.2;
    elseif rand==1 then
      player.ShotSpeed=player.ShotSpeed+0.1;
    elseif rand==1 then
      player.TearHeight = player.TearHeight +0.1;
    elseif rand==1 then
      player.Luck = player.Luck+0.3;
    end
  end
end

--Dark Soul Function
function darkAfterPickup()
  if Isaac.GetPlayer(0):HasCollectible(DarkSoul) then
    pos = Vector(Isaac.GetPlayer(0).Position.X, Isaac.GetPlayer(0).Position.Y);
    if math.random(0,100) < 30 then
      Isaac.GetPlayer(0):TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0)
    else 
      Isaac.GetPlayer(0):AddBlackHearts(2)
    end
  end
end
  
--Angel Soul Function
function Soulforge:AngelFloor()
  if Isaac.GetPlayer(0):HasCollectible(AngelSoul) == true then
    Isaac.GetPlayer(0):AddEternalHearts(1)
  end
end

--Demon Soul Function
function Soulforge:DemonFloor()
  player=Isaac.GetPlayer(0)
  if player:HasCollectible(DemonSoul) == true then 
    local rand = math.random(0,5)
    if rand==0 then
      player.Damage=player.Damage+1;
    elseif rand==1 then
      player.MoveSpeed=player.MoveSpeed+1;
    elseif rand==1 then
      player.ShotSpeed=player.ShotSpeed+0.4;
    elseif rand==1 then
      player.TearHeight = player.TearHeight +0.6;
    elseif rand==1 then
      player.Luck = player.Luck+1;
    end
    
    Isaac.GetPlayer(0):TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0)
    
  end
end

function Soulforge:PureSoul () 
  player = Isaac.GetPlayer(0);
  if Isaac.GetPlayer(0):HasCollectible(PureSoul) == true then
    debugText ="1";
    game = Game() 
    level = game:GetLevel()
    level:ShowMap()
  end
end

--Function to update colors
function Soulforge:Colorupdate()
  player = Isaac.GetPlayer(0);
  if player:HasCollectible(FlameThrower) == true then
    Isaac.GetPlayer(0).TearColor = Color(255.0,93,0,1,1,0,0)
  end
  if player:HasCollectible(DarkSoul) == true then
    Isaac.GetPlayer(0).TearColor = Color(0,0,0,1,1,0,0)
  end
  if player:HasCollectible(DemonSoul) == true then
    Isaac.GetPlayer(0).TearColor = Color(159,117,117,1,1,0,0)
  end
  if player:HasCollectible(AngelSoul) == true then
    Isaac.GetPlayer(0).TearColor = Color(108,122,189,1,1,0,0)
  end
  if player:HasCollectible(BumboSoul) == true then
    Isaac.GetPlayer(0).TearColor = Color(255,215,0,1,1,0,0)
  end
  if player:HasCollectible(PureSoul) == true then
    Isaac.GetPlayer(0).TearColor = Color(255,255,255,1,1,0,0)
  end
  if player:HasCollectible(StainedSoul) == true then
    Isaac.GetPlayer(0).TearColor = Color(94,110,98,1,1,0,0)
  end
end





--Environmental callbacks (Contain callbacks for some items)
Soulforge:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Soulforge.Reset)
Soulforge:AddCallback( ModCallbacks.MC_POST_UPDATE, Soulforge.checkConsumables);

--Callbacks for Itemcolors (Mostly for testing purpose)
Soulforge:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Soulforge.Colorupdate)
Soulforge:AddCallback(ModCallbacks.MC_POST_UPDATE, Soulforge.Colorupdate)

--Callback for Items
Soulforge:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Soulforge.FlamethrowerF)
Soulforge:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Soulforge.PureSoul)

--Callback for Floorupdate
Soulforge:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Soulforge.AngelFloor)
Soulforge:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Soulforge.DemonFloor)

--debug
Soulforge:AddCallback(ModCallbacks.MC_POST_RENDER, Soulforge.debug)
