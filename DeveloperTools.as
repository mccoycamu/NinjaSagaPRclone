// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.DeveloperTools

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import Storage.GameData;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class DeveloperTools extends MovieClip 
    {

        public var btn_spoiler_clan:SimpleButton;
        public var btn_spoiler_sw:SimpleButton;
        public var spoilerMC:MovieClip;
        public var spoilerSWMC:MovieClip;
        public var addBtn:SimpleButton;
        public var closeBtn:SimpleButton;
        public var setBtn:SimpleButton;
        public var changeBtn:SimpleButton;
        public var itemTxt:TextField;
        public var levelTxt:TextField;
        public var rankTxt:TextField;
        public var emblemMc:MovieClip;
        private var main:*;
        private var eventHandler:*;
        private var itemStringHolder:*;
        private var levelHolder:*;
        private var rankHolder:*;

        public function DeveloperTools(_arg_1:*)
        {
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.initUI();
        }

        private function initUI():*
        {
            this.spoilerMC.visible = false;
            this.spoilerSWMC.visible = false;
            this.emblemMc.gotoAndStop((Character.account_type + 1));
            this.eventHandler.addListener(this.addBtn, MouseEvent.CLICK, this.sendAmfItem, false, 0, true);
            this.eventHandler.addListener(this.setBtn, MouseEvent.CLICK, this.sendAmfLevelRank, false, 0, true);
            this.eventHandler.addListener(this.changeBtn, MouseEvent.CLICK, this.changeCharacter, false, 0, true);
            this.eventHandler.addListener(this.closeBtn, MouseEvent.CLICK, this.closePanel, false, 0, true);
            this.eventHandler.addListener(this.emblemMc, MouseEvent.CLICK, this.setEmblem, false, 0, true);
            this.eventHandler.addListener(this.btn_spoiler_clan, MouseEvent.CLICK, this.handleSpoilerClan, false, 0, true);
            this.eventHandler.addListener(this.btn_spoiler_sw, MouseEvent.CLICK, this.handleSpoilerSW, false, 0, true);
            this.eventHandler.addListener(this.spoilerMC.btn_close, MouseEvent.CLICK, this.closeSpoiler, false, 0, true);
            this.eventHandler.addListener(this.spoilerSWMC.btn_close, MouseEvent.CLICK, this.closeSpoilerSW, false, 0, true);
            this.emblemMc.buttonMode = true;
        }

        private function sendAmfItem(_arg_1:MouseEvent):*
        {
            this.itemStringHolder = this.itemTxt.text;
            this.main.amf_manager.service("CharacterService.addItems", [Character.char_id, Character.sessionkey, this.itemStringHolder], this.sendAmfItemResponse);
        }

        private function sendAmfItemResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                Character.addRewards(_arg_1.items);
                this.main.giveReward(1, _arg_1.items);
                if ((("HUD" in this.main) && (this.main.HUD)))
                {
                    this.main.HUD.setBasicData();
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

        private function sendAmfLevelRank(_arg_1:MouseEvent):*
        {
            this.levelHolder = this.levelTxt.text;
            this.rankHolder = this.rankTxt.text;
            this.main.amf_manager.service("CharacterService.setCharInfo", [Character.char_id, Character.sessionkey, this.levelHolder, this.rankHolder], this.sendAmfLevelRankResponse);
        }

        private function sendAmfLevelRankResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                Character.character_lvl = this.levelHolder;
                Character.character_rank = this.rankHolder;
                if ((("HUD" in this.main) && (this.main.HUD)))
                {
                    this.main.HUD.loadFrame();
                    this.main.HUD.setBasicData();
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

        private function changeCharacter(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.CharacterSelect");
            this.destroy();
        }

        private function setEmblem(_arg_1:MouseEvent):*
        {
            this.main.amf_manager.service("CharacterService.toggleEmblem", [Character.char_id, Character.sessionkey], this.setEmblemResponse);
        }

        private function setEmblemResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                if (Character.account_type == 0)
                {
                    Character.account_type = 1;
                }
                else
                {
                    Character.account_type = 0;
                };
                this.main.showMessage(_arg_1.result);
                this.emblemMc.gotoAndStop((Character.account_type + 1));
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.status);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function handleSpoilerClan(_arg_1:MouseEvent):void
        {
            var _local_3:int;
            var _local_4:String;
            var _local_5:OutfitManager;
            this.spoilerMC.visible = true;
            this.main.handleVillageHUDVisibility(false);
            var _local_2:Array = GameData.get("cwsw").clan;
            _local_3 = 0;
            while (_local_3 < 5)
            {
                _local_4 = "0";
                this.spoilerMC[("char_mc" + _local_3)].icon.visible = false;
                if (_local_2[_local_3].accessory)
                {
                    this.spoilerMC[("char_mc" + _local_3)].icon.visible = true;
                    this.spoilerMC[("char_mc" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerMC[("char_mc" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerMC[("char_mc" + _local_3)].icon, _local_2[_local_3].accessory);
                };
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerMC[("char_mc" + _local_3)], _local_2[_local_3].weapon, _local_2[_local_3].back, _local_2[_local_3].set.replace("%s", _local_4), _local_2[_local_3].hair.replace("%s", _local_4), ("face_01_" + _local_4));
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < 5)
            {
                _local_4 = "1";
                this.spoilerMC[("char_mc" + (_local_3 + 5))].icon.visible = false;
                if (_local_2[_local_3].accessory)
                {
                    this.spoilerMC[("char_mc" + (_local_3 + 5))].icon.visible = true;
                    this.spoilerMC[("char_mc" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerMC[("char_mc" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerMC[("char_mc" + (_local_3 + 5))].icon, _local_2[_local_3].accessory);
                };
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerMC[("char_mc" + (_local_3 + 5))], _local_2[_local_3].weapon, _local_2[_local_3].back, _local_2[_local_3].set.replace("%s", _local_4), _local_2[_local_3].hair.replace("%s", _local_4), ("face_01_" + _local_4));
                _local_3++;
            };
        }

        private function closeSpoiler(_arg_1:MouseEvent):void
        {
            this.main.handleVillageHUDVisibility(true);
            this.spoilerMC.visible = false;
        }

        private function handleSpoilerSW(_arg_1:MouseEvent):void
        {
            var _local_3:int;
            var _local_4:String;
            var _local_5:OutfitManager;
            var _local_6:String;
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            this.spoilerSWMC.visible = true;
            this.main.handleVillageHUDVisibility(false);
            var _local_2:Object = GameData.get("cwsw").sw;
            _local_3 = 0;
            while (_local_3 < 4)
            {
                this.spoilerSWMC[("char_mc_ab" + _local_3)].icon.visible = false;
                if (_local_2.all_squad[_local_3].accessory)
                {
                    this.spoilerSWMC[("char_mc_ab" + _local_3)].icon.visible = true;
                    this.spoilerSWMC[("char_mc_ab" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerSWMC[("char_mc_ab" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerSWMC[("char_mc_ab" + _local_3)].icon, _local_2.all_squad[_local_3].accessory);
                };
                _local_4 = "0";
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerSWMC[("char_mc_ab" + _local_3)], _local_2.all_squad[_local_3].weapon, _local_2.all_squad[_local_3].back, _local_2.all_squad[_local_3].set.replace("%s", _local_4), _local_2.all_squad[_local_3].hair.replace("%s", _local_4), ("face_01_" + _local_4));
                this.spoilerSWMC[("char_mc_ag" + _local_3)].icon.visible = false;
                if (_local_2.all_squad[_local_3].accessory)
                {
                    this.spoilerSWMC[("char_mc_ag" + _local_3)].icon.visible = true;
                    this.spoilerSWMC[("char_mc_ag" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerSWMC[("char_mc_ag" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerSWMC[("char_mc_ag" + _local_3)].icon, _local_2.all_squad[_local_3].accessory);
                };
                _local_6 = "1";
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerSWMC[("char_mc_ag" + _local_3)], _local_2.all_squad[_local_3].weapon, _local_2.all_squad[_local_3].back, _local_2.all_squad[_local_3].set.replace("%s", _local_6), _local_2.all_squad[_local_3].hair.replace("%s", _local_6), ("face_01_" + _local_6));
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < 2)
            {
                this.spoilerSWMC[("char_mc_wb" + _local_3)].icon.visible = false;
                if (_local_2.winner_squad[_local_3].accessory)
                {
                    this.spoilerSWMC[("char_mc_wb" + _local_3)].icon.visible = true;
                    this.spoilerSWMC[("char_mc_wb" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerSWMC[("char_mc_wb" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerSWMC[("char_mc_wb" + _local_3)].icon, _local_2.winner_squad[_local_3].accessory);
                };
                _local_4 = "0";
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerSWMC[("char_mc_wb" + _local_3)], _local_2.winner_squad[_local_3].weapon, _local_2.winner_squad[_local_3].back, _local_2.winner_squad[_local_3].set.replace("%s", _local_4), _local_2.winner_squad[_local_3].hair.replace("%s", _local_4), ("face_01_" + _local_4));
                this.spoilerSWMC[("char_mc_wg" + _local_3)].icon.visible = false;
                if (_local_2.winner_squad[_local_3].accessory)
                {
                    this.spoilerSWMC[("char_mc_wg" + _local_3)].icon.visible = true;
                    this.spoilerSWMC[("char_mc_wg" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerSWMC[("char_mc_wg" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerSWMC[("char_mc_wg" + _local_3)].icon, _local_2.winner_squad[_local_3].accessory);
                };
                _local_6 = "1";
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerSWMC[("char_mc_wg" + _local_3)], _local_2.winner_squad[_local_3].weapon, _local_2.winner_squad[_local_3].back, _local_2.winner_squad[_local_3].set.replace("%s", _local_6), _local_2.winner_squad[_local_3].hair.replace("%s", _local_6), ("face_01_" + _local_6));
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < 2)
            {
                this.spoilerSWMC[("char_mc_gb" + _local_3)].icon.visible = false;
                if (_local_2.global_rank[_local_3].accessory)
                {
                    this.spoilerSWMC[("char_mc_gb" + _local_3)].icon.visible = true;
                    this.spoilerSWMC[("char_mc_gb" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerSWMC[("char_mc_gb" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerSWMC[("char_mc_gb" + _local_3)].icon, _local_2.global_rank[_local_3].accessory);
                };
                _local_4 = "0";
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerSWMC[("char_mc_gb" + _local_3)], _local_2.global_rank[_local_3].weapon, _local_2.global_rank[_local_3].back, _local_2.global_rank[_local_3].set.replace("%s", _local_4), _local_2.global_rank[_local_3].hair.replace("%s", _local_4), ("face_01_" + _local_4));
                this.spoilerSWMC[("char_mc_gg" + _local_3)].icon.visible = false;
                if (_local_2.global_rank[_local_3].accessory)
                {
                    this.spoilerSWMC[("char_mc_gg" + _local_3)].icon.visible = true;
                    this.spoilerSWMC[("char_mc_gg" + _local_3)].icon.ownedTxt.visible = false;
                    this.spoilerSWMC[("char_mc_gg" + _local_3)].icon.amtTxt.visible = false;
                    NinjaSage.loadItemIcon(this.spoilerSWMC[("char_mc_gg" + _local_3)].icon, _local_2.global_rank[_local_3].accessory);
                };
                _local_6 = "1";
                _local_5 = new OutfitManager();
                _local_5.fillOutfit(this.spoilerSWMC[("char_mc_gg" + _local_3)], _local_2.global_rank[_local_3].weapon, _local_2.global_rank[_local_3].back, _local_2.global_rank[_local_3].set.replace("%s", _local_6), _local_2.global_rank[_local_3].hair.replace("%s", _local_6), ("face_01_" + _local_6));
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < 3)
            {
                _local_7 = _local_2.all_squad[_local_3].weapon;
                _local_8 = _local_2.all_squad[_local_3].back;
                _local_9 = _local_2.all_squad[_local_3].accessory;
                if (_local_7 != null)
                {
                    this.spoilerSWMC[("b" + _local_3)].gotoAndStop("wpn");
                    this.spoilerSWMC[("g" + _local_3)].gotoAndStop("wpn");
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this.spoilerSWMC[("b" + _local_3)].gotoAndStop("back");
                        this.spoilerSWMC[("g" + _local_3)].gotoAndStop("back");
                    }
                    else
                    {
                        if (_local_9 != null)
                        {
                            this.spoilerSWMC[("b" + _local_3)].gotoAndStop("acc");
                            this.spoilerSWMC[("g" + _local_3)].gotoAndStop("acc");
                        };
                    };
                };
                _local_3++;
            };
            _local_7 = _local_2.winner_squad[0].weapon;
            _local_8 = _local_2.winner_squad[0].back;
            _local_9 = _local_2.winner_squad[0].accessory;
            if (_local_7 != null)
            {
                this.spoilerSWMC["bw0"].gotoAndStop("wpn");
                this.spoilerSWMC["gw0"].gotoAndStop("wpn");
            }
            else
            {
                if (_local_8 != null)
                {
                    this.spoilerSWMC["bw0"].gotoAndStop("back");
                    this.spoilerSWMC["gw0"].gotoAndStop("back");
                }
                else
                {
                    if (_local_9 != null)
                    {
                        this.spoilerSWMC["bw0"].gotoAndStop("acc");
                        this.spoilerSWMC["gw0"].gotoAndStop("acc");
                    };
                };
            };
            _local_3 = 0;
            while (_local_3 < 2)
            {
                _local_7 = _local_2.global_rank[_local_3].weapon;
                _local_8 = _local_2.global_rank[_local_3].back;
                _local_9 = _local_2.global_rank[_local_3].accessory;
                if (_local_7 != null)
                {
                    this.spoilerSWMC[("bg" + _local_3)].gotoAndStop("wpn");
                    this.spoilerSWMC[("gg" + _local_3)].gotoAndStop("wpn");
                }
                else
                {
                    if (_local_8 != null)
                    {
                        this.spoilerSWMC[("bg" + _local_3)].gotoAndStop("back");
                        this.spoilerSWMC[("gg" + _local_3)].gotoAndStop("back");
                    }
                    else
                    {
                        if (_local_9 != null)
                        {
                            this.spoilerSWMC[("bg" + _local_3)].gotoAndStop("acc");
                            this.spoilerSWMC[("gg" + _local_3)].gotoAndStop("acc");
                        };
                    };
                };
                _local_3++;
            };
        }

        private function closeSpoilerSW(_arg_1:MouseEvent):void
        {
            this.main.handleVillageHUDVisibility(true);
            this.spoilerSWMC.visible = false;
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        private function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.main = null;
            this.eventHandler = null;
            this.itemStringHolder = null;
            this.levelHolder = null;
            this.rankHolder = null;
            GF.removeAllChild(this);
        }


    }
}//package Panels

