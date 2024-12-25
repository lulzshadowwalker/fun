-- Player module
Monkey = Object:extend() -- same as Object.extend(Object)

function Monkey:new()
    self.image = love.graphics.newImage('assets/monkey.png')
    self.scale = 0.3
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale

    --  NOTE: Center the image on the screen
    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.speed = 500
end

function Monkey:update(dt)
    -- X-axis movement
    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown('d') then
        self.x = self.x + self.speed * dt
    end

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.width
    end

    -- Y-axis movement
    if love.keyboard.isDown('w') then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown('s') then
        self.y = self.y + self.speed * dt
    end

    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end
end

function Monkey:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end
