using UnityEngine;
using System.Collections;
using System.IO;
using System.Text;
using System;
using LuaInterface;

namespace LuaFramework {
    public class ByteBuffer {
        MemoryStream stream = null;
        BinaryWriter writer = null;
        BinaryReader reader = null;

        public ByteBuffer() {
            stream = new MemoryStream();
            writer = new BinaryWriter(stream);
        }

        public ByteBuffer(byte[] data) {
            if (data != null) {
                stream = new MemoryStream(data);
                reader = new BinaryReader(stream);
            } else {
                stream = new MemoryStream();
                writer = new BinaryWriter(stream);
            }
        }

        public void Close() {
            if (writer != null) writer.Close();
            if (reader != null) reader.Close();

            stream.Close();
            writer = null;
            reader = null;
            stream = null;
        }

        public void WriteByte(byte v) {
            writer.Write(v);
        }

        public void WriteInt(int v) {
            v=System.Net.IPAddress.HostToNetworkOrder(v);
            writer.Write((int)v);
        }
        public void WriteShort(short v)
        {
            v = System.Net.IPAddress.HostToNetworkOrder(v);
            writer.Write(v);
        }
        public void WriteUshort(ushort v) {
            writer.Write((ushort)v);
        }

        public void WriteLong(long v) {
            v = System.Net.IPAddress.HostToNetworkOrder(v);
            writer.Write((long)v);
        }

        public void WriteFloat(float v) {
            byte[] temp = BitConverter.GetBytes(v);
            Array.Reverse(temp);
            writer.Write(BitConverter.ToSingle(temp, 0));
        }

        public void WriteDouble(double v) {
            byte[] temp = BitConverter.GetBytes(v);
            Array.Reverse(temp);
            writer.Write(BitConverter.ToDouble(temp, 0));
        }

        public void WriteString(string v) {
            byte[] bytes = Encoding.UTF8.GetBytes(v);
            WriteShort((short)bytes.Length);
            writer.Write(bytes);
        }

        public void WriteBytes(byte[] v) {
            writer.Write((int)v.Length);
            writer.Write(v);
        }

        public void WriteBuffer(LuaByteBuffer strBuffer) {
            WriteBytes(strBuffer.buffer);
        }

        public byte ReadByte() {
            return reader.ReadByte();
        }

        public int ReadInt() {
            int v = reader.ReadInt32();
            v = System.Net.IPAddress.NetworkToHostOrder(v);
            return v;
        }
        public short ReadShort()
        {
            short v= reader.ReadInt16();
            v= System.Net.IPAddress.NetworkToHostOrder(v);
            return v;
        }
        public ushort ReadUshort() {
            return (ushort)reader.ReadInt16();
        }

        public long ReadLong() {
            long v = reader.ReadInt64();
            v = System.Net.IPAddress.NetworkToHostOrder(v);
            return v;
        }

        public float ReadFloat() {
            byte[] temp = BitConverter.GetBytes(reader.ReadSingle());
            Array.Reverse(temp);
            return BitConverter.ToSingle(temp, 0);
        }

        public double ReadDouble() {
            byte[] temp = BitConverter.GetBytes(reader.ReadDouble());
            Array.Reverse(temp);
            return BitConverter.ToDouble(temp, 0);
        }

        public string ReadString() {
            short len = ReadShort();
            byte[] buffer = new byte[len];
            buffer = reader.ReadBytes(len);
            return Encoding.UTF8.GetString(buffer);
        }

        public byte[] ReadBytes() {
            int len = ReadInt();
            return reader.ReadBytes(len);
        }

        public LuaByteBuffer ReadBuffer() {
            byte[] bytes = ReadBytes();
            return new LuaByteBuffer(bytes);
        }

        public byte[] ToBytes() {
            writer.Flush();
            byte[]bytes= stream.ToArray();
            return bytes;
        }

        public void Flush() {
            writer.Flush();
        }
    }
}