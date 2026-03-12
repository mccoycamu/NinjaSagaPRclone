// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.JouninExam

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public class JouninExam extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var main:*;
        public var target:int;
        public var response:Object;

        public function JouninExam(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.getData();
        }

        public function getData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("JouninExam.getData", [Character.sessionkey, Character.char_id], this.onGetJouninData);
        }

        public function onGetJouninData(_arg_1:Object):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1.data;
                this.panelMC.panel.rightPanel.visible = false;
                this.panelMC.panel.parent_mc = this;
                this.panelMC.panel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanel);
                this.panelMC.panel.btnClaim.visible = false;
                _local_2 = true;
                _local_3 = 0;
                while (_local_3 < this.response.length)
                {
                    this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].gotoAndStop(1);
                    if (this.response[_local_3].status == "2")
                    {
                        this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].tickMC.visible = true;
                        this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].buttonMode = true;
                        this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].addEventListener(MouseEvent.MOUSE_OVER, this.over);
                        this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].addEventListener(MouseEvent.MOUSE_OUT, this.out);
                        this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].addEventListener(MouseEvent.CLICK, this.click);
                    }
                    else
                    {
                        if (this.response[_local_3].status == "1")
                        {
                            _local_2 = false;
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].tickMC.visible = false;
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].buttonMode = true;
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].addEventListener(MouseEvent.MOUSE_OVER, this.over);
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].addEventListener(MouseEvent.MOUSE_OUT, this.out);
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].addEventListener(MouseEvent.CLICK, this.click);
                        }
                        else
                        {
                            _local_2 = false;
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].gotoAndStop(4);
                        };
                    };
                    _local_3++;
                };
                if (((_local_2) && (this.response[0].claimed == "0")))
                {
                    this.panelMC.panel.btnClaim.visible = true;
                    this.panelMC.panel.btnClaim.addEventListener(MouseEvent.CLICK, this.promoteToJounin);
                };
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        internal function over(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame != 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        internal function out(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame != 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        internal function click(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.gotoAndStop(3);
            this.target = int(_arg_1.currentTarget.name.replace("stage", ""));
            this.panelMC.panel.rightPanel.visible = true;
            this.panelMC.panel.rightPanel.tabMc.gotoAndStop(this.target);
            this.setRightPanel(this.target);
        }

        internal function setRightPanel(_arg_1:int):void
        {
            if (this.response[(_arg_1 - 1)].status == "2")
            {
                this.panelMC.panel.rightPanel.tabMc.btnStart.visible = false;
                this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
            }
            else
            {
                this.panelMC.panel.rightPanel.tabMc.btnStart.visible = true;
                this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
            };
            switch (_arg_1)
            {
                case 1:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage I - Hand Seals";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "To be promoted to Jounin, you need to pass a series of tests and exams. First test: can you learn a jutsu quickly?";
                    break;
                case 2:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage II - Shinobi Tower";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Reach the top of the Tower. Note: Team mates aren't allowed to go inside of the tower with you.";
                    break;
                case 3:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage III - The Kekkai";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Unseal all the Kekkai in the forest.";
                    break;
                case 4:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage IV - The Elements";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Lead your team and challenge the Shinkigami of Elements!";
                    break;
                case 5:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage V - The Orochi";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Hunt Orochi the Yamata No Orochi. Advice: Make sure you recruit 2 team mates to assist you in this mission. Mission Complete upon capture of the Giant Snake (only).";
            };
            this.panelMC.panel.rightPanel.tabMc.btnStart.addEventListener(MouseEvent.CLICK, this.startStage);
        }

        public function promoteToJounin(_arg_1:MouseEvent):*
        {
            _arg_1.currentTarget.visible = false;
            this.main.loading(true);
            this.main.amf_manager.service("JouninExam.promoteToJounin", [Character.sessionkey, Character.char_id], this.onPromoteJouninRes);
        }

        public function onPromoteJouninRes(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status > 0)
            {
                if (_arg_1.status == 1)
                {
                    this.main.makeJounin(_arg_1.rewards);
                }
                else
                {
                    this.main.getNotice(_arg_1.result);
                };
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        public function startStage(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("JouninExam.startStage", [Character.sessionkey, Character.char_id, (int(this.target) + 5)], this.onStageStartRes);
        }

        public function onStageStartRes(_arg_1:Object):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = _arg_1.hash;
                _local_3 = _arg_1.result.split("_");
                if (int(this.target) == int(_local_3[2]))
                {
                    if (_arg_1.result == "start_stage_1")
                    {
                        this.main.loadJouninStage("stage1");
                        this.destroy();
                    }
                    else
                    {
                        if (_arg_1.result == "start_stage_2")
                        {
                            this.main.loadJouninStage("stage2");
                            this.destroy();
                        }
                        else
                        {
                            if (_arg_1.result == "start_stage_3")
                            {
                                this.main.loadJouninStage("stage3");
                                this.destroy();
                            }
                            else
                            {
                                if (_arg_1.result == "start_stage_4")
                                {
                                    this.main.loadJouninStage("stage4");
                                    this.destroy();
                                }
                                else
                                {
                                    if (_arg_1.result == "start_stage_5")
                                    {
                                        this.main.loadJouninStage("stage5");
                                        this.destroy();
                                    };
                                };
                            };
                        };
                    };
                };
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.panelMC.panel.btnClose.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.panelMC.panel.stage1.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.panelMC.panel.stage1.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.panelMC.panel.stage1.removeEventListener(MouseEvent.CLICK, this.click);
            this.panelMC.panel.rightPanel.tabMc.btnStart.removeEventListener(MouseEvent.CLICK, this.startStage);
            this.target = null;
            this.main = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

