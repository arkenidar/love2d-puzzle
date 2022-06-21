
if arg[#arg] == "-debug" then require("mobdebug").start() end

size=3

local heap = require"heap" -- luapower.com/heap -- "heap.lua" file

--[[ Priority queues implemented as binary heaps. A binary heap is a binary tree that maintains the lowest (or highest) value at the root. The tree is laid as an implicit data structure over an array. Pushing and popping values from the heap is O(log n). Removal is O(n) by default unless a key is reserved on the elements (assuming they’re indexable) to store the element index which makes removal O(log n) too. ]]

function grid_copy(grid_to_copy)
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


function grid_swap(grid,row1,column1,row2,column2)
  grid[row1][column1], grid[row2][column2] = grid[row2][column2], grid[row1][column1]
end

function find_empty(grid)
  for row_id = 1,size do
    for column_id = 1,size do
      if grid[row_id][column_id] == 0 then
        return {row_id, column_id}
      end
    end
  end
end

-- Function to calculate the number of
-- misplaced tiles ie. number of non-blank
-- tiles not in their goal position.
function calculate_cost(mat, final)
	
	local count = 0
	for i=1,size do
		for j=1,size do
			if mat[i][j]>0 and (mat[i][j] ~= final[i][j]) then
				count = count + 1
      end
    end
  end
	return count
end -- function

function new_node(mat, empty_tile_pos, new_empty_tile_pos, level, parent, final)
  
  -- Copy data from parent matrix to current matrix.
  local new_mat = grid_copy(mat) -- copy
  
  -- Move tile by 1 position.
  -- swap on the copy
  local row1,column1,row2,column2
  row1 = empty_tile_pos[1]
	column1 = empty_tile_pos[2]
	row2 = new_empty_tile_pos[1]
	column2 = new_empty_tile_pos[2]
  grid_swap(new_mat,row1,column1,row2,column2)
  
  -- Set number of misplaced tiles.
	local cost = calculate_cost(new_mat, final)
  
  local new_node = {
  parent=parent,
  mat=new_mat,
  empty_tile_pos=new_empty_tile_pos,
  cost=cost,
  level=level}

  return new_node
end

-- Function to print the N x N matrix.
function print_matrix(mat)
	
	for i=1,size do
		for j=1,size do
			io.write( mat[i][j] .. " ")
    end
		print()
  end
end

function is_safe(row, column)
  return row >= 1 and row <= size and column >= 1 and column <= size
end

function solve(initial,final)

  print("solving...")
  
  local empty_tile_pos = find_empty( initial )

  -- Create the root node.
  local cost = calculate_cost(initial, final)
  local root = {
    parent=nil,
    mat=initial,
    empty_tile_pos=empty_tile_pos,
    cost=cost,
    level=0
  }

  -- Create a priority queue to store live nodes of search tree.
  -- Priority queues implemented as binary heaps.
  local pq = heap.valueheap{cmp = function(a, b)
    return a.cost < b.cost
  end}

  -- Add root to list of live nodes.
  pq:push(root)

  while pq:length() > 0 do

    -- Find a live node with least estimated cost and delete it form the list of live nodes.
    local minimum = pq:pop()
    
    
    if minimum.level > 20 then return {} end -- debug

    -- If minimum is the answer node
    if minimum.cost == 0 then
      
      -- Print path from root node to destination node.
      function print_path(root)
        
        if root == nil then
          return
        end
        
        print_path(root.parent)
        print_matrix(root.mat)
        print()
      end -- function
      
      -- Print path from root node to destination node.
      local path={}
      function print_path2(root)
        
        if root == nil then
          return
        end
        
        print_path2(root.parent) -- recurse
        print_matrix(root.mat)
        print()
        
        table.insert(path,root.mat)
        
      end -- function
      
      -- Print the path from root to destination.
      print_path2(minimum); print("----------------------------")

      return path
    end -- if

    -- Generate all possible children.
    for i = 1,4 do
      
      -- bottom, left, top, right (parallel arrays)
      local row = { 1,  0, -1, 0 }
      local col = { 0, -1,  0, 1 }
      
      local new_tile_pos = {
        minimum.empty_tile_pos[1] + row[i],
        minimum.empty_tile_pos[2] + col[i] }
      
      if is_safe(new_tile_pos[1], new_tile_pos[2]) then
        
        -- Create a child node.
        local child = new_node(
          minimum.mat,
          minimum.empty_tile_pos,
          new_tile_pos,
          minimum.level + 1,
          minimum,
          final)

        -- Add child to list of live nodes.
        pq:push(child)
      end -- if
    end -- for
    
  end -- while

end -- function


-- Driver code:

function grid_sorted()
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


function grid_shuffled()
  
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

function grid_shuffled2(grid)
  grid=grid_copy(grid)
  local empty = find_empty(grid)

  -- bottom, left, top, right (parallel arrays)
  local row = { 1,  0, -1, 0 }
  local col = { 0, -1,  0, 1 }
  
  local iterations = 20
  math.randomseed( os.time() )
  while iterations>0 do
    local dir = math.random(1,4)
    local new = {
      row[dir]+empty[1],
      col[dir]+empty[2],
      }
    
    if is_safe(new[1], new[2]) then
      grid_swap(grid,empty[1],empty[1],new[1],new[2])
      -- removed: iterations=iterations-1
    end
    iterations=iterations-1 -- warning: iteration can occur without swapping
  end
  return grid
end

function grid_shuffled3(grid)
  grid=grid_copy(grid)
  local empty = find_empty(grid)

  -- bottom, left, top, right (parallel arrays)
  local row = { 1,  0, -1, 0 }
  local col = { 0, -1,  0, 1 }
  
  local iterations = 20 --30 too much --5 --2
  math.randomseed( os.time() )
  while iterations>0 do    
    local safe={}
    
    print_matrix(grid) -- DEBUG
    empty = find_empty(grid)
    print("empty", empty[1],empty[2]) -- DEBUG
    
    for dir=1,4 do
      --local dir = math.random(1,4)
      empty = find_empty(grid)
      local new_move = {
        row[dir]+empty[1],
        col[dir]+empty[2],
        }
      
      if is_safe(new_move[1], new_move[2]) then
        table.insert(safe, new_move)
        print("new_move", new_move[1],new_move[2]) -- DEBUG
      end
    end
    local new = safe[math.random(1,#safe)]
    local empty = find_empty(grid)
    
    grid=grid_copy(grid)
    
    grid_swap(grid,empty[1],empty[2],new[1],new[2]) ---- !!!!!!!!!!!!!!!
    
    print_matrix(grid) ; print() -- DEBUG
    
    iterations=iterations-1 -- iterations=iterations-1 after swap (safe swap)
  end
  return grid
end

local final = grid_sorted()
local initial = grid_shuffled3(final)
--[[
initial = { { 1, 2, 3 },
			{ 5, 6, 0 },
			{ 7, 8, 4 } }

final = { { 1, 2, 3 },
		{ 5, 8, 6 },
		{ 0, 7, 4 } }     --]]
    
local solution=solve(initial, final)
print("#solution",#solution)
print_matrix( solution[2] or solution[1] ); print("is next")

--solve,grid_shuffled3 = unpack(require("bnb_puzzle")) --import
--return {solve,grid_shuffled3} --export


