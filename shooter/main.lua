Object = require 'classic'
require 'monkey' 
require 'hippo' 
require 'bullet'

function love.conf(t)
  t.window.title = "Monkey Shooter!"
  t.window.icon = "assets/monkey.png"
end

function love.load()
  Player = Monkey()
  Enemy = Hippo()
  Bullets = {}
end

function love.update(dt)
  Player:update(dt)
  Enemy:update(dt)

  for i, v in ipairs(Bullets) do
    v:update(dt)
    v:checkCollision(Enemy)

    if v.dead then
      table.remove(Bullets, i)
    end
  end
end

function love.draw()
  Player:draw()
  Enemy:draw()

  for i, v in ipairs(Bullets) do
    v:draw(dt)
  end
end


function love.keypressed(key)
  Player:keypressed(key)
end
