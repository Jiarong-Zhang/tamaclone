-- tamagotchi clone
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

math.randomseed(playdate.getSecondsSinceEpoch())

local gfx <const>  = playdate.graphics

local sprite = nil
local fullness = nil

local synth = playdate.sound.synth.new(playdate.sound.kWaveSawtooth)
synth:setADSR(0, 0.1, 0, 0)

-- border setup
class('Box').extends(playdate.graphics.sprite)

function Box:draw(x, y, width, height)
  local cx, cy, width, height = self:getCollideBounds()
  gfx.setColor(playdate.graphics.kColorWhite)
  gfx.fillRect(cx, cy, width, height)
  gfx.setColor(playdate.graphics.kColorBlack)
  gfx.drawRect(cx, cy, width, height)
end

local function addBlock(x,y,w,h)
  local block = Box()
  block:setSize(w, h)
  block:moveTo(x, y)
  block:setCenter(0,0)
  block:addSprite()
  block:setCollideRect(0,0,w,h)
end

function setup()

	-- the little guy
	local image = gfx.image.new("images/sprite")
	assert( image )

	sprite = gfx.sprite.new(image)
	sprite:setScale(4)
	sprite:moveTo( 200, 120 )
	sprite:setCollideRect( 0, 0, sprite:getSize() )
	sprite:add()

	-- DEBUG: hunger/happy test
	fullness = math.random(0,3)
	print("fullness: ", fullness)

	-- border colour + width in pixels(?)
	gfx.setColor(gfx.kColorBlack)
	gfx.setLineWidth(3) 

	-- background colour and background image
	local bg = gfx.image.new("images/bg")
	assert( bg )

	gfx.setBackgroundColor(gfx.kColorWhite)
	-- gfx.sprite.setBackgroundDrawingCallback(
 --        function( x, y, width, height )
 --            gfx.setScreenClipRect( 32, 32, 336, 176 ) -- let's only draw the part of the screen that's dirty
 --            bg:draw( 0, 0 )
 --            gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
 --        end
 --    )

 	-- tilemaps???
 	-- imageTable = gfx.imagetable.new("images/border")	-- load 
 	-- print(imageTable:getLength())
end

setup()

-- draws the static sprites on screen
function drawSprite( )

	--gfx.drawRoundRect(32, 32, 336, 176, 5)		-- border
	statusIcons()
end

local borderSize = 3
local displayWidth = playdate.display.getWidth()
local displayHeight = playdate.display.getHeight()

-- hunger and happiness icons
function statusIcons()
	
	local empty = gfx.image.new("images/heart-empty")
	local full = gfx.image.new("images/heart-full")

	local heart1 = gfx.sprite.new(empty)	-- default empty
	heart1:moveTo( 48, 16 )
	if fullness >= 1 then
	 	heart1:setImage(full) 	-- becomes full heart if at least 1 fullness
	end
	heart1:setScale(4)
	heart1:add()

	local heart2 = gfx.sprite.new(empty)
	heart2:moveTo( 84, 16 )
	if fullness >= 2 then
	 	heart2:setImage(full)
	end
	heart2:setScale(4)
	heart2:add()

	local heart3 = gfx.sprite.new(empty)
	heart3:moveTo( 120, 16 )
	if fullness == 3 then
	 	heart3:setImage(full)
	end
	heart3:setScale(4)
	heart3:add()

	-- border test copied from dev forums
	-- border edges
	addBlock(32, 32, displayWidth-64, borderSize)
	addBlock(32, borderSize+32, borderSize, displayHeight-borderSize*2 - 64)
	addBlock(displayWidth-borderSize-32, borderSize+32, borderSize, displayHeight-borderSize*2 - 64)
	addBlock(32, displayHeight-borderSize-32, displayWidth-64, borderSize)
end


-- i need the sprite to move left and right randomly
-- to emulate movement (it's alive!)

-- randomly select a movement direction
-- and randomly choose the movement magnitude
local faceL = true
function shuffle( )

	--if sprite.x == 64 then return end
	--if sprite.y == 64 then return end

	local rDirection = math.random(0,4)
	local rMagnitude = math.random(1,10)
	--print(rDirection)

	local dy = 0;
	local dx = 0;

	if rDirection  == 0 then	-- move left
		dx = 0 - rMagnitude
		if faceL == false then
			sprite:setImageFlip(gfx.kImageUnflipped)	-- reset facing
			faceL = true
		end
	end
	if rDirection == 1 then		-- move right
		dx = 0 + rMagnitude
		if faceL == true then
			sprite:setImageFlip(gfx.kImageFlippedX)	-- flip facing
			faceL = false
		end
	end
	if rDirection == 2 then		-- move up
		dy = 0 - rMagnitude
	end
	if rDirection == 3 then		-- move down
		dy = 0 + rMagnitude
	end
	if rDirection == 4 then
		return
	end
	--print(faceL)

	sprite:moveWithCollisions(sprite.x + dx, sprite.y + dy);

end

-- only update sprite location if one seconds has passed
-- since the last movement event. runs every frame
local timeSince = 0
function movement( )

	local elapsed = playdate.getCurrentTimeMilliseconds()

	if (elapsed - timeSince) > 5 then
		shuffle()
		sprite:moveTo(sprite.x, sprite.y)	-- move sprite
		timeSince = elapsed		-- update time of last movement event
	end

	-- DEBUG: testing soundssss
	if playdate.buttonJustPressed("down") == true then
		synth:playNote(200)
	end

	-- DEBUG: reset position
	if playdate.buttonJustPressed("a") == true then
		sprite:moveTo( 200, 120 )
	end


end


-- main update function runs every frame (i think?)
function playdate.update( )

	gfx.sprite.update();
	playdate.timer.updateTimers()
	drawSprite()
	movement()
end