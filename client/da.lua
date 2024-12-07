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
      print("CANNOT READ DATA!!!: \n" .. err)
      return nil
    end
  else
    print("CONNECTION FAILED!!! \n" .. status)
    return nil
  end
end

function client:sign_in(name, password)
  local url
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
      print("CANNOT READ DATA!!!: \n" .. err)
      return nil
    end
  else
    print("CONNECTION FAILED!!! \n" .. status)
    return nil
  end
end

function client:create_new_user(name, password)
  local try = client:sign_in(name)
  if try and try[1] then
    print("user exists"); return
  end
  local data = { name = name, password = password }
  local json_data = json.encode(data)
  local response_body = {}

  local res, code, headers, status = http.request {
    url = base_url .. "users/",
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json",
      ["Content-Length"] = tostring(#json_data),
    },
    source = ltn12.source.string(json_data),
    sink = ltn12.sink.table(response_body)
  }

  local da = ltn12.source.string(json_data)

  if code == 200 or code == 201 then
    print("Request successful!")
    print("Response: " .. table.concat(response_body))
  else
    print("Request failed!")
    print("HTTP Code: " .. tostring(code))
    print("Status: " .. tostring(status))
  end
end
