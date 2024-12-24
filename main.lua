nickname = require 'example.example' -- example/example.lua
Rectangle = require 'rect'
Circle = require 'circle'

local greet = function(name)
	return "hello " .. name
end

print(greet("Lulzie"))
print("Game is starting up ..")

--  NOTE:
--  in order --> love.load -> love.update -> love.draw

--  NOTE:
--  in lua, boolean conditions check for the value not being nil or false so 'hello' is truthy

--  NOTE: locals are much faster for lua to access

--  NOTE: It's kind of annoying though, how we have to pass r1 every time we call one of its functions. Luckily, Lua has a shorthand for this. When we use a colon (:), the function-call will automatically pass the object left of the colon as first argument.
--  r1:update(dt) --equals--> r1.update(r1, dt)

shapes = {}
frames = 0
fruits = { "banana", "monkey", "strawberry" }
start = true

--  NOTE: Damb, I think I really like it :D

function love.load()
	-- spawn the first rect
	shapes.spawn()

	-- tick = require 'tick'
	-- tick.delay(function() start = true end, 2)
end

function love.update(dt)
	--  NOTE: Do not process anything if the game hasn't started yet
	if not start then
		return
	end

	for i, v in ipairs(shapes) do
    v:update(dt)
	end

	if love.keyboard.isDown("space") then
		shapes.spawn()
	end

	if love.keyboard.isDown("r") then
		print("welp, that's a little weird :D")

		for i = 1, #shapes do
			if i ~= 1 then
				table.remove(shapes, i)
			end
		end
	end

	frames = frames + 1
end

function love.draw()
	for i, v in ipairs(fruits) do
		love.graphics.print(v, 175 + 100 * i, 20)
	end

	love.graphics.print("Frames: " .. frames, 20, 20)
	love.graphics.print("Greetings, " .. name .. "!" .. " (nickname: " .. nickname .. ")", 20, 40)

	if not start then
		love.graphics.print("Get Ready ...", 400, 300)
	end

	for i, v in ipairs(shapes) do
		-- love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
    v:draw()
		love.graphics.print("R" .. i, v.x, v.y - 20)
	end
end

function shapes.spawn()
  if math.random(0, 1) == 1 then
    shape = Rectangle(math.random(80, 140), math.random(80, 140), math.random(160, 300), math.random(50, 300))
  else
    shape = Circle(math.random(80, 140), math.random(80, 140), math.random(20, 150))
  end

	table.insert(shapes, shape)
end
