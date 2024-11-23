Saved = {}

function Saved:new()
  local obj = {}

  function obj:load()
  end

  function obj:keypressed(k)
  end

  function obj:mousepressed(x, y, button)
  end

  function obj:wheelmoved(x, y, button)
  end

  function obj:mousereleased(x, y, button)
  end

  function obj:mousemoved(x, y, dx, dy)
  end

  function obj:update(dt)
  end

  function obj:draw()
    love.graphics.setColor(colors.main_text.r, colors.main_text.g, colors.main_text.b, 1)
    love.graphics.printf("Saved Page", fonts.WorkSans, 40, 300, love.graphics.getWidth() - 40, "center")
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
