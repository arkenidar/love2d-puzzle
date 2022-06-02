
function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end

local table_grid={
 {1,2,3},
 {4,5,6},
 {7,8,0},
}

function love.draw()
  
  local side = 50
  local center = side/2
  
  for row_id , row in pairs(table_grid) do
    for column_id , element in pairs(row) do
      local x_id , y_id
      x_id = column_id - 1
      y_id = row_id - 1
      
      local rx , ry
      rx = x_id*side
      ry = y_id*side
      
      local mx , my = love.mouse.getPosition()
      
      if point_in_rectangle({mx,my} , {rx,ry,side,side} ) then
         love.graphics.setColor(1,0,0)
      else
         love.graphics.setColor(1,1,1)
      end
      
      love.graphics.print(element, -- content
        rx+center, ry+center) -- x y
      
    end -- end for/row
  end -- end for/table
  
end
