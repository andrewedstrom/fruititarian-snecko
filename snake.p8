pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--pico snake
--by andrew edstrom 

local player
local board_length=15
local grid_size=8
local frames
local tails
local apple
local game_over=false

function _init()
    frames=0
    player={
      x=10,
      y=10,
      dx=0,
      dy=1,
      tail_length=3,
      tail_blocks={
        {x=10,y=7},
        {x=10,y=8},
        {x=10,y=9}
      },
      draw=function(self)
        draw_block(self.x,self.y,3)
        -- spr(2,self.x*grid_size+2,self.y*grid_size+2)
        for tail in all(self.tail_blocks) do
            draw_block(tail.x,tail.y,3)
        end
      end,
      update=function(self)
        if frames % 10 == 0 then
            add(self.tail_blocks,{x=self.x,y=self.y})
            if #self.tail_blocks>self.tail_length then
                del(self.tail_blocks,self.tail_blocks[1])
            end
            self.x+=self.dx
            self.y+=self.dy
            if self.x == apple.x and self.y==apple.y then
                sfx(0)
                self.tail_length+=1
                apple=new_apple()
            end

            for block in all(self.tail_blocks) do
                if block.x == self.x and block.y== self.y then
                    game_over=true
                end
            end

            if self.x<0 or self.y<0 or self.x==board_length or self.y==board_length then
                game_over=true
            end
        end
        self:handle_input()
      end,
      handle_input=function(self)
        if btn(1) then
            self.dx=1
            self.dy=0
        end
        if btn(0) then
            self.dx=-1
            self.dy=0
        end
        if btn(3) then
            self.dx=0
            self.dy=1
        end
        if btn(2) then
            self.dx=0
            self.dy=-1
        end
      end
    }

    apple=new_apple()
end

function new_apple()
    local unfilled_place=false
    local x,y
    repeat
        unfilled_place=true
        x,y = random_x_y_coordinate()
        for block in all(player.tail_blocks) do
            if block.x == x and block.y == y then
                unfilled_place=false
            end
        end
    until unfilled_place==true
    
    return {
        x=x,
        y=y,
        draw=function(self) 
            spr(1,self.x*grid_size+2,self.y*grid_size+2)
        end
    }
end

function random_x_y_coordinate()
    return flr(rnd(board_length)), flr(rnd(board_length))
end

function draw_block(x,y,col)
    rectfill(x*grid_size+2,
    y*grid_size+2,
    x*grid_size+grid_size,
    y*grid_size+grid_size,
    col) 
end

function _update()
    if not game_over then
        frames+=1
        player:update()
    end
end

function _draw()
    cls()
    player:draw()
    apple:draw()
    draw_board()
    if game_over then
        centered_print("game over",board_length*grid_size/2,board_length*grid_size/3,7,5)
        centered_print("final tail length was "..player.tail_length,board_length*grid_size/2,2*board_length*grid_size/3,7,5)
    end
end

function draw_board()
    rect(1,1,(board_length*grid_size)+1,(board_length*grid_size)+1,7)
end

-- fancy printing
function centered_print(text,x,y,col)
    outlined_print(text, x-#text*2, y, col, 5)
end

function outlined_print(text,x,y,col,outline_col)
    print(text,x-1,y,outline_col)
    print(text,x+1,y,outline_col)
    print(text,x,y-1,outline_col)
    print(text,x,y+1,outline_col)

    print(text,x,y,col)
end

__gfx__
00000000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088b08800333330003333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700288bb7780333030003330300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000288888780303330003033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000288888880300000803000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700228888880388888003888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022888200333330803333308000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
01040000180501c0501f0502405000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
