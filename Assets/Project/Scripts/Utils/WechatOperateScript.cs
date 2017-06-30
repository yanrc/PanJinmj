using UnityEngine;
using System.Collections;
using cn.sharesdk.unity3d;
using AssemblyCSharp;
using System.IO;
using UnityEngine.UI;
using System;
using LuaInterface;

/**
 * 微信操作
 */ 
public class WechatOperateScript : MonoBehaviour {
	public ShareSDK shareSdk;
	private string picPath;
	void Start () {
		if (shareSdk != null) {
			shareSdk.showUserHandler = getUserInforCallback;
			shareSdk.shareHandler = onShareCallBack;
		}

	}
    /**
	 * 获取微信个人信息成功回调,登录
	 *
	 */
    public void getUserInforCallback(int reqID, ResponseState state, PlatformType type, Hashtable data)
    {
    }

    /**
	 * 登录，提供给button使用
	 * 
	 */
    public void login(){
	    shareSdk.GetUserInfo(PlatformType.WeChat);
	}



	/***
	 * 分享战绩成功回调
	 */ 
	public void onShareCallBack(int reqID,ResponseState state,PlatformType type,Hashtable result){
		if (state == ResponseState.Success) {
			//TipsManagerScript.getInstance ().setTips ("分享成功");

		} else if(state == ResponseState.Fail){
			Debugger.Log ("shar fail :" + result ["error_msg"]);
		}
	}

	/**
	 * 分享战绩、战绩
	 */ 
	public void shareAchievementToWeChat(PlatformType platformType){
		StartCoroutine(GetCapture(platformType));
	}

	/**
	 * 执行分享到朋友圈的操作
	 */ 
	private void shareAchievement(PlatformType platformType){
		ShareContent customizeShareParams = new ShareContent();
		customizeShareParams.SetText("");
		customizeShareParams.SetImagePath(picPath);
		customizeShareParams.SetShareType(ContentType.Image);
		customizeShareParams.SetObjectID("");
		customizeShareParams.SetShareContentCustomize(platformType, customizeShareParams);
		shareSdk.ShareContent (platformType, customizeShareParams);
	}

	/**
	 * 截屏
	 * 
	 * 
	 */ 
	private IEnumerator GetCapture(PlatformType platformType)
	{
		yield return new WaitForEndOfFrame();
		if(Application.platform==RuntimePlatform.Android || Application.platform==RuntimePlatform.IPhonePlayer)  

			picPath=Application.persistentDataPath;  

		else if(Application.platform==RuntimePlatform.WindowsPlayer)  

			picPath=Application.dataPath;  

		else if(Application.platform==RuntimePlatform.WindowsEditor)

		{  
			picPath=Application.dataPath;  
			picPath= picPath.Replace("/Assets",null);  
		}   
		picPath = picPath + "/screencapture.png";
		int width = Screen.width;
		int height = Screen.height;
		Texture2D tex = new Texture2D(width,height,TextureFormat.RGB24,false);
		tex.ReadPixels(new Rect(0,0,width,height),0,0,true);
		tex.Apply ();
		byte[] imagebytes = tex.EncodeToPNG();//转化为png图
		tex.Compress(false);//对屏幕缓存进行压缩
		if (File.Exists (picPath)) {
			File.Delete (picPath);
		}
		File.WriteAllBytes(picPath,imagebytes);//存储png图
		Destroy(tex);
		shareAchievement(platformType);
	}
}
