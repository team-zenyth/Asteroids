timer = Timer.new()
timer:start()

dofile("eslib.lua")

Mp3.load("Dixvague.mp3", 0)
Mp3.play(true, 0)
Ogg.load("laser shot.ogg", 0)
Ogg.load("explosion.ogg", 1)

System.setCpuSpeed(333)

blanc = Color.new(255,255,255)
vert = Color.new(0,255,0)
jaune = Color.new(255,255,0)
rouge = Color.new(255,0,0)
noir = Color.new(0,0,0)
missiles = {}
cooldown = Timer.new()
level = 1
asteroids = {}
spaceship = {lifes = 5,x = 240,y = 136,angle = 0}
boucliers = 0
elan = 0
direction = 0

pi = math.pi

ltn_1 = IntraFont.load("flash0:/font/ltn0.pgf", 0); 

function initLevel()
 if level / 5 == math.floor(level/5) then
  boucliers = boucliers + 1
 end
 for i = 1, level do
  asteroids[i] = {x = math.random(0,480),y = math.random(0,272),size = 32,angle = math.random(0,360)}
  while object.collision({x = asteroids[i].x,y = asteroids[i].y,radius = asteroids[i].size},{x = spaceship.x,y = spaceship.y,radius = 30}) do
   asteroids[i] = {x = math.random(0,480),y = math.random(0,272),size = 32,angle = math.random(0,360)}
  end
 end
 for i = 1, 255 do
  System.draw()
  screen:clear()

  background(0)

  for j = 1, #asteroids do
   screen.circle(asteroids[j].x,asteroids[j].y,asteroids[j].size,Color.new(i,i,i))
  end
  
  screen:drawLine(spaceship.x-10*math.cos(math.rad(-90-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-90-spaceship.angle)),spaceship.x-10*math.cos(math.rad(-210-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-210-spaceship.angle)),vert)
  screen:drawLine(spaceship.x-10*math.cos(math.rad(-90-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-90-spaceship.angle)),spaceship.x-10*math.cos(math.rad(-330-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-330-spaceship.angle)),vert)
  screen:drawLine(spaceship.x,spaceship.y,spaceship.x-10*math.cos(math.rad(-210-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-210-spaceship.angle)),vert)
  screen:drawLine(spaceship.x,spaceship.y,spaceship.x-10*math.cos(math.rad(-330-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-330-spaceship.angle)),vert)

  ltn_1:setStyle(1.0,Color.new(0,255,0,255-i),noir,IntraFont.ALIGN_CENTER)
  ltn_1:print(240, 136, "Level "..level)

  System.endDraw()
  screen.flip()
 end
 missiles = {}
end

function pauseMenu()
 oldpad = pad

 while 1 do
  System.draw()
  screen:clear()
  pad = Controls.readPeek()

  background(0)

  ltn_1:setStyle(1.0,Color.new(0,255,0),noir,IntraFont.ALIGN_CENTER)
  ltn_1:print(240, 20, "PAUSE")
  ltn_1:print(240, 240, "Press START to continue playing")
  ltn_1:print(240, 260, "Press HOME to quit")

  if pad:start() and not oldpad:start() then
   oldpad = pad
   break
  end
  if pad:home() then System.quit() end

  System.endDraw()
  screen.flip()
  oldpad = pad
 end
end

function gameOver()
 System.msgDialog("Spaceship destroyed!",1)
 asteroids = {}
 level = 1
 spaceship = {lifes = 5,x = 240,y = 136,angle = 0}
 elan = 0
 direction = 0
 initLevel()
end

etoiles = {}

for i = 1, 30 do
 etoiles[i] = {x =math.random(0,480),y =math.random(0,272)}
end

function background(anim)
 for i = 1, # etoiles do
  screen.safePixel(etoiles[i].x,etoiles[i].y,blanc)
  if anim == 1 then
   etoiles[i].x,etoiles[i].y = object.move(direction+180,elan/2,etoiles[i].x,etoiles[i].y)
   if etoiles[i].x > 480 then
    etoiles[i].x = 0
   elseif etoiles[i].x < 0 then
    etoiles[i].x = 480
   end
   if etoiles[i].y > 272 then
    etoiles[i].y = 0
   elseif etoiles[i].y < 0 then
    etoiles[i].y = 272
   end
  end
 end
end

initLevel()

while 1 do
System.draw()
screen:clear()
pad = Controls.readPeek()

background(1)

if #asteroids == 0 then
 level = level + 1
 initLevel()
end

