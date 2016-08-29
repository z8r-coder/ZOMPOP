 
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self.flag = cc.UserDefault:getInstance():getIntegerForKey("FFlag")
    if self.flag == 0 or self.flag == nil then
    	self:enterScene("story")
    	self.flag = 1
    	cc.UserDefault:getInstance():setIntegerForKey("FFlag", self.flag)
	else
		self:enterScene("Loading")
	end
end

return MyApp
