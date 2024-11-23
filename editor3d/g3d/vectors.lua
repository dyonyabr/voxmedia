-- written by groverbuger for g3d
-- september 2021
-- MIT license

----------------------------------------------------------------------------------------------------
-- vector functions
----------------------------------------------------------------------------------------------------
-- some basic vector functions that don't use tables
-- because these functions will happen often, this is done to avoid frequent memory allocation

local vectors = {}

function vectors.subtract(v1, v2, v3, v4, v5, v6)
  return v1 - v4, v2 - v5, v3 - v6
end

function vectors.add(v1, v2, v3, v4, v5, v6)
  return v1 + v4, v2 + v5, v3 + v6
end

function vectors.scalarMultiply(scalar, v1, v2, v3)
  return v1 * scalar, v2 * scalar, v3 * scalar
end

function vectors.crossProduct(a1, a2, a3, b1, b2, b3)
  return a2 * b3 - a3 * b2, a3 * b1 - a1 * b3, a1 * b2 - a2 * b1
end

function vectors.dotProduct(a1, a2, a3, b1, b2, b3)
  return a1 * b1 + a2 * b2 + a3 * b3
end

function vectors.normalize(x, y, z)
  local mag = 1
  if x ~= 0 and y ~= 0 and z ~= 0 then
    mag = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
  end
  return x / mag, y / mag, z / mag
end

function vectors.magnitude(x, y, z)
  return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
end

function vectors.rotated(v1, v2, v3, u1, u2, u3, angle)
  if angle == 0 or angle == math.pi * 2 then
    return v1, v2, v3
  end

  u1, u2, u3 = vectors.normalize(u1, u2, u3)

  local cosAngle = math.cos(angle)
  local sinAngle = math.sin(angle)

  local r1 = v1 * cosAngle +
      (u2 * v3 - u3 * v2) * sinAngle +
      u1 * (u1 * v1 + u2 * v2 + u3 * v3) * (1 - cosAngle)

  local r2 = v2 * cosAngle +
      (u3 * v1 - u1 * v3) * sinAngle +
      u2 * (u1 * v1 + u2 * v2 + u3 * v3) * (1 - cosAngle)

  local r3 = v3 * cosAngle +
      (u1 * v2 - u2 * v1) * sinAngle +
      u3 * (u1 * v1 + u2 * v2 + u3 * v3) * (1 - cosAngle)

  return r1, r2, r3
end

return vectors
