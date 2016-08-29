local Shoter = class("Shoter", function(px,py,str_png)
	local sprite = str_png
      				:pos(px, py)
      	sprite.position_x = px
      	sprite.position_y = py
      	sprite:setScale(1.2)
	return sprite
end)
function Shoter:ctor()
end
function Shoter:set_Shoter_position(px,py)
	self.position_x = px
	self.position_y = py

end

return Shoter

-- -- resultLayer 半透明展示信息
-- 	local resultLayer = display.newColorLayer(cc.c4b(0,0,0,150))
-- 	resultLayer:addTo(self)
-- 	-- 吞噬事件
-- 	resultLayer:setTouchEnabled(true)
-- 	resultLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
-- 		if event.name == "began" then
-- 			return true
-- 		end
-- 	end)

-- 	-- 更新数据
-- 	if self.curSorce >= self.highSorce then
-- 		self.highSorce = self.curSorce
-- 	end
-- 	self.stage = self.stage + 1
-- 	self.target = self.stage * 200
-- 	-- 存储到文件
-- 	cc.UserDefault:getInstance():setIntegerForKey("HighScore", self.highSorce)
-- 	cc.UserDefault:getInstance():setIntegerForKey("Stage", self.stage)

-- 	display.newSprite("lose.png")
-- 		:pos(display.cx,display.cy + 90)
-- 		:addTo(resultLayer)

-- 	 -- 失败信息
-- 	display.newBMFontLabel({text = "\n最后得分: "..self.highSorce,font = "result.fnt"})
-- 	 	:pos(display.cx, display.cy + 100)
-- 	 	:addTo(resultLayer)
		
-- 	-- 返回按钮
-- 	local returnBtnImages = {
		-- normal = "return_normal.png",
		-- pressed = "return_select.png",
-- 	}
--     cc.ui.UIPushButton.new(returnBtnImages, {scale9 = false})
-- 		:onButtonClicked(function(event)
-- 			audio.stopMusic()

-- 			local mainScene = import("app.scenes.MainScene"):new()
-- 			display.replaceScene(mainScene, "flipX", 0.5)
-- 		end)
-- 		:align(display.CENTER, display.cx - 230, display.cy - 100)
-- 		:addTo(resultLayer)	
-- end