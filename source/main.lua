-- tamagotchi clone
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

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

	local rNum = math.random(0,1);
	print(rNum)

	if rNum  == 0 then
		sprite.x = sprite.x - 1
	end
	if rNum == 1 then
		sprite.x = sprite.x + 1
	end
end

function drawSprite( )

	shuffle()
	sprite:moveTo(sprite.x, sprite.y)
end


-- main update function runs every frame (i think?)
function playdate.update( )

	gfx.sprite.update();
	playdate.timer.updateTimers();
	drawSprite()
	
end