Shoter=import("app.scenes.ShotItem")
Monster=import("app.scenes.Monster")
local bullet = class("bullet", function()--ch
	sprite=display.newSprite("plusboom/ProjectilePea.png")--子弹替换
	return sprite
end)
function bullet:set_dis(To_position_x,To_position_y )--设置目标方位
	self.to_position_x = To_position_x
	self.to_position_y = To_position_y
	
	
end
function bullet:set_from( From_position_x,From_position_y )--子弹初始方位
	
	self:pos(From_position_x,From_position_y)
	self.from_position_x = From_position_x
	self.from_position_y = From_position_y
end
function bullet:move_to(time)
	
	local move_t = cc.MoveTo:create(time,cc.p(self.to_position_x,self.to_position_y))
	return move_t
end
function bullet:getrun (shorters,Monsters,re_time,time,delay,de_time_s,shanghai)--得到单个子弹动作
	self:set_dis(Monsters.position_x,Monsters.position_y )
	self:set_from(shorters.position_x - 20,shorters.position_y+20 )
	local b_time=(shorters.position_x+60-Monsters.position_x)/(shorters.position_x+60)*time
	local action = self:move_to(b_time)
	local b_de_time_s = de_time_s + delay * 0.1
	local action_delay = cc.DelayTime:create (b_de_time_s)
	local action_delay_one = cc.DelayTime:create (delay * 0.1)
	local action1 = cc.FadeTo:create(0,0)
	local action2 = cc.FadeTo:create(0,1000)
	local action3 = cc.FadeTo:create(b_de_time_s,100)

	local callback_xue = cc.CallFunc:create(function() 
        Monsters:xuetiao_run(shanghai)
    end)
      local callback_boom = cc.CallFunc:create(function() 
       	self:bullet_boom()
    end)
     local callback_remove = cc.CallFunc:create(function() 
       	self:removeFromParent()
    end)
    

	local ru_action=cc.Sequence:create(action1,action_delay,action2,action,action1,callback_xue,callback_boom,action_delay_one,callback_remove)
	return ru_action
end

function bullet:ctor()
end
function bullet:bullet_boom(  )
	-- body
	self.bullent_boom_a = self:OnAction("boom.plist","boom.png","puff_")
	:addTo(self)

end
function bullet:OnAction( plist_name,png_name,Str_bef_Shu)
  display.addSpriteFrames(plist_name, png_name)
  local on_a = Str_bef_Shu.."%d.png"
  local frames=display.newFrames(on_a,1,7)
  local animation = display.newAnimation(frames,0.1)
  local on_b = "#"..Str_bef_Shu.."1.png"
  local sprite = display.newSprite(on_b)
    :pos(0, 0)
   
  sprite:playAnimationForever(animation,true, 
  	function ( )
  		
  	end, 0)
  return sprite
end
return bullet
