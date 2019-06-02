-- ESSENTIAL LIB, by psgarsenal

-- CIRCLE

function screen.circle(x0,y0,radius,couleur)
 f = 1 - radius
 ddF_x = 1
 ddF_y = -2 * radius
 x = 0
 y = radius

 screen.safePixel(x0, y0 + radius,couleur)
 screen.safePixel(x0, y0 - radius,couleur)
 screen.safePixel(x0 + radius, y0,couleur)
 screen.safePixel(x0 - radius, y0,couleur)

 while x < y do
  if f >= 0 then
   y = y-1
   ddF_y = ddF_y + 2
   f = f + ddF_y
  end
  x = x + 1
  ddF_x = ddF_x + 2
  f = f + ddF_x
  screen.safePixel(x0 + x, y0 + y,couleur)
  screen.safePixel(x0 - x, y0 + y,couleur)
  screen.safePixel(x0 + x, y0 - y,couleur)
  screen.safePixel(x0 - x, y0 - y,couleur)
  screen.safePixel(x0 + y, y0 + x,couleur)
  screen.safePixel(x0 - y, y0 + x,couleur)
  screen.safePixel(x0 + y, y0 - x,couleur)
  screen.safePixel(x0 - y, y0 - x,couleur)
 end
end

function screen.safePixel(x,y,couleur)
 if x > 0 and x < 480 and y < 272 and y > 0 then
  screen:pixel(x,y,couleur)
 end
end

-- DISK

function screen.disk(x0,y0,radius,couleur)
 f = 1 - radius
 ddF_x = 1
 ddF_y = -2 * radius
 x = 0
 y = radius

 screen:drawLine(x0 + radius, y0,x0 - radius, y0,couleur)

 while x < y do
  if f >= 0 then
   y = y-1
   ddF_y = ddF_y + 2
   f = f + ddF_y
  end
  x = x + 1
  ddF_x = ddF_x + 2
  f = f + ddF_x
  screen:drawLine(x0 + x, y0 + y,x0 - x, y0 + y,couleur)
  screen:drawLine(x0 + x, y0 - y,x0 - x, y0 - y,couleur)
  screen:drawLine(x0 + y, y0 + x,x0 - y, y0 + x,couleur)
  screen:drawLine(x0 + y, y0 - x,x0 - y, y0 - x,couleur)
 end
end

-- GRADIENT RECTANGLE

function screen.gradientRect(x,y,width,height,mode,firstColor,lastColor)
 local couleur1, couleur2 = firstColor:colors(), lastColor:colors()
 local diffR, diffG, diffB = couleur2.r-couleur1.r, couleur2.g-couleur1.g, couleur2.b-couleur1.b

 if mode == "h" then
  local stepR, stepG, stepB = diffR/width, diffG/width, diffB/width
  for i = 1, width do
   screen:drawLine(x+i-1,y,x+i-1,y+height,Color.new(i*stepR+couleur1.r, i*stepG+couleur1.g, i*stepB+couleur1.b))
  end
 elseif mode == "v" then
  local stepR, stepG, stepB = diffR/height, diffG/height, diffB/height
  for i = 1, height do
   screen:drawLine(x,y+i-1,x+width,y+i-1,Color.new(i*stepR+couleur1.r, i*stepG+couleur1.g, i*stepB+couleur1.b))
  end
 else
  error("Incorect mode value\""..mode.."\". Possible values are \"h\" and \"v\".")
 end
end

-- MOVES & COLLISIONS
object = {}

function object.move(angle,distance,x,y)
 x = x-distance*math.cos(math.rad(-90-angle))
 y = y+distance*math.sin(math.rad(-90-angle))
 return x,y
end

function object.collision(C1,C2)
 d2 = (C1.x-C2.x)*(C1.x-C2.x) + (C1.y-C2.y)*(C1.y-C2.y)
 if d2 > (C1.radius + C2.radius)^2 then
  return false -- pas de collision
 else
  return true -- collision
 end
end

-- IMAGE

-- Resize

function Image.resize(image,new_width,new_height)
old_width = image:width()
old_height = image:height()
calque = Image.createEmpty(new_width,new_height)
taille_pixel_x = new_width / old_width
taille_pixel_y = new_height / old_height

if taille_pixel_x == 1 and taille_pixel_y == 1 then
 calque = image
elseif taille_pixel_x < 1 and taille_pixel_y < 1 then
 for x = 0, old_width - 1 do
  for y = 0, old_height - 1 do
   calque:blit(x*taille_pixel_x,y*taille_pixel_y,image,x,y,1,1)
  end
 end
else
 taille_pixel_x_floor = math.floor(taille_pixel_x)
 taille_pixel_y_floor = math.floor(taille_pixel_y)
 for x = 0, old_width - 1 do
  for y = 0, old_height - 1 do
   for i = 0, taille_pixel_x_floor do
    for j = 0, taille_pixel_y_floor do
     calque:blit(x*taille_pixel_x + i,y*taille_pixel_y + j,image,x,y,1,1)
    end
   end
  end
 end
end
return calque
end

--Mirror

function Image.mirror(pic,mode)
calque = Image.createEmpty(pic:width(),pic:height())
calque:clear()
if mode == 1 then
 for i = 1, pic:width() do
  calque:blit(0,pic:width()-i,pic,0,i-1,pic:width(),1)
 end
elseif mode == 2 then
 for i = 1, pic:height() do
  calque:blit(pic:height()-i,0,pic,i-1,0,1,pic:height())
 end
else
 calque = pic
end

return calque
end
