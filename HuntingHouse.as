// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.HuntingHouse

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.system.System;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import com.hurlant.crypto.Crypto;
    import flash.utils.ByteArray;
    import com.hurlant.util.Hex;

    public dynamic class HuntingHouse extends MovieClip 
    {

        private const price:int = 5;
        private const KARI_BADGE:String = "material_509";
        private const HARD_BOSS_REQUIREMENT:int = 10;
        private const EASY_BOSS_REQUIREMENT:int = 5;

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var bosses:Array;
        private var energy:int;
        private var amount:int = 1;
        private var cost:int = 0;
        private var bossIdx:int;
        private var response:Object;
        private var currentDif:String;
        private var currentZone:int;
        private var currentBoss:Array;

        public function HuntingHouse(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getData();
        }

        private function getData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("HuntingHouse.getData", [Character.char_id, Character.sessionkey], this.onGetDataResponse);
        }

        private function onGetDataResponse(_arg_1:Object=null):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.setWorldMap();
                this.initUI();
                if (!this.response.daily_claim)
                {
                    this.openDailyClaim();
                };
            }
            else
            {
                if (_arg_1.status > 1)
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

        private function initUI():*
        {
            this.main.handleVillageHUDVisibility(false);
            this.panelMC.panelMC.popupBuyItemMc.visible = false;
            this.panelMC.panelMC.bossDetailMc.visible = false;
            this.panelMC.panelMC.HuntingDarenMC.visible = false;
            this.panelMC.panelMC.dailyMc.visible = false;
            var _local_1:* = 1;
            while (_local_1 < 5)
            {
                this.panelMC.panelMC.WorldMapMc[("eventBoss" + _local_1)].visible = false;
                this.panelMC.panelMC.WorldMapMc[("eventBossBg" + _local_1)].visible = false;
                _local_1++;
            };
            this.panelMC.panelMC.titleTxt.text = "Hunting House";
            this.panelMC.panelMC.subTitle.text = "Click any Boss Icon to Start";
            this.panelMC.panelMC.lbl_recruited.text = "Team";
            this.panelMC.panelMC.recruitedTxt.text = (Character.character_recruit_ids.length + "/2");
            this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.panelMC.HuntingTicketTxt.text = this.response.material;
            this.main.initButton(this.panelMC.panelMC.getDailyItemBtn, this.openMenu, "");
            this.main.initButton(this.panelMC.panelMC.getMoreBtn, this.openMenu, "");
            this.main.initButton(this.panelMC.panelMC.getMoreItemBtn, this.openMenu, "Get More!");
            this.main.initButton(this.panelMC.panelMC.goForgePanelBtn, this.openMenu, "Material Bag");
            this.main.initButton(this.panelMC.panelMC.recruitFriendBtn, this.openMenu, "Recruit");
            this.eventHandler.addListener(this.panelMC.panelMC.btnClose, MouseEvent.CLICK, this.openMenu);
        }

        private function setWorldMap():*
        {
            var _local_1:* = 0;
            var _local_2:* = 0;
            var _local_3:* = this.panelMC.panelMC.WorldMapMc;
            while (_local_1 < 5)
            {
                if (((this.response.zones[_local_1].hardBoss == null) && (this.response.zones[_local_1].easyBoss == null)))
                {
                    _local_3[("EasyBoss" + int((_local_1 + 1)))].visible = false;
                    _local_3[("HardBoss" + int((_local_1 + 1)))].visible = false;
                }
                else
                {
                    if (((!(this.response.zones[_local_1].hardBoss == null)) && (this.response.zones[_local_1].easyBoss == null)))
                    {
                        _local_3[("EasyBoss" + int((_local_1 + 1)))].visible = false;
                        _local_3[("HardBoss" + int((_local_1 + 1)))].visible = true;
                        _local_3[("HardBoss" + int((_local_1 + 1)))].lvMc.lvLow.txt.text = String((int(Character.character_lvl) - 5));
                        _local_3[("HardBoss" + int((_local_1 + 1)))].lvMc.lvHigh.txt.text = String((int(Character.character_lvl) + 10));
                        this.main.initButton(_local_3[("HardBoss" + int((_local_1 + 1)))], this.openBossDetail, "");
                        NinjaSage.loadIconSWF("enemy", this.response.zones[_local_1].hardBoss[0], _local_3[("HardBoss" + int((_local_1 + 1)))].bossHolder1, "enemy_head");
                        NinjaSage.loadIconSWF("enemy", this.response.zones[_local_1].hardBoss[1], _local_3[("HardBoss" + int((_local_1 + 1)))].bossHolder2, "enemy_head");
                    }
                    else
                    {
                        if (((this.response.zones[_local_1].hardBoss == null) && (!(this.response.zones[_local_1].easyBoss == null))))
                        {
                            _local_3[("EasyBoss" + int((_local_1 + 1)))].visible = true;
                            _local_3[("HardBoss" + int((_local_1 + 1)))].visible = false;
                            _local_3[("EasyBoss" + int((_local_1 + 1)))].lvMc.lvLow.txt.text = String((int(Character.character_lvl) - 5));
                            _local_3[("EasyBoss" + int((_local_1 + 1)))].lvMc.lvHigh.txt.text = String((int(Character.character_lvl) + 10));
                            this.main.initButton(_local_3[("EasyBoss" + int((_local_1 + 1)))], this.openBossDetail, "");
                            NinjaSage.loadIconSWF("enemy", this.response.zones[_local_1].easyBoss[0], _local_3[("EasyBoss" + int((_local_1 + 1)))].bossHolder1, "enemy_head");
                        };
                    };
                };
                _local_1++;
            };
        }

        private function openBossDetail(_arg_1:MouseEvent):*
        {
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:int;
            var _local_9:*;
            this.panelMC.panelMC.bossDetailMc.visible = true;
            var _local_2:* = this.panelMC.panelMC.bossDetailMc.panel;
            var _local_3:* = _arg_1.currentTarget.name;
            var _local_4:int = undefined;
            if (_local_3.indexOf("HardBoss") != -1)
            {
                _local_2.gotoAndStop("hard");
                _local_5 = _local_3.replace("HardBoss", "");
                _local_4 = (_local_5 - 1);
                this.currentZone = int(_local_4);
                this.currentDif = "HardBoss";
                this.currentBoss = this.response["zones"][_local_4].hardBoss;
                _local_2.huntingPassMc.HuntingTicketTxt.text = String(this.HARD_BOSS_REQUIREMENT);
                _local_6 = 0;
                _local_7 = 0;
                while (_local_6 < 10)
                {
                    _local_8 = (_local_6 + (0 * 10));
                    while (_local_7 < 2)
                    {
                        _local_9 = this.response.bosses[this.currentBoss[_local_7]];
                        _local_2[("detailMc" + _local_7)].nameTxt.text = _local_9.name;
                        _local_2[("detailMc" + _local_7)].decTxt.text = _local_9.description;
                        _local_2[("detailMc" + _local_7)].goldMc.txt.text = String(((int(Character.character_lvl) * 220) / 50));
                        _local_2[("detailMc" + _local_7)].xpMc.txt.text = String(((int(Character.character_lvl) * 250) / 40));
                        _local_2[("detailMc" + _local_7)].lvMc.lvLow.txt.text = String((int(Character.character_lvl) - 5));
                        _local_2[("detailMc" + _local_7)].lvMc.lvHigh.txt.text = String((int(Character.character_lvl) + 10));
                        _local_2[("detailMc" + _local_7)].bgMc.gotoAndStop(_local_4);
                        if (_local_9.rewards.length > _local_8)
                        {
                            _local_2[("detailMc" + _local_7)][("item" + _local_6)].visible = true;
                            if (!_local_2[("detailMc" + _local_7)][("item" + _local_6)].holder.filled)
                            {
                                NinjaSage.loadItemIcon(_local_2[("detailMc" + _local_7)][("item" + _local_6)].holder, _local_9.rewards[_local_8], "icon");
                            };
                        }
                        else
                        {
                            _local_2[("detailMc" + _local_7)][("item" + _local_6)].visible = false;
                        };
                        _local_7++;
                    };
                    _local_6++;
                    _local_7 = 0;
                };
                NinjaSage.loadIconSWF("enemy", this.response["zones"][_local_4].hardBoss[0], _local_2["detailMc0"].bossHolder, "StatichuntingHouse");
                NinjaSage.loadIconSWF("enemy", this.response["zones"][_local_4].hardBoss[1], _local_2["detailMc1"].bossHolder, "StatichuntingHouse");
            }
            else
            {
                _local_2.gotoAndStop("easy");
                _local_5 = _local_3.replace("EasyBoss", "");
                _local_4 = (_local_5 - 1);
                this.currentZone = int(_local_4);
                this.currentDif = "EasyBoss";
                this.currentBoss = this.response["zones"][_local_4].easyBoss;
                _local_2.huntingPassMc.HuntingTicketTxt.text = String(this.EASY_BOSS_REQUIREMENT);
                _local_6 = 0;
                while (_local_6 < 10)
                {
                    _local_9 = this.response.bosses[this.currentBoss[0]];
                    _local_8 = (_local_6 + (0 * 10));
                    _local_2["detailMc0"].nameTxt.text = _local_9.name;
                    _local_2["detailMc0"].decTxt.text = _local_9.description;
                    _local_2["detailMc0"].goldMc.txt.text = String(((int(Character.character_lvl) * 220) / 50));
                    _local_2["detailMc0"].xpMc.txt.text = String(((int(Character.character_lvl) * 250) / 40));
                    _local_2["detailMc0"].lvMc.lvLow.txt.text = String((int(Character.character_lvl) - 5));
                    _local_2["detailMc0"].lvMc.lvHigh.txt.text = String((int(Character.character_lvl) + 10));
                    _local_2["detailMc0"].bgMc.gotoAndStop(_local_4);
                    if (_local_9.rewards.length > _local_8)
                    {
                        _local_2["detailMc0"][("item" + _local_6)].visible = true;
                        NinjaSage.loadItemIcon(_local_2["detailMc0"][("item" + _local_6)].holder, _local_9.rewards[_local_8], "icon");
                    }
                    else
                    {
                        _local_2["detailMc0"][("item" + _local_6)].visible = false;
                    };
                    _local_6++;
                };
                NinjaSage.loadIconSWF("enemy", this.response["zones"][_local_4].easyBoss[0], _local_2["detailMc0"].bossHolder, "StatichuntingHouse");
            };
            this.main.initButton(_local_2.attackBtn, this.startBattle, "Fight");
            this.eventHandler.addListener(_local_2.btnClose, MouseEvent.CLICK, this.closeBossDetail);
        }

        private function closeBossDetail(_arg_1:MouseEvent=null):*
        {
            this.panelMC.panelMC.bossDetailMc.visible = false;
            var _local_2:* = 0;
            var _local_3:* = 0;
            if (this.currentDif == "HardBoss")
            {
                while (_local_2 < 10)
                {
                    while (_local_3 < 2)
                    {
                        GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel[("detailMc" + _local_3)].bossHolder);
                        GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel[("detailMc" + _local_3)][("item" + _local_2)].holder);
                        this.panelMC.panelMC.bossDetailMc.panel[("detailMc" + _local_3)][("item" + _local_2)].holder.filled = false;
                        _local_3++;
                    };
                    _local_2++;
                    _local_3 = 0;
                };
            }
            else
            {
                _local_2 = 0;
                while (_local_2 < 10)
                {
                    GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel["detailMc0"].bossHolder);
                    GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel["detailMc0"][("item" + _local_2)].holder);
                    this.panelMC.panelMC.bossDetailMc.panel["detailMc0"][("item" + _local_2)].holder.filled = false;
                    _local_2++;
                };
            };
            System.gc();
        }

        private function openDailyClaim():*
        {
            this.panelMC.panelMC.dailyMc.visible = true;
            var _local_1:* = this.panelMC.panelMC.dailyMc;
            _local_1.amountTxt.text = ((Character.account_type == 1) ? "x10" : "x5");
            this.eventHandler.addListener(_local_1.claimBtn, MouseEvent.CLICK, this.claimDaily);
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closeDailyClaim);
        }

        private function claimDaily(_arg_1:MouseEvent):*
        {
            this.main.amf_manager.service("HuntingHouse.dailyClaim", [Character.char_id, Character.sessionkey], this.onClaimDaily);
        }

        private function onClaimDaily(_arg_1:Object):*
        {
            var _local_2:*;
            if (_arg_1.status == 1)
            {
                _local_2 = ((Character.account_type == 1) ? 10 : 5);
                Character.addMaterials(this.KARI_BADGE, _local_2);
                this.panelMC.panelMC.HuntingTicketTxt.text = _arg_1.material;
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
            this.closeDailyClaim();
        }

        private function closeDailyClaim(_arg_1:MouseEvent=null):*
        {
            this.panelMC.panelMC.dailyMc.visible = false;
            this.eventHandler.removeListener(this.panelMC.panelMC.dailyMc.btnClose, MouseEvent.CLICK, this.closeDailyClaim);
            this.eventHandler.removeListener(this.panelMC.panelMC.dailyMc.claimBtn, MouseEvent.CLICK, this.claimDaily);
        }

        private function openBadgeShop():*
        {
            this.panelMC.panelMC.popupBuyItemMc.visible = true;
            var _local_1:* = this.panelMC.panelMC.popupBuyItemMc.panel;
            _local_1.titleTxt.text = "Buy Kari Badge";
            _local_1.itemNameTxt.text = "Kari Badge";
            _local_1.TokenCost.txt_token.text = this.price;
            _local_1.numTxt.text = this.amount;
            this.main.initButton(_local_1.buyBtn, this.buyBudge, "Buy");
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closeBadge);
            this.eventHandler.addListener(_local_1.btnNext, MouseEvent.CLICK, this.changeAmount);
            this.eventHandler.addListener(_local_1.btnPrev, MouseEvent.CLICK, this.changeAmount);
            this.main.initButton(this.panelMC.panelMC.popupBuyItemMc.panel.buyBtn, this.buyBadge, "Buy");
        }

        private function changeAmount(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            if (((this.amount <= 1) && (!(_local_2 == "btnNext"))))
            {
                return;
            };
            if (_local_2 == "btnNext")
            {
                this.amount = (this.amount + 1);
            }
            else
            {
                this.amount--;
            };
            this.cost = (this.price * this.amount);
            this.panelMC.panelMC.popupBuyItemMc.panel.numTxt.text = this.amount;
            this.panelMC.panelMC.popupBuyItemMc.panel.TokenCost.txt_token.text = this.cost;
        }

        private function buyBadge(_arg_1:MouseEvent):*
        {
            this.main.loading(false);
            this.main.amf_manager.service("HuntingHouse.buyMaterial", [Character.char_id, Character.sessionkey, this.amount], this.onBuyBadge);
        }

        private function onBuyBadge(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.account_tokens = (Character.account_tokens - this.cost);
                this.panelMC.panelMC.HuntingTicketTxt.text = _arg_1.material;
                this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
                this.main.showMessage((this.amount + " Kari Badge Succesfully Bought!"));
                Character.addMaterials(this.KARI_BADGE, this.amount);
                this.main.HUD.setBasicData();
            }
            else
            {
                if (_arg_1.status == 2)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function closeBadge(_arg_1:MouseEvent):*
        {
            this.amount = 1;
            this.panelMC.panelMC.popupBuyItemMc.visible = false;
        }

        private function openMenu(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            switch (_local_2)
            {
                case "getDailyItemBtn":
                    this.openBadgeShop();
                    return;
                case "getMoreItemBtn":
                    this.openBadgeShop();
                    return;
                case "getMoreBtn":
                    this.main.loadPanel("Panels.Recharge");
                    return;
                case "goForgePanelBtn":
                    this.main.loadPanel("Panels.HuntingMarket");
                    return;
                case "recruitFriendBtn":
                    this.main.loadExternalSwfPanel("Social", "Social");
                    return;
                case "btnClose":
                    this.destroy();
            };
        }

        private function startBattle(_arg_1:MouseEvent):*
        {
            if (((Character.character_skill_set == "") || (Character.character_skill_set == null)))
            {
                this.main.showMessage("Please equip at least 1 skill");
                return;
            };
            if (int(Character.character_lvl) >= 0)
            {
                this.main.loading(true);
                this.main.amf_manager.service("HuntingHouse.startHunting", [Character.char_id, int((this.currentZone + 1)), Character.sessionkey], this.onStartHuntingAmf);
            };
        }

        private function onStartHuntingAmf(_arg_1:Object):*
        {
            var _local_2:int;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.mission_id = this.getBackgroundBattle((this.currentZone + 1));
                Character.battle_code = _arg_1.code;
                if (_arg_1.hash != this.__hash(((String((this.currentZone + 1)) + String(Character.char_id)) + Character.battle_code)))
                {
                    this.main.loading(false);
                    this.main.showMessage("Invalid hash, please try again or re-logout");
                    return;
                };
                Character.is_hunting_house = true;
                Character.hunting_zone = int((this.currentZone + 1));
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.EVENT_MATCH, Character.mission_id);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                _local_2 = 0;
                while (_local_2 < this.currentBoss.length)
                {
                    BattleManager.addPlayerToTeam("enemy", this.currentBoss[_local_2]);
                    _local_2++;
                };
                BattleManager.startBattle();
                this.closeBossDetail();
                this.destroy();
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

        private function getBackgroundBattle(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 1:
                    return ("mission_155");
                case 2:
                    return ("mission_03");
                case 3:
                    return ("mission_32");
                case 4:
                    return ("mission_1016");
                case 5:
                    return ("mission_1017");
            };
            return ("mission_01");
        }

        private function __hash(_arg_1:*):*
        {
            var _local_2:ByteArray = Crypto.getHash("sha256").hash(Crypto.bytesArray(_arg_1));
            return (Hex.fromArray(_local_2));
        }

        public function destroy():*
        {
            this.main.handleVillageHUDVisibility(true);
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main.clearEvents();
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            var _local_1:* = 1;
            while (_local_1 < 6)
            {
                GF.removeAllChild(this.panelMC.panelMC.WorldMapMc[("EasyBoss" + _local_1)].bossHolder1);
                GF.removeAllChild(this.panelMC.panelMC.WorldMapMc[("HardBoss" + _local_1)].bossHolder1);
                GF.removeAllChild(this.panelMC.panelMC.WorldMapMc[("HardBoss" + _local_1)].bossHolder2);
                _local_1++;
            };
            this.bosses = [];
            this.main = null;
            this.eventHandler = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

