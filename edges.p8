pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 g_t = 0
 g_b = makeboard(8, 10)
 g_cur = makecursor(g_b)
 
 --test
 g_b[3][9][1] = 3
 g_b[2][9][2] = 9
 g_b[2][9][1] = 8
 g_b[4][9][2] = 8
 
 g_b[4][3][2] = 8
 g_b[4][3][1] = 8
 g_b[5][3][1] = 3
 
 
 
 --g_b[1][10][1] = 8
 --g_b[1][10][2] = 8
 --g_b[2][10][2] = 9
 
 g_cur.x = 1
 g_cur.y = 8
end

function _update60()
 g_t += 1
 
 if btnp(0, 1) then
  raiseboard(g_b)
 end
 updatecursor(g_cur)

 
end

function _draw()
 cls()
 rect(0, 0, 127, 127, 1)
 
 camera(-4, -10)

 drawboard(g_b)
 
 drawcursor(g_cur)
 --local f =
 --  curframe(flr(g_t / -3))
   
 --f = 0
 
 --pal(1, 0)
 --spr(f, 8, 16, 3, 3)
-- pal()
 
 camera()
end


function curframe(i)
 i = i % 6
 if i < 5 then
  return i * 3
 end
 return 48
end

function makeboard(x, y)
 local b = {}
 for _x = 1, x do
 	local c = {}
 	b[_x] = c
 	
 	for _y = 1, y do
 	 c[_y] = {0, 0, 0, 0}
 	end
 
 end
 return b
end

function drawboard(b)
 for x = 1, #b do
  local c = b[x]
  for y = 1, #c do
   local e = c[y]
   
   if x > 1
     and x < #b
     and y > 1
     and y < #c
       then
    spr(15, x*8, y*8)
   end
   -- right
   if e[1] > 0 then
    pal(7, e[1])
    
    spr(47, x*8+4, y*8)
    pal()
   end
   
   -- up
   if e[2] > 0 then
    pal(7, e[2])
    spr(31, x*8, y*8-4)
    pal()
   end 
   
  end
 end
end


_spinpivots = {
 {{3, 11},  --left
  {20, 12}, --right
  {12, 3},  --top
  {11, 20}},--bot
 {{4, 13},
  {19, 10},
  {9, 3},
  {12, 20}},
 {{4, 15},
  {19, 8},
  {8, 4},
  {14, 19}},
 {{5, 17},
  {17, 6},
  {6, 5},
  {16, 18}},
 {{7, 18},
  {15, 5},
  {5, 7},
  {18, 16}},
 {{9, 19},
  {13, 4},
  {4, 9},
  {18, 14}}
}

function makecursor(board)
 return {
  x = 0,
  y = 0,
  direction = 0,
  rotcount = 0,
  pivot = 0,
  pivotcount = 0,
  board=board,
 }
end

_dirs = {
 {-1, 0},
 {1, 0},
 {0, -1},
 {0, 1},
}

function drawcursor(c)
 if c.direction == 0 then
  pal(1, 0)
  
 	spr(curframe(0),
 	  c.x * 8, c.y * 8, 3, 3) 
 
  pal()
  
  local x = c.x * 8 + 8
  local y = c.y * 8 + 8
  
  if c.pivot > 0 then
   x += _dirs[c.pivot][1] * 8
   y += _dirs[c.pivot][2] * 8
  end
  
  local f = 51
  if g_t % 30 > 14 then
   f += 1
  end
  spr(f, x, y)
  
  --print(c.x .. ' ' .. c.y,
  --  0, -10, 5)
 
 else
  
  spr(curframe(c.rotcount),
 	  c.x * 8, c.y * 8, 3, 3,
 	    c.direction > 0)
 
 end
 
end

_cwoffsets = {
 {0, 1, 1},
 {1, 1, 2},
 {1, 1, 1},
 {1, 2, 2}
}

function updatecursor(c)
  if c.direction == 0 then
   
   c.pivot = 0
   for i = 0, 3 do
    if btn(i) then
     c.pivot = i + 1
     break
    end
   end
   
   if c.pivot == 0 then
	   
	   local bp = -1
	   for i = 4, 5 do
	    if btnp(i) then
	     bp = i
	     break
	    end
	   end
	   
	   
	   if bp > -1 then
	    -- gather entries
	    local ens = {}
	    local vals = {}
	    for i = 1, 4 do
	     local e = _cwoffsets[i]
	     add(ens, {
	      c.board[c.x + e[1]]
	        [c.y + e[2]], e[3]})
	     
	     add(vals,
	       ens[i][1][e[3]]) 
	    end
	    
	    c.direction =
	      (bp - 4) * 2 - 1
	    
	      
	    for i = 1, 4 do
	     local en = ens[i]
	     local ii = i
	     
	     if bp == 5 then
	      ii -= 1
		     if ii < 1 then
		      ii = 4
		     end
		    else
		     ii = (ii % 4) + 1
		    end
	     en[1][en[2]] = vals[ii]
	     --
	    
	    end
	    --[[
	    stop('\n\n\n' .. vals[1] .. ' '
	      .. vals[2] .. ' '
	      .. vals[3] .. ' ' 
	      .. vals[4]) 
	    --]]
	    
	   end
   end
  
   updatecursorpos(c)
   
  else
  
   
   c.rotcount += 1
   
   if c.rotcount >= 5 then
    c.direction = 0
    c.rotcount = 0
   end
   
  end

