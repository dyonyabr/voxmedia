Example = {}

function Example:new()
    local obj = {}

    function obj:load()
    end

    function obj:update(dt)
    end

    function obj:draw()
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end
