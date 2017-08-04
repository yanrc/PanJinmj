DetailItem = {
	lbIndex,
	lbTime,
	lbScores={},
	btnPlay,
}

local mt = { }-- 元表（基类）
mt.__index = DetailItem-- index方法


function DetailItem.New(go, lua)
	local detailItem = { }
	setmetatable(detailItem, mt)
	detailItem.lbIndex = go.transform:FindChild('Texts/index'):GetComponent('Text')
	detailItem.lbTime = go.transform:FindChild('Texts/time'):GetComponent('Text')
	for i = 1, 4 do
		detailItem.lbScores[i] = go.transform:FindChild('Texts/score' .. i):GetComponent('Text')
	end
	detailItem.btnPlay = go.transform:FindChild('btnPlay').gameObject
	lua:AddClick(detailItem.btnPlay, detailItem.Click, detailItem)
	return detailItem
end

function DetailItem:SetUI(ItemData, index)
	self.id = ItemData.id
	self.lbIndex.text = index
	local time= DateTime.New(1970,1,1):AddMilliseconds(ItemData.createtime):ToString("yyyy-MM-dd HH:mm");
	self.lbTime.text =time
	local content =ItemData.content
	if content ~= nil and #content > 0 then
		local infoList = string.split(content, ',')
		for i = 1, #infoList-1 do
			infoList[i] = string.split(infoList[i], ':')
			self.lbScores[i].text = infoList[i][2]
		end
	end
end

function DetailItem:Click()
	networkMgr:SendMessage(ClientRequest.New(APIS.GAME_BACK_PLAY_REQUEST, tostring(self.id)));
	OpenPanel(PlayRecordPanel)
end
