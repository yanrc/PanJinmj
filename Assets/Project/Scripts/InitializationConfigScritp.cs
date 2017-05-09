using UnityEngine;
using System.Collections;
using AssemblyCSharp;

using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Threading;
using UnityEngine.SceneManagement;
using System;
using System.Net.Sockets;
using LuaFramework;

public class InitializationConfigScritp : MonoBehaviour {
	
	int num = 0;
	bool hasPaused   = false;
	void Start () {
       
        MicroPhoneInput.getInstance ();
		//GlobalDataScript.getInstance ();
		////CustomSocket.getInstance().Connect();
		////ChatSocket.getInstance ();
		//TipsManagerScript.getInstance ().parent = gameObject.transform;
		//SoundCtrl.getInstance ();

  //      //检查更新
		//UpdateScript update = new UpdateScript ();
		//StartCoroutine (update.updateCheck ());

		//ServiceErrorListener seriveError = new ServiceErrorListener();
		//Screen.sleepTimeout = SleepTimeout.NeverSleep;
		heartbeatThread(); 
	}

   void	Awake(){
		if (PlayerPrefs.HasKey ("MusicVolume")) {
            LuaHelper.GetSoundManager().MusicVolume = PlayerPrefs.GetFloat ("MusicVolume");
            LuaHelper.GetSoundManager().EffectVolume = PlayerPrefs.GetFloat ("EffectVolume");
		}
    }

    /// <summary>  
    /// 获取时间戳  
    /// </summary>  
    /// <returns></returns>  
    //public long GetTimeStamp()
    //{
    //    TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
    //    return Convert.ToInt64(ts.TotalSeconds);
    //}

	private void heartbeatThread(){
		Thread thread = new Thread (sendHeartbeat);
		thread.IsBackground = true;
		thread.Start();
	}


	private static void sendHeartbeat(){
		CustomSocket.getInstance ().sendHeadData ();
		Thread.Sleep (20000);
		sendHeartbeat ();
	}

	public  void doSendHeartbeat( object source, System.Timers.ElapsedEventArgs e){
		CustomSocket.getInstance ().sendHeadData ();
	}
}
