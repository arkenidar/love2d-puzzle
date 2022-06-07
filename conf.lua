function love.conf(t)
  -- https://love2d.org/forums/viewtopic.php?t=84826
  t.window.fullscreen = love._os == "Android" or love._os == "iOS"
  
  -- https://love2d.org/forums/viewtopic.php?t=79579
  t.console = true
end