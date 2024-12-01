local http = require 'socket.http'
local json = require 'lib.dkjson'
local ltn12 = require 'ltn12'

client = {}

local base_url = "http://127.0.0.1:8000/app/"

function client:get_user(id)
  local url = base_url .. "users/" .. tostring(id) .. "/"
  local response_body = {}

  local res, status, headers = http.request {
    url = url,
    method = "GET",
    sink = ltn12.sink.table(response_body)
  }

  if status == 200 then
    local response_data = table.concat(response_body)
    local decoded_data, pos, err = json.decode(response_data)
    if not err and type(decoded_data) == 'table' then
      return decoded_data
    else
      print("ERROR NAHUI!!!: \n" .. err)
      return nil
    end
  else
    print("CONNECTION FAILED!!! \n" .. status)
    return nil
  end
end
