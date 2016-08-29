FruitItem = import("app.scenes.FruitItem")
bullet = import("app.scenes.BulletItem")
Shoter = import("app.scenes.ShotItem")--local M_mons = self:Double_monister_shorter_OnAction("jiangshi2/zombie2.plist","jiangshi2/zombie2.png","tietong",14)
Monster = import("app.scenes.Monster")--以上都是调用
local PlayScene1 = class("PlayScene1", function()
	return display.newScene("PlayScene1")
end)

function PlayScene1:ctor()--这里需要完全复制我的
	self.jishuqi=1
	self.Percent = cc.UserDefault:getInstance():getIntegerForKey("Percent")
		-- init value
	self.highSorce = cc.UserDefault:getInstance():getIntegerForKey("HighScore") -- 最高分数
	self.stage = cc.UserDefault:getInstance():getIntegerForKey("Stage") -- 当前关卡
	if self.stage == 0 then self.stage = 1 end
	self.target =  100 -- 通关分数
	self.curSorce = 0 -- 当前分数
	self.xCount = 8 -- 水平方向水果数
	self.yCount = 8 -- 垂直方向水果数
	self.fruitXGap = -4 -- 水果X轴方向上的间距
	self.fruitYGap = 7 -- 水果Y轴方向上的间距
	self.scoreStart = 0 -- 水果基分
	self.scoreStep = 0 -- 加成分数
	self.activeScore = 0 -- 当前高亮的水果得分
	self.Count = 1 -- 周围存在能够被消除的水果数量
	self.size = 0 -- 记录前一个水果的index
	self.curX = 1 -- 当前水果X轴坐标
	self.curY = 1 -- 当前水果Y轴坐标
	self.bushu = 10
	--步数
	self.shanghai = 1.35--伤害
	self.activeScore_one=self.shanghai
	self:initUI()

	-- 初始化随机数
	math.newrandomseed()

	--  计算水果矩阵左下角的x、y坐标：以矩阵中点对齐屏幕中点来计算，然后再做Y轴修正。
	self.matrixLBX = (display.width - FruitItem.getWidth() * self.xCount - (self.yCount - 1) * self.fruitXGap) / 2 - 6
	self.matrixLBY = (display.height - FruitItem.getWidth() * self.yCount - (self.xCount - 1) * self.fruitYGap) / 2 - 180

	-- 等待转场特效结束后再加载矩阵
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
		if event.name == "enterTransitionFinish" then
			self:initMartix()
			self:jianting()
			self:WeiZhi_UIset() 
		end
	end)

	audio.playMusic("playmusic.mp3", true)
end
--其他我的文件全部替换，还有图片
function PlayScene1:move_run_bullent(zongbushu,zidanshu,shanghai,M_short,M_Monster)--发射炮弹和走路函数，新加在jianting里
	local size_x=display.right-60-display.left -60
	local  one_size=size_x/zongbushu
	local move_one_bu=cc.MoveTo:create(1,cc.p(M_Monster.position_x+one_size,M_Monster.position_y))--一步
	M_Monster:runAction(move_one_bu)
	M_Monster:setPosition(M_Monster.position_x+one_size,M_Monster.position_y)
	self:bullet_short(M_short,M_Monster,zidanshu,1,0,shanghai) -- 发射射手类，被攻击怪物类,子弹个数，子弹速度，子弹时间间隔，伤害量

	end
-- 僵尸豌豆操作
function PlayScene1:bullet_short( M_short,M_Monster,re_time,time,de_time_s,shanghai)--发射射手类，被攻击怪物类，子弹个数，子弹速度，每个子弹间隔时间的修正（默认1s）
  local i = 0
  Bullet_maix = {}
  repeat
     M_bullet = bullet.new()
     Bullet_maix[i] = M_bullet
     self:addChild(Bullet_maix[i])
     i = i + 1
    
  until i > (re_time - 1)
    j = 0
  repeat
 
    self:delay_bullet_short(j,M_short,M_Monster,re_time,time,de_time_s,shanghai)
   
    j = j + 1
  until j > (re_time-1)
   Bullent_maix = {}
end

function PlayScene1:delay_bullet_short(j,M_short,M_Monster,re_time,time,de_time_s ,shanghai)--内部调用函数函数
    local ac_run = Bullet_maix[j]:getrun(M_short,M_Monster,re_time,time,j,de_time_s,shanghai)   
    local c = time + j + de_time_s
    Bullet_maix[j]:runAction(ac_run)
  
end

--动画函数。plist文件名字，图片文件名字,数字之前的东西(daxie),
function PlayScene1:OnAction(plist_name,png_name,Str_bef_Shu)
  display.addSpriteFrames(plist_name, png_name)
  local on_a = Str_bef_Shu.."%d.png"
  local frames = display.newFrames(on_a,1,8)
  local animation = display.newAnimation(frames,0.1)
  local on_b = "#"..Str_bef_Shu.."1.png"
  sprite = display.newSprite(on_b)
    :pos(display.cx, display.cy)
    :addTo(self,10)
  sprite:playAnimationOne(animation,true, function ( )

  end, 0)
end--动画函数。plist文件名字，图片文件名字,数字之前的东西(daxie),

--建立僵尸和射手需要用到的类
function PlayScene1:Double_monister_shorter_OnAction( plist_name,png_name,Str_bef_Shu,number)
  display.addSpriteFrames(plist_name, png_name)
  local on_a = Str_bef_Shu.."%02d.png"
  local frames = display.newFrames(on_a,1,number)
  local animation = display.newAnimation(frames,0.1)
  local on_b = "#"..Str_bef_Shu.."01.png"
  sprite = display.newSprite(on_b)
  sprite:playAnimationForever(animation, false, function ( )

  end, 0)
  return sprite
end

function PlayScene1:WeiZhi_UIset(  )
   local M_shots = self:Double_monister_shorter_OnAction("wandou/wandoudou.plist","wandou/wandoudou.png","wandou0",6)
   M_short = Shoter.new(display.right - 60,display.top,M_shots)--初始化射手
        self:addChild(M_short)
  local M_mons = self:Double_monister_shorter_OnAction("jiangshi2/zombie2.plist","jiangshi2/zombie2.png","tietong",14)
Monster = import("app.scenes.Monster")--以上都是调用
   M_Monster = Monster.new(display.left + 60, display.top,M_mons)--初始化怪物
     self:addChild(M_Monster)
   
   local M_Monster_ACTION=cc.MoveTo:create(0.5, cc.p(M_Monster.position_x,M_Monster.position_y - 180))
   local M_short_ACTION=cc.MoveTo:create(0.5, cc.p(M_short.position_x,M_short.position_y - 200))
   M_Monster:runAction(M_Monster_ACTION)--运行动作
   M_short:runAction(M_short_ACTION) --运行动作
  
   M_short:set_Shoter_position(M_short.position_x,M_short.position_y - 200)
   M_Monster:setPosition(M_Monster.position_x,M_Monster.position_y - 180)
     
end

