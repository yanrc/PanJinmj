using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Text;

public class LoadingProgress : MonoBehaviour, ICommand
{
    public Slider s;
    public Text textInfo;
    public Text textTitle;
    static LoadingProgress mInstance;
    StringBuilder sb = new StringBuilder();
    public static float current=0;
    public static float all=1;
    public static LoadingProgress Instance
    {
        get
        {
            if (!mInstance)
            {
                mInstance = FindObjectOfType<LoadingProgress>();
            }
            return mInstance;
        }
    }
    public void Execute(IMessage message)
    {
        current++;
    }
    /// <summary>
    /// 省略号从1个点到6个点动态变化
    /// </summary>
    IEnumerator Changepoint()
    {
        string title = "";
        string info = "正在更新资源，请稍候";
        while (true)
        {
            sb.Append('.');
            if (sb.Length > 6) sb.Remove(0, sb.Length);
            s.value = current/all;
            textTitle.text = title;
            textInfo.text = info + sb;
            yield return new WaitForSeconds(0.3f);
        }
    }
    /// <summary>
    ///  Removes progress bar.
    /// </summary>
    public static void ClearProgressBar()
    {
        Instance.gameObject.SetActive(false);
    }
    private void OnEnable()
    {
        StartCoroutine(Changepoint());
    }
    private void OnDisable()
    {
        StopCoroutine(Changepoint());
    }
}
