Hippo = Object:extend()

function Hippo:new() 
    self.image = love.graphics.newImage('assets/hippo.png')
    self.scale = 0.3
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale
    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.speed = 300

    local bottom_padding = 20
    self.y = love.graphics.getHeight() - self.height - bottom_padding
end

function Hippo:update(dt)
    self.x = self.x + self.speed * dt

    --  X-axis movement
    if self.x < 0 then 
        self.x = 0
        self.speed = -self.speed
    elseif self.x + self.width > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.width
        self.speed = -self.speed
    end
end

function Hippo:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end