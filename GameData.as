// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.GameData

package Storage
{
    import flash.display.MovieClip;

    public class GameData extends MovieClip 
    {

        private static var data:* = {};
        private static var _constructed:* = false;

        public var main:*;

        public function GameData(_arg_1:*)
        {
            this.main = _arg_1;
        }

        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            GameData.data = {};
            for each (_local_2 in _arg_1)
            {
                GameData.data[_local_2.id] = GameData.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function get constructed():*
        {
            return (GameData._constructed == true);
        }

        public static function get(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1].data);
            };
            return (GameData.prefix());
        }

        private static function prefix(_arg_1:*=null):*
        {
            return ({
                "id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : ""),
                "data":(((!(_arg_1 == null)) && ("data" in _arg_1)) ? _arg_1.data : {})
            });
        }


    }
}//package Storage

