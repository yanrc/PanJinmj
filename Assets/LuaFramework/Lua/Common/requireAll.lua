
require "Common/define"
require "Common/CoMgr"
require "Common/Enums"

require "Rules/JiuJiangPanel"

require "Logic.GlobalData"
require "Logic/TipsManager"
require "Logic/LoginManager"
require "Logic/BroadcastScript"
require "Logic/Test"
require "Logic/UIManager"

require "Logic/TopAndBottomCardScript"
require "Logic/BottomScript"
require "Logic/WechatOperate"


require "Vos/APIS"
require "vos/AvatarVO"
require "vos/Account"
require "vos/ClientRequest"
require "vos/ChatRequest"

require "Data/PlayerItem"
require "Data/RuleSelect"
require "Data/SignalOverItem"
require "Data/FinalOverItem"
require "Data/ShopItem"

require "Rules/JiuJiangPanel"
require "Rules/PanjinRule"

require "NewModule/Payment"
require "MicPhone/MicPhone"

require "Common/UIBase"
for k,v in pairs(define.Panels) do
	require("Controller/" .. v)
end
json = require "cjson"