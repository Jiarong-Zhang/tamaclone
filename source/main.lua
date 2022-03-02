-- tamagotchi clone
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

math.randomseed(playdate.getSecondsSinceEpoch())

local gfx <const>  = playdate.graphics

local sprite = nil

function setup()

	local image = gfx.image.new("images/sprite")
	assert( image )

	sprite = gfx.sprite.new(image)
	sprite:setScale(4);
	sprite:moveTo( 200,120 )
	sprite:add()

	gfx.setColor(gfx.kColorBlack)
	gfx.setLineWidth(3) 

	-- background colour and background image
	local bg = gfx.image.new("images/bg")
	assert( bg )

	gfx.setBackgroundColor(gfx.kColorBlack)
	gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            gfx.setScreenClipRect( 32, 32, 336, 176 ) -- let's only draw the part of the screen that's dirty
            bg:draw( 0, 0 )
            gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
        end
    )
end

setup()

-- draws the static sprites on screen
function drawSprite( )

	gfx.drawRoundRect(32, 32, 336, 176, 5)		-- border

end


-- i need the sprite to move left and right randomly
-- to emulate movement (it's alive!)

-- randomly select a movement direction
-- and randomly choose the movement magnitude
local faceL = true
function shuffle( )

	local rDirection = math.random(0,4)
	local rMagnitude = math.random(1,10)
	--print(rDirection)

	if rDirection  == 0 then	-- move left
		sprite.x = sprite.x - rMagnitude
		if faceL == false then
			sprite:setImageFlip(gfx.kImageUnflipped)	-- reset facing
			faceL = true
		end
	end
	if rDirection == 1 then		-- move right
		sprite.x = sprite.x + rMagnitude
		if faceL == true then
			sprite:setImageFlip(gfx.kImageFlippedX)	-- flip facing
			faceL = false
		end
	end
	if rDirection == 2 then		-- move down
		sprite.y = sprite.y - rMagnitude
	end
	if rDirection == 3 then		-- move up
		sprite.y = sprite.y + rMagnitude
	end
	if rDirection == 4 then
		return
	end
	--print(faceL)

end

-- only update sprite location if one seconds has passed
-- since the last movement event
local timeSince = 0
function movement( )

	local elapsed = playdate.getCurrentTimeMilliseconds()

	if (elapsed - timeSince) > 750 then
		shuffle()
		sprite:moveTo(sprite.x, sprite.y)	-- move sprite
		timeSince = elapsed		-- update time of last movement event
	end
end


-- main update function runs every frame (i think?)
function playdate.update( )

	gfx.sprite.update();
	playdate.timer.updateTimers()
	drawSprite()
	movement()
end