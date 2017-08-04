RecordItem = {
	lbIndex,
	lbRoomid,
	lbTime,
	lbNames={},
	lbScores={},
	btnShowDetail,
}

local mt = { }-- 元表（基类）
mt.__index = RecordItem-- index方法


function RecordItem.New(go, lua)
	local recordItem = { }
	setmetatable(recordItem, mt)
	recordItem.lbIndex = go.transform:FindChild('Texts/index'):GetComponent('Text')
	recordItem.lbRoomid = go.transform:FindChild('Texts/roomid/Text'):GetComponent('Text')
	recordItem.lbTime = go.transform:FindChild('Texts/time/Text'):GetComponent('Text')
	for i = 1, 4 do
		recordItem.lbNames[i] = go.transform:FindChild('Texts/player' .. i):GetComponent('Text')
		recordItem.lbScores[i] = go.transform:FindChild('Texts/player' .. i .. '/Text'):GetComponent('Text')
	end
	recordItem.btnShowDetail = go.transform:FindChild('btnShowDetail').gameObject
	lua:AddClick(recordItem.btnShowDetail, recordItem.Click, recordItem)
	return recordItem
end

function RecordItem:SetUI(ItemData, index)
	self.id = ItemData.data.id
	self.lbIndex.text = index
	self.lbRoomid.text = ItemData.roomId
	local time= DateTime.New(1970,1,1):AddMilliseconds(ItemData.data.createtime):ToString("yyyy-MM-dd HH:mm");
	self.lbTime.text =time
	local content =ItemData.data.content
	if content ~= nil and #content > 0 then
		local infoList = string.split(content, ',')
		for i = 1, #infoList-1 do
			infoList[i] = string.split(infoList[i], ':')
			self.lbNames[i].text = infoList[i][1]
			self.lbScores[i].text = infoList[i][2]
		end
	end
end

function RecordItem:Click()
	networkMgr:SendMessage(ClientRequest.New(APIS.ZHANJI_REPOTER_REQUEST,tostring(self.id)));
end