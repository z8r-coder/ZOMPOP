local story = class("story", function()
	return display.newScene("story")
end)

function story:ctor()

	-- 背景层
	local backgroundLayer = display.newLayer()
		:addTo(self)

	local storyLabel = cc.ui.UILabel.new({
		UILabelType = 2,
		text = "    伪装成人类的邪恶僵尸\n\n戴夫利用植物打败正义僵尸\n\n后，回到了地球。而植物在\n\n战斗中清醒过来，发现了戴\n\n夫的邪恶阴谋，并一起反抗\n\n显露僵尸真身的戴夫……\n\n",
		size = 40})
		:align(display.CENTER, display.cx, display.cy - 800)
		:addTo(backgroundLayer)

	local moveBy1 = cc.MoveBy:create(15,cc.p(0,1600))
	storyLabel:runAction(moveBy1)

	local jsSprite = display.newSprite("story_js.png")
		:align(display.CENTER, display.cx + 650, display.cy )
		:addTo(backgroundLayer)
	self:performWithDelay(function()
		local moveBy2 = cc.MoveBy:create(1, cc.p(-650,0))
	 	jsSprite:runAction(moveBy2)
	end,15.0)

	local story_plantSprite = display.newSprite("story_plant.png")
		:align(display.CENTER, display.cx - 650, display.cy )
		:addTo(backgroundLayer)
	self:performWithDelay(function()
		local moveBy3 = cc.MoveBy:create(1, cc.p(650,0))
	 	story_plantSprite:runAction(moveBy3)
	end,15.0)

	--火焰特效
	self:performWithDelay(function()
			local scaleTo1 = cc.ScaleTo:create(0.1,1.4)
			local scaleTo2 = cc.ScaleTo:create(0.1, 1)
			local scaleTo3 = cc.ScaleTo:create(0.1,1.4)
			local scaleTo4 = cc.ScaleTo:create(0.1, 1)
			jsSprite:runAction(cc.Sequence:create(scaleTo1,scaleTo2))
			story_plantSprite:runAction(cc.Sequence:create(scaleTo3,scaleTo4))
	end,16.0)

	local mapScene = import("app.scenes.Loading"):new()
	self:performWithDelay(function()
		audio.stopMusic()
		display.replaceScene(mapScene,"turnOffTiles",0.5)
	end,19)
end



function story:onEnter()
	audio.playMusic("sound/begin.mp3") 
end

function story:onExit()
end

return story