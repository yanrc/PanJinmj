ChatRequest = { }
-- 构造函数
function ChatRequest.New(headcode, userList,myuuid, ChatSound)
	local buffer = ByteBuffer.New()
	buffer:WriteInt(headcode)
	if #userList > 0 then
		buffer:WriteInt(#userList)
		for i = 1, #userList do
			buffer:WriteInt(userList[i])
		end
	end
	if myuuid~=nil then
		buffer:WriteInt(myuuid)
	end
	if (ChatSound~=nil and ChatSound.Length > 0) then
		buffer:WriteBytes(ChatSound)
	end
	print(string.format("lua ChatRequest:headcode=%#x,ChatSound=%s", headcode, ChatSound))
	return buffer
end
