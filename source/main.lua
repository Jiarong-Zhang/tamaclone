-- tamagotchi clone
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

math.randomseed(playdate.getSecondsSinceEpoch())

local gfx <const>  = playdate.graphics

local sprite = nil

function setup()

	local image = gfx.image.new("images/testSprite")
	assert( image )

	sprite = gfx.sprite.new(image)
	sprite:setScale(3);
	sprite:moveTo( 200,120 )
	sprite:add()
end

setup()

-- i need the sprite to move left and right randomly
-- to emulate movement (it's alive!)


-- randomly select a movement direction
-- and randomly choose the movement magnitude
function shuffle( )

	local rDirection = math.random(0,4)
	local rMagnitude = math.random(1,10)
	--print(rDirection)

	if rDirection  == 0 then
		sprite.x = sprite.x - rMagnitude
	end
	if rDirection == 1 then
		sprite.x = sprite.x + rMagnitude
	end
	if rDirection == 2 then
		sprite.y = sprite.y - rMagnitude
	end
	if rDirection == 3 then
		sprite.y = sprite.y + rMagnitude
	end
	if rDirection == 4 then
		return
	end
end

-- only update sprite location if one seconds has passed
-- since the last movement event
local timeSince = 0
function drawSprite( )
	
	local elapsed = playdate.getCurrentTimeMilliseconds()

	if (elapsed - timeSince) < 750 then
		return
	end

	shuffle()
	sprite:moveTo(sprite.x, sprite.y)	-- move sprite
	timeSince = elapsed		-- update time of last movement event
end


-- main update function runs every frame (i think?)
function playdate.update( )

	gfx.sprite.update();
	playdate.timer.updateTimers();
	drawSprite()
	
end