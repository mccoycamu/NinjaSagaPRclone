// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.Crypt

package id.ninjasage
{
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.symmetric.PKCS5;
    import flash.utils.ByteArray;
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.symmetric.IVMode;
    import com.hurlant.util.Base64;

    public class Crypt 
    {

        private static var cipher:* = "aes-128-cbc";


        public static function encrypt(_arg_1:String, _arg_2:String, _arg_3:*):*
        {
            _arg_3 = Hex.toArray(Hex.fromString(_arg_3));
            new PKCS5(16).pad(_arg_3);
            var _local_4:ByteArray = Hex.toArray(Hex.fromString(_arg_1));
            var _local_5:ByteArray = Hex.toArray(Hex.fromString(_arg_2));
            var _local_6:ICipher = Crypto.getCipher(Crypt.cipher, _local_5);
            var _local_7:IVMode = (_local_6 as IVMode);
            _local_7.IV = _arg_3;
            _local_6.encrypt(_local_4);
            var _local_8:* = Base64.encodeByteArray(_local_4);
            _local_6.dispose();
            _local_4.clear();
            _local_5.clear();
            return (_local_8);
        }

        public static function decrypt(_arg_1:String, _arg_2:String, _arg_3:*):*
        {
            _arg_3 = Hex.toArray(Hex.fromString(_arg_3));
            new PKCS5(16).pad(_arg_3);
            var _local_4:ByteArray = Base64.decodeToByteArray(_arg_1);
            var _local_5:ByteArray = Hex.toArray(Hex.fromString(_arg_2));
            var _local_6:ICipher = Crypto.getCipher(Crypt.cipher, _local_5);
            var _local_7:IVMode = (_local_6 as IVMode);
            _local_7.IV = _arg_3;
            _local_6.decrypt(_local_4);
            var _local_8:* = Hex.toString(Hex.fromArray(_local_4));
            _local_6.dispose();
            _local_4.clear();
            _local_5.clear();
            return (_local_8);
        }


    }
}//package id.ninjasage

