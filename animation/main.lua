function love.load()
	--  NOTE: Approach no. 1
	-- frames = {}
	-- for i=1,5 do
	--   local frame = love.graphics.newImage('assets/jump/jump' .. i .. '.png')
	--   table.insert(frames, frame)
	-- end

	-- x = love.graphics.getWidth() / 2 - frames[1]:getWidth() / 2
	-- y = love.graphics.getHeight() / 2 - frames[1]:getHeight() / 2

	-- currentFrame = 1

	--  NOTE: sprite.png (single row)
	-- frames = {}
	-- fps = 0

	-- sprite = love.graphics.newImage('assets/jump/sprite.png')
	-- local frame_width = 117
	-- local frame_height = 233

	-- for i=0,4 do
	--   frame = love.graphics.newQuad(i * frame_width, 0, frame_width, frame_height, sprite:getWidth(), sprite:getHeight())
	--   table.insert(frames, frame)
	-- end

	-- -- quad = love.graphics.newQuad(0, 0, frame_width, frame_height, sprite:getWidth(), sprite:getHeight())
	-- -- table.insert(frames, quad)

	-- x = love.graphics.getWidth() / 2 - frame_width / 2
	-- y = love.graphics.getHeight() / 2 - frame_height / 2

	-- currentFrame = 1

	--  NOTE: sprite-1.png (grid)
	frames = {}
	fps = 0

	sprite = love.graphics.newImage("assets/jump/sprite-1.png")
	local frame_width = 117
	local frame_height = 233

  maxFrames = 5
  borderWidth = 1
	for i = 0, 1 do
		for j = 0, 2 do

			frame = love.graphics.newQuad(
				borderWidth + j * (frame_width + 2),
				borderWidth + i * (frame_height + 2),
				frame_width,
				frame_height,
				sprite:getWidth(),
				sprite:getHeight()
			)
			table.insert(frames, frame)

      if #frames == maxFrames then
        break
      end
		end
	end

	-- quad = love.graphics.newQuad(0, 0, frame_width, frame_height, sprite:getWidth(), sprite:getHeight())
	-- table.insert(frames, quad)

	x = love.graphics.getWidth() / 2 - frame_width / 2
	y = love.graphics.getHeight() / 2 - frame_height / 2

	currentFrame = 1

  --  NOTE: "A good rule of thumb is to use stream for music files and static for all short sound effects. Basically, you want to avoid loading large files at once."
  sfx = love.audio.newSource('assets/sound/sfx.ogg', 'static')
end

function love.update(dt)
	currentFrame = currentFrame + dt * 10.8

	fps = 1 / dt
end

function love.draw()
	--  NOTE: Approach no. 1
	-- love.graphics.draw(frames[math.floor(currentFrame) % #frames + 1], x, y)

  local current = frames[math.floor(currentFrame) % #frames + 1]
	love.graphics.draw(sprite, current, x, y)
	love.graphics.print("FPS: " .. math.ceil(fps), 10, 10)

  local _, _, _, current_height = current:getViewport()
  love.graphics.print("Press 's' to play SFX", x, y + current_height + 20)


end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	if key == 'r' then
		love.load()
	end

  if key == 's' then
    -- love.audio.play(sfx)
    -- or ..
    sfx:play()
  end
end