function PlayScene1:initUI()
	-- 背景图片
	display.newSprite("PlayScene2.png")
		:pos(display.cx, display.cy)
		:addTo(self)
	self.curSorceLabel = cc.ui.UILabel.new({UILabelType = 1, text = tostring(self.curSorce), font = "font/earth48.fnt"})
	:align(display.CENTER, display.cx, display.top - 150)
     :addTo(self)

          -- 选项按钮
    local optionImages = {
    	normal = "button/option_normal.png",
    	pressed = "button/option_select.png",
	}

	cc.ui.UIPushButton.new(optionImages, {scale9 = false})
		:onButtonClicked(function()
			
			audio.playSound("sound/floop.mp3")

			-- 选项层
			local optionLayer = display.newColorLayer(cc.c4b(0, 0, 0, 125)) 
			optionLayer:setTouchEnabled(true)
			optionLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
       			return true;
    		end)
			optionLayer:addTo(self)

			display.newSprite("Background/optionBg.png")
				:align(display.CENTER, display.cx, display.cy)
				:setScale(1.0)
				:addTo(optionLayer)

			-- 继续游戏按钮
			local continueGameImages = {
				normal = "button/continueGame_normal.png",
				pressed = "button/continueGame_select.png",
			}

			cc.ui.UIPushButton.new(continueGameImages, {scale9 = false})
				:onButtonClicked(function()

					audio.playSound("sound/floop.mp3")

					optionLayer:removeFromParent()

				end)
				:align(display.CENTER, display.cx, display.cy + 80)
				:setScale(0.6)
				:addTo(optionLayer)

			-- 任务进度按钮
			local taskPlayImages = {
				normal = "button/taskPlay_normal.png",
				pressed = "button/taskPlay_select.png",
			}

			cc.ui.UIPushButton.new(taskPlayImages, {scale9 = false})
				:onButtonClicked(function()

					audio.playSound("sound/floop.mp3")

					local taskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 125)) 
					taskLayer:setTouchEnabled(true)
					taskLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
       					return true;
    				end)

 					local taskLayer = display.newLayer() 
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

    				-- 4.返回按钮
    				local returnPlayImages = {
    					normal = "button/returnPlay_normal.png",
    					pressed = "button/returnPlay_select.png",
    				}

    				cc.ui.UIPushButton.new(returnPlayImages, {scale9 = false})
    					:onButtonClicked(function()

    						audio.playSound("sound/floop.mp3")

    						taskLayer:removeFromParent()
    					end)
    					:align(display.CENTER,display.cx, display. cy -200)
						:setScale(0.55)
						:addTo(taskLayer)
				end)
				:align(display.CENTER, display.cx, display.cy + 10)
				:setScale(0.6)
				:addTo(optionLayer)

			-- 重新开始按钮
			local restartImages = {
				normal = "button/restart_normal.png",
				pressed = "button/restart_select.png",
			}

			cc.ui.UIPushButton.new(restartImages, {scale9 = false})
				:onButtonClicked(function()

					audio.playSound("sound/floop.mp3")
					audio.playSound("sound/awooga.mp3")

					local playScene1 = import("app.scenes.PlayScene1"):new()
					display.replaceScene(playScene1, "flipX", 0.5)

				end)
				:align(display.CENTER, display.cx, display.cy - 60)
				:setScale(0.6)
				:addTo(optionLayer)

			-- 返回菜单按钮
			local returnImages = {
				normal = "button/return_normal.png",
				pressed = "button/return_select.png",
			}

			cc.ui.UIPushButton.new(returnImages, {scale9 =false})
				:onButtonClicked(function()
					audio.playSound("sound/floop.mp3")

					local mainScene = import("app.scenes.MainScene"):new()
					display.replaceScene(mainScene, "flipX", 0.5)
				end)
				:align(display.CENTER, display.cx, display.cy - 130)
				:setScale(0.6)
				:addTo(optionLayer)

			-- 退出游戏按钮
			local exitImages = {
				normal = "button/exit_normal.png",
				pressed = "button/exit_select.png",
			}

			cc.ui.UIPushButton.new(exitImages, {scale9 = false})
				:onButtonClicked(function()
					audio.playSound("sound/floop.mp3")

					action = self:performWithDelay(function()
						os.exit()
					end, 0.5)
				end)
				:align(display.CENTER, display.cx, display.cy - 200)
				:setScale(0.6)
				:addTo(optionLayer)
		end)
		:align(display.CENTER, display.right - 40, display.top - 40)
		:setScale(1.0)
		:addTo(self)

	local action_in = cc.FadeIn:create(1.5)
	local action_out = cc.FadeOut:create(1.5)
	local comeIn = display.newSprite("Background/comeIn.png")
	comeIn:align(display.CENTER, display.cx, display.cy + 200)
	comeIn:setOpacity(0)
	comeIn:setScale(0.5)
	local seq = cc.Sequence:create(action_in,action_out)
	comeIn:runAction(seq)
	comeIn:addTo(self)
	
	self:performWithDelay(function()

		comeIn:removeFromParent()
	end, 3)
     	
end



function PlayScene1:initMartix()
	-- 创建空矩阵
	self.matrix = {}
	-- 高亮水果
	self.actives = {}
	-- 维护的白色线段数组
	self.LinkLines = {}
	for y = 1, self.yCount do
		for x = 1, self.xCount do
			if 1 == y and 2 == x then
                -- 由于以下矩阵算法通过(y - 1) * self.xCount + x来存储x,y的值
                -- matrix[1]，可计算出x,y均为1,1，则可保证，(1,1)(2,1)坐标的水果相同
                -- 确保有可消除的水果
                self:createAndDropFruit(x, y, self.matrix[1].fruitIndex)
            else
                self:createAndDropFruit(x, y)
			end
		end
	end
