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
-- and shuffle the sprite that way
function shuffle( )

	local rDirection = math.random(0,3)
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
end

local timeSince = 0
function drawSprite( )
	
	local elapsed = playdate.getCurrentTimeMilliseconds()

	if (elapsed - timeSince) < 1000 then
		return
	end

	shuffle()
	sprite:moveTo(sprite.x, sprite.y)
	timeSince = elapsed
end


-- main update function runs every frame (i think?)
function playdate.update( )

	gfx.sprite.update();
	playdate.timer.updateTimers();
	drawSprite()
	
end