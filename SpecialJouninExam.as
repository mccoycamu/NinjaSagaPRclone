// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SpecialJouninExam

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Popups.Confirmation;
    import br.com.stimuli.loading.BulkLoader;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import Storage.SkillLibrary;
    import flash.events.Event;

    public dynamic class SpecialJouninExam extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var spjounin:Array;
        private var curr_stage:int;
        private var curr_chapter:int;
        private var confirmation:Confirmation;
        private var CLASS_BTN_NAME_ARR:Array = ["select_info", "select_surprise", "select_perceive", "select_attack", "select_heal"];
        private var CLASS_SKILL_ARR:Array = ["skill_4002", "skill_4004", "skill_4001", "skill_4003", "skill_4000"];
        private var CLASS_NAME_ARR:Array = ["Intelligence Class", "Surprise Attack Class", "Sensor Class", "Heavy Attack Class", "Medical Class"];
        private var tooltip:*;
        private var loader:BulkLoader;
        private var swfName:String;
        private var selected_class:int;
        private var eventHandler:EventHandler;

        public function SpecialJouninExam(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.main.handleVillageHUDVisibility(false);
            this.eventHandler = new EventHandler();
            this.loader = BulkLoader.createUniqueNamedLoader(10);
            this.panelMC.gotoAndStop(1);
            this.main.loading(true);
            this.main.amf_manager.service("SpecialJouninExam.getData", [Character.sessionkey, Character.char_id], this.onShow);
            this.panelMC.addFrameScript(40, this.frame41, 47, this.frame48, 80, this.frame81);
        }

        private function onShow(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.spjounin = _arg_1.data;
                this.panelMC.gotoAndPlay(1);
            }
            else
            {
                if (((_arg_1.status > 1) && (_arg_1.hasOwnProperty("result"))))
                {
                    this.main.showMessage(_arg_1.result);
                    this.destroy();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function stageFrame27():*
        {
            this.panelMC.panel.stageMc.stop();
            this.panelMC.panel.stageMc.hintMC.visible = false;
            this.panelMC.panel.stageMc.gotoAndStop("show");
            this.panelMC.panel.stageMc.hintMC2.gotoAndStop("hard");
            this.panelMC.panel.stageMc.hintMC2.iconMC1.gotoAndStop("tensai");
            var _local_1:* = 1;
            while (_local_1 < 7)
            {
                this.panelMC.panel.stageMc[("stage" + _local_1)].gotoAndStop("enable");
                this.panelMC.panel.rightPanel.tabMc.btnClaim.visible = true;
                this.panelMC.panel.stageMc[("stage" + _local_1)].tickMC.visible = false;
                this.panelMC.panel.stageMc[("stage" + _local_1)].buttonMode = true;
                this.eventHandler.addListener(this.panelMC.panel.stageMc[("stage" + _local_1)], MouseEvent.MOUSE_OVER, this.mouseOver);
                this.eventHandler.addListener(this.panelMC.panel.stageMc[("stage" + _local_1)], MouseEvent.MOUSE_OUT, this.mouseOut);
                this.eventHandler.addListener(this.panelMC.panel.stageMc[("stage" + _local_1)], MouseEvent.CLICK, this.mouseClick);
                _local_1++;
            };
            if (((this.spjounin[0].status == 2) && (this.spjounin[1].status == 2)))
            {
                this.panelMC.panel.stageMc["stage1"].tickMC.visible = true;
            };
            if (((this.spjounin[2].status == 2) && (this.spjounin[3].status == 2)))
            {
                this.panelMC.panel.stageMc["stage2"].tickMC.visible = true;
            };
            if (((this.spjounin[4].status == 2) && (this.spjounin[5].status == 2)))
            {
                this.panelMC.panel.stageMc["stage3"].tickMC.visible = true;
            };
            if (((this.spjounin[6].status == 2) && (this.spjounin[7].status == 2)))
            {
                this.panelMC.panel.stageMc["stage4"].tickMC.visible = true;
            };
            if (((this.spjounin[8].status == 2) && (this.spjounin[9].status == 2)))
            {
                this.panelMC.panel.stageMc["stage5"].tickMC.visible = true;
            };
            if ((((this.spjounin[10].status == 2) && (this.spjounin[11].status == 2)) && (this.spjounin[12].status == 2)))
            {
                this.panelMC.panel.stageMc["stage6"].tickMC.visible = true;
            };
            if (((this.spjounin[0].status == 0) && (this.spjounin[1].status == 0)))
            {
                this.panelMC.panel.stageMc["stage1"].bgMC.gotoAndStop("idle");
                this.panelMC.panel.stageMc["stage1"].gotoAndStop("locked");
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage1"], MouseEvent.CLICK, this.mouseClick);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage1"], MouseEvent.MOUSE_OUT, this.mouseOut);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage1"], MouseEvent.MOUSE_OVER, this.mouseOver);
            };
            if (((this.spjounin[2].status == 0) && (this.spjounin[3].status == 0)))
            {
                this.panelMC.panel.stageMc["stage2"].bgMC.gotoAndStop("idle");
                this.panelMC.panel.stageMc["stage2"].gotoAndStop("locked");
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage2"], MouseEvent.CLICK, this.mouseClick);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage2"], MouseEvent.MOUSE_OUT, this.mouseOut);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage2"], MouseEvent.MOUSE_OVER, this.mouseOver);
            };
            if (((this.spjounin[4].status == 0) && (this.spjounin[5].status == 0)))
            {
                this.panelMC.panel.stageMc["stage3"].bgMC.gotoAndStop("idle");
                this.panelMC.panel.stageMc["stage3"].gotoAndStop("locked");
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage3"], MouseEvent.CLICK, this.mouseClick);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage3"], MouseEvent.MOUSE_OUT, this.mouseOut);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage3"], MouseEvent.MOUSE_OVER, this.mouseOver);
            };
            if (((this.spjounin[6].status == 0) && (this.spjounin[7].status == 0)))
            {
                this.panelMC.panel.stageMc["stage4"].bgMC.gotoAndStop("idle");
                this.panelMC.panel.stageMc["stage4"].gotoAndStop("locked");
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage4"], MouseEvent.CLICK, this.mouseClick);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage4"], MouseEvent.MOUSE_OUT, this.mouseOut);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage4"], MouseEvent.MOUSE_OVER, this.mouseOver);
            };
            if (((this.spjounin[8].status == 0) && (this.spjounin[9].status == 0)))
            {
                this.panelMC.panel.stageMc["stage5"].bgMC.gotoAndStop("idle");
                this.panelMC.panel.stageMc["stage5"].gotoAndStop("locked");
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage5"], MouseEvent.CLICK, this.mouseClick);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage5"], MouseEvent.MOUSE_OUT, this.mouseOut);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage5"], MouseEvent.MOUSE_OVER, this.mouseOver);
            };
            if ((((this.spjounin[10].status == 0) && (this.spjounin[11].status == 0)) && (this.spjounin[12].status == 0)))
            {
                this.panelMC.panel.stageMc["stage6"].bgMC.gotoAndStop("idle");
                this.panelMC.panel.stageMc["stage6"].gotoAndStop("locked");
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage6"], MouseEvent.CLICK, this.mouseClick);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage6"], MouseEvent.MOUSE_OUT, this.mouseOut);
                this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage6"], MouseEvent.MOUSE_OVER, this.mouseOver);
            };
        }

        private function setRightPanel(_arg_1:String):*
        {
            switch (_arg_1)
            {
                case "stage1":
                    this.curr_stage = 1;
                    this.curr_chapter = 0;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage1");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "The Force Of Yami";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Mystery enemy is attacking Fire Village. They have someone who look like Shin and Ryu. Yudai has called out a meeting and gathered the five captains from each division.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[0].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[1].status == 0)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[1].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case "stage2":
                    this.curr_stage = 2;
                    this.curr_chapter = 2;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage3");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Front Line Battle";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Kage has appointed you to work with the Surprise Attack Division.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[2].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[3].status == 0)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[3].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case "stage3":
                    this.curr_stage = 3;
                    this.curr_chapter = 4;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage5");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Sensor Division";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Facing the unknown enemy, It is better to know what they are good at as soon as possible. Sensor Division Captain is here and tell you what you can do.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[4].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[5].status == 0)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[5].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case "stage4":
                    this.curr_stage = 4;
                    this.curr_chapter = 6;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage7");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Secret Training";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Based on previous battle, Yudai suggests you should take some advises from Heavy Attack Division.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[6].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[7].status == 0)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[7].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case "stage5":
                    this.curr_stage = 5;
                    this.curr_chapter = 8;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage9");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Medical Division";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Kage finally discovers the man behind this attack. Also, there are lack of ninja in Medical Division. Kage wants you to help with them.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[8].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[9].status == 0)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[9].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case "stage6":
                    this.curr_stage = 6;
                    this.curr_chapter = 10;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage11");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.tab5.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab5.chapTxt.text = "Chapter 3";
                    this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab4.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab3.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "The Released Beast";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Vadar has brought a evil beast with him together!";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab4, MouseEvent.CLICK, this.setRightPanel2, false, 0, true);
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab5, MouseEvent.CLICK, this.setRightPanel3, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[10].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = true;
                    };
                    if (this.spjounin[11].status == 0)
                    {
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4, MouseEvent.CLICK, this.setRightPanel2);
                        this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5, MouseEvent.CLICK, this.setRightPanel3);
                    };
                    if (this.spjounin[11].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
                    };
                    if (this.spjounin[12].status == 0)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5, MouseEvent.CLICK, this.setRightPanel3);
                    };
                    if (this.spjounin[12].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = true;
                    };
                    return;
            };
        }

        private function setRightPanel2(_arg_1:String):*
        {
            switch (this.curr_stage)
            {
                case 1:
                    this.curr_chapter = 1;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage2");
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Unpredicted Attack";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "The weapons are now ready, go and deliver the weapons to the front line. But watch out for the enemy!";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1, MouseEvent.CLICK, this.backToS1C1, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[0].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[1].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case 2:
                    this.curr_chapter = 3;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage4");
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Defense! Defense!";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Yudai suggest every Jounin should in charge one guarding tower and observe all the enemy movements. It looks like an enemy is coming towards you!";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1, MouseEvent.CLICK, this.backToS2C1, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[2].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[3].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case 3:
                    this.curr_chapter = 5;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage6");
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Call For Backup";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Enemies sneak in and attack us from behind. You must go to the front line and call for backup. Hurry! You are the only hope!";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1, MouseEvent.CLICK, this.backToS3C1, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[4].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[5].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case 4:
                    this.curr_chapter = 7;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage8");
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Swords vs Ninjutsu";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "After the training, you are more confidence to fight in battle. Yudai tells you to go back to front line as he wants to end this battle as soon as possible.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1, MouseEvent.CLICK, this.backToS4C1, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[6].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[7].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case 5:
                    this.curr_chapter = 9;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage10");
                    this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Time To Fight Back";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "According to Mori Naruhisa, enemy will try to sneak into the village tonight. We can prepare a massive attack for this.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1, MouseEvent.CLICK, this.backToS5C1, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[8].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
                    };
                    if (this.spjounin[9].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
                    };
                    return;
                case 6:
                    this.curr_chapter = 11;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage12");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab3.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.tab3.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab5.chapTxt.text = "Chapter 3";
                    this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab4.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Kage vs Kage";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Long battle has came to a close, the fight between Vadar and Yudai is finally begun.";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab3, MouseEvent.CLICK, this.backToS6C1, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[10].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = true;
                    };
                    if (this.spjounin[11].status == 0)
                    {
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4, MouseEvent.CLICK, this.setRightPanel2);
                        this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[11].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
                    };
                    if (this.spjounin[12].status == 0)
                    {
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4, MouseEvent.CLICK, this.setRightPanel2);
                        this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[12].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = true;
                    };
                    return;
            };
        }

        private function setRightPanel3(_arg_1:String):*
        {
            switch (this.curr_stage)
            {
                case 6:
                    this.curr_chapter = 12;
                    this.panelMC.panel.rightPanel.visible = true;
                    this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage13");
                    this.panelMC.panel.rightPanel.tabMc.tab1.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab2.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab3.chapTxt.text = "Chapter 1";
                    this.panelMC.panel.rightPanel.tabMc.tab3.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab3.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.gotoAndStop("unselect");
                    this.panelMC.panel.rightPanel.tabMc.tab4.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab4.chapTxt.text = "Chapter 2";
                    this.panelMC.panel.rightPanel.tabMc.tab5.gotoAndStop("select");
                    this.panelMC.panel.rightPanel.tabMc.tab5.dateTxt.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.tab5.chapTxt.text = "Chapter 3";
                    this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Beyond Kage's Power";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Vadar has shown his true power to everyone. However, Kage's Ultimate Element Seal is not yet complete, how much longer can you last?";
                    this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
                    this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1, MouseEvent.CLICK, this.backToS5C1, false, 0, true);
                    this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim, this.startStage, "Start");
                    if (this.spjounin[10].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
                    };
                    if (this.spjounin[11].status == 0)
                    {
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4, MouseEvent.CLICK, this.setRightPanel2);
                        this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[11].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
                    };
                    if (this.spjounin[12].status == 0)
                    {
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4, MouseEvent.CLICK, this.setRightPanel2);
                        this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                        this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5, MouseEvent.CLICK, this.setRightPanel2);
                    };
                    if (this.spjounin[12].status == 2)
                    {
                        this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 3";
                        this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                        this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = true;
                    };
                    return;
            };
        }

        private function startStage(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("SpecialJouninExam.startStage", [Character.sessionkey, Character.char_id, (this.curr_chapter + 11)], this.startExam);
        }

        private function startExam(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if (this.curr_chapter == 0)
                {
                    this.main.loadSpecialJouninStage("stage1c1");
                }
                else
                {
                    if (this.curr_chapter == 1)
                    {
                        this.main.loadSpecialJouninStage("stage1c2");
                    }
                    else
                    {
                        if (this.curr_chapter == 2)
                        {
                            this.main.loadSpecialJouninStage("stage2c1");
                        }
                        else
                        {
                            if (this.curr_chapter == 3)
                            {
                                this.main.loadSpecialJouninStage("stage2c2");
                            }
                            else
                            {
                                if (this.curr_chapter == 4)
                                {
                                    this.main.loadSpecialJouninStage("stage3c1");
                                }
                                else
                                {
                                    if (this.curr_chapter == 5)
                                    {
                                        this.main.loadSpecialJouninStage("stage3c2");
                                    }
                                    else
                                    {
                                        if (this.curr_chapter == 6)
                                        {
                                            this.main.loadSpecialJouninStage("stage4c1");
                                        }
                                        else
                                        {
                                            if (this.curr_chapter == 7)
                                            {
                                                this.main.loadSpecialJouninStage("stage4c2");
                                            }
                                            else
                                            {
                                                if (this.curr_chapter == 8)
                                                {
                                                    this.main.loadSpecialJouninStage("stage5c1");
                                                }
                                                else
                                                {
                                                    if (this.curr_chapter == 9)
                                                    {
                                                        this.main.loadSpecialJouninStage("stage5c2");
                                                    }
                                                    else
                                                    {
                                                        if (this.curr_chapter == 10)
                                                        {
                                                            this.main.loadSpecialJouninStage("stage6c1");
                                                        }
                                                        else
                                                        {
                                                            if (this.curr_chapter == 11)
                                                            {
                                                                this.main.loadSpecialJouninStage("stage6c2");
                                                            }
                                                            else
                                                            {
                                                                if (this.curr_chapter == 12)
                                                                {
                                                                    this.main.loadSpecialJouninStage("stage6c3");
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                this.destroy();
            }
            else
            {
                this.main.showMessage(_arg_1.result);
            };
        }

        private function backToS1C1(_arg_1:MouseEvent):*
        {
            this.setRightPanel("stage1");
        }

        private function backToS2C1(_arg_1:MouseEvent):*
        {
            this.setRightPanel("stage2");
        }

        private function backToS3C1(_arg_1:MouseEvent):*
        {
            this.setRightPanel("stage3");
        }

        private function backToS4C1(_arg_1:MouseEvent):*
        {
            this.setRightPanel("stage4");
        }

        private function backToS5C1(_arg_1:MouseEvent):*
        {
            this.setRightPanel("stage5");
        }

        private function backToS6C1(_arg_1:MouseEvent):*
        {
            this.setRightPanel("stage6");
        }

        private function backToS6C2(_arg_1:MouseEvent):*
        {
            this.setRightPanel2("6");
        }

        private function showExamPassed():*
        {
            this.panelMC.panel.finishAni.visible = true;
            this.panelMC.panel.finishAni.gotoAndPlay(1);
            this.panelMC.panel.finishAni.addFrameScript(222, this.showCharInfo, 226, this.showBadge, 229, this.showClassSelection, 244, this.confirmExamScroll);
        }

        private function showBadge():*
        {
            this.panelMC.panel.finishAni.badgeMC.gotoAndStop("genius");
        }

        private function showCharInfo():*
        {
            var _local_1:* = this.main.getPlayerHead();
            _local_1.scaleX = 3;
            _local_1.scaleY = 3;
            this.panelMC.panel.finishAni.iconHolder.addChild(_local_1);
            this.panelMC.panel.finishAni.nameTxt.text = "Name:";
            this.panelMC.panel.finishAni.nameField.text = Character.character_name;
            this.panelMC.panel.finishAni.rankTxt.text = "Rank:";
            this.panelMC.panel.finishAni.classTxt.text = "Class:";
        }

        private function showClassSelection():*
        {
            this.panelMC.panel.finishAni.stop();
            this.panelMC.panel.finishAni.classSelectionMC.addFrameScript(16, this.onShowClassSelection);
        }

        private function onShowClassSelection():*
        {
            this.panelMC.panel.finishAni.classSelectionMC.stop();
            this.panelMC.panel.finishAni.classSelectionMC.panelMC.addFrameScript(15, this.onSelectClass, 36, this.stopSelectClassPanel);
        }

        private function onSelectClass():*
        {
            this.tooltip = new skillToolTip();
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_local_1]].gotoAndStop(1);
                this.eventHandler.addListener(this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_local_1]], MouseEvent.CLICK, this.changeClass, false, 0, true);
                this.eventHandler.addListener(this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_local_1]], MouseEvent.MOUSE_OVER, this.mouseOverClassBtn, false, 0, true);
                this.eventHandler.addListener(this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_local_1]], MouseEvent.MOUSE_OUT, this.mouseOutClassBtn, false, 0, true);
                this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_local_1]].classTitle.text = this.CLASS_NAME_ARR[_local_1];
                this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_local_1]].highlightMC.visible = false;
                this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_local_1]].thisType = (_local_1 + 1);
                this.main.initButtonDisable(this.panelMC.panel.finishAni["classSelectionMC"]["panelMC"]["btnComfirm"], this.showConfirmationClass, "Confirm");
                _local_1++;
            };
        }

        private function stopSelectClassPanel():*
        {
            this.panelMC.panel.finishAni.classSelectionMC.panelMC.stop();
        }

        private function changeClass(_arg_1:MouseEvent=null):*
        {
            var _local_2:uint;
            var _local_3:MovieClip = this.panelMC.panel.finishAni["classSelectionMC"]["panelMC"];
            this.selected_class = _arg_1.currentTarget.thisType;
            _local_2 = 0;
            while (_local_2 < 5)
            {
                if (this.selected_class == (_local_2 + 1))
                {
                    if (_local_3[this.CLASS_BTN_NAME_ARR[_local_2]].hasEventListener(MouseEvent.CLICK))
                    {
                        this.eventHandler.removeListener(_local_3[this.CLASS_BTN_NAME_ARR[_local_2]], MouseEvent.CLICK, this.changeClass);
                    };
                    _local_3[this.CLASS_BTN_NAME_ARR[_local_2]]["highlightMC"].visible = true;
                }
                else
                {
                    if (!_local_3[this.CLASS_BTN_NAME_ARR[_local_2]].hasEventListener(MouseEvent.CLICK))
                    {
                        this.eventHandler.addListener(_local_3[this.CLASS_BTN_NAME_ARR[_local_2]], MouseEvent.CLICK, this.changeClass, false, 0, true);
                    };
                    _local_3[this.CLASS_BTN_NAME_ARR[_local_2]]["highlightMC"].visible = false;
                };
                _local_2++;
            };
            if (!_local_3["btnComfirm"].hasEventListener(MouseEvent.CLICK))
            {
                this.main.initButton(_local_3["btnComfirm"], this.showConfirmationClass, "Confirm");
            };
        }

        private function mouseOutClassBtn(_arg_1:MouseEvent=null):*
        {
            var _local_2:uint = _arg_1.currentTarget.thisType;
            _arg_1.currentTarget.gotoAndStop(1);
            GF.removeAllChild(this.panelMC.panel.finishAni.classSelectionMC.panelMC[("tooltipHolder" + _local_2)]);
        }

        private function mouseOverClassBtn(_arg_1:MouseEvent=null):*
        {
            _arg_1.currentTarget.gotoAndStop(2);
            var _local_2:uint = _arg_1.currentTarget.thisType;
            var _local_3:* = this.CLASS_SKILL_ARR[(_local_2 - 1)];
            var _local_4:* = SkillLibrary.getSkillInfo(_local_3);
            var _local_5:* = -1;
            if (_local_3 == "skill_4000")
            {
                _local_5 = (1000 + ((int(Character.character_lvl) - 60) * 70));
                this.tooltip.healTxt.text = _local_5;
                Character.recolor(this.tooltip.healTxt, 0xFF00);
            }
            else
            {
                if (_local_3 == "skill_4004")
                {
                    _local_5 = (700 + ((int(Character.character_lvl) - 60) * 64));
                    this.tooltip.healTxt.text = _local_5;
                    Character.recolor(this.tooltip.healTxt, 0xFF0000);
                }
                else
                {
                    this.tooltip.healTxt.text = "-";
                    Character.recolor(this.tooltip.healTxt, 0xFFFFFF);
                };
            };
            this.tooltip.classMC.gotoAndStop((_local_2 + 1));
            this.tooltip.cooldownTxt.text = "-";
            this.tooltip.skillNameTxt.text = _local_4.skill_name;
            this.tooltip.currskillTxt.text = _local_4.skill_description.replace("[valamount]", _local_5);
            if (_local_2 != 5)
            {
                this.tooltip.damageIcon.visible = true;
                this.tooltip.healIcon.visible = false;
            }
            else
            {
                this.tooltip.damageIcon.visible = false;
                this.tooltip.healIcon.visible = true;
            };
            this.loadSkill(_local_3);
            this.panelMC.panel.finishAni.classSelectionMC.panelMC[("tooltipHolder" + _local_2)].addChild(this.tooltip);
        }

        private function loadSkill(_arg_1:*):*
        {
            this.swfName = _arg_1;
            var _local_2:* = this.loader.add((("skills/" + _arg_1) + ".swf"), {"id":_arg_1});
            _local_2.addEventListener(BulkLoader.COMPLETE, this.onSkillLoaded);
            this.loader.start();
        }

        private function onSkillLoaded(_arg_1:Event):*
        {
            _arg_1.target.removeEventListener(BulkLoader.COMPLETE, this.onSkillLoaded);
            _arg_1.target.content[this.swfName].gotoAndStop(1);
            var _local_2:* = _arg_1.target.content["icon"];
            this.tooltip.iconMC.gotoAndStop("enable");
            this.tooltip.iconMC.iconHolder.addChild(_local_2);
        }

        private function showConfirmationClass(e:MouseEvent):*
        {
            var target:* = e.currentTarget.name.replace("select_", "");
            this.confirmation = new Confirmation();
            var name:* = this.CLASS_NAME_ARR[(this.selected_class - 1)];
            this.confirmation.txtMc.txt.text = (("Are you sure to become a member of " + name) + " ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.continueExamScroll);
            this.panelMC.addChild(this.confirmation);
        }

        private function continueExamScroll(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.panelMC.panel.finishAni.classSelectionMC.visible = false;
            this.panelMC.panel.finishAni.iconMC.gotoAndStop(("class" + this.selected_class));
            this.panelMC.panel.finishAni.gotoAndPlay(230);
        }

        private function confirmExamScroll():*
        {
            this.panelMC.panel.finishAni.stop();
            this.main.initButton(this.panelMC.panel.finishAni.btnGo, this.closeExamScroll, "Confirm");
        }

        private function closeExamScroll(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.finishAni.visible = false;
            this.panelMC.panel.rewardAni.visible = true;
            this.panelMC.panel.rewardAni.gotoAndPlay("idle");
            this.panelMC.panel.rewardAni.addFrameScript(7, this.onShowReward, 39, this.onCloseReward);
        }

        private function onShowReward():*
        {
            this.panelMC.panel.rewardAni.stop();
            this.panelMC.panel.rewardAni.panelMC.iconMC1.gotoAndStop(this.selected_class);
            this.panelMC.panel.rewardAni.panelMC.iconMC3.gotoAndStop(String(Character.character_gender));
            this.main.initButton(this.panelMC.panel.rewardAni.panelMC.btnGo, this.closeReward, "Confirm");
            this.eventHandler.addListener(this.panelMC.panel.rewardAni.panelMC.btnGo, MouseEvent.CLICK, this.closeReward, false, 0, true);
        }

        private function closeReward(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.rewardAni.gotoAndPlay("exit");
        }

        private function onCloseReward():*
        {
            this.panelMC.panel.rewardAni.gotoAndStop("idle");
            this.panelMC.panel.rewardAni.visible = false;
            this.sendAmfReward();
        }

        private function sendAmfReward():*
        {
            this.main.amf_manager.service("SpecialJouninExam.promoteToSpecialJounin", [Character.sessionkey, Character.char_id, this.CLASS_SKILL_ARR[(this.selected_class - 1)]], this.amfRewardRes);
        }

        private function amfRewardRes(_arg_1:Object=null):*
        {
            if (_arg_1.status == 1)
            {
                Character.updateSkills("skill_345", true);
                Character.addSet(("set_588_" + Character.character_gender));
                Character.character_rank = "7";
                Character.character_class = this.CLASS_SKILL_ARR[(this.selected_class - 1)];
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function mouseClick(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrameLabel == "locked")
            {
                _arg_1.currentTarget.gotoAndStop("locked");
            }
            else
            {
                _arg_1.currentTarget.gotoAndStop("selected");
            };
            this.setRightPanel(_arg_1.currentTarget.name);
        }

        private function mouseOver(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrameLabel == "locked")
            {
                _arg_1.currentTarget.gotoAndStop("locked");
            };
            if (_arg_1.currentTarget.currentFrameLabel != "selected")
            {
                _arg_1.currentTarget.gotoAndStop("mover");
            };
        }

        private function mouseOut(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrameLabel == "locked")
            {
                _arg_1.currentTarget.gotoAndStop("locked");
            };
            if (_arg_1.currentTarget.currentFrameLabel != "selected")
            {
                _arg_1.currentTarget.gotoAndStop("enable");
            };
        }

        private function onExit(_arg_1:MouseEvent):*
        {
            this.panelMC.gotoAndPlay("exit");
        }

        private function frame41():*
        {
            this.panelMC.panel.stageMc.addFrameScript(0, this.stage1Desc, 1, this.stage2Desc, 4, this.stage3Desc, 9, this.stage4Desc, 12, this.stage5Desc, 16, this.stage6Desc, 26, this.stageFrame27);
            this.eventHandler.addListener(this.panelMC.panel.btnClose, MouseEvent.CLICK, this.onExit);
            this.panelMC.panel.rewardAni.visible = false;
            this.panelMC.panel.finishAni.visible = false;
            this.panelMC.panel.helpPanel.visible = false;
            this.panelMC.panel.stageMc.maskMC.visible = false;
            this.panelMC.panel.timerMC.visible = false;
            this.panelMC.panel.stageMc.titleMC.dateTxt.visible = false;
            this.panelMC.panel.rightPanel.visible = false;
            this.panelMC.panel.stageMc.titleMC.tabMC.visible = false;
            this.panelMC.panel.stageMc.titleMC.gotoAndStop("hard1");
            if (this.spjounin[12].status == 2)
            {
                this.showExamPassed();
            };
        }

        internal function stage1Desc():*
        {
            this.panelMC.panel.stageMc.stage1.bgMC.gotoAndStop("stage1");
            this.panelMC.panel.stageMc.stage1.comeTxt.text = "Intelligence Division";
            this.panelMC.panel.stageMc.stage1.descTxt.text = "Stage 1";
            this.panelMC.panel.stageMc.stage1.tickMC.visible = false;
            this.panelMC.panel.stageMc.stage1.gotoAndStop("enable");
        }

        internal function stage2Desc():*
        {
            this.panelMC.panel.stageMc.stage2.bgMC.gotoAndStop("stage2");
            this.panelMC.panel.stageMc.stage2.comeTxt.text = "Surprise Attack Division";
            this.panelMC.panel.stageMc.stage2.descTxt.text = "Stage 2";
            this.panelMC.panel.stageMc.stage2.tickMC.visible = false;
            this.panelMC.panel.stageMc.stage2.gotoAndStop("enable");
        }

        internal function stage3Desc():*
        {
            this.panelMC.panel.stageMc.stage3.bgMC.gotoAndStop("stage3");
            this.panelMC.panel.stageMc.stage3.comeTxt.text = "Sensor Division";
            this.panelMC.panel.stageMc.stage3.descTxt.text = "Stage 3";
            this.panelMC.panel.stageMc.stage3.tickMC.visible = false;
            this.panelMC.panel.stageMc.stage3.gotoAndStop("enable");
        }

        internal function stage4Desc():*
        {
            this.panelMC.panel.stageMc.stage4.bgMC.gotoAndStop("stage4");
            this.panelMC.panel.stageMc.stage4.comeTxt.text = "Heavy Attack Division";
            this.panelMC.panel.stageMc.stage4.descTxt.text = "Stage 4";
            this.panelMC.panel.stageMc.stage4.tickMC.visible = false;
            this.panelMC.panel.stageMc.stage4.gotoAndStop("enable");
        }

        internal function stage5Desc():*
        {
            this.panelMC.panel.stageMc.stage5.bgMC.gotoAndStop("stage5");
            this.panelMC.panel.stageMc.stage5.comeTxt.text = "Medical Division";
            this.panelMC.panel.stageMc.stage5.descTxt.text = "Stage 5";
            this.panelMC.panel.stageMc.stage5.tickMC.visible = false;
            this.panelMC.panel.stageMc.stage5.gotoAndStop("enable");
        }

        internal function stage6Desc():*
        {
            this.panelMC.panel.stageMc.stage6.bgMC.gotoAndStop("stage6");
            this.panelMC.panel.stageMc.stage6.comeTxt.text = "Vadar, The Finale";
            this.panelMC.panel.stageMc.stage6.descTxt.text = "Stage 6";
            this.panelMC.panel.stageMc.stage6.tickMC.visible = false;
            this.panelMC.panel.stageMc.stage6.gotoAndStop("enable");
        }

        private function frame48():*
        {
            this.panelMC.stop();
        }

        private function frame81():*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.panelMC.stop();
            this.main.handleVillageHUDVisibility(true);
            this.loader.removeAll();
            this.loader.clear();
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.main.clearEvents();
            this.main = null;
            this.eventHandler = null;
            this.tooltip = null;
            this.curr_stage = null;
            this.curr_chapter = null;
            this.confirmation = null;
            this.loader = null;
            this.swfName = null;
            this.selected_class = null;
            GF.clearArray(this.spjounin);
            GF.clearArray(this.CLASS_BTN_NAME_ARR);
            GF.clearArray(this.CLASS_SKILL_ARR);
            GF.clearArray(this.CLASS_NAME_ARR);
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