end
function PlayScene1:jianting()
	-- 优化坐标计算
	local Index = {}
	local location = {}
	local plocation 
	for y = 1, self.yCount do
		for x = 1, self.xCount do
			plocation = self:positionOfFruit(x, y)
			local startPosition = cc.p(plocation.x - FruitItem.getWidth() / 2, 
				plocation.y - FruitItem.getHeight() / 2)
			local endPosition = cc.p(plocation.x + FruitItem.getWidth() / 2,
				plocation.y + FruitItem.getHeight() / 2)
			local temp = {startPosition,endPosition}
			table.insert(location,temp)
			local lp = cc.p(x,y)
			table.insert(Index,lp) -- 水果在矩阵中的位置映射到屏幕分辨率
		end
	end

	-- 绑定触摸事件
	self:checkIsAction(true)
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	local scheduler = require(cc.PACKAGE_NAME..".scheduler")
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
		bool = false
		local fruit = nil
		local p
		local flag = 0
		for count = 1, self.yCount * self.xCount do
			if event.x > location[count][1].x and event.x < location[count][2].x
				and event.y > location[count][1].y and event.y < location[count][2].y then
				fruit = self.matrix[(Index[count].y - 1) * self.xCount + Index[count].x]
				self.x = Index[count].x
				self.y = Index[count].y
				flag = 1
				break
			else
				self.x = 0
				self.y = 0
			end
		end

		if #self.actives == 2 then
			self:clear_flag(self.actives[1]) --当第一个水果不是最后一个水果的时候清楚其周边的标记
			self.size = 1
			self:checkIsLast(self.actives[2])
		end
	
		if event.name == "moved" then
			--判断高亮table中是否有重复对象，保证每个水果对象不重复
			if self.x ~= 0 and self.y ~= 0 then
				for _, pfruit in pairs(self.actives) do
					if pfruit == fruit then
					--如果重复返回true
					bool = true
						break
					end
				end

				if bool == false and fruit.fruitIndex == self.actives[1].fruitIndex 
					and self:checkActive(fruit) == true and fruit.flag_last == 1 then
					if fruit.isSpecial == true then
						self:SpecialFruitBoom(fruit)
					end
					self.size = #self.actives
					table.insert(self.actives, fruit)
					self:LinkLine()
					fruit:setActive(true)--选中的水果本身变为高亮
					self:clear_flag(self.actives[self.size])
					self:checkIsLast(self.actives[#self.actives])--标记最后一个水果对象周围的可行域
				end
				self:backTo(self.x, self.y)
			end
		end

		if event.name == "ended" then
			--初始化数据
			self.size = 0
			self:clear_all() 
			if #self.actives then
				local musicIndex = #self.actives
				if musicIndex < 2 then
					musicIndex = 2
				end

				if musicIndex >= 10 then
					self.Percent = self.Percent + 1
					if self.Percent > 10 then
						self.Percent = 0
					end
					cc.UserDefault:getInstance():setIntegerForKey("Percent", self.Percent)
				end

				if musicIndex > 7 then
					musicIndex = 7
				end

				local tmpStr = string.format("sound/broken%d.mp3", musicIndex)
				audio.playSound(tmpStr)
			end
			if #self.actives >= 3 then
				--todo
				
				local sum = #self.actives
				
				local tempFruit = self.actives[1].fruitIndex
			
			
				local temp = 0
				if self.specialFruit ~= nil and #self.specialFruit ~= 0 then

					temp = #self.specialFruit
					for _,pfruit in pairs(self.specialFruit) do
						if pfruit.isSpecial == true and pfruit.fruitIndex == fruit.fruitIndex then
							self:SpecialEffects(pfruit)
						end
					end
				end
				self:removeActivedFruits()
				self:dropFruits(sum,tempFruit,temp)
					self:move_run_bullent(self.bushu,ji,self.shanghai,M_short,M_Monster)
				self:inactive()
				self:checkNextStage()
				self:ClearAllLine()
				self.jishuqi=self.jishuqi+1

			else
				self:inactive()
				self:ClearAllLine()
			end
			
			self:FadeFocuse()
		end
		if event.name == "began" then
			--todo
			if #self.actives == 0 then
				--todo
				if fruit ~= nil then
					table.insert(self.actives, fruit)
					self:checkIsLast(self.actives[1])--标记第一个水果对象的可行域

					self:FruitGetFocuse(fruit)
					fruit:setActive(true)--选中的水果本身变为高亮
					if fruit.isSpecial == true then

						self:SpecialFruitBoom(fruit)
					end
				end

			end
			return true
		end
	end)
end
--特效水果消除方法
function PlayScene1:SpecialFruitBoom(fruit)
	self.specialFruit = {} -- 特殊的水果消除的数组
	
	if  fruit.fruitIndex == 4 then -- 太阳花元素，行元素全部加入特殊水果消除数组 粒子火焰特效
		for x = 1,self.xCount do
			local temp = self.matrix[(fruit.y - 1) * self.xCount + x]
			temp:setActive(true) 
			table.insert(self.specialFruit, temp)
		end
	end
	if fruit.fruitIndex == 1 then -- 蘑菇元素，纵元素全部加入特殊水果消除数组 闪电特效
		for y = 1, self.yCount do
			local temp = self.matrix[(y - 1) * self.xCount + fruit.x]
			temp:setActive(true) 
			table.insert(self.specialFruit, temp)
		end
		--mogu:removeFromParent()
	end
	if fruit.fruitIndex == 2 then -- 苹果元素，半径为2的元素十字型消除 烂特效

		for x = fruit.x - 2, fruit.x + 2 do
			if x >= 1 and x <= self.xCount then				
				local temp = self.matrix[(fruit.y - 1) * self.xCount + x]
				temp:setActive(true)
				table.insert(self.specialFruit, temp)
			end
		end
		for y = fruit.y - 2, fruit.y + 2 do
			if y >= 1 and y <= self.yCount then
				local temp = self.matrix[(y - 1) * self.xCount + fruit.x]
				temp:setActive(true)
				if temp ~= fruit then
					table.insert(self.specialFruit, temp)
				end
			end
		end
	end
	if fruit.fruitIndex == 3 then  --坚果 泥土特效
		for y = 1, self.yCount do
			for x = 1, self.xCount do
				local temp = self.matrix[(y - 1) * self.xCount + x]
				if temp.fruitIndex == 3 then
					temp:setActive(true)
					table.insert(self.specialFruit,temp)
				end
			end	
		end
	end
	if fruit.fruitIndex == 5 then -- 竹笋，黑洞特效
		for y = fruit.y - 1, fruit.y + 1 do
			for x = fruit.x - 1, fruit.x + 1 do
				if y >= 1 and y <= self.yCount
				  and x >= 1 and x <= self.xCount then
					local temp = self.matrix[(y - 1) * self.xCount + x]
					temp:setActive(true)
					table.insert(self.specialFruit, temp)
				end
			end
		end
	end
end

-- 特效
function PlayScene1:SpecialEffects(fruit)
	if fruit and fruit.isSpecial == true then
		if fruit.fruitIndex == 1 then
			audio.playSound("shockthuder.mp3")
			local mogu = display.newSprite("#mogu.png")
			local p = self:positionOfFruit(fruit.x, fruit.y)
			mogu:align(display.CENTER, p.x + 5, 400)
			mogu:addTo(self,25)
			mogu:setScale(1.1)
			local scaleTo1 = cc.ScaleTo:create(0.1,1.2)
			local scaleTo2 = cc.ScaleTo:create(0.1, 1)
			mogu:runAction(cc.Sequence:create(scaleTo1,scaleTo2))
			local action_out = cc.FadeOut:create(0.3)
			mogu:runAction(action_out)
			local scheduler = require(cc.PACKAGE_NAME..".scheduler")
				
			local function onInterval()
				mogu:removeFromParent()
			end

			scheduler.performWithDelayGlobal(onInterval, 0.5)
		end
		if fruit.fruitIndex == 2 then
			audio.playSound("redApple.mp3")
			local SpecialEffectsTable = {}
			for _,pfruit in pairs(self.specialFruit) do
				local redApple = display.newSprite("#hongpingguo.png")
				redApple:setScale(1.2)
				local p = self:positionOfFruit(pfruit.x, pfruit.y)
				redApple:align(display.CENTER, p.x, p.y)
				redApple:addTo(self,25)
				redApple:setScale(1.1)
				local scaleTo1 = cc.ScaleTo:create(0.8,1.4)
				local scaleTo2 = cc.ScaleTo:create(0.8, 1)
				redApple:runAction(cc.Sequence:create(scaleTo1,scaleTo2))
				local action_out = cc.FadeOut:create(0.8)
				redApple:runAction(action_out)
				table.insert(SpecialEffectsTable, redApple)
			end
			local scheduler = require(cc.PACKAGE_NAME..".scheduler")
			local function onInterval()
				for _, se in pairs(SpecialEffectsTable) do
					se:removeFromParent()
				end
			end
			scheduler.performWithDelayGlobal(onInterval, 0.8)
		end
		if fruit.fruitIndex == 3 then
			audio.playSound("jianguo.mp3")
			local SpecialEffectsTable = {}
			for _,pfruit in pairs(self.specialFruit) do
				local earth = display.newSprite("#tu-1.png")
				earth:setScale(1.2)
				local p = self:positionOfFruit(pfruit.x, pfruit.y)
				earth:align(display.CENTER, p.x, p.y)
				earth:addTo(self,25)
				earth:setScale(1.1)
				local scaleTo1 = cc.ScaleTo:create(0.8,1.4)
				local scaleTo2 = cc.ScaleTo:create(0.8, 1)
				earth:runAction(cc.Sequence:create(scaleTo1,scaleTo2))
				local action_out = cc.FadeOut:create(0.8)
				earth:runAction(action_out)
				table.insert(SpecialEffectsTable, earth)
			end
			local scheduler = require(cc.PACKAGE_NAME..".scheduler")
			local function onInterval()
				for _, se in pairs(SpecialEffectsTable) do
					se:removeFromParent()
				end
			end
			scheduler.performWithDelayGlobal(onInterval, 0.8)
		end
		if fruit.fruitIndex == 4 then
			audio.playSound("shockthuder.mp3")
			local sunFlower = display.newSprite("#taiyanghua.png")
			local p = self:positionOfFruit(fruit.x, fruit.y)
			sunFlower:align(display.CENTER, 320, p.y)
			sunFlower:addTo(self,25)
			sunFlower:setScale(0.9)
			local scaleTo1 = cc.ScaleTo:create(0.1,1)
			local scaleTo2 = cc.ScaleTo:create(0.1, 0.8)
			sunFlower:runAction(cc.Sequence:create(scaleTo1,scaleTo2))
			local action_out = cc.FadeOut:create(0.3)
			sunFlower:runAction(action_out)
			local scheduler = require(cc.PACKAGE_NAME..".scheduler")
				
			local function onInterval()
				sunFlower:removeFromParent()
			end

			scheduler.performWithDelayGlobal(onInterval, 0.3)
		end
		if fruit.fruitIndex == 5 then
			audio.playSound("blackhole.mp3")
			local blackHole = display.newSprite("#zhusun.png")
			local p = self:positionOfFruit(fruit.x, fruit.y)
			blackHole:align(display.CENTER, p.x, p.y)
			blackHole:addTo(self,25)
			local action = cc.RotateTo:create(1,100000)
			blackHole:runAction(action)
			local action_out = cc.FadeOut:create(0.8)
			blackHole:runAction(action_out)
			local scheduler = require(cc.PACKAGE_NAME..".scheduler")
			local function onInterval()
				blackHole:removeFromParent()
			end
			scheduler.performWithDelayGlobal(onInterval, 0.8)
		end
	end
end
-- 检查是否有动画
function PlayScene1:checkIsAction(isAnimationing)
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)   
		if isAnimationing == true then
			isAnimationing = false
			for y = 1,self.yCount do
				for x = 1,self.xCount do
					temp = self.matrix[(y - 1) * self.xCount + x]
					if temp and temp:getNumberOfRunningActions() > 0 then
						isAnimationing = true
						self:setTouchEnabled(false)
					end
				end
			end
		else
			self:setTouchEnabled(true)
			self:unscheduleUpdate()
		end
	end)
	self:scheduleUpdate()
