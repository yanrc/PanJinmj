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
	define.GameOverPanel,
	define.UserInfoPanel,
	define.MessagePanel,
	define.RulePanel,
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
		this.InitPrefabs()
		LoadingProgress.ClearProgressBar();
	end
	UpdateBeat:Add(this.Update);
end

function UIManager.InitPrefabs()
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Pointer.prefab" }, function(prefabs) this.Pointer = newObject(prefabs[0]) end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function(prefabs) this.Bottom_B = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_R.prefab' }, function(prefabs) this.Bottom_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_T.prefab' }, function(prefabs) this.Bottom_T = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_L.prefab' }, function(prefabs) this.Bottom_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard.prefab" }, function(prefabs) this.TopAndBottomCard = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/ThrowCard_R.prefab" }, function(prefabs) this.ThrowCard_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/ThrowCard_L.prefab" }, function(prefabs) this.ThrowCard_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab" }, function(prefabs) this.PengGangCard_B = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_R.prefab" }, function(prefabs) this.PengGangCard_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_T.prefab" }, function(prefabs) this.PengGangCard_T = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_L.prefab" }, function(prefabs) this.PengGangCard_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/gangBack.prefab" }, function(prefabs) this.GangBack = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/GangBack_L&R.prefab" }, function(prefabs) this.GangBack_LR = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/GangBack_T.prefab" }, function(prefabs) this.GangBack_T = prefabs[0] end)
	resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/morentouxiang.jpg' }, function(sprite) this.DefaultIcon = sprite[0] end)
end

function OpenPanel(panel, ...)
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

function UIManager.Update()
	if (Input.GetKey(KeyCode.Escape)) then
		OpenPanel(ExitPanel)
	end
end

