local socket = require("socket")
local client = nil

function shared_load()
  client = assert(socket.connect("localhost", 12345))
  client:settimeout(0)
end

function send(data)
  print("jopa")
  if client then
    client:send(data)
  end
end
