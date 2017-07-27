using System;  
using System.Collections.Generic;  
using System.IO;  
using System.Linq;  
using System.Text;  
using UnityEngine;  
using System.Collections;
using AssemblyCSharp;
using LuaFramework;
using YRC;
using LuaInterface;
[RequireComponent (typeof(AudioSource))]  
public class MicroPhoneInput : MonoBehaviour {  
	private static MicroPhoneInput m_instance;  
	private AudioSource playAudio;
    private static string[] micArray=null;  
	const int HEADER_SIZE = 44;  
	const int RECORD_TIME = 10;  
	void Start () {  
		playAudio = GameObject.Find ("SoundsContainer/GamePlayAudio").GetComponent<AudioSource> ();
		if (playAudio.clip == null) {
			playAudio.clip = AudioClip.Create("playRecordClip", 160000, 1, 8000, false);
            GetComponent<AudioSource>().spatialBlend = 0;
        }
	}  

	public static MicroPhoneInput getInstance()  
	{  
		if (m_instance == null)   
		{  
			micArray = Microphone.devices;  
			if (micArray.Length == 0)  
			{  
				Debug.LogWarning ("Microphone.devices is null");  
			}  
			foreach (string deviceStr in Microphone.devices)  
			{  
				Debug.Log("device name = " + deviceStr);  
			}  
			if(micArray.Length==0)  
			{  
				Debug.LogWarning("no mic device");  
			}
            m_instance = FindObjectOfType<MicroPhoneInput>();
		}  
		return m_instance;  
	}  
		
	public void StartRecord()  
	{  
		GetComponent<AudioSource>().Stop();  
		if (micArray.Length == 0)  
		{  
			Debug.Log("No Record Device!");  
			return;  
		}  
		GetComponent<AudioSource>().loop = false;  
		GetComponent<AudioSource>().mute = true;  
		GetComponent<AudioSource>().clip = Microphone.Start("inputMicro", false, RECORD_TIME, 8000); //22050    
		while (!(Microphone.GetPosition(null)>0)) {  
		}  
		GetComponent<AudioSource>().Play ();  
		Debug.Log("StartRecord");   
	}  

	public  void StopRecord()  
	{  
		Debuger.Log("StopRecord");  
		if (micArray.Length == 0)  
		{  
			Debug.Log("No Record Device!");  
			return;  
		}  
		if (!Microphone.IsRecording(null))  
		{  
			return;  
		}  
		Microphone.End (null);  
		GetComponent<AudioSource>().Stop();
		PlayRecord ();
	}  

	public Byte[] GetClipData()  
	{  
		if (GetComponent<AudioSource>().clip == null)  
		{  
			Debuger.Log("GetClipData audio.clip is null");  
			return null;   
		}  
		float[] samples = new float[GetComponent<AudioSource>().clip.samples];
        Debuger.Log ("samples.Length = "+samples.Length);
		GetComponent<AudioSource>().clip.GetData(samples, 0);  
		Byte[] outData = new byte[samples.Length * 2];  
		int rescaleFactor = 32767; //to convert float to Int16   
		for (int i = 0; i < samples.Length; i++)  
		{  
			short temshort = (short)(samples[i] * rescaleFactor);  
			Byte[] temdata=System.BitConverter.GetBytes(temshort);  
			outData[i*2]=temdata[0];  
			outData[i*2+1]=temdata[1];  
		}  
		if (outData == null || outData.Length <= 0)  
		{  
			Debug.Log("GetClipData intData is null");  
			return null;   
		}    
		return outData;  
	}  


	public void PlayClipData(byte[] data)  
	{
        int k = 0;
        List<short> result = new List<short>();
        while (data.Length - k >= 2)
        {
            result.Add(BitConverter.ToInt16(data, k));
            k += 2;
        }
        Int16[] intArr = result.ToArray();
        if (intArr.Length == 0)  
		{  
			Debug.Log("get intarr clipdata is null");  
			return;  
		}
		float[] samples = new float[intArr.Length];  
		int rescaleFactor = 32767;  
		for (int i = 0; i < intArr.Length; i++)  
		{  
			samples[i] = (float)intArr[i] / rescaleFactor;  
		}  			
		playAudio.clip.SetData(samples, 0);  
		playAudio.mute = false;
        PlayClipDataBy();
    }

    public void PlayClipDataBy()
    {
        LuaHelper.GetSoundManager().playBGM(0);
        playAudio.volume = LuaHelper.GetSoundManager().EffectVolume;
        playAudio.Play();
        StartCoroutine(DelayedCallback(playAudio.clip.length));
    }


    private IEnumerator DelayedCallback(float time)
    {
        time = 5;//这里获取不了声音的时间
        yield return new WaitForSeconds(time);
        LuaHelper.GetSoundManager().playBGM(2);
    }

    private void PlayRecord()  
	{  
		if (GetComponent<AudioSource>().clip == null)  
		{  
			Debug.Log("audio.clip=null");  
			return;  
		}  
		GetComponent<AudioSource>().mute = false;  
		GetComponent<AudioSource>().loop = false;  
		GetComponent<AudioSource>().Play ();
    }
    public void OnPointerDown()
    {
        Util.CallMethod("MicPhone","OnPointerDown");
    }
    public void OnPointerUp()
    {
        Util.CallMethod("MicPhone", "OnPointerUp");
    }
}