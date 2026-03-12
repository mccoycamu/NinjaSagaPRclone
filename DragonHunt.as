// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.DragonHunt

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import Storage.Character;
    import id.ninjasage.Util;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import Managers.StatManager;
    import Storage.EnemyInfo;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.Crypto;
    import Combat.BattleVars;
    import Combat.BattleManager;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class DragonHunt extends MovieClip 
    {

        private const NORMAL_PRICE:Number = 250000;
        private const EASY_PRICE:Number = 100;
        private const SUSHI_MATERIAL:String = "item_54";
        private const SEAL_MATERIAL:String = "item_52";

        public var panelMC:MovieClip;
        private var bossData:Array = [];
        private var selectedEnemy:int = -1;
        private var selectedMode:int = -1;
        private var selectedBuyMaterial:String;
        private var amount:int = 1;
        private var price:int = 10;
        private var cost:int = 0;
        private var main:*;
        private var eventHandler:EventHandler;
        private var response:Object;

        public function DragonHunt(_arg_1:*, _arg_2:*)
        {
            var _local_3:* = GameData.get("dragon_hunt");
            var _local_4:* = {"level":Character.character_lvl};
            var _local_5:int;
            while (_local_5 < _local_3.bosses.length)
            {
                this.bossData.push({
                    "bossId":_local_3.bosses[_local_5].id,
                    "bossName":_local_3.bosses[_local_5].name,
                    "bossDescription":_local_3.bosses[_local_5].description,
                    "bossLevel":[(int(Character.character_lvl) + _local_3.bosses[_local_5].levels[0]), (int(Character.character_lvl) + _local_3.bosses[_local_5].levels[1])],
                    "bossGold":int(Util.calculateFromString(_local_3.bosses[_local_5].gold, _local_4)),
                    "bossXp":int(Util.calculateFromString(_local_3.bosses[_local_5].gold, _local_4)),
                    "bossRequirement":_local_3.bosses[_local_5].requirement,
                    "bossReward":_local_3.bosses[_local_5].rewards,
                    "backgroundBattle":_local_3.bosses[_local_5].background
                });
                _local_5++;
            };
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.hidePopup();
            this.initButton();
            this.initUI();
        }

        private function initUI():*
        {
            this.main.handleVillageHUDVisibility(false);
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                this.panelMC[("battle_" + _local_1)].btn.graphicMc.gotoAndStop((_local_1 + 1));
                this.panelMC[("battle_" + _local_1)].btn.graphicMc.enemyName.text = this.bossData[_local_1].bossName;
                this.panelMC[("battle_" + _local_1)].gotoAndStop(1);
                this.eventHandler.addListener(this.panelMC[("battle_" + _local_1)], MouseEvent.CLICK, this.setSelectedEnemy);
                this.eventHandler.addListener(this.panelMC[("battle_" + _local_1)], MouseEvent.MOUSE_OVER, this.over);
                this.eventHandler.addListener(this.panelMC[("battle_" + _local_1)], MouseEvent.MOUSE_OUT, this.out);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 7)
            {
                this.panelMC.dragonBallMc[("DBMc_" + _local_1)].DBtxt.text = "";
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 3)
            {
                this.main.initButton(this.panelMC.bossDetailMc.panel[("modeMc_" + _local_1)], this.checkStartBattle, "");
                this.panelMC.bossDetailMc.panel[("modeMc_" + _local_1)].btn.modePicMc.gotoAndStop((_local_1 + 1));
                _local_1++;
            };
            this.panelMC.bossDetailMc.panel.gotoAndStop(1);
            this.panelMC.bossDetailMc.panel["modeMc_0"].priceMc.visible = false;
            this.panelMC.bossDetailMc.panel["modeMc_0"].modeTxt.text = "Hard Mode";
            this.panelMC.bossDetailMc.panel["modeMc_0"].descTxt.text = "Range of capturable HP: 5%, without capture reminder";
            this.panelMC.bossDetailMc.panel["modeMc_1"].priceMc.icon.gotoAndStop("gold");
            this.panelMC.bossDetailMc.panel["modeMc_1"].priceMc.price_0.text = this.NORMAL_PRICE;
            this.panelMC.bossDetailMc.panel["modeMc_1"].freeTxt.visible = false;
            this.panelMC.bossDetailMc.panel["modeMc_1"].priceMc.token_0.visible = false;
            this.panelMC.bossDetailMc.panel["modeMc_1"].modeTxt.text = "Normal Mode";
            this.panelMC.bossDetailMc.panel["modeMc_1"].descTxt.text = "Range of capturable HP: 15%, without capture reminder";
            this.panelMC.bossDetailMc.panel["modeMc_2"].priceMc.icon.gotoAndStop("token");
            this.panelMC.bossDetailMc.panel["modeMc_2"].priceMc.token_0.text = this.EASY_PRICE;
            this.panelMC.bossDetailMc.panel["modeMc_2"].freeTxt.visible = false;
            this.panelMC.bossDetailMc.panel["modeMc_2"].priceMc.price_0.visible = false;
            this.panelMC.bossDetailMc.panel["modeMc_2"].modeTxt.text = "Easy Mode";
            this.panelMC.bossDetailMc.panel["modeMc_2"].descTxt.text = "Range of capturable HP: 25%, with capture reminder";
            this.panelMC.bossDetailMc.panel.sushiItemTxt.text = String(Character.getConsumableAmount(this.SUSHI_MATERIAL));
            this.panelMC.bossDetailMc.panel.scrollItemTxt.text = String(Character.getConsumableAmount(this.SEAL_MATERIAL));
            this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.btnClose, MouseEvent.CLICK, this.closeBossDetail);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.sushiBtn, MouseEvent.CLICK, this.openBuyMaterial);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.scrollBtn, MouseEvent.CLICK, this.openBuyMaterial);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.convertBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.getMoreTokenBtn, MouseEvent.CLICK, this.openRecharge);
        }

        private function setSelectedEnemy(_arg_1:MouseEvent):*
        {
            var _local_2:int = _arg_1.currentTarget.name.replace("battle_", "");
            var _local_3:* = 0;
            while (_local_3 < 5)
            {
                this.panelMC[("battle_" + _local_3)].gotoAndStop(1);
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < 7)
            {
                this.panelMC.dragonBallMc[("DBMc_" + _local_3)].DBtxt.text = ("x" + String(Character.getMaterialAmount(this.bossData[_local_2].bossRequirement[_local_3])));
                NinjaSage.loadItemIcon(this.panelMC.dragonBallMc[("DBMc_" + _local_3)].iconHolder.DBIcon.iconHolder, this.bossData[_local_2].bossRequirement[_local_3], "icon");
                _local_3++;
            };
            this.panelMC[("battle_" + _local_2)].gotoAndStop(3);
            this.selectedEnemy = _local_2;
        }

        private function openBossDetail(_arg_1:MouseEvent):*
        {
            var _local_3:int;
            if (this.selectedEnemy == -1)
            {
                this.main.showMessage("Please select an enemy");
                return;
            };
            this.panelMC.bossDetailMc.visible = true;
            this.panelMC.bossDetailMc.panel.detailMc0.nameTxt.text = this.bossData[this.selectedEnemy].bossName;
            this.panelMC.bossDetailMc.panel.detailMc0.decTxt.text = this.bossData[this.selectedEnemy].bossDescription;
            this.panelMC.bossDetailMc.panel.goldMc.txt.text = this.bossData[this.selectedEnemy].bossGold;
            this.panelMC.bossDetailMc.panel.xpMc.txt.text = this.bossData[this.selectedEnemy].bossXp;
            this.panelMC.bossDetailMc.panel.detailMc0.lvMc.lvLow.txt.text = this.bossData[this.selectedEnemy].bossLevel[0];
            this.panelMC.bossDetailMc.panel.detailMc0.lvMc.lvHigh.txt.text = this.bossData[this.selectedEnemy].bossLevel[1];
            this.panelMC.bossDetailMc.panel.goldTxt.text = String(Character.character_gold);
            this.panelMC.bossDetailMc.panel.tokenTxt.text = String(Character.account_tokens);
            NinjaSage.loadIconSWF("enemy", this.bossData[this.selectedEnemy].bossId[0], this.panelMC.bossDetailMc.panel.detailMc0.bossHolder, "StatichuntingHouse");
            var _local_2:* = 0;
            while (_local_2 < 5)
            {
                _local_3 = (_local_2 + (0 * 5));
                if (this.bossData[this.selectedEnemy].bossReward.length > _local_3)
                {
                    this.panelMC.bossDetailMc.panel[("item" + _local_2)].visible = true;
                    NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.panel[("item" + _local_2)].holder, this.bossData[this.selectedEnemy].bossReward[_local_2], "icon");
                }
                else
                {
                    this.panelMC.bossDetailMc.panel[("item" + _local_2)].visible = false;
                };
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < 7)
            {
                this.panelMC.bossDetailMc.panel.huntingPassMc[("Dbtxt_" + _local_2)].text = "x1";
                NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.panel.huntingPassMc[("Db_" + _local_2)].DBIcon.iconHolder, this.bossData[this.selectedEnemy].bossRequirement[_local_2], "icon");
                _local_2++;
            };
        }

        private function checkStartBattle(_arg_1:MouseEvent):*
        {
            this.selectedMode = _arg_1.currentTarget.name.replace("modeMc_", "");
            if (int(Character.getConsumableAmount(this.SEAL_MATERIAL)) < 1)
            {
                this.openNoScrollPopup();
            }
            else
            {
                this.startBattle();
            };
        }

        private function startBattle(_arg_1:MouseEvent=null):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = this.bossData[this.selectedEnemy].bossId[0];
            Character.christmas_boss_num = 0;
            Character.christmas_boss_id = _local_5;
            _local_2 = StatManager.calculate_stats_with_data("agility");
            _local_3 = EnemyInfo.getCopy(_local_5);
            this.enemyStats = ((((("id:" + _local_3["enemy_id"]) + "|hp:") + _local_3["enemy_hp"]) + "|agility:") + _local_3["enemy_agility"]);
            _local_4 = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(((((String(Character.char_id) + String(_local_5)) + String(this.selectedMode)) + this.enemyStats) + String(_local_2)))));
            this.main.loading(true);
            this.main.amf_manager.service("DragonHuntEvent.startBattle", [Character.char_id, _local_5, this.selectedMode, _local_2, this.enemyStats, _local_4, Character.sessionkey], this.onStartEventAmf);
        }

        private function onStartEventAmf(_arg_1:Object):*
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if (_arg_1.hash != Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(((((String(Character.christmas_boss_id) + _arg_1.code) + Character.char_id) + String(_arg_1.n1)) + _arg_1.n2)))))
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
                if (this.selectedMode == 1)
                {
                    Character.character_gold = String((Number(Character.character_gold) - Number(this.NORMAL_PRICE)));
                }
                else
                {
                    if (this.selectedMode == 2)
                    {
                        Character.account_tokens = (Character.account_tokens - int(this.EASY_PRICE));
                    };
                };
                _local_2 = 0;
                while (_local_2 < 7)
                {
                    Character.removeMaterials(this.bossData[this.selectedEnemy].bossRequirement[_local_2], 1);
                    _local_2++;
                };
                this.main.HUD.setBasicData();
                _local_3 = _arg_1.n1;
                _local_4 = _arg_1.n2;
                BattleVars.CAPTURE_RANGE_START = _local_3;
                BattleVars.CAPTURE_RANGE_END = _local_4;
                BattleVars.CAPTURED_AT = -1;
                BattleVars.DH_MODE = this.selectedMode;
                Character.battle_code = _arg_1.code;
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.DRAGON_HUNT_MATCH, this.bossData[this.selectedEnemy].backgroundBattle);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                _local_2 = 0;
                while (_local_2 < this.bossData[this.selectedEnemy].bossId.length)
                {
                    BattleManager.addPlayerToTeam("enemy", this.bossData[this.selectedEnemy].bossId[_local_2]);
                    _local_2++;
                };
                BattleManager.startBattle();
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

        private function openNoScrollPopup():*
        {
            this.panelMC.popupNoScrollMc.visible = true;
            this.eventHandler.addListener(this.panelMC.popupNoScrollMc.panel.btnClose, MouseEvent.CLICK, this.closeNoScrollPopup);
            this.eventHandler.addListener(this.panelMC.popupNoScrollMc.panel.attackBtn, MouseEvent.CLICK, this.startBattle);
            this.eventHandler.addListener(this.panelMC.popupNoScrollMc.panel.buyScrollBtn, MouseEvent.CLICK, this.openBuyMaterial);
        }

        private function openBuyMaterial(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            this.panelMC.popupBuyItemMc.visible = true;
            this.panelMC.popupBuyItemMc.panel.titleTxt.text = "Dragon Hunt Material";
            this.panelMC.popupBuyItemMc.panel.goldTxt.text = String(Character.character_gold);
            this.panelMC.popupBuyItemMc.panel.tokenTxt.text = String(Character.account_tokens);
            this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.convertBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.getMoreTokenBtn, MouseEvent.CLICK, this.openRecharge);
            GF.removeAllChild(this.panelMC.popupBuyItemMc.panel.displayHolder);
            if (_local_2 == "sushiBtn")
            {
                this.panelMC.popupBuyItemMc.panel.itemNameTxt.text = "Sushi Item";
                this.selectedBuyMaterial = this.SUSHI_MATERIAL;
                NinjaSage.loadItemIcon(this.panelMC.popupBuyItemMc.panel.displayHolder, this.SUSHI_MATERIAL, "icon");
            }
            else
            {
                this.panelMC.popupBuyItemMc.panel.itemNameTxt.text = "Scroll Item";
                this.selectedBuyMaterial = this.SEAL_MATERIAL;
                NinjaSage.loadItemIcon(this.panelMC.popupBuyItemMc.panel.displayHolder, this.SEAL_MATERIAL, "icon");
            };
            this.cost = (this.price * this.amount);
            this.panelMC.popupBuyItemMc.panel.numTxt.text = this.amount;
            this.panelMC.popupBuyItemMc.panel.TokenCost.txt_token.text = this.cost;
            this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.buyBtn, MouseEvent.CLICK, this.buyMaterial);
            this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.btnNext, MouseEvent.CLICK, this.changeAmount);
            this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.btnPrev, MouseEvent.CLICK, this.changeAmount);
            this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.btnClose, MouseEvent.CLICK, this.closeBuyMaterial);
        }

        private function changeAmount(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            var _local_3:* = this.panelMC.popupBuyItemMc.panel;
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
            _local_3.numTxt.text = this.amount;
            _local_3.TokenCost.txt_token.text = this.cost;
        }

        private function buyMaterial(_arg_1:MouseEvent):*
        {
            this.main.loading(false);
            this.main.amf_manager.service("DragonHuntEvent.buyMaterial", [Character.char_id, Character.sessionkey, this.selectedBuyMaterial, this.amount], this.onBuyMaterial);
        }

        private function onBuyMaterial(_arg_1:Object=null):*
        {
            if (_arg_1.status == 1)
            {
                Character.addConsumables(this.selectedBuyMaterial, this.amount);
                Character.account_tokens = (Character.account_tokens - this.cost);
                this.panelMC.popupBuyItemMc.panel.tokenTxt.text = _arg_1.tokens;
                this.panelMC.bossDetailMc.panel.sushiItemTxt.text = String(Character.getConsumableAmount(this.SUSHI_MATERIAL));
                this.panelMC.bossDetailMc.panel.scrollItemTxt.text = String(Character.getConsumableAmount(this.SEAL_MATERIAL));
                this.main.HUD.setBasicData();
                this.main.showMessage((this.amount + " Material bought!"));
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

        private function openResource(_arg_1:MouseEvent):*
        {
            this.panelMC.popupGetMoreMc.visible = true;
            this.panelMC.popupGetMoreMc.panel.popup_chart.visible = false;
            this.main.initButton(this.panelMC.popupGetMoreMc.panel.askFriendBtn, this.openResourcePanel, "Events");
            this.main.initButton(this.panelMC.popupGetMoreMc.panel.postBtn, this.openResourcePanel, "Eudemon Garden");
            this.main.initButton(this.panelMC.popupGetMoreMc.panel.huntingHouseBtn, this.openResourcePanel, "Hunting House");
            this.main.initButton(this.panelMC.popupGetMoreMc.panel.geshaponBtn, this.openResourcePanel, "Dragon Gacha");
            this.main.initButton(this.panelMC.popupGetMoreMc.panel.freeGiftBtn, this.openResourcePanel, "Friend Battle");
            this.main.initButton(this.panelMC.popupGetMoreMc.panel.dailyTaskBtn, this.openResourcePanel, "Shadow War");
            this.main.initButton(this.panelMC.popupGetMoreMc.panel.hintsBtn, this.openResourcePanel, "Chart");
            this.eventHandler.addListener(this.panelMC.popupGetMoreMc.panel.btnClose, MouseEvent.CLICK, this.openResourcePanel);
        }

        private function openResourcePanel(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "askFriendBtn":
                    this.main.loadExternalSwfPanel("EventMenu", "EventMenu");
                    this.destroy();
                    return;
                case "postBtn":
                    this.main.loadExternalSwfPanel("EudemonGarden", "EudemonGarden");
                    this.destroy();
                    return;
                case "huntingHouseBtn":
                    this.main.loadExternalSwfPanel("HuntingHouse", "HuntingHouse");
                    this.destroy();
                    return;
                case "geshaponBtn":
                    this.main.loadExternalSwfPanel("DragonGacha", "DragonGacha");
                    this.destroy();
                    return;
                case "freeGiftBtn":
                    this.main.loadExternalSwfPanel("Social", "Social");
                    this.destroy();
                    return;
                case "dailyTaskBtn":
                    this.main.loadPanel("Popups.Scroll_Arena");
                    this.destroy();
                    return;
                case "hintsBtn":
                    this.panelMC.popupGetMoreMc.panel.popup_chart.visible = true;
                    this.eventHandler.addListener(this.panelMC.popupGetMoreMc.panel.popup_chart.panel.btnClose, MouseEvent.CLICK, this.closeChart);
                    return;
                case "btnClose":
                    this.panelMC.popupGetMoreMc.visible = false;
                    return;
            };
        }

        private function closeChart(_arg_1:MouseEvent):*
        {
            this.panelMC.popupGetMoreMc.panel.popup_chart.visible = false;
            this.eventHandler.removeListener(this.panelMC.popupGetMoreMc.panel.popup_chart.btnClose, MouseEvent.CLICK, this.closeChart);
        }

        private function closeNoDragonBall(_arg_1:MouseEvent):*
        {
            this.panelMC.noDragonBallMc.visible = false;
            this.eventHandler.removeListener(this.panelMC.noDragonBallMc.panel.okBtn, MouseEvent.CLICK, this.closeNoDragonBall);
            this.eventHandler.removeListener(this.panelMC.noDragonBallMc.panel.btnClose, MouseEvent.CLICK, this.closeNoDragonBall);
        }

        private function closeNoScrollPopup(_arg_1:MouseEvent):*
        {
            this.panelMC.popupNoScrollMc.visible = false;
            this.eventHandler.removeListener(this.panelMC.popupNoScrollMc.panel.btnClose, MouseEvent.CLICK, this.closeNoScrollPopup);
            this.eventHandler.removeListener(this.panelMC.popupNoScrollMc.panel.attackBtn, MouseEvent.CLICK, this.startBattle);
            this.eventHandler.removeListener(this.panelMC.popupNoScrollMc.panel.buyScrollBtn, MouseEvent.CLICK, this.openBuyMaterial);
        }

        private function closeBossDetail(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < 5)
            {
                GF.removeAllChild(this.panelMC.bossDetailMc.panel[("item" + _local_2)].holder);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < 7)
            {
                GF.removeAllChild(this.panelMC.bossDetailMc.panel.huntingPassMc[("Db_" + _local_2)].DBIcon.iconHolder);
                _local_2++;
            };
            GF.removeAllChild(this.panelMC.bossDetailMc.panel.detailMc0.bossHolder);
            this.panelMC.bossDetailMc.visible = false;
        }

        private function closeBuyMaterial(_arg_1:MouseEvent):*
        {
            this.panelMC.popupBuyItemMc.visible = false;
            this.amount = 1;
            this.price = 10;
            this.cost = 0;
        }

        private function openDetails(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("DragonHuntDetail", "DragonHuntDetail");
        }

        private function openRewards(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("DragonHuntReward", "DragonHuntReward");
        }

        private function openRecharge(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function hidePopup():*
        {
            this.panelMC.popupBuyItemMc.visible = false;
            this.panelMC.popupNoScrollMc.visible = false;
            this.panelMC.noDragonBallMc.visible = false;
            this.panelMC.popUpGetReward.visible = false;
            this.panelMC.bossDetailMc.visible = false;
            this.panelMC.popupGetMoreMc.visible = false;
        }

        private function initButton():*
        {
            this.main.initButton(this.panelMC.detailBtn, this.openDetails, "Details");
            this.main.initButton(this.panelMC.getMoreBtn, this.openResource, "Get Dragon Ball");
            this.main.initButton(this.panelMC.rewardBtn, this.openRewards, "Rewards");
            this.main.initButton(this.panelMC.battleBtn, this.openBossDetail, "Battle");
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
        }

        private function over(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        private function out(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.main.handleVillageHUDVisibility(true);
            this.hidePopup();
            var _local_1:* = 0;
            while (_local_1 < 7)
            {
                GF.removeAllChild(this.panelMC.dragonBallMc[("DBMc_" + _local_1)].iconHolder.DBIcon.iconHolder);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 5)
            {
                GF.removeAllChild(this.panelMC.bossDetailMc.panel[("item" + _local_1)].holder);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 7)
            {
                GF.removeAllChild(this.panelMC.bossDetailMc.panel.huntingPassMc[("Db_" + _local_1)].DBIcon.iconHolder);
                _local_1++;
            };
            GF.removeAllChild(this.panelMC.bossDetailMc.panel.detailMc0.bossHolder);
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.eventHandler.removeAllEventListeners();
            this.main.clearEvents();
            this.main.removeExternalSwfPanel();
            this.bossData = [];
            this.selectedEnemy = -1;
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

