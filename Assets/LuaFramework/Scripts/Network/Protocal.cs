
namespace LuaFramework
{
    public class Protocal
    {
        ///BUILD TABLE
        public const int Connect = 101;             //连接服务器
        public const int Exception = 102;           //异常掉线
        public const int Disconnect = 103;          //正常断线
        public const int Message = 104;	            //接收消息
        public const int ConnectFail = 105;	        //连接服务器失败
        public const int ChatConnect = 301;         //语音连接服务器
        public const int ChatException = 302;       //语音异常掉线
        public const int ChatDisconnect = 303;      //语音正常断线
        public const int ChatMessage = 304;	        //接收消息
        public const int ChatConnectFail = 305;	    //连接语音服务器失败
    }
}