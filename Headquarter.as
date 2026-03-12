// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.Headquarter

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.Event;
    import com.utils.GF;
    import flash.system.System;

    public class Headquarter extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var head:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var CLASS_NAME_ARR:Array = ["Medical Class", "Sensor Class", "Intelligence Class", "Heavy Attack Class", "Surprise Attack Class"];

        public function Headquarter(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.main.handleVillageHUDVisibility(false);
            this.panelMC.addFrameScript(42, this.initUI);
        }

        public function initUI():void
        {
            var _local_2:*;
            this.panelMC.stop();
            this.panelMC.btn_apply.visible = false;
            this.panelMC.convertMc.visible = false;
            this.panelMC.rankMC.gotoAndStop(Character.character_rank);
            this.panelMC.txt_name.text = Character.character_name;
            this.panelMC.txt_id.text = Character.char_id;
            if (int(Character.character_rank) == 1)
            {
                this.panelMC.txt_rank.text = "Genin";
            }
            else
            {
                if (int(Character.character_rank) == 2)
                {
                    this.panelMC.txt_rank.text = "Chunin";
                }
                else
                {
                    if (int(Character.character_rank) == 3)
                    {
                        this.panelMC.txt_rank.text = "Tensai Chunin";
                    }
                    else
                    {
                        if (int(Character.character_rank) == 4)
                        {
                            this.panelMC.txt_rank.text = "Jounin";
                        }
                        else
                        {
                            if (int(Character.character_rank) == 5)
                            {
                                this.panelMC.txt_rank.text = "Tensai Jounin";
                            }
                            else
                            {
                                if (int(Character.character_rank) == 6)
                                {
                                    this.panelMC.txt_rank.text = "Special Jounin";
                                }
                                else
                                {
                                    if (int(Character.character_rank) == 7)
                                    {
                                        this.panelMC.txt_rank.text = "Tensai Special Jounin";
                                    }
                                    else
                                    {
                                        if (int(Character.character_rank) == 8)
                                        {
                                            this.panelMC.txt_rank.text = "Ninja Tutor";
                                        }
                                        else
                                        {
                                            if (int(Character.character_rank) == 9)
                                            {
                                                this.panelMC.txt_rank.text = "Senior Ninja Tutor";
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (Character.character_class != null)
            {
                this.panelMC.classMC.gotoAndStop(Character.character_class);
                _local_2 = Character.character_class.replace("skill_400", "");
                this.panelMC.txt_class.text = this.CLASS_NAME_ARR[_local_2];
            }
            else
            {
                this.panelMC.classMC.gotoAndStop("classNull");
                this.panelMC.txt_class.text = "Special Class Unavailable";
            };
            this.panelMC.element_1.gotoAndStop((int(Character.character_element_1) + 1));
            this.panelMC.element_2.gotoAndStop((int(Character.character_element_2) + 1));
            if (Character.account_type == 0)
            {
                this.panelMC.element_3.gotoAndStop(1);
            }
            else
            {
                this.panelMC.element_3.gotoAndStop((int(Character.character_element_3) + 1));
            };
            var _local_1:int = 1;
            while (_local_1 < 4)
            {
                if (this.panelMC[("element_" + _local_1)].currentFrame == 1)
                {
                    this.eventHandler.addListener(this.panelMC[("element_" + _local_1)], MouseEvent.CLICK, this.openAcademy);
                };
                _local_1++;
            };
            this.panelMC.txt_gold.text = Character.character_gold;
            this.panelMC.txt_token.text = Character.account_tokens;
            if (int(Character.account_type) == 0)
            {
                this.panelMC.btn_apply.visible = true;
                this.eventHandler.addListener(this.panelMC.btn_apply, MouseEvent.CLICK, this.goToSite1);
            };
            if (((int(Character.account_type) == 1) && (int(Character.emblem_duration) > 0)))
            {
                this.panelMC.btn_apply.visible = true;
                this.eventHandler.addListener(this.panelMC.btn_apply, MouseEvent.CLICK, this.goToSite1);
            };
            if (Character.account_type == 0)
            {
                this.panelMC.emblemMC.gotoAndStop(1);
                this.panelMC.emblemTxt.text = "Free User";
            }
            else
            {
                this.panelMC.emblemMC.gotoAndStop(2);
                this.panelMC.emblemTxt.text = "Ninja Emblem";
            };
            this.eventHandler.addListener(this.panelMC.btn_website, MouseEvent.CLICK, this.goToSite);
            this.eventHandler.addListener(this.panelMC.btn_info, MouseEvent.CLICK, this.infoProfile);
            this.eventHandler.addListener(this.panelMC.btn_convert, MouseEvent.CLICK, this.convertGold);
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.convertMc.btn_cvgold, MouseEvent.CLICK, this.convertAmf);
            this.head = this.main.getPlayerHead();
            this.head.scaleX = (this.head.scaleX * 2.1);
            this.head.scaleY = (this.head.scaleY * 2.1);
            this.panelMC.convertMc.insertedToken.restrict = "0-9.";
            this.panelMC["headHolder"].addChild(this.head);
        }

        public function goToSite(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://ninjasage.id/"));
        }

        public function goToSite1(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://ninjasage.id/merchants"));
        }

        public function convertGold(_arg_1:MouseEvent):void
        {
            this.panelMC.convertMc.visible = true;
            this.head.visible = false;
            this.panelMC.convertMc.gainedGold.text = 0;
            this.panelMC.convertMc.insertedToken.text = 0;
            this.panelMC.convertMc.ownedGold.text = Character.character_gold;
            this.panelMC.convertMc.ownedToken.text = Character.account_tokens;
            this.eventHandler.addListener(this.panelMC.convertMc.insertedToken, Event.CHANGE, this.convertToGold);
        }

        public function convertToGold(_arg_1:Event):void
        {
            var _local_2:Number = NaN;
            _local_2 = Number(this.panelMC.convertMc.insertedToken.text);
            if (this.panelMC.convertMc.insertedToken.text > 1000000)
            {
                this.main.getNotice("Maximum Convert is 1.000.000 Token");
                this.panelMC.convertMc.gainedGold.text = 0;
                this.panelMC.convertMc.insertedToken.text = 0;
                this.panelMC.convertMc.ownedToken.text = Character.account_tokens;
            }
            else
            {
                if (this.panelMC.convertMc.insertedToken.text > Character.account_tokens)
                {
                    this.main.getNotice("You Can't Convert More Than Your Owned Token");
                    this.panelMC.convertMc.gainedGold.text = 0;
                    this.panelMC.convertMc.insertedToken.text = 0;
                    this.panelMC.convertMc.ownedToken.text = Character.account_tokens;
                }
                else
                {
                    this.panelMC.convertMc.gainedGold.text = (int(this.panelMC.convertMc.insertedToken.text) * 1000);
                    this.panelMC.convertMc.ownedGold.text = (int(Character.character_gold) + int(this.panelMC.convertMc.gainedGold.text));
                    this.panelMC.convertMc.ownedToken.text = (int(Character.account_tokens) - int(this.panelMC.convertMc.insertedToken.text));
                };
            };
        }

        public function infoProfile(_arg_1:MouseEvent):void
        {
            this.panelMC.convertMc.visible = false;
            this.head.visible = true;
        }

        public function openAcademy(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Academy");
            this.destroy();
        }

        public function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function convertAmf(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.convertTokensToGold", [Character.sessionkey, Character.char_id, this.panelMC.convertMc.insertedToken.text], this.convertRes);
        }

        public function convertRes(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.getNotice("Your Token Has Been Converted to Gold!");
                this.panelMC.convertMc.gainedGold.text = 0;
                this.panelMC.convertMc.insertedToken.text = 0;
                this.panelMC.convertMc.ownedToken.text = _arg_1.account_tokens;
                this.panelMC.convertMc.ownedGold.text = _arg_1.character_gold;
                Character.character_gold = String(_arg_1.character_gold);
                Character.account_tokens = int(_arg_1.account_tokens);
                this.main.HUD.setBasicData();
            }
            else
            {
                this.main.getNotice("Please Insert At Least 1 Token!");
            };
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.main = null;
            this.eventHandler = null;
            this.CLASS_NAME_ARR = [];
            GF.removeAllChild(this.head);
            GF.removeAllChild(this.panelMC.headHolder);
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

