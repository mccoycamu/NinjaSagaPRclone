// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ArenaLeague

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public dynamic class ArenaLeague extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var main:*;

        public function ArenaLeague(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.main = null;
            this.eventHandler = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

