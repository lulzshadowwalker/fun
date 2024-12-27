Lume = require('lume')

function love.load()
	Player = {}
	Player.size = 25
	Player.x = love.graphics.getWidth() / 2 - Player.size / 2
	Player.y = love.graphics.getHeight() / 2 - Player.size / 2
	Player.speed = 200
	Player.image = love.graphics.newImage('face.png')

	Coins = {}

	if love.filesystem.getInfo('save') then
		file = love.filesystem.read('save')

		data = Lume.deserialize(file)

		--Apply the player info
		Player.x = data.player.x
		Player.y = data.player.y
		Player.size = data.player.size

		for i, v in ipairs(data.coins) do
			Coins[i] = {
				x = v.x,
				y = v.y,
				size = 10,
				image = love.graphics.newImage('dollar.png'),
			}
		end
	else
		for i = 1, 1000 do
			local coin = {
				x = love.math.random(0, love.graphics.getWidth()),
				y = love.math.random(0, love.graphics.getHeight()),
				size = 10,
				image = love.graphics.newImage('dollar.png'),
			}

			table.insert(Coins, coin)
		end
	end
end

function love.update(dt)
	if love.keyboard.isDown('right') then
		Player.x = Player.x + Player.speed * dt
	end
	if love.keyboard.isDown('left') then
		Player.x = Player.x - Player.speed * dt
	end

	if love.keyboard.isDown('down') then
		Player.y = Player.y + Player.speed * dt
	end
	if love.keyboard.isDown('up') then
		Player.y = Player.y - Player.speed * dt
	end

	if love.keyboard.isDown('escape') then
    save()
		love.event.quit()
	end

	if love.keyboard.isDown('r') then
    love.filesystem.remove('save')
		love.event.quit('restart')
	end

	if love.keyboard.isDown('s') then
		save()
	end

	for i = #Coins, 1, -1 do
		local coin = Coins[i]
		if collides(Player, coin) then
			table.remove(Coins, i)

			Player.size = Player.size + 0.1
		end
	end
end

function love.draw()
	love.graphics.circle('line', Player.x, Player.y, Player.size)

	--  NOTE: Face
	love.graphics.draw(
		Player.image,
		Player.x,
		Player.y,
		0,
		1,
		1,
		Player.image:getWidth() / 2,
		Player.image:getHeight() / 2
	)

	for i = 1, #Coins do
		local coin = Coins[i]
		love.graphics.circle('line', coin.x, coin.y, coin.size)
		love.graphics.draw(coin.image, coin.x, coin.y, 0, 1, 1, coin.image:getWidth() / 2, coin.image:getHeight() / 2)
	end
end

function collides(c1, c2)
	local distance = math.sqrt((c1.x - c2.x) ^ 2 + (c1.y - c2.y) ^ 2)
	return distance < c1.size + c2.size
end

function save()
	data = {}

	data.player = {
		x = Player.x,
		y = Player.y,
		size = Player.size,
	}

	data.coins = {}
	for i = 1, #Coins do
		data.coins[i] = {
			x = Coins[i].x,
			y = Coins[i].y,
		}
	end

	local serialized = Lume.serialize(data)
	love.filesystem.write('save', serialized)
	print('Game saved successfully')
end

function load() end
