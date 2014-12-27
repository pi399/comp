--main.lua
local love=love
local voices,volumes
local bound,sliders
local xl,yl,amount,yf

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function love.load()
	math.randomseed(os.time())
	voices={}
	sliders={}
	bound={}
	volumes={}
	amount=15
	xl,yl=love.window.getWidth()/amount,30
	yf=0
	love.graphics.setBackgroundColor(255-math.random(20),255-math.random(20),255-math.random(20))
	for i=1,amount do
		volumes[i]=0
		bound[i]=false
		sliders[i]={}
		sliders[i].x,sliders[i].y=(i-1)*love.window.getWidth()/amount,love.graphics.getHeight()-yl
		sliders[i].r,sliders[i].g,sliders[i].b=i*math.random(51),i*math.random(51),i*math.random(51)
		voices[i]=love.audio.newSource(i..".wav","static")
		if voices[i] then
			voices[i]:setLooping(true)
			voices[i]:setVolume(volumes[i])
			voices[i]:play()
		end
	end
end

function love.draw()
	for i=1,amount do
		love.graphics.setColor(sliders[i].r,sliders[i].g,sliders[i].b)
		love.graphics.line(sliders[i].x,0,sliders[i].x,love.window.getHeight())
		love.graphics.rectangle("fill",sliders[i].x,sliders[i].y,xl,yl)
		love.graphics.setColor(	sliders[i].r-90>=0 and sliders[i].r-90 or 0,
								sliders[i].g-90>=0 and sliders[i].g-90 or 0,
								sliders[i].b-90>=0 and sliders[i].b-90 or 0)
		love.graphics.printf(tostring(round(volumes[i],2)*100).."%",sliders[i].x,sliders[i].y+.25*yl,xl,"center")
	end
end

function love.update()
	for i=1,amount do
		if bound[i] then
			local x,y=love.mouse.getPosition()
			sliders[i].y=y-yf
			volumes[i]=1-(sliders[i].y/(love.graphics.getHeight()-yl))
			if voices[i] then
				voices[i]:setVolume(round(volumes[i],2))
			end
		end
	end
end

function love.mousepressed(x,y,button)
	for i=1,amount do
		if sliders[i].x<=x and x<=sliders[i].x+xl and
		   sliders[i].y<=y and y<=sliders[i].y+yl then
		   	bound[i]=true
		   	yf=y-sliders[i].y
		   	return bound[i]
		end
	end
end

function love.mousereleased(x,y,button)
	for i=1,amount do
		bound[i]=false
		yf=0
	end
end