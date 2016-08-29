local End = class("End", function()
	return display.newScene("End")
end)


function End:ctor()

	-- 背景层
	local backgroundLayer = display.newLayer()
		:addTo(self)

	-- 文字
	local ThxSprite = display.newSprite("Thx.png")
		:align(display.CENTER, display.cx , display.cy - 1250 )
		:addTo(backgroundLayer)
	local moveBy = cc.MoveBy:create(45, cc.p(0,2450))
	 ThxSprite:runAction(moveBy)

	 audio.playMusic("sound/storyBG.mp3") 

	 action = self:performWithDelay(function()
	 				audio.stopMusic()
	 				ThxSprite:setVisible(false)
					local mapScene = import("app.scenes.MapScene"):new()
					display.replaceScene(mapScene,"slideInT",0.5)
				end, 47)
end


function End:onEnter()
end

function End:onExit()
end

return End