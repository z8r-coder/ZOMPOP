local Loading = class("Loading", function()
	return display.newScene("Loading")
end)

function Loading:ctor()
	local currentPercent = 0
	local totalPercent = 100

	-- 背景层
	local background = display.newLayer()
		:addTo(self)

	-- 背景图片
	display.newSprite("loading/loading_Bg.png")
		:align(display.CENTER, display.cx, display.cy )
		:addTo(background)

	-- 进度条
    local loadbar = display.newSprite("loading/loadingBg.png")
    		:align(display.CENTER, display.cx - 40, display.cy - 350)
    		:setScale(2.0)
    		:addTo(background)

    local loadingbar = cc.ui.UILoadingBar.new({
    		scale9 = false,
    		-- capInsets = cc.rect(0,0,10,10), -- scale region
    		image =  "loading/loadingbar.png", -- loading bar image
    		viewRect = cc.rect(0,0,144,10), -- set loading bar rect
    		percent = currentPercent, -- set loading bar percent
    })
    	:pos(display.cx - 183, display.cy - 357)
    	:setScale(2.0)
    	:addTo(background)

    -- loading字体
   	local loadFont = display.newSprite("loading/loading.png")
    	:align(display.CENTER, display.cx, display.cy- 400)
    	:setScale(0.5)
    	:addTo(self)

    -- 加载BMFont
    display.newBMFontLabel({text = "最后高得分1234567890：",font ="font/resultB.fnt"})
        :pos(display.cx, display.cy + 100)

    -- 预加载音乐音效
    audio.preloadMusic("sound/ZombiesOnYourLawn.mp3")
    audio.preloadSound("sound/awooga.mp3")
    audio.preloadSound("sound/broken3.mp3")
    audio.preloadSound("sound/broken4.mp3")
    audio.preloadSound("sound/broken5.mp3")
    audio.preloadSound("sound/broken6.mp3")
    audio.preloadSound("sound/broken7.mp3")
    audio.preloadSound("sound/floop.mp3")
    audio.preloadSound("sound/scream.mp3")
    audio.preloadSound("sound/map.mp3")
    audio.preloadMusic("playmusic.mp3")
    audio.preloadSound("shockthuder.mp3")
    audio.preloadSound("redApple.mp3")
    audio.preloadSound("jianguo.mp3")
    audio.preloadSound("blackhole.mp3")
    audio.preloadMusic("sound/storyBG.mp3")

    -- loading 进度显示
   	local load = {}
    for i = 0, 100, 20 do
    	load[i] = display.newSprite("loading/loading_"..i..".png")
    		:align(display.CENTER, display.cx + 150, display.cy - 350 )
    		:setScale(0.5)
    		:addTo(self)
    		:setVisible(false)
    end

    load[0]:setVisible(true)

    local scheduler = require(cc.PACKAGE_NAME..".scheduler")

    self.index = 0
    self:schedule(function()
    	self.index = self.index + 20
    	if self.index > 100 then
    		loadFont:setVisible(false)
    		loadbar:setVisible(false)
            loadingbar:setVisible(false)
    		load[100]:setVisible(false)
    		local mainScene = import("app.scenes.MainScene"):new()
			display.replaceScene(mainScene,"fadeDown",0.5)
			return
    	end
    	display.addSpriteFrames("test/zombie_"..self.index..".plist", "test/zombie_"..self.index..".png")
    	load[self.index - 20]:setVisible(false)
    	load[self.index]:setVisible(true)
    	loadingbar:setPercent(self.index)
	end, 0.8)
end

function Loading:onEnter()
end

function Loading:onExit()
end

return Loading