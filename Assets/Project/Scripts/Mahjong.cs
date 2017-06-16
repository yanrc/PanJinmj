using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using LuaInterface;
public class Mahjong : MonoBehaviour, IPointerDownHandler, IPointerUpHandler, IDragHandler
{
    LuaTable self;
    public void Init(LuaTable table)
    {
        self = table;
    }
    public void OnDrag(PointerEventData eventData)
    {
        self.GetLuaFunction("OnDrag").Call(self, eventData);
    }
    public void OnPointerDown(PointerEventData eventData)
    {
        self.GetLuaFunction("OnPointerDown").Call(self, eventData);
    }
    public void OnPointerUp(PointerEventData eventData)
    {
        self.GetLuaFunction("OnPointerUp").Call(self, eventData);
    }
}