for i = 1, #asteroids do
 if asteroids[i] ~= nil then
  asteroids[i].x,asteroids[i].y = object.move(asteroids[i].angle,1.5,asteroids[i].x,asteroids[i].y)
  screen.circle(asteroids[i].x,asteroids[i].y,asteroids[i].size,blanc)
  if asteroids[i].x > (480 + asteroids[i].size) then
   asteroids[i].x = 0 - asteroids[i].size
  elseif asteroids[i].y > (272 + asteroids[i].size) then
   asteroids[i].y = 0 - asteroids[i].size
  elseif asteroids[i].x < (0 - asteroids[i].size) then
   asteroids[i].x = 480 - asteroids[i].size
  elseif asteroids[i].y < (0 - asteroids[i].size) then
   asteroids[i].y = 272 - asteroids[i].size
  end
  if object.collision({x = asteroids[i].x,y = asteroids[i].y,radius = asteroids[i].size},{x = spaceship.x,y = spaceship.y,radius = 10}) then
   if boucliers ~= 0 then
    if asteroids[i].size > 16 then
     asteroids[i].size = asteroids[i].size / 2
     asteroids[i].angle = math.random(0,360)
     asteroids[#asteroids +1] = {x = asteroids[i].x,y = asteroids[i].y,size = asteroids[i].size,angle = math.random(0,360)}
    else
     table.remove(asteroids,i)
    end
    boucliers = boucliers -1
   else
    gameOver()
   end
  end
 end
end

for i = 1, #missiles do
 if missiles[i] ~= nil then
  missiles[i].x,missiles[i].y = object.move(missiles[i].angle,6,missiles[i].x,missiles[i].y)
  screen.circle(missiles[i].x,missiles[i].y,3,jaune)
  if missiles[i].x < 0 or missiles[i].y < 0 or missiles[i].x > 480 or missiles[i].y > 272 then
   table.remove(missiles,i)
  else
   for j = 1, #asteroids do
    if asteroids[j] ~= nil then
     if missiles[i] ~= nil then
      if object.collision({x = asteroids[j].x,y = asteroids[j].y,radius = asteroids[j].size},{x = missiles[i].x,y = missiles[i].y,radius = 3}) then
       Ogg.play(false,1)
       if asteroids[j].size > 16 then
        asteroids[j].size = asteroids[j].size / 2
        asteroids[j].angle = math.random(0,360)
        asteroids[#asteroids +1] = {x = asteroids[j].x,y = asteroids[j].y,size = asteroids[j].size,angle = math.random(0,360)}
       else
        table.remove(asteroids,j)
       end
        table.remove(missiles,i)
      end
     end
    end
   end
  end
 end
end

if pad:r() or pad:right() then
 spaceship.angle = spaceship.angle + 4
end
if pad:l() or pad:left() then
 spaceship.angle = spaceship.angle - 4
end

if spaceship.angle > 356 then
 spaceship.angle = 0
elseif spaceship.angle < 4 then
 spaceship.angle = 356
end

if cooldown:time() >= 500 then
 cooldown:stop()
 cooldown:reset()
end

if pad:square() or pad:circle() or pad:triangle() then
 if cooldown:time() == 0 or cooldown:time() >= 500-(level*10) then
  if #missiles ~= nil then
   missiles[#missiles + 1] = {x = spaceship.x,y = spaceship.y,angle = spaceship.angle}
  else
   missiles[1] = {x = spaceship.x,y = spaceship.y,angle = spaceship.angle}
  end
  Ogg.play(false,0)
  cooldown:reset()
  cooldown:start()
 end
end

if pad:cross() then
 if elan < 5 then
  elan = elan + 0.1
 end
 direction = spaceship.angle
 spaceship.x,spaceship.y = object.move(direction,elan,spaceship.x,spaceship.y)
else
 if elan > 0 then
  elan = elan - 0.05
  spaceship.x,spaceship.y = object.move(direction,elan,spaceship.x,spaceship.y)
 end
end

if spaceship.x > 490 then
 spaceship.x = -10
elseif spaceship.y > 282 then
 spaceship.y = -10
elseif spaceship.x < -10 then
 spaceship.x = 490
elseif spaceship.y < -10 then
 spaceship.y = 282
end

-- Don't ask me how, but it works

for i = 1, boucliers do
 screen.circle(spaceship.x,spaceship.y,10 + i * 2,rouge)
end

screen:drawLine(spaceship.x-10*math.cos(math.rad(-90-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-90-spaceship.angle)),spaceship.x-10*math.cos(math.rad(-210-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-210-spaceship.angle)),vert)
screen:drawLine(spaceship.x-10*math.cos(math.rad(-90-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-90-spaceship.angle)),spaceship.x-10*math.cos(math.rad(-330-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-330-spaceship.angle)),vert)
screen:drawLine(spaceship.x,spaceship.y,spaceship.x-10*math.cos(math.rad(-210-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-210-spaceship.angle)),vert)
screen:drawLine(spaceship.x,spaceship.y,spaceship.x-10*math.cos(math.rad(-330-spaceship.angle)),spaceship.y+10*math.sin(math.rad(-330-spaceship.angle)),vert)

-- End of the unhuman sequence

if pad:start() and not oldpad:start() then pauseMenu() end

while timer:time() < 33 do
--cap the Framerate to aprox. 30FPS
end

System.endDraw()
System.showFPS()
screen.flip()

oldpad = pad

timer:reset(0)
timer:start()
end
