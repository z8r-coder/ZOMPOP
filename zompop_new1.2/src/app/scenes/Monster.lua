local Monster = class("Monster", function(px,py,str_png)
	local sprite=str_png
     			:pos(px,py)
     			:scale(1.2)
      	sprite.position_x = px
      	sprite.position_y = py
      	sprite.xue = 100
      	
	return sprite
end)
function Monster:ctor()
	self:xuetiao_UI()

end
function Monster:getpos_x(  )
  -- body
  return self.position_x
end
function Monster:getpos_y(  )
  -- body
  return self.position_y
end

function Monster:setPosition(px,py)
  self.position_x = px
  self.position_y = py
end

function Monster:getWidth()
	local  g_Monster_Width = 0
    if (0 == g_Monster_Width) then
        local sprite = display.newSprite(str_png)
        g_Monster_Width = sprite:getContentSize().width
    end
    return g_Monster_Width
end
function Monster:xuetiao_UI(  )--对怪物的血条进行设置
   self.xuetiao = cc.ui.UILoadingBar.new({
      scale9 = false,
      capInsets = cc.rect(0,0,0,0),
      image = "xuetiao.png",
      viewRect = cc.rect(0,0,380,100),
      percent = 100
    })
    :addTo(self)
    :pos(-10, 130)
  	:scale(0.3)

end

function Monster:xuetiao_run(shanghai)
	self.xue = self.xue - shanghai

  if(self.xue<0) then
      self.xue=0
    end
	self.xuetiao:setPercent(self.xue)
end
function Monster:set_xue_tiao(a)
  self.xue = a
end

function Monster:get_xuetiao(  )
  -- body
  return self.xue
end

return Monster
