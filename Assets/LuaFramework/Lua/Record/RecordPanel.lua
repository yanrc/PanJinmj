-- 战绩面板
RecordPanel = UIBase(define.Panels.RecordPanel, define.PopUI);
local this = RecordPanel
local transform;
local gameObject;

local btnClose
local btnWatch
local InputPanelbtnConfirm
local InputPanelbtnCancel
local RecordPage
local DetailPage
local InputPanel
local inputField
local recordItemsRoot
local detailItemsRoot
local recordItem
local detailItem
local playerText = { }
local recordList = { }
local detailList = { }
-- 启动事件--
function RecordPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)
	RecordPage = transform:FindChild('RecordPage').gameObject
	DetailPage = transform:FindChild('DetailPage').gameObject
	btnClose = transform:FindChild('btnClose').gameObject
	btnWatch = transform:FindChild('btnWatch').gameObject
	InputPanelbtnConfirm = transform:FindChild('InputPanel/btnConfirm').gameObject
	InputPanelbtnCancel = transform:FindChild('InputPanel/btnCancel').gameObject
	inputField = transform:FindChild('InputPanel/InputField'):GetComponent('InputField')
	InputPanel = transform:FindChild('InputPanel').gameObject
	recordItemsRoot = transform:FindChild('RecordPage/scrollrect/root')
	detailItemsRoot = transform:FindChild('DetailPage/scrollrect/root')
	for i = 1, 4 do
		playerText[i] = transform:FindChild('DetailPage/Header/root/Player' .. i):GetComponent('Text')
	end
	this.lua:AddClick(btnClose, this.CloseClick)
	this.lua:AddClick(btnWatch, this.OpenInputPanel)
	this.lua:AddClick(InputPanelbtnConfirm, this.InputSubmit)
	this.lua:AddClick(InputPanelbtnCancel, this.CloseInputPanel)
	inputField.onValueChanged:AddListener(this.OnValueChange)
end

function RecordPanel.GetRecord()
	networkMgr:SendMessage(ClientRequest.New(APIS.ZHANJI_REPOTER_REQUEST, "0"));
end

function RecordPanel.RecordResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message)
	if next(data) then
		GamePanel.CleanList(recordList)
		recordList = { }
		RecordPage:SetActive(true)
		DetailPage:SetActive(false)
		for i = 1, #data do
			local obj = newObject(recordItem)
			obj.transform:SetParent(recordItemsRoot)
			obj.transform.localScale = Vector3.one
			local objCtrl = RecordItem.New(obj, this.lua)
			objCtrl:SetUI(data[i], i)
			table.insert(recordList, obj)
		end
	end
end

function RecordPanel.DetailResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message)
	if next(data) then
		GamePanel.CleanList(detailList)
		detailList = { }
		RecordPage:SetActive(false)
		DetailPage:SetActive(true)
		-- 设置表头
		local header = data[1].content
		if header ~= nil and #header > 0 then
			local infoList = string.split(header, ',')
			for i = 1, #infoList - 1 do
				local name = string.split(infoList[i], ':')[1]
				playerText[i].text = name
			end
		end
		-- 创建内容
		for i = 1, #data do
			local obj = newObject(detailItem)
			obj.transform:SetParent(detailItemsRoot)
			obj.transform.localScale = Vector3.one
			local objCtrl = DetailItem.New(obj, this.lua)
			objCtrl:SetUI(data[i], i)
			table.insert(detailList, obj)
		end
	end
end

function RecordPanel.OpenInputPanel()
	InputPanel:SetActive(true)
	inputField.text = ""
end

function RecordPanel.CloseInputPanel()
	InputPanel:SetActive(false)
end

function RecordPanel.InputSubmit()
	soundMgr:playSoundByActionButton(1);
	if inputField.text ~= "" then
		networkMgr:SendMessage(ClientRequest.New(APIS.ZHANJI_SEARCH_REQUEST, inputField.text));
		InputPanel:SetActive(false)
	else
		TipsManager.SetTips("请输入正确的回放码！")
	end
end

function RecordPanel.OnValueChange()
	inputField.text = string.gsub(inputField.text, '-', '')
end
-------------------模板-------------------------
function RecordPanel.CloseClick()
	soundMgr:playSoundByActionButton(1);
	ClosePanel(this)
end

function RecordPanel.OnOpen()
	recordItem = UIManager.RecordItem
	detailItem = UIManager.DetailItem
	this.GetRecord()
end

function RecordPanel.AddListener()
	Event.AddListener(tostring(APIS.ZHANJI_REPORTER_REPONSE), this.RecordResponse)
	Event.AddListener(tostring(APIS.ZHANJI_DETAIL_REPORTER_REPONSE), this.DetailResponse)
end

function RecordPanel.RemoveListener()
	Event.RemoveListener(tostring(APIS.ZHANJI_REPORTER_REPONSE), this.RecordResponse)
	Event.RemoveListener(tostring(APIS.ZHANJI_DETAIL_REPORTER_REPONSE), this.DetailResponse)
end