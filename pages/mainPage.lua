require "pages.myProfile"
require "pages.saved"
require "pages.dashboard"
require "components.sideBar"
require "stuff.clickEffect"
require "stuff.button"
require "stuff.iconButton"

MainPage = {}

function MainPage:new()
  local obj = {}

  obj.my_profile = MyProfile:new()
  obj.saved = Saved:new()
  obj.dashboard = Dashboard:new()

  obj.page = obj.my_profile

  obj.side_bar = SideBar:new(obj)

  function obj:setPage(page)
    obj.page = page
  end

  function obj:load()
    obj.side_bar:load()
    if obj.page ~= nil then
      obj.page:load()
    end
  end

  function obj:update(dt)
    obj.side_bar:update(dt)
    if obj.page ~= nil then
      obj.page:update(dt)
    end
  end

  function obj:textinput(t)
  end

  function obj:keypressed(k)
    if obj.page ~= nil then
      obj.page:keypressed(k)
    end
  end

  function obj:wheelmoved(x, y)
    if obj.page ~= nil then
      obj.page:wheelmoved(x, y)
    end
  end

  function obj:mousepressed(x, y, button)
    obj.side_bar:mousepressed(x, y, button)
    if obj.page ~= nil then
      obj.page:mousepressed(x, y, button)
    end
  end

  function obj:mousereleased(x, y, button)
    if obj.page ~= nil then
      obj.page:mousereleased(x, y, button)
    end
  end

  function obj:mousemoved(x, y, dx, dy)
    if obj.page ~= nil then
      obj.page:mousemoved(x, y, dx, dy)
    end
  end

  function obj:draw()
    if obj.page ~= nil then
      obj.page:draw()
    end
    obj.side_bar:draw()
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
