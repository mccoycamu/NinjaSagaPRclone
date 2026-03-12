// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ChuninExam

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public class ChuninExam extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var target:int;
        private var eventHandler:EventHandler;

        public function ChuninExam(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.main.loading(true);
            this.getData();
        }

        public function getData():void
        {
            this.main.amf_manager.service("ChuninExam.getData", [Character.sessionkey, Character.char_id], this.onGetChuninData);
        }

        public function onGetChuninData(_arg_1:Object):void
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.panel.chunin_data = _arg_1.data;
                this.panelMC.panel.rightPanel.visible = false;
                this.eventHandler.addListener(this.panelMC.panel.btnClose, MouseEvent.CLICK, this.closePanel);
                this.panelMC.panel.btnClaim.visible = false;
                _local_2 = true;
                _local_3 = 0;
                while (_local_3 < 5)
                {
                    this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].gotoAndStop(1);
                    if (this.panelMC.panel.chunin_data[_local_3].status == "2")
                    {
                        this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].tickMC.visible = true;
                        this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].buttonMode = true;
                        this.eventHandler.addListener(this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))], MouseEvent.MOUSE_OVER, this.over);
                        this.eventHandler.addListener(this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))], MouseEvent.MOUSE_OUT, this.out);
                        this.eventHandler.addListener(this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))], MouseEvent.CLICK, this.click);
                    }
                    else
                    {
                        if (this.panelMC.panel.chunin_data[_local_3].status == "1")
                        {
                            _local_2 = false;
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].tickMC.visible = false;
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].buttonMode = true;
                            this.eventHandler.addListener(this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))], MouseEvent.MOUSE_OVER, this.over);
                            this.eventHandler.addListener(this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))], MouseEvent.MOUSE_OUT, this.out);
                            this.eventHandler.addListener(this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))], MouseEvent.CLICK, this.click);
                        }
                        else
                        {
                            _local_2 = false;
                            this.panelMC.panel[("stage" + String((int(_local_3) + int(1))))].gotoAndStop(4);
                        };
                    };
                    _local_3++;
                };
                if (((_local_2) && (this.panelMC.panel.chunin_data[0].claimed == "0")))
                {
                    this.panelMC.panel.btnClaim.visible = true;
                    this.eventHandler.addListener(this.panelMC.panel.btnClaim, MouseEvent.CLICK, this.promoteToChunin);
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
            if (this.panelMC.panel.chunin_data[(_arg_1 - 1)].status == "2")
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
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage I - Written Test";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "To be promoted to Chunin, you need to pass a series of tests and exams. The first round is a written test.";
                    break;
                case 2:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage II - Scroll War";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Don't forget to recruit your teammates before you start your next exam.";
                    break;
                case 3:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage III - Arena";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "The third exam is to finish a 1vs1 battle you will fight with other ninja candidates. Note: No teammates can go inside the Tower with you!";
                    break;
                case 4:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage IV - Team Battle";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Team cooperation is very important. The final exam is to test your teamwork.";
                    break;
                case 5:
                    this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage V - Finale";
                    this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Help Shin and Genzu to defeat Kojima and save Ken. Note: No teammates can go inside with you!";
            };
            this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.btnStart, MouseEvent.CLICK, this.startStage);
        }

        public function promoteToChunin(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.visible = false;
            this.main.loading(true);
            this.main.amf_manager.service("ChuninExam.promoteToChunin", [Character.sessionkey, Character.char_id], this.onPromoteChuninRes);
        }

        public function onPromoteChuninRes(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status > 0)
            {
                if (_arg_1.status == 1)
                {
                    this.main.makeChunin(_arg_1.rewards);
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

        public function startStage(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ChuninExam.startStage", [Character.sessionkey, Character.char_id, this.target], this.onStageStartRes);
        }

        public function onStageStartRes(_arg_1:Object):void
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
                        this.main.loadStage("stage1");
                    }
                    else
                    {
                        if (_arg_1.result == "start_stage_2")
                        {
                            this.main.loadStage("stage2");
                        }
                        else
                        {
                            if (_arg_1.result == "start_stage_3")
                            {
                                this.main.loadStage("stage3");
                            }
                            else
                            {
                                if (_arg_1.result == "start_stage_4")
                                {
                                    this.main.loadStage("stage4");
                                }
                                else
                                {
                                    if (_arg_1.result == "start_stage_5")
                                    {
                                        this.main.loadStage("stage5");
                                    };
                                };
                            };
                        };
                    };
                    this.destroy();
                };
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

        public function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.target = null;
            this.main = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

