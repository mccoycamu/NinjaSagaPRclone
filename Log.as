// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.Log

package id.ninjasage
{
    import flash.utils.getQualifiedClassName;

    public class Log 
    {


        public static function info(... _args):void
        {
            log("INFO", _args);
        }

        public static function warning(... _args):void
        {
            log("WARNING", _args);
        }

        public static function error(... _args):void
        {
            log("ERROR", _args);
        }

        public static function debug(... _args):void
        {
            log("DEBUG", _args);
        }

        private static function log(_arg_1:*, _arg_2:*):void
        {
            var _local_4:*;
            if (_arg_2 == null)
            {
                _arg_2 = [];
            };
            var _local_3:String = new Date().toLocaleTimeString();
            if (_arg_2.length > 1)
            {
                _local_4 = _arg_2[0];
                if (!(_local_4 is String))
                {
                    _local_4 = getQualifiedClassName(_local_4);
                    _arg_2.shift();
                };
                return;
            };
        }


    }
}//package id.ninjasage

