// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Encyclopedia

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class Encyclopedia extends MovieClip 
    {

        public var bg:MovieClip;
        public var btn_Encyclopedia_Npc:SimpleButton;
        public var descriptionTx:TextField;
        public var btn_close:SimpleButton;
        public var btn_Encyclopedia_Items:SimpleButton;
        public var btn_Encyclopedia_Pets:SimpleButton;
        public var btn_Encyclopedia_Skills:SimpleButton;
        public var btn_Encyclopedia_Enemy:SimpleButton;
        public var btn_Encyclopedia_Effect:SimpleButton;
        public var main:*;

        public function Encyclopedia(_arg_1:*)
        {
            this.main = _arg_1;
            this.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel, false, 0, true);
            this.btn_Encyclopedia_Items.addEventListener(MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.btn_Encyclopedia_Pets.addEventListener(MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.btn_Encyclopedia_Skills.addEventListener(MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.btn_Encyclopedia_Enemy.addEventListener(MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.btn_Encyclopedia_Npc.addEventListener(MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.btn_Encyclopedia_Effect.addEventListener(MouseEvent.CLICK, this.openPanel, false, 0, true);
        }

        internal function openPanel(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.name == "btn_Encyclopedia_Effect")
            {
                this.main.loadExternalSwfPanel("EncyclopediaEffect", "EncyclopediaEffect");
                return;
            };
            var _local_2:String = _arg_1.currentTarget.name.replace("btn_", "");
            this.main.loadPanel(("Panels." + _local_2));
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.main.handleVillageHUDVisibility(true);
            this.main = null;
            this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.btn_Encyclopedia_Items.removeEventListener(MouseEvent.CLICK, this.openPanel);
            this.btn_Encyclopedia_Pets.removeEventListener(MouseEvent.CLICK, this.openPanel);
            this.btn_Encyclopedia_Skills.removeEventListener(MouseEvent.CLICK, this.openPanel);
            this.btn_Encyclopedia_Enemy.removeEventListener(MouseEvent.CLICK, this.openPanel);
            this.btn_Encyclopedia_Npc.removeEventListener(MouseEvent.CLICK, this.openPanel);
            this.btn_Encyclopedia_Effect.removeEventListener(MouseEvent.CLICK, this.openPanel);
            GF.removeAllChild(this);
            System.gc();
        }


    }
}//package Panels

