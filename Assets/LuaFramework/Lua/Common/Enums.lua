ResponseState =
{
	Begin = 0,
	Success = 1,
	Fail = 2,
	Cancel = 3
}


ContentType =
{
	Auto = 0;-- 自动(iOS为自动，安卓仅为Text)
	Text = 1;-- 文字分享
	Image = 2;-- 图文分享
	Webpage = 4;-- 链接分享
	Music = 5;-- 音乐分享
	Video = 6;-- 视频分享
	App = 7;-- 应用分享
	File = 8;-- 附件分享
	Emoji = 9;-- 表情分享
}
