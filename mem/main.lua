Lume = require("lume")

function love.load()
	Score1 = 0
	Score2 = 0
	ShakeDuration = 0

	Player1 = {}
	Player1.size = 5
	Player1.x = love.graphics.getWidth() / 2 - Player1.size / 2
	Player1.y = love.graphics.getHeight() / 2 - Player1.size / 2
	Player1.speed = 200
	Player1.image = love.graphics.newImage("face.png")

	Player2 = {}
	Player2.size = 5
	Player2.x = love.graphics.getWidth() / 2 - Player1.size / 2 + 200
	Player2.y = love.graphics.getHeight() / 2 - Player1.size / 2
	Player2.speed = 200
	Player2.image = love.graphics.newImage("face.png")

	Coins = {}

	if love.filesystem.getInfo("save") then
		file = love.filesystem.read("save")

		data = Lume.deserialize(file)

    Score1 = data.score1
    Score2 = data.score2

		--Apply the player info
		Player1.x = data.player1.x
		Player1.y = data.player1.y
		Player1.size = data.player1.size

    Player2.x = data.player2.x
    Player2.y = data.player2.y
    Player2.size = data.player2.size

		for i, v in ipairs(data.coins) do
			Coins[i] = {
				x = v.x,
				y = v.y,
				size = 10,
				image = love.graphics.newImage("dollar.png"),
			}
		end
	else
		for i = 1, 5000 do
			local coin = {
				x = love.math.random(0, love.graphics.getWidth()),
				y = love.math.random(0, love.graphics.getHeight()),
				size = 10,
				image = love.graphics.newImage("dollar.png"),
			}

			table.insert(Coins, coin)
		end
	end

	ScreenCanvas = love.graphics.newCanvas(400, 600)
end

function love.update(dt)
	if love.keyboard.isDown("right") then
		Player1.x = Player1.x + Player1.speed * dt
	end
	if love.keyboard.isDown("left") then
		Player1.x = Player1.x - Player1.speed * dt
	end

	if love.keyboard.isDown("down") then
		Player1.y = Player1.y + Player1.speed * dt
	end
	if love.keyboard.isDown("up") then
		Player1.y = Player1.y - Player1.speed * dt
	end

	if love.keyboard.isDown("d") then
		Player2.x = Player2.x + Player2.speed * dt
	end
	if love.keyboard.isDown("a") then
		Player2.x = Player2.x - Player2.speed * dt
	end

	if love.keyboard.isDown("s") then
		Player2.y = Player2.y + Player2.speed * dt
	end
	if love.keyboard.isDown("w") then
		Player2.y = Player2.y - Player2.speed * dt
	end

	if love.keyboard.isDown("escape") then
		save()
		love.event.quit()
	end

	if love.keyboard.isDown("r") then
		love.filesystem.remove("save")
		love.event.quit("restart")
	end

	if love.keyboard.isDown("p") then
		save()
	end

	for i = #Coins, 1, -1 do
		local coin = Coins[i]
		if collides(Player1, coin) then
			table.remove(Coins, i)
			Player1.size = Player1.size + 0.05
			Score1 = Score1 + 1
			ShakeDuration = 0.3
		elseif collides(Player2, coin) then
			table.remove(Coins, i)
			Player2.size = Player2.size + 0.05
			Score2 = Score2 + 1
			ShakeDuration = 0.3
		end
	end

	if ShakeDuration > 0 then
		ShakeDuration = ShakeDuration - dt
	end
end

function love.draw()
  --  NOTE: Player 1 Split
	love.graphics.setCanvas(ScreenCanvas)
	love.graphics.clear()
	drawGame(Player1)
	love.graphics.setCanvas()
	love.graphics.draw(ScreenCanvas)

  --  NOTE: Player 2 Split
	love.graphics.setCanvas(ScreenCanvas)
	love.graphics.clear()
	drawGame(Player2)
	love.graphics.setCanvas()
	love.graphics.draw(ScreenCanvas, 400)

  love.graphics.line(400, 0, 400, 600)

  --  NOTE: Print scores
	love.graphics.setColor(1, 0, 0)
	love.graphics.print("Score 1: " .. Score1, 10, 10, 0, 2, 2)
	love.graphics.print("Score 2: " .. Score2, 10, 40, 0, 2, 2)
	love.graphics.setColor(1, 1, 1)
end

function collides(c1, c2)
	local distance = math.sqrt((c1.x - c2.x) ^ 2 + (c1.y - c2.y) ^ 2)
	return distance < c1.size + c2.size
end

function drawGame(target)
	--  NOTE: Camera
	love.graphics.push() --  NOTE: Approach 2
	love.graphics.translate(-target.x + 200, -target.y + 300)

	if ShakeDuration > 0 then
		local dx = love.math.random(-5, 5)
		local dy = love.math.random(-5, 5)
		love.graphics.translate(dx, dy)
	end

	love.graphics.circle("line", Player1.x, Player1.y, Player1.size)
	love.graphics.circle("line", Player2.x, Player2.y, Player2.size)

	--  NOTE: Face
	love.graphics.draw(
		Player1.image,
		Player1.x,
		Player1.y,
		0,
		1,
		1,
		Player1.image:getWidth() / 2,
		Player1.image:getHeight() / 2
	)

	love.graphics.draw(
		Player2.image,
		Player2.x,
		Player2.y,
		0,
		1,
		1,
		Player2.image:getWidth() / 2,
		Player2.image:getHeight() / 2
	)

	for i = 1, #Coins do
		local coin = Coins[i]
		love.graphics.circle("line", coin.x, coin.y, coin.size)
		love.graphics.draw(coin.image, coin.x, coin.y, 0, 1, 1, coin.image:getWidth() / 2, coin.image:getHeight() / 2)
	end
	love.graphics.pop() --  NOTE: Approach 2

	--  NOTE: Approach 1
	-- love.graphics.translate(player.x - 400, player.y - 300)
	-- or
	-- love.graphics.origin()
end

function save()
	data = {}

	data.player1 = {
		x = Player1.x,
		y = Player1.y,
		size = Player1.size,
	}

	data.player2 = {
		x = Player2.x,
		y = Player2.y,
		size = Player2.size,
	}

	data.coins = {}
	for i = 1, #Coins do
		data.coins[i] = {
			x = Coins[i].x,
			y = Coins[i].y,
		}
	end

  data.score1 = Score1
  data.score2 = Score2

	local serialized = Lume.serialize(data)
	love.filesystem.write("save", serialized)
	print("Game saved successfully")
end

function load() end
