
local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()
	-- 1.加载精灵帧
    display.addSpriteFrames("fruity.plist", "fruity.png")
    display.addSpriteFrames("texiao.plist", "texiao.png")
    display.addSpriteFrames("tu.plist", "tu.png")
    display.addSpriteFrames("sun.plist","sun.png")
	-- 1. 背景音乐

    audio.playMusic("sound/ZombiesOnYourLawn.mp3",true)

    self.backgroundLayer = display.newLayer()
    self.backgroundLayer:addTo(self)

    -- 2. 背景图片
    display.newSprite("Background/BackGround1.png")
        :pos(display.cx,display.cy)
        :addTo(self.backgroundLayer)

    -- 3. 背景移动效果
    local sprite1 = display.newSprite("Background/s.png")
    sprite1:center()
    local move_left = cc.MoveBy:create(30, cc.p(display.width / 2, 0))
    local move_right = cc.MoveBy:create(60, cc.p(- display.width , 0))
    local seq = cc.Sequence:create(move_left, move_right, move_left)
    local rep = cc.RepeatForever:create(seq)
    sprite1:runAction(rep)
    sprite1:addTo(self.backgroundLayer)
    
    self.backgroundLayer:runAction(cc.Follow:create(sprite1))

    -- 4. 大标题
    local fade_In = cc.FadeTo:create(3,255)
    local fade_Out = cc.FadeTo:create(3,120)
    local seq = cc.Sequence:create(fade_In, fade_Out)
    local logo = display.newSprite("Background/logo2.png")
   	logo:pos(display.cx,display.cy + 180)
   	logo:setOpacity(120)
    logo:setScale(1.1)
    logo:addTo(self)
    logo:runAction(cc.RepeatForever:create(seq)) 

    -- 5. 开始按钮
    local moveTolocal moveTo_start = cc.MoveTo:create(1, cc.p(display.cx, display.cy - 60))
    local action_start = cc.Sequence:create(moveTo_start)
    local startBtnImages = {
    	normal = "button/StartBtn_normal.png",
    	pressed = "button/StartBtn_select.png",
	}

	cc.ui.UIPushButton.new(startBtnImages, {scale9 = false})
		:onButtonClicked(function(event)

			audio.playSound("sound/floop.mp3")

			audio.stopMusic(true)

			local mapScene = import("app.scenes.MapScene"):new()
			display.replaceScene(mapScene,"turnOffTiles",0.5)
		end)
		:align(display.CENTER, display.cx, 0)
		:setScale(0.8)
		:addTo(self)
		:runAction(action_start)


	-- 6.任务按钮
	local moveTolocal moveTo_task = cc.MoveTo:create(1, cc.p(display.cx,display.cy - 160))
    local action_task = cc.Sequence:create(moveTo_task)
	local taskBtnImages = {
		normal = "button/task_normal.png",
		pressed = "button/task_select.png",
	}

	cc.ui.UIPushButton.new(taskBtnImages, {scale9 = false})
		:onButtonClicked(function(event)
			audio.playSound("sound/floop.mp3")
			
			local taskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 125)) 
			taskLayer:setTouchEnabled(true)
			taskLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
       			return true;
    		end)

    		-- 1.背景图片
    		display.newSprite("Background/taskBg.png")
    			:pos(display.cx,display.cy)
    			:setScale(1.0)
    			:addTo(taskLayer)
    		self:addChild(taskLayer)

   		-- 2.任务描述
			self.Percent = cc.UserDefault:getInstance():getIntegerForKey("Percent")
    		local taskNumber = 1
    		display.newSprite("task/Task_"..taskNumber..".png")
    			:setScale(0.7)
    			:align(display.CENTER, display.cx, display.cy + 100)
    			:addTo(taskLayer)

    		display.newSprite("task/Task"..taskNumber.."_"..self.Percent..".png")
    			:setScale(0.7)
    			:align(display.CENTER, display.cx + 170, display.cy)
    			:addTo(taskLayer)

    		-- 3.进度条
    		display.newSprite("loading/loadingBg.png")
    			:align(display.CENTER, display.cx - 40, display.cy)
    			:setScale(2.0)
    			:addTo(taskLayer)

    		local loadingbar = cc.ui.UILoadingBar.new({
    				scale9 = false,
    				-- capInsets = cc.rect(0,0,10,10), -- scale region
    				image =  "loading/loadingbar.png", -- loading bar image
    				viewRect = cc.rect(0,0,144,10), -- set loading bar rect
    				percent = self.Percent * 10, -- set loading bar percent
    		})
    		:pos(display.cx - 183, display.cy - 7)
    		:setScale(2.0)
    		:addTo(taskLayer)


    		-- 4. 开始按钮
    		local acceptBtnImages = {
				normal = "button/start_normal.png",
				pressed = "button/start_select.png",
			}

			cc.ui.UIPushButton.new(acceptBtnImages, {scale9 = false})
				:onButtonClicked(function(event)

					audio.playSound("sound/floop.mp3")

					audio.stopMusic(true)

					local mapScene = import("app.scenes.MapScene"):new()
					display.replaceScene(mapScene,"turnOffTiles",0.5)
				end)
				:align(display.CENTER,display.cx - 105, display. cy -200)
				:setScale(0.55)
				:addTo(taskLayer)

			-- 5. 休息按钮
			local refuseBtnImages = {
				normal = "button/rest_normal.png",
				pressed = "button/rest_select.png",
			}

			cc.ui.UIPushButton.new(refuseBtnImages, {scale9 = false})
				:onButtonClicked(function(event)

					audio.playSound("sound/floop.mp3")

					taskLayer:removeFromParent()
				end)
				:align(display.CENTER,display.cx + 105, display. cy -200)
				:setScale(0.55)
				:addTo(taskLayer)

		end)
		:align(display.CENTER,display.cx,0)
		:setScale(0.8)
		:addTo(self)
		:runAction(action_task)

	-- 7.选项按钮
	local moveTolocal moveTo_setting = cc.MoveTo:create(1, cc.p(display.cx,display.cy - 260))
    local action_setting = cc.Sequence:create(moveTo_setting)
	local settingBtnImages = {
		normal = "button/setting_normal.png",
		pressed = "button/setting_select.png",
	}

	cc.ui.UIPushButton.new(settingBtnImages, {scale9 = false})
		:onButtonClicked(function(event)

			audio.playSound("sound/floop.mp3")

			local settingLayer = display.newColorLayer(cc.c4b(0, 0, 0, 125)) 
			settingLayer:setTouchEnabled(true)
			settingLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
       			return true;
    		end)

			-- 1.背景图片
    		display.newSprite("Background/settingBg.png")
    			:pos(display.cx,display.cy)
    			:setScale(1.0)
    			:addTo(settingLayer)
    		self:addChild(settingLayer)

    		local PreMusicVolume = audio.getMusicVolume()
    		local PreSoundsVolume = audio.getSoundsVolume()

    		-- 2.音量调节条
			local MusicSliderImages = {
				bar = "button/progress.png",
				button = "button/SliderThumb.png",
			}
			musicSlider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, MusicSliderImages, {scale9 = true})
			musicSlider:align(display.CENTER, display.cx, display.cy + 50)
			musicSlider:setSliderValue(PreMusicVolume * 100)
			musicSlider:onSliderValueChanged(function(event)
				audio.setMusicVolume(musicSlider:getSliderValue() / 100)
			end)
			musicSlider:addTo(settingLayer)

			-- 3.音效调节条
			local SoundSliderImages = {
				bar = "button/progress.png",
				button = "button/SliderThumb2.png",
			}
			soundSlider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, SoundSliderImages, {scale9 = true})
			soundSlider:align(display.CENTER, display.cx, display.cy - 80)
			soundSlider:setSliderValue(PreSoundsVolume * 100)
			soundSlider:onSliderValueChanged(function(event)
				audio.setSoundsVolume(soundSlider:getSliderValue() / 100)
			end)
			soundSlider:addTo(settingLayer)

			-- 4.确认按钮
			local yesBtnImages = {
				normal = "button/yes_normal.png",
				pressed = "button/yes_select.png",
			}

			cc.ui.UIPushButton.new(yesBtnImages, {scale9 = false})
				:onButtonClicked(function(event)

					audio.playSound("sound/floop.mp3")

					settingLayer:removeFromParent()
				end)
				:align(display.CENTER,display.cx - 105, display. cy -200)
				:setScale(0.55)
				:addTo(settingLayer)

			-- 5.取消按钮
			local cancelBtnImages = {
				normal = "button/cancel_normal.png",
				pressed = "button/cancel_select.png",
			}

			cc.ui.UIPushButton.new(cancelBtnImages, {scale9 = false})
				:onButtonClicked(function(event)
					audio.playSound("sound/floop.mp3")

					audio.setMusicVolume(PreMusicVolume)
					audio.setSoundsVolume(PreSoundsVolume)
					settingLayer:removeFromParent()
				end)
				:align(display.CENTER,display.cx + 105, display. cy -200)
				:setScale(0.55)
				:addTo(settingLayer)
		end)
		:align(display.CENTER,display.cx,0)
		:setScale(0.8)
		:addTo(self) 
		:runAction(action_setting)

	-- 8.退出按钮
	local moveTolocal moveTo_quit = cc.MoveTo:create(1, cc.p(display.cx,display.cy - 360))
    local action_quit = cc.Sequence:create(moveTo_quit)
	local quitBtnImages = {
		normal = "button/quit_normal.png",
		pressed = "button/quit_select.png",
	}

	cc.ui.UIPushButton.new(quitBtnImages, {scale9 = false})
		:onButtonClicked(function(event)

			audio.playSound("sound/floop.mp3")

			-- os.exit()
			local quitLayer = display.newColorLayer(cc.c4b(0, 0, 0, 125)) 
			quitLayer:setTouchEnabled(true)
			quitLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
       			return true;
    		end)

    		-- 1.背景图片
    		display.newSprite("Background/exitBg.png")
    			:pos(display.cx,display.cy)
    			:setScale(1.0)
    			:addTo(quitLayer)
    		self:addChild(quitLayer)

    		-- 2.确认按钮
			local yesBtnImages = {
				normal = "button/yes_normal.png",
				pressed = "button/yes_select.png",
			}

			cc.ui.UIPushButton.new(yesBtnImages, {scale9 = false})
				:onButtonClicked(function(event)

					audio.playSound("sound/floop.mp3")

					-- audio.playSound("sound/scream.mp3")

					action = self:performWithDelay(function()
						os.exit()
					end, 0.5)
					
				end)
				:align(display.CENTER,display.cx - 105, display. cy -100)
				:setScale(0.55)
				:addTo(quitLayer)

			-- 3.取消按钮
			local cancelBtnImages = {
				normal = "button/cancel_normal.png",
				pressed = "button/cancel_select.png",
			}

			cc.ui.UIPushButton.new(cancelBtnImages, {scale9 = false})
				:onButtonClicked(function(event)

					audio.playSound("sound/floop.mp3")

					quitLayer:removeFromParent(true)
				end)
				:align(display.CENTER,display.cx + 105, display. cy -100)
				:setScale(0.55)
				:addTo(quitLayer)


		end)
		:align(display.CENTER,display.cx,0)
		:setScale(0.8)
		:addTo(self)
		:runAction(action_quit)
end

function MenuScene:onEnter()
end

function MenuScene:onExit()
end

return MenuScene
