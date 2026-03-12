// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ConfrontingDeathDialogue

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Storage.GameData;
    import flash.events.MouseEvent;
    import Managers.AppManager;
    import flash.geom.ColorTransform;
    import com.utils.GF;

    public dynamic class ConfrontingDeathDialogue extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var dialogueData:Array;
        private var currentState:String;
        private var currentIndex:int = 0;

        public function ConfrontingDeathDialogue(_arg_1:*, _arg_2:*)
        {
            this.panelMC = _arg_1.panelMC;
            this.currentState = _arg_2;
            this.dialogueData = GameData.get("confrontingdeath2025").dialogues[_arg_2];
            this.initDialogue();
        }

        private function initDialogue():void
        {
            this.panelMC.clickmask.addEventListener(MouseEvent.CLICK, this.nextDialogue);
            this.panelMC.npc_name_left.text = "";
            this.panelMC.npc_name_right.text = "";
            this.panelMC.dialogueTxt.text = "";
            this.panelMC.bg.gotoAndStop(1);
            this.panelMC.npc_left.gotoAndStop(2);
            this.panelMC.npc_right.gotoAndStop(2);
            this.updateDialogue();
        }

        private function updateDialogue():void
        {
            if (this.currentIndex >= this.dialogueData.length)
            {
                if (this.currentState == "scene_1")
                {
                    AppManager.getInstance().main.startConfrontingDeathBattle("battle_1");
                }
                else
                {
                    if (this.currentState == "scene_2")
                    {
                        AppManager.getInstance().main.startConfrontingDeathBattle("battle_2");
                    };
                };
                this.destroy();
                return;
            };
            var _local_1:Object = this.dialogueData[this.currentIndex];
            if (_local_1.position == "left")
            {
                this.panelMC.npc_name_left.text = _local_1.npc;
                this.panelMC.npc_left.gotoAndStop(_local_1.npc);
                this.applyColorEffect(this.panelMC.npc_left, 1, 1, 1);
                this.applyColorEffect(this.panelMC.npc_right, 0.4, 0.4, 0.4);
            }
            else
            {
                this.panelMC.npc_name_right.text = _local_1.npc;
                this.panelMC.npc_right.gotoAndStop(_local_1.npc);
                this.applyColorEffect(this.panelMC.npc_right, 1, 1, 1);
                this.applyColorEffect(this.panelMC.npc_left, 0.4, 0.4, 0.4);
            };
            this.panelMC.dialogueTxt.text = _local_1.dialogue;
            if (_local_1.hasOwnProperty("scene"))
            {
                this.panelMC.bg.gotoAndStop(_local_1.scene);
            };
        }

        private function nextDialogue(_arg_1:MouseEvent):void
        {
            this.currentIndex++;
            this.updateDialogue();
        }

        public function applyColorEffect(_arg_1:MovieClip, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            var _local_5:ColorTransform = new ColorTransform(_arg_2, _arg_3, _arg_4, 1, 1, 1, 1, 0);
            _arg_1.transform.colorTransform = _local_5;
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.panelMC.clickmask.removeEventListener(MouseEvent.CLICK, this.nextDialogue);
            this.currentState = null;
            this.dialogueData = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

