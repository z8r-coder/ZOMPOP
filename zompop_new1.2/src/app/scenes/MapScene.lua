local MapScene = class("Mapscene", function()
	return display.newScene("MapScene")
end)

function MapScene:ctor()
	-- 1. 背景图片
	display.newSprite("map/map_Bg.png")
		:align(display.CENTER, display.cx, display.cy)
		:addTo(self)

	audio.playSound("sound/map.mp3")

	-- 2. 第一关按钮
	local action_1 = cc.MoveTo:create(1, cc.p(display.cx - 90, display.cy - 370))
	local pass1Images = {
		normal = "map/pass1_normal.png",
		pressed = "map/pass1_select.png",
	}

	local pass1Btn = cc.ui.UIPushButton.new(pass1Images, {scale9 = false})
		:onButtonClicked(function()
			audio.playSound("sound/floop.mp3")
			audio.playSound("sound/awooga.mp3")

			local playScene = import("app.scenes.PlayScene"):new()
			display.replaceScene(playScene,"turnOffTiles",0.5)
		end)
	pass1Btn:align(display.CENTER,display.cx - 90, display.top)
	pass1Btn:runAction(action_1)
	pass1Btn:setScale(0.4)
	pass1Btn:setLocalZOrder(5)
	pass1Btn:addTo(self)

	-- 3.第二关按钮
	local action_2 = cc.MoveTo:create(1, cc.p(display.cx - 195, display.cy - 180))
	local pass2Images = {
		normal = "map/pass2_normal.png",
		pressed = "map/pass2_select.png",
	}

	local pass2Btn = cc.ui.UIPushButton.new(pass2Images, {scale9 = false})
		:onButtonClicked(function()
			audio.playSound("sound/floop.mp3")
			audio.playSound("sound/awooga.mp3")

			local playScene1 = import("app.scenes.PlayScene1"):new()
			display.replaceScene(playScene1,"turnOffTiles",0.5)
		end)
	pass2Btn:align(display.CENTER, display.cx - 195, display.top)
	pass2Btn:runAction(action_2)
	pass2Btn:setScale(0.4)
	pass2Btn:setLocalZOrder(4)
	pass2Btn:addTo(self)

	-- 4.第三关按钮
	local action_3 = cc.MoveTo:create(1, cc.p(display.cx + 205, display.cy - 205))
	local pass3Images = {
		normal = "map/pass3_normal.png",
		pressed = "map/pass3_select.png",
	}

	local pass3Btn = cc.ui.UIPushButton.new(pass3Images, {scale9 = false})
		:onButtonClicked(function()
			audio.playSound("sound/floop.mp3")
			audio.playSound("sound/awooga.mp3")

			local playScene2 = import("app.scenes.PlayScene2"):new()
			display.replaceScene(playScene2,"turnOffTiles",0.5)
		end)
	pass3Btn:align(display.CENTER, display.cx + 205, display.top)
	pass3Btn:runAction(action_3)
	pass3Btn:setScale(0.4)
	pass3Btn:setLocalZOrder(2)
	pass3Btn:addTo(self)

	-- 5.第四关
	local action_4 = cc.MoveTo:create(1, cc.p(display.cx + 20, display.cy - 40))
	local pass4Btn = display.newSprite("map/pass4_normal.png")
	pass4Btn:align(display.CENTER, display.cx + 20, display.top)
	pass4Btn:runAction(action_4)
	pass4Btn:setScale(0.4)
	pass4Btn:setLocalZOrder(1)
	pass4Btn:addTo(self)

	-- 6.第五关
	local action_5 = cc.MoveTo:create(1, cc.p(display.cx + 70, display.cy + 140))
	local pass5Btn = display.newSprite("map/pass5_normal.png")
	pass5Btn:align(display.CENTER,display.cx + 70, display.top)
	pass5Btn:runAction(action_5)
	pass5Btn:setScale(0.4)
	pass5Btn:setLocalZOrder(0)
	pass5Btn:addTo(self)

	-- 7.返回按钮
	local returnImages = {
		normal = "map/return_normal.png",
		pressed = "map/return_select.png",
	}

	cc.ui.UIPushButton.new(returnImages, {scale9 = false})
		:onButtonClicked(function()
			audio.playSound("sound/floop.mp3")

			local mainScene = import("app.scenes.MainScene"):new()
			display.replaceScene(mainScene,"turnOffTiles",0.5)
		end)
		:align(display.CENTER, display.left + 40, display.top - 40)
		:setScale(1.2)
		:setLocalZOrder(1)
		:addTo(self)

	-- 8. 关于我们
	local aboutUsImages = {
		normal = "button/aboutUs_normal.png",
		pressed = "button/aboutUs_select.png",
	}

	cc.ui.UIPushButton.new(aboutUsImages, {scale9 = false})
		:onButtonClicked(function()

			audio.playSound("sound/floop.mp3")

			local End = import("app.scenes.End"):new()
			display.replaceScene(End,"slideInB",0.5)
		end)
		:align(display.CENTER, display.right - 70, 50)
		:setScale(0.6)
		:setLocalZOrder(1)
		:addTo(self)
end

function MapScene:onEnter()
end

function MapScene:onExit()
end

return MapScene