end

_curoffs = {
 --ccw, cw
 {{-1, -1},{-1, 1}}, --left
 {{1, 1}, {1, -1}}, --right
 {{1, -1}, {-1, -1}}, --up
 {{-1, 1}, {1, 1}} --down
}

_curdirs = {
 {-1, 0},
 {1, 0},
 {0, -1},
 {0, 1}
}

function updatecursorpos(c)
 if c.pivot == 0 then
  return
 end
 
 
 local x = c.x
 local y = c.y
 
 if btnp(c.pivot - 1) then
  x += _curdirs[c.pivot][1]
  y += _curdirs[c.pivot][2]
  
 else
  return
 end
 
 
 
 
 
 --[[
 local d = 0
 
 if btnp(4) then
  d = 1
 elseif btnp(5) then
  d = 2
 end

 if d == 0 then
  return
 end
 
 local off =
   _curoffs[c.pivot][d]
 local x = c.x + off[1]
 local y = c.y + off[2]
 --]]
 local w = #c.board
 local h = #c.board[1]
 
 
 if x < 1 or x > w - 2 then
  return
 end
 
 if y < 1 or y > h - 2 then
 	return
 end
 
 c.x = x
 c.y = y
end

_colors = {
  0, 0, 0, 0, 0, 0, 0,
  3, 8, 12}

function getcol()
 return _colors[
   flr(rnd(#_colors)) + 1]
 
end

function raiseboard(b)
 --todo
 for i = 1, #b do
  local c = b[i]
  
  del(c, c[1])
  local e = {0,0,0,0}
  
  if i > 1 and i < #b then
   e[2] = getcol()
   
   if c[#c][1] == 0 then
    c[#c][1] = getcol()
   end
  
   
  end
  
  
  add(c, e)
  
  c[1][1] = 0
  c[1][2] = 0
 end
end
__gfx__
00000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001771000000000000000000111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000017007100000000000000001777100000000000000000011110000000000000000000000000000000000000000000000000001111000000000000000
00000000170000710000000000000017700710000000000000000177771000000000000000000111000000011100000000000000000017777100000000055000
00000000170000710000000000000017000071000000000000001700007100000000000000001777100000177710000000000000000170007100000000055000
00000000170000710000000000000017000071000000000000001700007100011111000000017000710001700071000000011111000170007100000000000000
00000000170000710000000000000017000071000000000000001770000710117777100000017000071017000071000000177777100700007100000000000000
00000000170000710000000000000001700071111111000000000170000711770007710000017000007170000071000000170000711700007100000000000000
00011111170000711111100000000001700007777777110000000017000077000000710000017000000700000710000000170000077000007100000000000000
00177777700000077777710000000111700000000000710000000017000000000007100000001700000000000710000000170000000000071000000000077000
01700000000000000000071000011777000000000000710000000017000000000077100000000170000000007100000000017000000000071000000000077000
17000000000000000000007100177000000000000000710000000117000000007711000000000017000000071000000000001770000000071100000000077000
17000000000000000000007101700000000000000077100000011770000000071100000000000017000000071000000000000117000000007710000000077000
01700000000000000000071001700000000000077711000000177000000000071000000000000170000000007100000000000017000000000071000000077000
00177777700000077777710001700000000000711100000000170000000000071000000000001700000000000710000000000017000000000007100000077000
00011111170000711111100000177777770000710000000000170000077000071000000000001700000000000071000000000177000077000000710000000000
00000000170000710000000000011111117000710000000000170007711700007100000000017000007170000071000000000170000711770000710000000000
00000000170000710000000000000000017000071000000000177771111700007710000000017000071017000071000000000170000710177777100000000000
00000000170000710000000000000000017000071000000000011111000170000710000000017000710001700071000000000170007100011111000000000000
00000000170000710000000000000000017000071000000000000000000170000710000000001777100000177710000000000170007100000000000007777770
00000000170000710000000000000000001700710000000000000000000017777100000000000111000000011100000000000177771000000000000007777770
00000000017007100000000000000000000177710000000000000000000001111000000000000000000000000000000000000011110000000000000000000000
00000000001771000000000000000000000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007700000077000000770000007700000077000000777000007777770000000000000000000000000000000000
00000000000011000000000000000000000aa0007700000077000000777000007770000077770000777777007777770000000000000000000000000000000000
000000000001771000000000000aa00000a00a007700000077000000077000000777000000777700000777000000000000000000000000000000000000000000
00000000001700710000000000a00a000a0000a07700000007700000077000000077700000007700000000000000000000000000000000000000000000000000
00000000017000071000000000a00a000a0000a07700000007700000077700000007770000000000000000000000000000000000000000000000000000000000
000000000170000710000000000aa00000a00a007700000007700000007700000000700000000000000000000000000000000000000000000000000000000000
00000000017000071000000000000000000aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111111117000710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01777777770000710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01700000000000710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01700000000000071111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00170000000000007777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00017770000000000000710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001117000000000000710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001700000000000710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001700007777777710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001700071111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000017000071000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000017000071000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000017000071000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001700710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000