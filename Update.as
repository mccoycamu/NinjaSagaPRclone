// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Update

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class Update extends MovieClip 
    {

        public var btn_site:SimpleButton;

        public function Update(_arg_1:*)
        {
            this.btn_site.addEventListener(MouseEvent.CLICK, this.update);
        }

        internal function update(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://ninjasage.id/en#downloads"));
            this.btn_site.removeEventListener(MouseEvent.CLICK, this.update);
            this.btn_site = null;
        }


    }
}//package Panels

