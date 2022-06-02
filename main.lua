
-- 8 puzzle

function love.load()
  size = 3
  table_grid={
   {1,2,3},
   {4,5,6},
   {7,8,0},
  }
  side = 50
  love.window.setMode(size*side,size*side)
  
  local font = love.graphics.getFont()
  font_width_max = 0
  for number = 1 , size*size-1 do -- whole range
    local font_width = font:getWidth(tostring(number))
    if font_width > font_width_max then
      font_width_max = font_width
    end
  end
end

function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end

function draw_grid()
  
  local font = love.graphics.getFont()
  
  local width, height
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  if width < height then
    side = width/size
  else
    side = height/size
  end
  
  local font_height = font:getHeight() -- same height
  local font_width = font_width_max -- maximum width
  
  local font_scale
  if font_width > font_height then
    font_scale = side/font_width
  else
    font_scale = side/font_height
  end
  
  local x_offset, y_offset
  x_offset = width/2 - size*side/2
  y_offset = height/2 - size*side/2
  
  love.graphics.push()
  love.graphics.translate(x_offset, y_offset)

  for row_id , row in pairs(table_grid) do
    for column_id , element in pairs(row) do
      
      local x_id , y_id
      x_id = column_id - 1
      y_id = row_id - 1
      
      local rx , ry
      rx = x_id*side
      ry = y_id*side
      
      local mx , my = love.mouse.getPosition()
      mx = mx - x_offset
      my = my - y_offset
      
      local square = {rx,ry,side,side}
      local inside = point_in_rectangle({mx,my} , square )
    
      function swap(row_id_2, column_id_2)
        local temporary
        temporary = table_grid[row_id][column_id]
        table_grid[row_id][column_id] = table_grid[row_id_2][column_id_2]
        table_grid[row_id_2][column_id_2] = temporary
      end
    
      -- action when click/touch inside the square
      if inside and love.mouse.isDown(1) then

        -- left
        if column_id > 1 and table_grid[row_id][column_id - 1] == 0 then
          swap(row_id, column_id - 1)
        end
        
        -- right
        if column_id < size and table_grid[row_id][column_id + 1] == 0 then
          swap(row_id, column_id + 1)
        end
        
        -- up
        if row_id > 1 and table_grid[row_id - 1][column_id] == 0 then
          swap(row_id - 1, column_id)
        end
        
        -- down
        if row_id < size and table_grid[row_id + 1][column_id] == 0 then
          swap(row_id + 1, column_id)
        end
        
      end
      
      -- drawing
      
      -- draw square
      love.graphics.setColor(0,0,0) -- black
      love.graphics.rectangle("fill", square[1], square[2], square[3], square[4])
      
      -- draw square line
      if inside then
        love.graphics.setColor(1,0,0) -- red
      else
        love.graphics.setColor(1,1,1) -- white
      end
      love.graphics.rectangle("line", square[1]+1, square[2]+1, square[3]-2, square[4]-2)
      
      -- draw square content
      if element > 0 then
        local center = side/2
        
        local font_height = font:getHeight()
        local font_width = font:getWidth(tostring(element))
        local x,y
        x = rx + center - (font_width*font_scale)/2 -- scaled font size
        y = ry + center - (font_height*font_scale)/2
        love.graphics.setColor(1,1,1) -- white
        love.graphics.print(element, x , y , 0 , font_scale , font_scale ) -- uniform scaling
      end
      
    end -- end for/row
  end -- end for/table
  
  love.graphics.pop()
  
end

function love.draw()
  draw_grid()
end
