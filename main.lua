nickname = require("example.example") -- example/example.lua
Rectangle = require("rect")
Circle = require("circle")

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
sheeps = {}
frames = 0
fruits = { "banana", "monkey", "strawberry" }
start = true

--  NOTE: Damb, I think I really like it :D

function love.load()
	--  NOTE: For collision detection
	r1 = {
		x = 10,
		y = 100,
		width = 100,
		height = 100,
	}

	r2 = {
		x = 250,
		y = 120,
		width = 150,
		height = 120,
	}

	sheep = love.graphics.newImage("sheep.png")
	-- spawn the first rect
	-- shapes.spawn()

	-- for i = 1, 1000 do
	-- 	sheeps.spawn()
	-- end

	-- tick = require 'tick'
	-- tick.delay(function() start = true end, 2)
end

function love.update(dt)
	r1.x = r1.x + 100 * dt

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

	if love.keyboard.isDown("tab") then
		sheeps.spawn()
	end

	if love.keyboard.isDown("r") then
		print("welp, that's a little weird :D")

		for i = 1, #shapes do
			table.remove(shapes, i)
		end

		for i = 1, #sheeps do
			table.remove(sheeps, i)
		end
	end

	if love.keyboard.isDown("q") then
		love.load()
	end

	frames = frames + 1

	for i, v in ipairs(sheeps) do
		v.y = v.y + v.speed * dt
	end
end

function love.draw()
	--We create a local variable called mode
	local mode
	if checkCollision(r1, r2) then
		--If there is collision, draw the rectangles filled
		mode = "fill"
	else
		--else, draw the rectangles as a line
		mode = "line"
	end

	love.graphics.rectangle(mode, r1.x, r1.y, r1.width, r1.height)
	love.graphics.rectangle(mode, r2.x, r2.y, r2.width, r2.height)

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

	love.graphics.setColor(1, 1, 1, 0.65)
	for i, v in ipairs(sheeps) do
		-- love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
		love.graphics.draw(sheep, v.x, v.y, v.rotation, v.scaleX, v.scaleY, v.originX, v.originY)
	end
	love.graphics.setColor(1, 1, 1, 1)
end

function shapes.spawn()
	if math.random(0, 1) == 1 then
		shape = Rectangle(math.random(80, 140), math.random(80, 140), math.random(160, 300), math.random(50, 300))
	else
		shape = Circle(math.random(80, 140), math.random(80, 140), math.random(60, 150))
	end

	table.insert(shapes, shape)
end

function sheeps.spawn()
	screenWidth = love.graphics.getWidth()
	scale = math.random(1, 1)

	table.insert(sheeps, {
		x = math.random(-50, screenWidth),
		y = math.random(50, 200),
		speed = math.random(30, 180),
		scaleX = scale,
		scaleY = scale,
		rotation = 0,
		originX = sheep:getWidth() / 2,
		originY = sheep:getHeight() / 2,
	})
end

function checkCollision(a, b)
	--With locals it's common usage to use underscores instead of camelCasing
	local a_left = a.x
	local a_right = a.x + a.width
	local a_top = a.y
	local a_bottom = a.y + a.height

	local b_left = b.x
	local b_right = b.x + b.width
	local b_top = b.y
	local b_bottom = b.y + b.height

	-- Summary
	-- Collision between two rectangles can be checked with four conditions.

	-- Where A and B are rectangles:

	-- A's right side is further to the right than B's left side.
	-- A's left side is further to the left than B's right side.
	-- A's bottom side is further to the bottom than B's top side.
	-- A's top side is further to the top than B's bottom side.

	-- Directly return this boolean value without using if-statement
	return a_right > b_left and a_left < b_right and a_bottom > b_top and a_top < b_bottom
end
