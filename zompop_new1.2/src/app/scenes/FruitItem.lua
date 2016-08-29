local FruitItem = class("FruitItem", function(x, y, fruitIndex)
	fruitIndex = fruitIndex or math.round(math.random() * 1000) % 5 + 1
	local sprite = display.newSprite("#fruit"  .. fruitIndex .. '_1.png')
	sprite.fruitIndex = fruitIndex
	sprite.x = x
	sprite.y = y
    sprite.flag = 0 --标记出所有可行域
    sprite.flag_last = 0 --标记出最后一个水果对象的可行域
	sprite.isActive = false -- 是否高亮
    sprite.isFocuse = true -- 是否被忽略
    sprite.isSpecial = false -- 是否是特殊的消除元素
	return sprite
end)

function FruitItem:ctor()
end
-- 设置特殊消除元素
function FruitItem:setSpecial(isSpecial)
    self.isSpecial = isSpecial
    local frame
    if (isSpecial) then
        frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_4.png')
    else
        frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_1.png')
    end
    self:setSpriteFrame(frame)
end
-- 设置元素是否被忽略
function FruitItem:setFocuse(isFocuse)
    self.isFocuse = isFocuse
    local frame
    if(self.isSpecial) then
        if (isFocuse) then
            frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_4.png')
        else
            frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_6.png')
        end
    else
        if (isFocuse) then
            frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_1.png')
        else
            frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_3.png')
        end
    end
    self:setSpriteFrame(frame)
end

function FruitItem:setActive(active)
    self.isActive = active

    local frame
    if (self.isSpecial) then
        if (active) then
            frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_5.png')
        else
            frame = display.newSpriteFrame("fruit" .. self.fruitIndex .. '_4.png')
        end
    else
        if (active) then
            frame = display.newSpriteFrame("fruit"  .. self.fruitIndex .. '_2.png')
        else
            frame = display.newSpriteFrame("fruit"  .. self.fruitIndex .. '_1.png')
    end

    end

    self:setSpriteFrame(frame)

    if (active) then
        self:stopAllActions()
        local scaleTo1 = cc.ScaleTo:create(0.05, 1.4)
        local scaleTo2 = cc.ScaleTo:create(0.05, 1)
        self:runAction(cc.Sequence:create(scaleTo1, scaleTo2))
    end
end

function FruitItem.getWidth()
    g_fruitWidth = 0
    if (0 == g_fruitWidth) then
        local sprite = display.newSprite("#fruit1_1.png")
        g_fruitWidth = sprite:getContentSize().width
    end
    return g_fruitWidth
end

function FruitItem.getHeight()
    -- body
    g_fruitHeight = 0
    if 0 == g_fruitHeight then
        local  sprite = display.newSprite("#fruit1_1.png")
        g_fruitHeight = sprite:getContentSize().height
    end
    return g_fruitHeight 
end

return FruitItem
