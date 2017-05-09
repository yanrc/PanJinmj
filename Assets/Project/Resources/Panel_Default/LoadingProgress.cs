using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Text;

public class LoadingProgress : MonoBehaviour {
    public Slider s;
    public Text textInfo;
    public Text textTitle;
    static LoadingProgress mInstance;
    StringBuilder sb = new StringBuilder();
    public static LoadingProgress Instance
    {
        get
        {
            if (!mInstance)
            {
                mInstance =FindObjectOfType<LoadingProgress>();
            }
            return mInstance;
        }
    }
    /// <summary>
    /// 省略号从1个点到6个点动态变化
    /// </summary>
    IEnumerator Changepoint()
    {
        while (true)
        {
            sb.Append('.');
            if (sb.Length > 6) sb.Remove(0, sb.Length);
            yield return new WaitForSeconds(0.3f);
        }
    }
    /// <summary>
    /// Displays or updates a progress bar.
    /// </summary>
    public static void DisplayProgressBar(string title, string info, float progress)
    {
        Instance.s.value = progress;
        Instance.textTitle.text = title;
        Instance.textInfo.text = info+ Instance.sb;
        Instance.gameObject.SetActive(true);
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
