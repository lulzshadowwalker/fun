Object = require("classic")

Entity = Object:extend()

function Entity:new(x, y, imagePath)
	self.x = x
	self.y = y
	self.image = love.graphics.newImage(imagePath)
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.last = {}
	self.last.x = self.x
	self.last.y = self.y

	self.strength = 0
	self.tempStrength = 0
end

function Entity:update(dt)
	self.last.x = self.x
	self.last.y = self.y

	self.tempStrength = self.strength
end

function Entity:draw()
	love.graphics.draw(self.image, self.x, self.y)
end

function Entity:checkCollision(e)
	return self.x + self.width > e.x
		and self.x < e.x + e.width
		and self.y + self.height > e.y
		and self.y < e.y + e.height
end

function Entity:wasVerticallyAligned(e)
	-- It's basically the collisionCheck function, but with the x and width part removed.
	-- It uses last.y because we want to know this from the previous position
	return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontallyAligned(e)
	-- It's basically the collisionCheck function, but with the y and height part removed.
	-- It uses last.x because we want to know this from the previous position
	return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end

function Entity:resolveCollision(e)
	--  NOTE: This is to solve cases e.g. you push the box against the wall, but the box cannot push the wall so it will lead to a weird yet expected behavior.
	if self.tempStrength > e.tempStrength then
		return e:resolveCollision(self)
	end

	--  NOTE: Compare the center of the box and player to determine which side of the box the player is on.

	if self:checkCollision(e) then
		self.tempStrength = e.tempStrength

		if self:wasVerticallyAligned(e) then
			if self.x + self.width / 2 < e.x + e.width / 2 then
				-- pusback = the right side of the player - the left side of the wall
				local pushback = self.x + self.width - e.x
				self.x = self.x - pushback
			else
				-- pusback = the right side of the wall - the left side of the player
				local pushback = e.x + e.width - self.x
				self.x = self.x + pushback
			end
		elseif self:wasHorizontallyAligned(e) then
			if self.y + self.height / 2 < e.y + e.height / 2 then
				-- pusback = the bottom side of the player - the top side of the wall
				local pushback = self.y + self.height - e.y
				self.y = self.y - pushback
			else
				-- pusback = the bottom side of the wall - the top side of the player
				local pushback = e.y + e.height - self.y
				self.y = self.y + pushback
			end
		end

		return true
	end

	return false
end