end


-- 连线数组的维护
function PlayScene1:LinkLine()
	-- 连线
	local fruit = self.actives[self.size]
	local fruit_last = self.actives[#self.actives]
	local p_from = self:positionOfFruit(fruit.x,fruit.y)
	local p_to = self:positionOfFruit(fruit_last.x, fruit_last.y)
	local whiteLine = display.newLine({{p_from.x,p_from.y},{p_to.x,p_to.y}},
		{borderColor = cc.c4f(1.0, 1.0, 1.0, 0.5),
		borderWidth = 8})
	whiteLine:addTo(self,10)
	table.insert(self.LinkLines,whiteLine)
	audio.playSound("LinkLine.mp3")
end
-- 选中水果,其他不同水果变为透明效果
function PlayScene1:FruitGetFocuse(fruit)
	for y = 1,self.yCount do
		for x = 1,self.xCount do
			local el_fruit = self.matrix[(y - 1) * self.xCount + x]
			if el_fruit.fruitIndex ~= fruit.fruitIndex then
				el_fruit:setFocuse(false)
			end
		end
	end
end
-- 恢复水果的透明效果
function PlayScene1:FadeFocuse()
	for y = 1, self.yCount do
		for x = 1, self.xCount do
			local el_fruit = self.matrix[(y - 1) * self.xCount + x]
			el_fruit:setFocuse(true)
		end
	end
end
-- 清楚回退的线段
function PlayScene1:ClearLine(whiteLine)
	whiteLine:removeFromParent()
	table.remove(self.LinkLines,#self.LinkLines)
end
-- 消除完成后清除所有线段
function PlayScene1:ClearAllLine()
	-- 清除连线
	for _, whiteLine in pairs(self.LinkLines) do
		whiteLine:removeFromParent()
	end
	self.LinkLines = {}
end	
function PlayScene1:createAndDropFruit(x, y)
    local newFruit = FruitItem.new(x, y, fruitIndex)--获取每个水果对象
    local endPosition = self:positionOfFruit(x, y)--设置每个水果对象的最终位置，即矩阵的最终排列
    local startPosition = cc.p(endPosition.x, endPosition.y + display.height / 2)
    newFruit:setPosition(startPosition)--设置每个水果的最初位置（从屏幕二分之一开始一直到屏幕最上方）
    local speed = startPosition.y / (2 * display.height)--定义每个水果落下的速度
    newFruit:runAction(cc.MoveTo:create(speed, endPosition))--运行动作
    self.matrix[(y - 1) * self.xCount + x] = newFruit--类比解决了hash冲突的算法，存储x,y
    self:addChild(newFruit)
end
	
--以下矩阵为消除得分矩阵
function PlayScene1:removeActivedFruits()
	local fruitScore = self.scoreStart
	for _, fruit in pairs(self.actives) do
		if (fruit) then--高亮水果消除
			-- 从矩阵中移除
			self.matrix[(fruit.y - 1) * self.xCount + fruit.x] = nil
			local time = 0.3;--释放时间
			-- 爆炸圈
			local circleSprite = display.newSprite("circle.png")--加载圈圈的图片
				:pos(fruit:getPosition())--圈圈的位置
				:addTo(self)
			circleSprite:setScale(1)
			circleSprite:runAction(cc.Sequence:create(cc.ScaleTo:create(time, 1.0),
					cc.CallFunc:create(function() circleSprite:removeFromParent() end)))
			
			-- 爆炸碎片
			local emitter = cc.ParticleSystemQuad:create("stars.plist")
			emitter:setPosition(fruit:getPosition())
			local batch = cc.ParticleBatchNode:createWithTexture(emitter:getTexture())
			batch:addChild(emitter)
			self:addChild(batch)

			-- 分数特效
			
			fruitScore = fruitScore 

			-- 移除水果
			local count = 1
			if self.specialFruit ~= nil then
				for _, pfruit in pairs(self.specialFruit) do
					if fruit == pfruit then
						count = 0
					end
				end
				if count == 1 then -- 与高亮数组中没有相同的元素
					fruit:removeFromParent()
				end
			else
				fruit:removeFromParent()
			end	
		end
	end
		--特效消除数组

	if self.specialFruit ~= nil and #self.specialFruit ~= 0 then
		for _, fruit in pairs(self.specialFruit) do
			if (fruit) then--高亮水果消除
				-- 从矩阵中移除
				self.matrix[(fruit.y - 1) * self.xCount + fruit.x] = nil
				local time = 0.3;--释放时间
				-- 爆炸圈
				local circleSprite = display.newSprite("circle.png")--加载圈圈的图片
					:pos(fruit:getPosition())--圈圈的位置
					:addTo(self)
				circleSprite:setScale(1)
				circleSprite:runAction(cc.Sequence:create(cc.ScaleTo:create(time, 1.0),
						cc.CallFunc:create(function() circleSprite:removeFromParent() end)))
				
				-- 爆炸碎片
				local emitter = cc.ParticleSystemQuad:create("stars.plist")
				emitter:setPosition(fruit:getPosition())
				local batch = cc.ParticleBatchNode:createWithTexture(emitter:getTexture())
				batch:addChild(emitter)
				self:addChild(batch)


				fruit:removeFromParent()
			end
		end
	end

end

function PlayScene1:checkNextStage()
	if self.curSorce < self.target then
		if self.jishuqi==self.bushu then

------------------------------------------------------
		-- -- resultLayer 半透明展示信息
		local resultLayer = display.newColorLayer(cc.c4b(0,0,0,150))
		resultLayer:addTo(self,10)
		-- then--高亮水果消除吞噬事件
		resultLayer:setTouchEnabled(true)
		resultLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if event.name == "began" then
				return true
			end
		end)


	-- display.newSprite("lose.png")
	-- 	:pos(display.cx,display.cy + 90)
	-- 	:addTo(resultLayer,8)

	 -- 失败信息
	audio.playSound("sound/scream.mp3")
	display.newSprite("chininaozi.png")
		:setScale(0.7)
		:pos(display.cx,display.cy + 100)
		:addTo(resultLayer)

	-- 失败信息
	-- display.newSprite("lose.png")
	-- 	:pos(display.cx,display.cy + 90)
	-- 	:setScale(0.8)
	-- 	:addTo(resultLayer,8)

	-- display.newBMFontLabel({text = "\n最后得分："..self.highSorce,font = "font/resultW.fnt"})
	--  	:pos(display.cx, display.cy + 100)
	--  	:addTo(resultLayer,8)
		
	-- 开始按钮
	local restartImages = {
		normal = "button/restart_normal.png",
		pressed = "button/restart_select.png",
	}

    cc.ui.UIPushButton.new(restartImages, {scale9 = false})
		:onButtonClicked(function(event)
			audio.stopMusic()
			audio.playSound("sound/floop.mp3")
			audio.playSound("sound/awooga.mp3")

			local mainScene = import("app.scenes.PlayScene1"):new()
			display.replaceScene(mainScene, "flipX", 0.5)
		end)
		:align(display.CENTER, display.cx - 100, display.cy - 100)
		:setScale(0.5)
		:setLocalZOrder(1)
		:addTo(resultLayer)	
		
	-- 返回按钮
	local returnBtnImages = {
		normal = "button/return_normal.png",
		pressed = "button/return_select.png",
	}
    cc.ui.UIPushButton.new(returnBtnImages, {scale9 = false})
		:onButtonClicked(function(event)
			audio.stopMusic()
			audio.playSound("sound/floop.mp3")

			local mainScene = import("app.scenes.MainScene"):new()
			display.replaceScene(mainScene, "flipX", 0.5)
		end)
		:align(display.CENTER, display.cx + 100, display.cy - 100)
		:setScale(0.5)
		:setLocalZOrder(1)
		:addTo(resultLayer,8)	
		self.jishuqi=1

--------------------------------------------------
		end
	
		return
	end

	audio.playSound("music/wow.mp3")
	-- resultLayer 半透明展示信息
	local resultLayer = display.newColorLayer(cc.c4b(0,0,0,150))
	resultLayer:addTo(self,10)
	-- 吞噬事件
	resultLayer:setTouchEnabled(true)
	resultLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			return true
		end
	end)

	-- 更新数据
	if self.curSorce >= self.highSorce then
		self.highSorce = self.curSorce
	end
	
	-- 存储到文件
	cc.UserDefault:getInstance():setIntegerForKey("HighScore", self.highSorce)
	cc.UserDefault:getInstance():setIntegerForKey("Stage", self.stage)

	display.newSprite("victory.png")
		:pos(display.cx,display.cy + 90)
		:setLocalZOrder(0)
		:addTo(resultLayer)
	--通关信息
	display.newBMFontLabel({text = "\n最高得分：".. self.highSorce,font ="font/resultB.fnt"})
		:pos(display.cx, display.cy + 100)
		:setLocalZOrder(1)
		:addTo(resultLayer)
	
	-- 开始按钮
	local startBtnImages = {
		normal = "button/continue_normal.png",
		pressed = "button/continue_select.png",
	}

    cc.ui.UIPushButton.new(startBtnImages, {scale9 = false})
		:onButtonClicked(function(event)
			audio.stopMusic()
			audio.playSound("sound/floop.mp3")

			local mainScene = import("app.scenes.PlayScene2"):new()
			display.replaceScene(mainScene, "flipX", 0.5)
		end)
		:align(display.CENTER, display.cx - 100, display.cy - 50)
		:setScale(0.5)
		:setLocalZOrder(1)
		:addTo(resultLayer)	

	local returnBtnImages = {
		normal = "button/return_normal.png",
		pressed = "button/return_select.png",
	}

	cc.ui.UIPushButton.new(returnBtnImages, {scale9 = false})
		:onButtonClicked(function(event)
			audio.stopMusic()
			audio.playSound("sound/floop.mp3")

			local mainScene = import("app.scenes.MainScene"):new()
			display.replaceScene(mainScene, "flipX", 0.5)
		end)
		:align(display.CENTER, display.cx + 100, display.cy - 50)
		:setScale(0.5)
		:setLocalZOrder(1)
		:addTo(resultLayer,8)	
