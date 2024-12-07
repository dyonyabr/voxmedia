require "stuff.button"
require "pages.sign_in"
require "pages.sign_up"

Sign = {}

function Sign:new()
  local obj = {}

  obj.pages = {
    SignIn:new(obj),
    SignUp:new(obj)
  }

  obj.current_num = 1
  obj.current = obj.pages[obj.current_num]

  obj.x = 0

  function obj:load()
    obj.pages[1]:load()
    obj.pages[2]:load()
  end

  function obj:keypressed(k)
    obj.current:keypressed(k)
  end

  function obj:textinput(t)
    obj.current:textinput(t)
  end

  function obj:mousepressed(x, y, button)
    obj.current:mousepressed(x, y, button)
  end

  function obj:wheelmoved(x, y, button)
    obj.current:wheelmoved(x, y, button)
  end

  function obj:mousereleased(x, y, button)
    obj.current:mousereleased(x, y, button)
  end

  function obj:mousemoved(x, y, dx, dy)
    obj.current:mousemoved(x, y, dx, dy)
  end

  function obj:update(dt)
    obj.current:update(dt)
    obj.x = lerp(obj.x, -(obj.current_num - 1) * love.graphics.getWidth(), dt * 10)
  end

  function obj:draw()
    love.graphics.translate(obj.x, 0)
    obj.pages[1]:draw(obj.x)
    obj.pages[2]:draw(obj.x)
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
