// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.Zlib

package id.ninjasage
{
    import flash.utils.ByteArray;

    public class Zlib 
    {


        public static function compress(_arg_1:String):ByteArray
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(_arg_1);
            _local_2.compress("zlib");
            return (_local_2);
        }

        public static function decompress(_arg_1:ByteArray):*
        {
            _arg_1.uncompress("zlib");
            return (_arg_1.readUTFBytes(_arg_1.length));
        }


    }
}//package id.ninjasage