end

function PlayScene1:dropFruits(SumFruit,fruitIndex,isSpecialDrop)
	local emptyInfo = {}
	 ji=0

	-- 1. 掉落已存在的水果
	-- 一列一列的处理
	for x = 1, self.xCount do
		local removedFruits = 0
		local newY = 0
		-- 从下往上处理
		for y = 1, self.yCount do
			local temp = self.matrix[(y - 1) * self.xCount + x]
			if temp == nil then
				-- 水果已被移除
				removedFruits = removedFruits + 1
			else
				-- 如果水果下有空缺，向下移动空缺个位置
				if removedFruits > 0 then
					newY = y - removedFruits
					self.matrix[(newY - 1) * self.xCount + x] = temp
					temp.y = newY
					self.matrix[(y - 1) * self.xCount + x] = nil

					local endPosition = self:positionOfFruit(x, newY)
					local speed = (temp:getPositionY() - endPosition.y) / display.height
					temp:stopAllActions() --停止之前的动画
					temp:runAction(cc.MoveTo:create(speed, endPosition))
				end
			end
		end
		-- 纪录本列最终空缺数
		emptyInfo[x] = removedFruits
		
		 ji=ji+removedFruits
		
		self:checkIsAction(true)
	end

	-- 2. 掉落新水果补齐空缺
	local location = {}
	for x = 1,self.xCount do
		for y = self.yCount - emptyInfo[x] + 1, self.yCount do
			table.insert(location, cc.p(x,y))
			
		
		end
	end




	-- 清空高亮水果分数统计
	
	self.activeScore = 0
	local randNum = math.round(math.random() * 1000) % #location + 1
	if SumFruit >= 5 and isSpecialDrop == 0 then -- 不是特效消除的才会落下特效水果

		local newFruit = FruitItem.new(location[randNum].x,location[randNum].y,fruitIndex)
		newFruit:setSpecial(true)
		local endPosition = self:positionOfFruit(location[randNum].x, location[randNum].y)
		local startPosition = cc.p(endPosition.x, endPosition.y + display.height / 2)
		newFruit:setPosition(startPosition)
		local speed = startPosition.y / (2 * display.height)
		newFruit:runAction(cc.MoveTo:create(speed, endPosition))
		self.matrix[(location[randNum].y - 1) * self.xCount + location[randNum].x] = newFruit
		local temp = self.matrix[(location[randNum].y - 1) * self.xCount + location[randNum].x]
		self:addChild(newFruit)
	end

	for x = 1, self.xCount do
		for y = self.yCount - emptyInfo[x] + 1, self.yCount do
			if SumFruit >= 5 and isSpecialDrop == 0 then
				if location[randNum].x == x and location[randNum].y == y then
					
				else
					self:createAndDropFruit(x, y)
				end
			else
				self:createAndDropFruit(x, y)
			end

		end
	end
	self:showActivesScore(ji)
	
		 
	-- 清空高亮数组
	self.actives = {}
	-- 清空特殊消除数组
	self.specialFruit = {}
	-- 更新当前得分
	self.curSorce = self.curSorce + self.activeScore
	self.curSorceLabel:setString(tostring(self.curSorce))
