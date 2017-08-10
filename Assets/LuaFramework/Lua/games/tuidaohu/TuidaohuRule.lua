TuidaohuRule = {
	name = "推倒胡",
	index = GameConfig.GAME_TYPE_TUIDAOHU,
	groups =
	{
		{
			title = "局数",
			content =
			{
				{ name = "4局", cost = "x1", pos = { 100, 0 } },
				{ name = "8局", cost = "x2", pos = { 400, 0 } },
				{ name = "16局", cost = "x4", pos = { 700, 0 } },
			},
			pos = { 0, - 60 },
			isCheckBox = false
		},
		{
			title = "玩法",
			content =
			{
				{ name = "将将胡", pos = { 100, 0 } },
				{ name = "清一色可吃", pos = { 400, 0 } },
				{ name = "开杠算一个", pos = { 100, - 100 } },
				{ name = "海底轮流胡", pos = { 400, - 100 } },
			},
			pos = { 0, - 160 },
			isCheckBox = true
		},
		{
			title = "扎鸟",
			content =
			{
				{ name = "不扎鸟", pos = { 100, 0 } },
				{ name = "单鸟", pos = { 400, 0 }, des = "(倍)" },
			},
			pos = { 0, - 360 },
			isCheckBox = false
		},
	},
	RuleText =
	{
		"推倒胡\n",
		"1任何对子均可做将。\n",
		"2允许一炮多响\n",
		"3胡牌必须自摸，不能点炮，除非是大胡子或枪明杠的牌(暗杠跟排杠不行)\n",
		"4过胡不胡（若想再胡该张牌，需重经自己的手之后）\n",
		"5小胡1分，大胡5分，可累计番上番\n",
		"6可选以下\n",
		"a,局数:8局,16局\n",
		"b,抓鸟数:1个,2个\n",
		"c,人数:3人,4人\n",
		"d,清一色(可吃)，将将胡(自摸)\n",
		"e,红中癞子\n",
	}
}


