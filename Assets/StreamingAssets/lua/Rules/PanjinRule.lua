local this = PanjinRule
PanjinRule = {
	name = "PanjinRule",
	groups =
	{
		["round"] =
		{
			["x1"] = "1圈",
			["x2"] = "2圈",
			["x4"] = "4圈",
			_type = "0"-- 单选
		},
		["rule"] =
		{
			["穷胡"] = "",
			["128番封顶"] = "",
			["包三家"] = "",
			["加钢"] = "",
			["会牌"] = "",
			["买断门"] = "",
			["鸡胡"] = "",
			_type = "1"-- 复选
		}
	}
}
