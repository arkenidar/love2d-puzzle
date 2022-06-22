
-- 8 puzzle (for size=3 )
require("bnb_puzzle")

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
  
  --table_grid = table_grid_shuffled() -- initial (shuffled)
  table_grid_end_game = table_grid_sorted()
  --table_grid = grid_shuffled3(table_grid_end_game) -- initial (shuffled)

--table_grid=grid_shuffled3(final)
  --table_grid=grid_shuffled3(table_grid_end_game)
  ---[[
  while true do -- TODO removed
    local shuffled = grid_shuffled3(table_grid_end_game) -- initial (shuffled)
    local path = solve(shuffled, table_grid_end_game)
    if #path > 0 then -- > 3
      table_grid=shuffled
      break
    end
  end
  --]]

  --[[
  table_grid = { -- 5 moves
    { 1, 2, 3, }, 
    { 4, 8, 5, }, 
    { 7, 6, 0, },
  }
  
  table_grid = { -- 9 moves
    { 1, 2, 3, }, 
    { 4, 0, 8, }, 
    { 7, 6, 5, },
  }
  --]]
  
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

function love.load(arg)
  
  love.window.setTitle("Puzzle search-game of love, made with Love2D, made of love")
  
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  size = 3 -- initial
  size_set(size)
  
  clicked = false -- initially
  
  --[[
  table_grid = {
    {1,2,3},
    {4,8,5},
    {7,6,0}
    }   ]]
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

function table_grid_swap(grid,row1,column1,row2,column2)
  grid[row1][column1], grid[row2][column2] = grid[row2][column2], grid[row1][column1]
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
  
  
  -- TODO which solve/search?
  
  -- BFS
  -- Breadth First Search or BFS for a Graph - GeeksforGeeks
  -- https://www.geeksforgeeks.org/breadth-first-search-or-bfs-for-a-graph/
  ---solve1()
  
  -- solve2() with Branch and Bound (BnB)
  -- https://www.geeksforgeeks.org/8-puzzle-problem-using-branch-and-bound/
  solve2() 
  
end

function solve1()
  

function table_grid_to_string(grid_to_stringify)
  
  local table_grid_stringified = ""
  
  for row_id = 1,size do
    for column_id = 1,size do
      
      table_grid_stringified = table_grid_stringified..grid_to_stringify[row_id][column_id]..","
    
    end
  end
  
  -- TODO remove this section?
  local move_string = ""
  if not ( grid_to_stringify.move_id == nil ) then
    --move_string = "|"..grid_to_stringify.move_id -- TODO explore (comment/uncomment/research)
  end
  
  local previous_string = ""
  if not ( grid_to_stringify.previous_grid == nil ) then -- TODO: is needed or superfluous?
    ---previous_string = "<("..table_grid_to_string(grid_to_stringify.previous_grid)..")"
  end
  
  table_grid_stringified = table_grid_stringified..move_string..previous_string
  --- print("table:", table_grid_stringified)
  
  return table_grid_stringified

end

function get_adjacent_nodes( node )
  local row_id, column_id = table_grid_empty( node )
  local adjacent_nodes = {}
  
  function possible_move(move_id, row, column)
    if row >= 1 and row <= size and column >= 1 and column <= size then
      local new_grid = table_grid_copy( node )
      
      table_grid_swap( new_grid, row, column, row_id, column_id )
      table.insert( adjacent_nodes, new_grid )
      
      -- additional. TODO: remove?
      new_grid.move_id = move_id
      new_grid.previous_grid = node -- TODO not a copy? same instead
    end
  end
  
  moves={"down", "up", "right", "left"}
  possible_move(1, row_id + 1 , column_id)
  possible_move(2, row_id - 1 , column_id)
  possible_move(3, row_id, column_id + 1 )
  possible_move(4, row_id, column_id - 1 )
  
  return adjacent_nodes
  
end

function table_grid_empty(grid)
  for row_id = 1,size do
    for column_id = 1,size do
      if grid[row_id][column_id] == 0 then
        return row_id, column_id
      end
    end
  end
end

function queue_size(queue)
  local size = 0
  for _,_ in pairs(queue) do
    size = size + 1
  end
  return size
end

function queue_to_string(queue)
  local string = ""
  for _,queued in pairs(queue) do
    string = string .. table_grid_to_string( queued ) .. "|"
  end
  return string
end
  
function search()
  local moves_to_solution={}
  local row_id, column_id = table_grid_empty(table_grid)
  local node_queue = {}; local visited_nodes = {}
  function enqueue(grid)
    table.insert( node_queue, grid )
    visited_nodes[ table_grid_to_string( grid ) ] = true
    if table_grid_same( grid, table_grid_end_game) then
      -- local moves={"down", "up", "right", "left"}
      print("found!!!", queue_to_string(node_queue), moves[ node_queue[1].move_id ])
      return "exit"
    end
  end
  if enqueue(table_grid) == "exit" then return end
  while #node_queue > 0 do
    for _ , adjacent_node in ipairs( get_adjacent_nodes( table.remove( node_queue, 1 ) ) ) do
      ---print(adjacent_node.move_id) -- moves=
      if visited_nodes[ table_grid_to_string( adjacent_node ) ] == nil then
        if enqueue(table_grid) == "exit" then return end
      end
    end
  end
  print("found NOT")
end
end

function solve2() -- with Branch and Bound (BnB)
  local initial, final
  final=table_grid_end_game
  
  initial=table_grid
  --initial=grid_shuffled3(final)
  ------table_grid=grid_shuffled3(final)
  
  ---table_grid = solve(initial, final)[2] --next in path
  local path = solve(initial, final)
  local solution = path[2] or path[1] --next in path
  if solution == nil then print("solution==nil"); return end
  table_grid = solution
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
          print("end game, next level")
          next_level=true
          -- ... pause and show completation
          
          -------size_set(size) -- no size increase TODO
          ---size_set(size+1) -- size increase TODO
          
          --[[
            table_grid = { -- 5 moves
              { 1, 2, 3, }, 
              { 4, 8, 5, }, 
              { 7, 6, 0, },
            }
          --]]
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
        --solve2() -- TODO which solve/search?
        after_move()
      end
      
      -- drawing
      
      -- draw square
      love.graphics.setColor(0,0,0) -- black
      if table_grid[row_id][column_id] == table_grid_end_game[row_id][column_id] and
      not ( table_grid[row_id][column_id] == 0 )
      then
        love.graphics.setColor(0,1,0) -- green
      end
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

function love.update()
  if delay then next_level=false end
  
  if next_level then
    next_level = false

    start_time = love.timer.getTime()
    delay = true
    print("count-down to next level")
  end
  
  if delay then
    local current_time = love.timer.getTime()
    local passed_time = current_time - start_time
    
    if passed_time >= 2 then
      delay = false
      
      size_set(size) -- next level
    end
  end
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
