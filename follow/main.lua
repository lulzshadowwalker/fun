function love.load()
    Circle = {} 
    Circle.radius = 10
    Circle.x = love.graphics.getWidth() / 2 
    Circle.y = love.graphics.getHeight() / 2
    Circle.speed = 350

    Arrow = {}
    Arrow.image = love.graphics.newImage('arrow.png')
    Arrow.scale = 1
    Arrow.rotation = 0
    Arrow.width = Arrow.image:getWidth() * Arrow.scale
    Arrow.height = Arrow.image:getHeight() * Arrow.scale
    Arrow.x = love.graphics.getWidth() / 2 - Arrow.width / 2
    Arrow.y = love.graphics.getHeight() / 2 - Arrow.height / 2
    Arrow.origin = {}
    Arrow.origin.x = Arrow.width / 2
    Arrow.origin.y = Arrow.height / 2
end

function love.update(dt)
    Mx, My = love.mouse.getPosition()

    Angle = math.atan2(My - Circle.y, Mx - Circle.x)
    Distance = get_distance(Circle.x, Circle.y, Mx, My)

    local follow_threshold = 50
    if Distance > follow_threshold then
        cos = math.cos(Angle)
        sin = math.sin(Angle)

        Circle.x = Circle.x + Circle.speed * cos * (Distance / 400) * dt
        Circle.y = Circle.y + Circle.speed * sin * (Distance / 400) * dt
    
        Arrow.x = Circle.x
        Arrow.y = Circle.y
        Arrow.rotation = Angle
        Arrow.scale = math.max(0.5, follow_threshold / Distance)
    end
end

function love.draw()
    love.graphics.circle('line', Circle.x, Circle.y, Circle.radius)

    love.graphics.print('Angle: ' .. Angle, 10, 10)

    love.graphics.print('R = ' .. Distance, Mx - (Mx - Circle.x) / 2, My - (My - Circle.y) / 2)
    love.graphics.line(Circle.x, Circle.y, Mx, My)

    love.graphics.line(Circle.x, Circle.y, Mx, Circle.y)
    love.graphics.line(Circle.x, Circle.y, Circle.x, My)
    love.graphics.line(Mx, Circle.y, Mx, My)
    love.graphics.line(Mx, My, Circle.x, My)

    love.graphics.circle('line', Circle.x, Circle.y, Distance)
    
    love.graphics.setColor(180 / 255, 235 / 255, 52 / 255, 1)
    love.graphics.circle('fill', Mx, My, 5)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.draw(Arrow.image, Arrow.x, Arrow.y, Arrow.rotation, Arrow.scale, Arrow.scale, Arrow.origin.x, Arrow.origin.y)
    love.graphics.setColor(1, 1, 1, 1)

end

function get_distance(x1, y1, x2, y2) 
    local horizontal_distance = x2 - x1
    local vertical_distance = y2 - y1

    local a = horizontal_distance ^ 2
    local b = vertical_distance ^ 2
    local c = a + b

    return math.sqrt(c)
end