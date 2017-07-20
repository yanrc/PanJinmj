using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using YRC;
using LitJson;

public class Payment : MonoBehaviour {
    //public static Payment Instance;
    //private void Start()
    //{
    //    Instance = this;
    //}
    //static string WXAppID = "wx9228df7ba5a4906c";//微信appid;
    //static AndroidJavaObject WXApi
    //{
    //    get
    //    {
    //        if (_wxApi == null)
    //        {
    //            AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
    //            AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
    //            AndroidJavaClass apiFactory = new AndroidJavaClass("com.tencent.mm.opensdk.openapi.WXAPIFactory");
    //            _wxApi = apiFactory.CallStatic<AndroidJavaObject>("createWXAPI",
    //                activity,
    //                WXAppID,
    //                false
    //            );
    //        }
    //        return _wxApi;
    //    }
    //}
    //static AndroidJavaObject _wxApi;
    //public void WXPay(string itemId)
    //{
    //    Debuger.Log("微信支付按钮点击");
    //    StartCoroutine(GetHttp(itemId));
    //}
    //IEnumerator GetHttp(string itemId)
    //{
        ////显示转圈圈，提示正在打开微信
        //WaitingPanel.Open("请稍等...");
        ////获取信息
        //string url = "http://dqc.qrz123.com/MaJiangManage/charge/weixin";
        //string userId = GlobalDataScript.loginResponseData.account.uuid.ToString();
        //string time = DateTime.Now.ToString("yyyyMMddHH");
        //string md5 = MD5Util.GetMD5(userId + time + itemId).ToLower();
        //url=string.Format(url + "?userId={0}&itemId={1}&identify={2}", userId, itemId, md5);
        //WWW www = new WWW(url);
        //yield return www;
        //Debuger.Log(url);
        //Debuger.Log(www.text);
        //JsonData JsonData = JsonMapper.ToObject(www.text);
        //string prepayid = JsonData["prepayid"].ToString();
        //string partnerid = JsonData["partnerid"].ToString();
        //string nonceStr = JsonData["noncestr"].ToString();
        //string timestamp = JsonData["timestamp"].ToString();
        //string packageValue = JsonData["package"].ToString();
        //string sign = JsonData["sign"].ToString();
        //Debuger.Log("partnerid=" + partnerid);
        //Dictionary<string, string> paras = new Dictionary<string, string>();
        ////#分割，前面是PayReq的参数，后面是用来计算MD5的
        //paras.Add("appid#appId", WXAppID);//应用ID
        //paras.Add("partnerid#partnerId", partnerid); //商户号
        //paras.Add("prepayid#prepayId", prepayid);//???
        //paras.Add("package#packageValue", packageValue); //???
        //paras.Add("noncestr#nonceStr", nonceStr); //随机字符串
        //paras.Add("timestamp#timeStamp", timestamp);//时间戳
        //paras.Add("sign#sign", sign); //应用签名
        //var request = new AndroidJavaObject("com.tencent.mm.opensdk.modelpay.PayReq");
        //foreach (var kv in paras)
        //{
        //    request.Set(kv.Key.Split('#')[1], kv.Value);
        //}
        //bool ret = WXApi.Call<bool>("sendReq", request);
    //}
    void WXPayCallback(string ret)
    {
        //WaitingPanel.Close();
        //Debuger.Log("微信支付 ret="+ret);
        ////结束转圈圈，关闭商城面板
        //ShopPanel.Close();
    }
}