end

function PlayScene1:positionOfFruit(x, y)
    local px = self.matrixLBX + (FruitItem.getWidth() + self.fruitXGap) * (x - 1) + FruitItem.getWidth() / 2
    local py = self.matrixLBY + (FruitItem.getWidth() + self.fruitYGap) * (y - 1) + FruitItem.getWidth() / 2
    return cc.p(px, py)
end
-- 清除所有对象标记
function PlayScene1:clear_all()
	for y = 1,self.yCount do
		for x = 1, self.xCount do
			local fruit = self.matrix[(y - 1)*self.xCount + 1]
			fruit.flag = 0
			fruit.flag_last = 0
		end
	end
end
-- x,y为当前水果对象的坐标，fruit为actives表中最后一个水果对象的
function PlayScene1:backTo(x,y)
	local fruit = self.matrix[(y - 1) * self.xCount + x]
	if fruit == self.actives[self.size] then
		self.actives[#self.actives]:setActive(false)
		self:clear_flag(self.actives[#self.actives])
		if self.actives[#self.actives].isSpecial == true then
			self:inSpecialFruiteActive()
		end
		table.remove(self.actives,#self.actives)
		self:checkIsLast(self.actives[self.size])
		self.size = self.size - 1
		self:ClearLine(self.LinkLines[#self.LinkLines])
		audio.playSound("LinkLine.mp3")
	end
end

-- 当前水果对象非最后一个水果对象时，清楚标记
function PlayScene1:clear_flag(fruit)
	--清楚左边标记
	if (fruit.x - 1) >= 1 then
		local leftNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x - 1]
		if (leftNeighbor.fruitIndex == fruit.fruitIndex) then
			leftNeighbor.flag_last = 0
		end
	end

	-- 检查fruit右边的水果
	if (fruit.x + 1) <= self.xCount then
		local rightNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x + 1]
		if (rightNeighbor.fruitIndex == fruit.fruitIndex) then
			rightNeighbor.flag_last = 0
		end
	end

	-- 检查fruit上边的水果
	if (fruit.y + 1) <= self.yCount then
		local upNeighbor = self.matrix[fruit.y * self.xCount + fruit.x]
		if (upNeighbor.fruitIndex == fruit.fruitIndex) then
			upNeighbor.flag_last = 0
		end
	end

	-- 检查fruit下边的水果
	if (fruit.y - 1) >= 1 then
		local downNeighbor = self.matrix[(fruit.y - 2) * self.xCount + fruit.x]
		if (downNeighbor.fruitIndex == fruit.fruitIndex) then
			downNeighbor.flag_last = 0
		end
	end
	--fruit = self.matrix[(y - 1) * self.xCount + x]
	--检查fruit左上的水果
	if(fruit.y + 1) <= self.yCount and (fruit.x - 1) >= 1 then
		local leftUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x - 1]
		if (leftUpNeighbor.fruitIndex == fruit.fruitIndex) then
			leftUpNeighbor.flag_last = 0
		end	
	end
	--检查fruit左下的水果
	if (fruit.y - 1) >= 1 and (fruit.x - 1) >= 1 then
		--todo
		local leftDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x - 1]
		if (leftDownNeighbor.fruitIndex == fruit.fruitIndex) then
			leftDownNeighbor.flag_last = 0
		end
	end
	--检查fruit右上的水果
	if (fruit.y + 1) <= self.yCount and (fruit.x + 1) <= self.xCount then
		--todo
		local rightUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x + 1]
		if (rightUpNeighbor.fruitIndex == fruit.fruitIndex) then
			rightUpNeighbor.flag_last = 0
		end
	end
	--检查fruit右下的水果
	if (fruit.y - 1) >= 1 and (fruit.x + 1) <= self.xCount then
		--todo
		local rightDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x + 1]
		if (rightDownNeighbor.fruitIndex == fruit.fruitIndex) then			
			rightDownNeighbor.flag_last = 0
		end
	end	
end
-- 检查是否连接着高亮数组中最后一个水果，解决分叉后有且仅能选择一边的问题
function PlayScene1:checkIsLast(fruit)
	--检查左边的水果
	if (fruit.x - 1) >= 1 then
		local leftNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x - 1]
		if (leftNeighbor.fruitIndex == fruit.fruitIndex) then
			leftNeighbor.flag_last = 1
		end
	end


	-- 检查fruit右边的水果
	if (fruit.x + 1) <= self.xCount then
		local rightNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x + 1]
		if (rightNeighbor.fruitIndex == fruit.fruitIndex) then
			rightNeighbor.flag_last = 1
		end
	end

	-- 检查fruit上边的水果
	if (fruit.y + 1) <= self.yCount then
		local upNeighbor = self.matrix[fruit.y * self.xCount + fruit.x]
		if (upNeighbor.fruitIndex == fruit.fruitIndex) then
			upNeighbor.flag_last = 1
		end
	end

	-- 检查fruit下边的水果
	if (fruit.y - 1) >= 1 then
		local downNeighbor = self.matrix[(fruit.y - 2) * self.xCount + fruit.x]
		if (downNeighbor.fruitIndex == fruit.fruitIndex) then
			downNeighbor.flag_last = 1
		end
	end
	--fruit = self.matrix[(y - 1) * self.xCount + x]
	--检查fruit左上的水果
	if(fruit.y + 1) <= self.yCount and (fruit.x - 1) >= 1 then
		local leftUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x - 1]
		if (leftUpNeighbor.fruitIndex == fruit.fruitIndex) then
			leftUpNeighbor.flag_last = 1
		end	
	end
	--检查fruit左下的水果
	if (fruit.y - 1) >= 1 and (fruit.x - 1) >= 1 then
		--todo
		local leftDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x - 1]
		if (leftDownNeighbor.fruitIndex == fruit.fruitIndex) then
			leftDownNeighbor.flag_last = 1
		end
	end
	--检查fruit右上的水果
	if (fruit.y + 1) <= self.yCount and (fruit.x + 1) <= self.xCount then
		--todo
		local rightUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x + 1]
		if (rightUpNeighbor.fruitIndex == fruit.fruitIndex) then
			rightUpNeighbor.flag_last = 1
		end
	end
	--检查fruit右下的水果
	if (fruit.y - 1) >= 1 and (fruit.x + 1) <= self.xCount then
		--todo
		local rightDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x + 1]
		if (rightDownNeighbor.fruitIndex == fruit.fruitIndex) then			
			rightDownNeighbor.flag_last = 1
		end
	end	
