
-- 8 puzzle (for size=3 )

function table_grid_sorted()
  local table_grid = {}
  
  for row_id = 1,size do
  
    local row = {}
    for column_id = 1,size do
      local number
      
      -- sorted number
      number = column_id + (row_id-1)*size
      if row_id==size and column_id==size then
        number = 0
      end
      
      table.insert(row, number)
    end
    table.insert(table_grid, row)
  
  end
  
  return table_grid
end

function table_grid_copy(grid_to_copy)
  local table_grid = {}
  
  for row_id = 1,size do
  
    local row = {}
    for column_id = 1,size do
      local number
      
      -- copied number
      number = grid_to_copy[row_id][column_id]
      
      table.insert(row, number)
    end
    table.insert(table_grid, row)
  
  end
  
  return table_grid
end

function table_grid_shuffled()
  
  -- starts from 1: empty square is the last
  -- starts from 0: empty square is randomly placed
  local start_from = 1
  
  local numbers_to_insert = {}
  for number = start_from,size*size-1 do
    table.insert(numbers_to_insert, number)
  end
  
  -- initialize the pseudo random number generator
  math.randomseed( os.time() )
  
  local table_grid = {}
  
  for row_id = 1,size do
  
    local row = {}
    for column_id = 1,size do
      local number
      
      -- shuffled number
      number = table.remove(numbers_to_insert, math.random(1, #numbers_to_insert) )
      if number==nil then number=0 end
      
      table.insert(row, number)
    end
    table.insert(table_grid, row)
  
  end
  
  return table_grid
end

function size_set(size_to_set)
  
  size = size_to_set
  
  table_grid = table_grid_shuffled() -- initial (shuffled)
  table_grid_end_game = table_grid_sorted()
  
  side = 100 -- applies when "windowed" in Desktop systems
  love.window.setMode(size*side,size*side)
  
  local font = love.graphics.getFont()
  font_width_max = 0
  for number = 1 , size*size-1 do -- whole range
    local font_width = font:getWidth(tostring(number))

    font_width_max = math.max(font_width, font_width_max)
  end
end

function table_grid_same(grid1, grid2)
  
  for row_id = 1,size do
    for column_id = 1,size do
      if not (grid1[row_id][column_id] == grid2[row_id][column_id]) then
        return false
      end
    end
  end
  
  return true

end

function table_grid_to_string(grid_to_stringify)
  
  local table_grid_stringified = ""
  
  for row_id = 1,size do
    for column_id = 1,size do
      
      table_grid_stringified = table_grid_stringified..grid_to_stringify[row_id][column_id]..","
    
    end
  end
  
  return table_grid_stringified

end

function love.load(arg)
  
  love.window.setTitle("puzzle")
  
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  size = 3 -- initial
  size_set(size)
  
  clicked = false -- initially
end

function love.mousepressed()
  clicked = true -- when click/touch
  
  -- "clicked = false" after love.draw()
end

function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end

function table_grid_swap(table_grid,row_id,column_id,row_id_2,column_id_2)
  local temporary
  temporary = table_grid[row_id][column_id]
  table_grid[row_id][column_id] = table_grid[row_id_2][column_id_2]
  table_grid[row_id_2][column_id_2] = temporary
end

function ai_solve_step()
  
  -- solution search, finds a solution
  -- TODO: is a "stable solution"? verify
  
  -- do one step toward the found solution
  
end

function draw_grid()
  
  local font = love.graphics.getFont()
  
  local width, height
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  side = math.min(width,height)/size
  
  local font_height = font:getHeight() -- same height
  local font_width = font_width_max -- maximum width
  
  local font_scale
  local spacing = 0.6

  font_scale = (side*spacing)/math.max(font_width,font_height)
  
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
    
      function after_move()
        -- (end-game) if solved ...
        if table_grid_same(table_grid, table_grid_end_game) then
          -- ... next level
          size_set(size+1) -- size increase
        end
      end
      
      function swap(row_id_2, column_id_2)
        
        table_grid_swap(table_grid,row_id,column_id,row_id_2,column_id_2)
        
        after_move()
        
      end
    
      -- action when click/touch inside the square
      local action = inside and clicked
      local empty_square = table_grid[row_id][column_id] == 0
      if action and not empty_square then

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
      
      if action and empty_square then
        -- hinting: game A.I. does one step toward solution
        ai_solve_step()
        
        after_move()
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
  clicked = false -- "clicked = false" after love.draw()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "+" then
    size_set( size + 1) -- increase
    
  elseif key == "-" then
    if (size - 1) >= 3 then
      
      size_set( size - 1 ) -- decrease
    end
  end

end
