// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.Http

package id.ninjasage
{
    import flash.net.URLRequestMethod;

    public class Http 
    {


        public static function get(_arg_1:String, _arg_2:Function, _arg_3:Array=null):void
        {
            new RequestWrapper(_arg_1, URLRequestMethod.GET, null, _arg_2, _arg_3);
        }

        public static function post(_arg_1:String, _arg_2:Object, _arg_3:Function, _arg_4:Array=null):void
        {
            new RequestWrapper(_arg_1, URLRequestMethod.POST, _arg_2, _arg_3, _arg_4);
        }


    }
}//package id.ninjasage

