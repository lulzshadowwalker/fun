function love.load()
  Object = require 'classic'
  require 'monkey' 

  Player = Monkey()
end

function love.update(dt)
  Player:update(dt)
end

function love.draw()
  Player:draw()
end
