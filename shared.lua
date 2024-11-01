local socket = require("socket")
local server = nil

function shared_load()
    server = assert(socket.bind("localhost", 12345))
    server:settimeout(0)
end

function shared_update(dt)
    if editor_opened and server ~= nil then
        local client = server:accept()
        if client then
            local data, err = client:receive()
            if data == "exit" then
                editor_opened = false
            end
            client:close()
        end
    end
end
