// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.News

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;

    public class News extends MovieClip 
    {

        public var bg:MovieClip;
        public var btn_close:SimpleButton;
        public var txt:TextField;
        public var main:*;

        public function News(_arg_1:*)
        {
            this.main = _arg_1;
            this.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.bg.addEventListener(MouseEvent.CLICK, this.closePanel);
        }

        internal function closePanel(_arg_1:MouseEvent):void
        {
            this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.bg.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.txt.text = "";
            this.main = null;
            parent.removeChild(this);
        }


    }
}//package Panels

