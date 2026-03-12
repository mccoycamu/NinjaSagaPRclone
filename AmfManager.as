// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.AmfManager

package Managers
{
    import amf.amfConnect;

    public class AmfManager 
    {

        public function AmfManager(_arg_1:*=null)
        {
        }

        public function service(_arg_1:String, _arg_2:Array, _arg_3:Function, _arg_4:Boolean=false, _arg_5:*=null):*
        {
            new amfConnect().service(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }


    }
}//package Managers

