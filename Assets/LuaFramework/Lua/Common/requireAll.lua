
require "Common/define"
require "Common/CoMgr"

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

require "Vos/APIS"
require "vos/AvatarVO"
require "vos/Account"
require "vos/ClientRequest"

require "Data/PlayerItem"
require "Data/RuleSelect"

require "Rules/JiuJiangPanel"
require "Rules/PanjinRule"

require "Common/UIBase"
for i = 1, #CtrlNames do
	require("Controller/" .. CtrlNames[i])
end
json = require "cjson"