end
--判断游戏是否还能继续
function PlayScene1:checkIsContinue()
	for y=1,self.yCount do
		for x=1,self.xCount do
			fruit = self.matrix[(y - 1)*self.xCount + x]
			if self:checkFruitSum(fruit) == false then
				self.Count = 1
				return false
			end
		end
	end
	self.Count = 1
	return true
end
--fruit = self.matrix[(y - 1) * self.xCount + x]
-- 判断一个水果对象附近能存在多少个相同的水果
-- 3个以上能玩儿，返回false
-- 3个以下不能玩儿，返回true
function PlayScene1:checkFruitSum(fruit)
	-- body
	if self:checkThree() == false then
		return false
	end
	-- 检查fruit左边的水果
	if (fruit.x - 1) >= 1 then
		local leftNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x - 1]
		if (leftNeighbor.fruitIndex == fruit.fruitIndex) and self.Count < 3 then
			self.Count = self.Count + 1
			self:activeNeighbor(leftNeighbor)
		end
	end


	-- 检查fruit右边的水果
	if (fruit.x + 1) <= self.xCount then
		local rightNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x + 1]
		if (self.Count < 3) and (rightNeighbor.fruitIndex == fruit.fruitIndex) then
			self.Count = self.Count + 1
			self:activeNeighbor(rightNeighbor)
		end
	end

	-- 检查fruit上边的水果
	if (fruit.y + 1) <= self.yCount then
		local upNeighbor = self.matrix[fruit.y * self.xCount + fruit.x]
		if (self.Count < 3) and (upNeighbor.fruitIndex == fruit.fruitIndex) then
			self.Count = self.Count + 1
			self:activeNeighbor(upNeighbor)
		end
	end

	-- 检查fruit下边的水果
	if (fruit.y - 1) >= 1 then
		local downNeighbor = self.matrix[(fruit.y - 2) * self.xCount + fruit.x]
		if (self.Count < 3) and (downNeighbor.fruitIndex == fruit.fruitIndex) then
			self.Count = self.Count + 1
			self:activeNeighbor(downNeighbor)
		end
	end
	--fruit = self.matrix[(y - 1) * self.xCount + x]
	--检查fruit左上的水果
	if(fruit.y + 1) <= self.yCount and (fruit.x - 1) >= 1 then
		local leftUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x - 1]
		if(self.Count < 3) and (leftUpNeighbor.fruitIndex == fruit.fruitIndex) then
			self.Count = self.Count + 1
			self:activeNeighbor(leftUpNeighbor)
		end	
	end
	--检查fruit左下的水果
	if (fruit.y - 1) >= 1 and (fruit.x - 1) >= 1 then
		--todo
		local leftDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x - 1]
		if(self.Count < 3) and (leftDownNeighbor.fruitIndex == fruit.fruitIndex) then
			self.Count = self.Count + 1
			self:activeNeighbor(leftDownNeighbor)
		end
	end
	--检查fruit右上的水果
	if (fruit.y + 1) <= self.yCount and (fruit.x + 1) <= self.xCount then
		--todo
		local rightUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x + 1]
		if(self.Count < 3) and (rightUpNeighbor.fruitIndex == fruit.fruitIndex) then
			self.Count = self.Count + 1
			self:activeNeighbor(rightUpNeighbor)
		end
	end
	--检查fruit右下的水果
	if (fruit.y - 1) >= 1 and (fruit.x + 1) <= self.xCount then
		--todo
		local rightDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x + 1]
		if(self.Count < 3) and (rightDownNeighbor.fruitIndex == fruit.fruitIndex) then			
			self.Count = self.Count + 1
			self:activeNeighbor(rightDownNeighbor)
		end
	end
	if self:checkThree() == false then
		--todo
		return false
	else
		return true
	end
end

-- 3个以上能玩儿，返回false
-- 3个以下不能玩儿，返回true
function PlayScene1:checkThree()
	if self.Count >= 3 then
		return false
	else
		return true
	end
end

