require "shared"
g3d = require "g3d"
require "assets.shaders"
require "lib.tools"
Timer = require "lib.Timer"

require "client.client"

require "pages.mainPage"
require "pages.sign"
require "components.windowTopBar"

utf8 = require "utf8"

colors = {
  main = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
  dark = { r = 0.05, g = 0.05, b = 0.05, a = 1 },
  main_text = { r = 0.9, g = 0.9, b = 0.9, a = 1 },
  secondary_text = { r = 0.6, g = 0.6, b = 0.6, a = 1 },
  highlight = { r = 0.2, g = 0.6, b = 0.8, a = 1 },
  button = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
  button_hover = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
  bright = { r = 0.2, g = 0.2, b = 0.2, a = 1 },
  button_pressed = { r = 0.3, g = 0.3, b = 0.3, a = 1 },
  border = { r = 0.2, g = 0.2, b = 0.2, a = 1 },
  white = { r = 0.9, g = 0.9, b = 0.9, a = 1 },
  red = { r = 0.8, g = 0.2, b = 0.2, a = 1 },
  green = { r = 0.2, g = 0.8, b = 0.4, a = 1 },
  yellow = { r = 0.8, g = 0.8, b = 0.4, a = 1 },
  disabled = { r = 0.05, g = 0.05, b = 0.05, a = 1 },
}

icons = {
  close = love.graphics.newImage("assets/icons/icon_close.png"),
  arrow_down = love.graphics.newImage("assets/icons/icon_arrow_down.png"),
  arrow_left = love.graphics.newImage("assets/icons/icon_arrow_left.png"),
  arrow_right = love.graphics.newImage("assets/icons/icon_arrow_right.png"),
  arrow_up = love.graphics.newImage("assets/icons/icon_arrow_up.png"),
  cube = love.graphics.newImage("assets/icons/icon_cube.png"),
  edit = love.graphics.newImage("assets/icons/icon_edit.png"),
  expand = love.graphics.newImage("assets/icons/icon_expand.png"),
  message = love.graphics.newImage("assets/icons/icon_message.png"),
  photo = love.graphics.newImage("assets/icons/icon_photo.png"),
  saved = love.graphics.newImage("assets/icons/icon_saved.png"),
  shrink = love.graphics.newImage("assets/icons/icon_shrink.png"),
  user = love.graphics.newImage("assets/icons/icon_user.png"),
  view = love.graphics.newImage("assets/icons/icon_view.png"),
  minimize = love.graphics.newImage("assets/icons/icon_minimize.png"),
  like = love.graphics.newImage("assets/icons/icon_like.png"),
  new = love.graphics.newImage("assets/icons/icon_new.png"),
  ortho = love.graphics.newImage("assets/icons/icon_ortho.png"),
  proj = love.graphics.newImage("assets/icons/icon_proj.png"),
}

images = {
  test_avatar = love.graphics.newImage("assets/images/test_avatar.png"),
  test_cap = love.graphics.newImage("assets/images/test_cap.png"),
}

fonts = {
  WorkSans = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-Regular.ttf", 16),
  WorkSansBig = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-Regular.ttf", 24),
  WorkSansSemiBold = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-SemiBold.ttf", 16),
  WorkSansSemiBoldBig = love.graphics.newFont("assets/fonts/Work_Sans/static/WorkSans-SemiBold.ttf", 24),
}
