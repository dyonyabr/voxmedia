function lerp(a, b, t)
  return a + (b - a) * t
end

function lerp_angle(a, b, t)
  local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
  return a + diff * t
end

function posmod(a, b)
  return ((a % b) + b) % b
end

function clamp(val, lower, upper)
  assert(val and lower and upper, "not very useful error message here")
  if lower > upper then lower, upper = upper, lower end
  return math.max(lower, math.min(upper, val))
end

function table.copy(original, copies)
  copies = copies or {}     -- Keeps track of already copied tables
  if type(original) ~= "table" then
    return original         -- If not a table, return the value itself
  elseif copies[original] then
    return copies[original] -- Avoid infinite loops by returning the copy if it already exists
  end

  local copy = {}                                       -- Create a new table for the copy
  copies[original] = copy                               -- Store the reference to avoid circular copying
  for k, v in pairs(original) do
    copy[table.copy(k, copies)] = table.copy(v, copies) -- Recursively copy keys and values
  end
  return setmetatable(copy, getmetatable(original))     -- Preserve the metatable of the original
end