--检查fruit周边八个水果是否有高亮水果
function PlayScene1:checkActive(fruit)
	-- 检查fruit左边的水果是否有高亮
	if (fruit.x - 1) >= 1 then
		local leftNeighbor = self.matrix[(fruit.y - 1)*self.xCount + fruit.x - 1]
		if leftNeighbor.isActive == true then
			--todo
			return true
		end
	end
	-- 检查fruit右边的水果是否有高亮
	if (fruit.x + 1) <= self.xCount  then
		--todo
		local rightNeighbor = self.matrix[(fruit.y - 1)*self.xCount + fruit.x + 1]
		if rightNeighbor.isActive == true then
			--todo
			return true
		end
	end
	-- 检查fruit上边的水果是否有高亮
	if (fruit.y + 1) <= self.yCount then
		local upNeighbor = self.matrix[fruit.y*self.xCount + fruit.x]
		if upNeighbor.isActive == true then
			return true
		end
	end
	-- 检查fruit下边的水果是否有高亮
	if(fruit.y - 1) >= 1 then
		local downNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x]
		if downNeighbor.isActive == true then
			return true
		end
	end
	-- 检查fruit左上的水果是否有高亮
	if (fruit.y + 1) <= self.yCount and (fruit.x - 1) >= 1 then
		local leftUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x - 1]
		if leftUpNeighbor.isActive == true then
			return true
		end
	end
	-- 检查fruit右下的水果是否有高亮
	if(fruit.y - 1) >= 1 and (fruit.x + 1) <= self.yCount then
		local rightDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x + 1]
		if rightDownNeighbor.isActive == true then
			return true
		end
	end
	-- 检查fruit右上的水果是否有高亮
	if(fruit.y + 1) <= self.xCount and (fruit.x + 1) <= self.yCount then
		local rightUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x + 1]
		if rightUpNeighbor.isActive == true then 
			return true
		end
	end
	-- 检查fruit左下的水果是否有高亮
	if (fruit.y - 1) >= 1 and (fruit.x - 1) >= 1 then
		--todo
		local leftDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x - 1]
		if leftDownNeighbor.isActive == true then
			--todo
			return true
		end
	end
	return false
end
function PlayScene1:activeNeighbor(fruit)
	-- 检查fruit左边的水果
	if (fruit.x - 1) >= 1 then
		local leftNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x - 1]
		if (leftNeighbor.flag == 0) and (leftNeighbor.fruitIndex == fruit.fruitIndex) then
			leftNeighbor.flag = 1
			self:activeNeighbor(leftNeighbor)
		end
	end

	-- 检查fruit右边的水果
	if (fruit.x + 1) <= self.xCount then
		local rightNeighbor = self.matrix[(fruit.y - 1) * self.xCount + fruit.x + 1]
		if (rightNeighbor.flag == 0) and (rightNeighbor.fruitIndex == fruit.fruitIndex) then
			rightNeighbor.flag = 1
			self:activeNeighbor(rightNeighbor)
		end
	end

	-- 检查fruit上边的水果
	if (fruit.y + 1) <= self.yCount then
		local upNeighbor = self.matrix[fruit.y * self.xCount + fruit.x]
		if (upNeighbor.flag == 0) and (upNeighbor.fruitIndex == fruit.fruitIndex) then
			upNeighbor.flag = 1
			self:activeNeighbor(upNeighbor)
		end
	end

	-- 检查fruit下边的水果
	if (fruit.y - 1) >= 1 then
		local downNeighbor = self.matrix[(fruit.y - 2) * self.xCount + fruit.x]
		if (downNeighbor.flag == 0) and (downNeighbor.fruitIndex == fruit.fruitIndex) then
			downNeighbor.flag = 1
			self:activeNeighbor(downNeighbor)
		end
	end
	--fruit = self.matrix[(y - 1) * self.xCount + x]
	--检查fruit左上的水果
	if(fruit.y + 1) <= self.yCount and (fruit.x - 1) >= 1 then
		local leftUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x - 1]
		if(leftUpNeighbor.flag == 0) and (leftUpNeighbor.fruitIndex == fruit.fruitIndex) then
			leftUpNeighbor.flag = 1
			self:activeNeighbor(leftUpNeighbor)
		end	
	end
	--检查fruit左下的水果
	if (fruit.y - 1) >= 1 and (fruit.x - 1) >= 1 then
		--todo
		local leftDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x - 1]
		if(leftDownNeighbor.flag == 0) and (leftDownNeighbor.fruitIndex == fruit.fruitIndex) then
			leftDownNeighbor.flag = 1
			self:activeNeighbor(leftDownNeighbor)
		end
	end
	--检查fruit右上的水果
	if (fruit.y + 1) <= self.yCount and (fruit.x + 1) <= self.xCount then
		--todo
		local rightUpNeighbor = self.matrix[fruit.y*self.xCount + fruit.x + 1]
		if(rightUpNeighbor.flag == 0) and (rightUpNeighbor.fruitIndex == fruit.fruitIndex) then
			rightUpNeighbor.flag = 1
			self:activeNeighbor(rightUpNeighbor)
		end
	end
	--检查fruit右下的水果
	if (fruit.y - 1) >= 1 and (fruit.x + 1) <= self.xCount then
		--todo
		local rightDownNeighbor = self.matrix[(fruit.y - 2)*self.xCount + fruit.x + 1]
		if(rightDownNeighbor.flag == 0) and (rightDownNeighbor.fruitIndex == fruit.fruitIndex) then			
			rightDownNeighbor.flag = 1
			self:activeNeighbor(rightDownNeighbor)
		end
	end
end

function PlayScene1:inSpecialFruiteActive()
	local flag = 0
	if self.specialFruit ~= nil then
		for _, fruit in pairs(self.specialFruit) do
			for _, pfruit in pairs(self.actives) do
				if fruit == pfruit then
					flag = 1 -- 有相同元素
					break	
				end
			end
			if flag == 0 then
				if (fruit) then
	    			fruit:setActive(false) -- 属于特殊消除数组，但是不属于高亮数组的设置为false
	    		end
			end
			flag = 0
	    end
	end
	self.specialFruit = {}
end

function PlayScene1:inactive()

    for _, fruit in pairs(self.actives) do
        if (fruit) then
            fruit:setActive(false)
        end
    end
	if self.specialFruit ~= nil then
	    for _, fruit in pairs(self.specialFruit) do
	    	if (fruit) then
	    		fruit:setActive(false)
	    	end
	    end
	end
	self.actives = {}
	self.specialFruit = {}
end

function PlayScene1:showActivesScore(removedFruits)
	-- 只有一个高亮，取消高亮并返回
	if 1 == #self.actives then
		self:inactive()
		self.activeScoreLabel:setString("")
		self.activeScore = 0
		return
	end

	-- 水果分数依次为5、15、25、35... ，求它们的和
	self.activeScore = self.scoreStart +  removedFruits *self.activeScore_one


end

function PlayScene1:onEnter()
end

function PlayScene1:onExit()
end

return PlayScene1
