
require "Common/define"
require "Common/CoMgr"
require "Common/Enums"

require "Logic/TipsManager"
require "Logic/LoginManager"
require "Logic/BroadcastScript"

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
require "Data/RoomData"
require "Data/RoomOverData"
require "Data/RoundOverData"
require "Data/LoginData"




require "Common/UIBase"

require "Record/RecordPanel"
require "Record/RecordItem"
require "Record/DetailItem"
require "Record/PlayRecordPanel"
require "Record/RecordPlayerItem"

require "NewModule/Payment"
require "MicPhone/MicPhone"
require "MicPhone/MessageBox"

require("Controller/CreateRoomPanel")
require("Controller/DialogPanel")
require("Controller/EnterRoomPanel")
require("Controller/ExitPanel")
require("Controller/GameOverPanel")
require("Controller/GamePanel")
require("Controller/HomePanel")
require("Controller/InviteCodePanel")
require("Controller/MessagePanel")
require("Controller/RulePanel")
require("Controller/SettingPanel")
require("Controller/SharePanel")
require("Controller/ShopPanel")
require("Controller/StartPanel")
require("Controller/UserInfoPanel")
require("Controller/VotePanel")
require("Controller/WaitingPanel")
require("Controller/ZhuaMaPanel")

json = require "cjson"

require "games/panjin/PanjinRule"
require "games/panjin/PanjinGame"
require "games/jiujiang/JiujiangRule"
require "games/jiujiang/JiujiangGame"
require "games/changsha/ChangshaRule"
require "games/changsha/ChangshaGame"
require "games/tuidaohu/TuidaohuRule"
require "games/tuidaohu/TuidaohuGame"
require "games/shuangliao/ShuangliaoRule"
require "games/shuangliao/ShuangliaoGame"