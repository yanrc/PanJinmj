
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
require "Logic/ButtonAction"
require "Logic/TopAndBottomCardScript"
require "Logic/BottomScript"
require "Logic/WechatOperate"


require "Vos/APIS"
require "vos/AvatarVO"
require "vos/Account"
require "vos/ClientRequest"


require "Data/PlayerItem"
require "Data/RuleSelect"
require "Data/SignalOverItem"
require "Data/FinalOverItem"
require "Data/ShopItem"

require "Rules/JiuJiangPanel"
require "Rules/PanjinRule"

require "NewModule/Payment"

require "Common/UIBase"
for i = 1, #CtrlNames do
	require("Controller/" .. CtrlNames[i])
end
json = require "cjson"