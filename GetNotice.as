// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.GetNotice

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;

    public class GetNotice extends MovieClip 
    {

        public var bg:MovieClip;
        public var btn_close:SimpleButton;
        public var txt_msg:TextField;

        public function GetNotice(_arg_1:String)
        {
            this.txt_msg.text = _arg_1;
            this.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.bg.addEventListener(MouseEvent.CLICK, this.closePanel);
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.txt_msg = null;
            this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.bg.removeEventListener(MouseEvent.CLICK, this.closePanel);
            parent.removeChild(this);
        }


    }
}//package Panels

