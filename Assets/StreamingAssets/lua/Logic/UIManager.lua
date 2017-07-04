CtrlNames = {
	define.CreateRoomPanel,
	define.DialogPanel,
	define.EnterRoomPanel,
	define.ExitPanel,
	define.GamePanel,
	define.HomePanel,
	define.SettingPanel,
	define.WaitingPanel,
	define.VotePanel,
	define.StartPanel,
}

UIManager = { }
local this = UIManager;

function UIManager.InitPanels()
	log("Lua:UIManager.InitPanels")
	Event.AddListener(define.PanelsInited, this.OnInited)
	for i = 1, #CtrlNames do
		_G[CtrlNames[i]]:Awake()
	end
end

function UIManager.OnInited(panel)
	if (panel == StartPanel) then
		OpenPanel(panel)
	end
end

function OpenPanel(panel,...)
	if (panel._type == define.FixUI) then
		log("Lua:OpenFix==>" .. panel.name)
	else
		log("Lua:OpenPop==>" .. panel.name)
	end
	panel:Open(...)
end


function ClosePanel(panel)
	if (panel._type == define.FixUI) then
		log("Lua:CloseFix==>" .. panel.name)
	else
		log("Lua:ClosePop==>" .. panel.name)
	end
	panel:Close()
end

