using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class GameSetting : MonoBehaviour {
    public  bool Panjin;
    public  bool Wuxi;
    public  bool Shuangliao;
    public  bool Jiujiang;
    public  bool Changsha;
    public  bool Tuidaohu;
    public  bool Fushun;
    public Sprite LOGO;
    public  Dictionary<string, bool> gamelist = new Dictionary<string, bool>();
    public Dictionary<string, bool> Init()
    {
        gamelist.Clear();
        gamelist.Add("Panjin", Panjin);
        gamelist.Add("Wuxi", Wuxi);
        gamelist.Add("ShuangLiao", Shuangliao);
        gamelist.Add("Jiujiang", Jiujiang);
        gamelist.Add("Changsha", Changsha);
        gamelist.Add("TuiDaoHu", Tuidaohu);
        gamelist.Add("Fushun", Fushun);
        return gamelist;
    }
    [ExecuteInEditMode]
    public void OnValidate()
    {
       FindObjectOfType<LoadingProgress>().transform.FindChild("logo").GetComponent<Image>().sprite = LOGO;
    }
}

