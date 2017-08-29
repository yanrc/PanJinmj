
ClientRequest = { }
-- 构造函数
function ClientRequest.New(headcode,data)
	local buffer = ByteBuffer.New()
	buffer:WriteInt(headcode)
	if (#data > 0) then
		buffer:WriteString(data)
	end
	print(string.format("lua ClientRequest:headcode=%#x,data=%s",headcode,data))
	return buffer
end
