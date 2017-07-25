using UnityEngine;
using YRC;
using LuaFramework;
public class Payment : MonoBehaviour {
    void WXPayCallback(string ret)
    {
        Debuger.Log("微信支付 ret="+ret);
        Util.CallMethod("Payment", "WXPayCallback", ret);
    }
}

