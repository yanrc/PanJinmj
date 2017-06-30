CtrlNames = {
	"CreateRoomPanel",
	"DialogPanel",
	"EnterRoomPanel",
	"ExitPanel",
	"GamePanel",
	"HomePanel",
	"SettingPanel",
	"WaitingPanel",
	"VotePanel",
	"StartPanel",
}

UIManager = { }
local this = UIManager;

function UIManager.InitPanels()
	log("Lua:UIManager.InitPanels")
	Event.AddListener(APIS.PanelsInited, this.OnInited)
	for i = 1, #CtrlNames do
		_G[CtrlNames[i]]:Awake()
	end
end

function UIManager.OnInited(panel)
	if (panel == StartPanel) then
		StartPanel:Open()
	end
end