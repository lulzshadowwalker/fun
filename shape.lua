Object = require 'classic'

Shape = Object:extend()

function Shape:new(x, y)
	self.x = x
	self.y = y
	self.speed = 750
end

function Shape:update(dt)
	if love.keyboard.isDown("right") then
		self.x = self.x + self.speed * dt
	elseif love.keyboard.isDown("left") then
		self.x = self.x - self.speed * dt
	end

	if love.keyboard.isDown("up") then
		self.y = self.y - self.speed * dt
	elseif love.keyboard.isDown("down") then
		self.y = self.y + self.speed * dt
	end
end

return Shape
