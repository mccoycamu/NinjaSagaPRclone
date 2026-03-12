// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.YinYangMenu

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import Storage.GameData;
    import Storage.Character;
    import id.ninjasage.Util;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Managers.StatManager;
    import Storage.EnemyInfo;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.Crypto;
    import Combat.BattleManager;
    import Combat.BattleVars;

    public class YinYangMenu extends MovieClip 
    {

        private var main:*;
        private var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;
        private var response:Object;
        private var bossData:Array;
        private var milestoneDataYin:Array;
        private var milestoneDataYang:Array;
        private var selectedMilestone:Array;
        private var milestoneType:int;
        private var selectedBoss:int;
        private var currentPage:int;
        private var totalPage:int;
        private var REFILL_PRICE:int = 50;

        public function YinYangMenu(_arg_1:*, _arg_2:*)
        {
            var _local_5:int;
            var _local_3:Object = GameData.get("yinyang2025");
            var _local_4:* = {"level":Character.character_lvl};
            super();
            this.bossData = [];
            _local_5 = 0;
            while (_local_5 < _local_3.bosses.length)
            {
                this.bossData.push({
                    "bossId":_local_3.bosses[_local_5].id,
                    "bossName":_local_3.bosses[_local_5].name,
                    "bossDescription":_local_3.bosses[_local_5].description,
                    "bossLevel":[(int(Character.character_lvl) + _local_3.bosses[_local_5].levels[0]), (int(Character.character_lvl) + _local_3.bosses[_local_5].levels[1])],
                    "bossGold":int(Util.calculateFromString(_local_3.bosses[_local_5].gold, _local_4)),
                    "bossXp":int(Util.calculateFromString(_local_3.bosses[_local_5].gold, _local_4)),
                    "bossReward":_local_3.bosses[_local_5].rewards,
                    "bossBackground":_local_3.bosses[_local_5].background
                });
                _local_5++;
            };
            this.milestoneDataYin = [];
            _local_5 = 0;
            while (_local_5 < _local_3.milestone_battle_yin.length)
            {
                this.milestoneDataYin.push({
                    "rewardId":_local_3.milestone_battle_yin[_local_5].id.replace("%s", Character.character_gender),
                    "rewardReq":_local_3.milestone_battle_yin[_local_5].requirement,
                    "rewardQty":_local_3.milestone_battle_yin[_local_5].quantity
                });
                _local_5++;
            };
            this.milestoneDataYang = [];
            _local_5 = 0;
            while (_local_5 < _local_3.milestone_battle_yang.length)
            {
                this.milestoneDataYang.push({
                    "rewardId":_local_3.milestone_battle_yang[_local_5].id.replace("%s", Character.character_gender),
                    "rewardReq":_local_3.milestone_battle_yang[_local_5].requirement,
                    "rewardQty":_local_3.milestone_battle_yang[_local_5].quantity
                });
                _local_5++;
            };
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = this.main.eventHandler;
            this.main.handleVillageHUDVisibility(false);
            this.getEventData();
        }

        private function getEventData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("YinYangEvent.getBattleData", [Character.char_id, Character.sessionkey], this.onGetEventData);
        }

        private function onGetEventData(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.updateEnergy();
                this.initUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function updateEnergy():void
        {
            var _local_1:int;
            while (_local_1 < 12)
            {
                this.panelMC.energyMC[("heart_" + _local_1)].visible = false;
                if (this.response.energy > _local_1)
                {
                    this.panelMC.energyMC[("heart_" + _local_1)].visible = true;
                };
                _local_1++;
            };
        }

        private function initUI():void
        {
            this.panelMC.milestoneMC.visible = false;
            this.panelMC.rewardListMC.visible = false;
            this.panelMC.bossDetailMc.visible = false;
            this.panelMC.tokenMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.txt_title.text = "Yin & Yang";
            var _local_1:int;
            while (_local_1 < 2)
            {
                this.panelMC[("enemy" + _local_1)].txt.text = this.bossData[_local_1].bossName;
                this.panelMC[("enemy" + _local_1)].buttonMode = true;
                this.eventHandler.addListener(this.panelMC[("enemy" + _local_1)], MouseEvent.CLICK, this.openBossDetail);
                _local_1++;
            };
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.rewardListBtn, MouseEvent.CLICK, this.openRewardList);
            this.eventHandler.addListener(this.panelMC.milestoneYinBtn, MouseEvent.CLICK, this.openMilestone);
            this.eventHandler.addListener(this.panelMC.milestoneYangBtn, MouseEvent.CLICK, this.openMilestone);
            this.eventHandler.addListener(this.panelMC.trainingBtn, MouseEvent.CLICK, this.openTraining);
            this.eventHandler.addListener(this.panelMC.materialMarketBtn, MouseEvent.CLICK, this.openMaterialMarket);
            this.eventHandler.addListener(this.panelMC.energyMC.heartBtn, MouseEvent.CLICK, this.refillConfirmation);
            this.eventHandler.addListener(this.panelMC.tokenMC.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
        }

        private function refillConfirmation(e:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure to refill full energy for " + this.REFILL_PRICE) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.refillAmf);
            this.panelMC.addChild(this.confirmation);
        }

        public function refillAmf(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.main.loading(true);
            this.main.amf_manager.service("YinYangEvent.refillEnergy", [Character.char_id, Character.sessionkey], this.refillResponse);
        }

        private function refillResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response.energy = _arg_1.energy;
                Character.account_tokens = (int(Character.account_tokens) - this.REFILL_PRICE);
                this.panelMC.tokenMC.tokenTxt.text = Character.account_tokens;
                this.main.HUD.setBasicData();
                this.updateEnergy();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function openBossDetail(_arg_1:MouseEvent):void
        {
            this.selectedBoss = _arg_1.currentTarget.name.replace("enemy", "");
            this.panelMC.bossDetailMc.visible = true;
            var _local_2:MovieClip = this.panelMC.bossDetailMc.panel;
            _local_2.detailMc0.nameTxt.text = this.bossData[this.selectedBoss].bossName;
            _local_2.detailMc0.decTxt.text = this.bossData[this.selectedBoss].bossDescription;
            _local_2.detailMc0.lvMc.lvLow.txt.text = this.bossData[this.selectedBoss].bossLevel[0];
            _local_2.detailMc0.lvMc.lvHigh.txt.text = this.bossData[this.selectedBoss].bossLevel[1];
            _local_2.detailMc0.goldMc.txt.text = this.bossData[this.selectedBoss].bossGold;
            _local_2.detailMc0.xpMc.txt.text = this.bossData[this.selectedBoss].bossXp;
            _local_2.detailMc0.bossHolder.scaleX = 0.7;
            _local_2.detailMc0.bossHolder.scaleY = 0.7;
            GF.removeAllChild(_local_2.detailMc0.bossHolder);
            NinjaSage.loadIconSWF("enemy", this.bossData[this.selectedBoss].bossId[0], _local_2.detailMc0.bossHolder, "StaticFullBody");
            var _local_3:int;
            while (_local_3 < 4)
            {
                _local_2.detailMc0[("rewardItem" + _local_3)].visible = false;
                if (this.bossData[this.selectedBoss].bossReward.length > _local_3)
                {
                    _local_2.detailMc0[("rewardItem" + _local_3)].visible = true;
                    NinjaSage.loadItemIcon(_local_2.detailMc0[("rewardItem" + _local_3)].holder, this.bossData[this.selectedBoss].bossReward[_local_3], "icon");
                };
                _local_3++;
            };
            this.eventHandler.addListener(_local_2.btnClose, MouseEvent.CLICK, this.closeBossDetail);
            this.eventHandler.addListener(_local_2.attackBtn, MouseEvent.CLICK, this.startBattle);
        }

        private function startBattle(_arg_1:MouseEvent):void
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = undefined;
            var _local_6:* = this.bossData[this.selectedBoss].bossId[0];
            Character.christmas_boss_num = this.selectedBoss;
            Character.christmas_boss_id = _local_6;
            _local_2 = StatManager.calculate_stats_with_data("agility");
            _local_3 = EnemyInfo.getCopy(_local_6);
            _local_5 = ((((("id:" + _local_3["enemy_id"]) + "|hp:") + _local_3["enemy_hp"]) + "|agility:") + _local_3["enemy_agility"]);
            _local_4 = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray((((String(Character.char_id) + String(_local_6)) + _local_5) + String(_local_2)))));
            this.main.loading(true);
            this.main.amf_manager.service("YinYangEvent.startBattle", [Character.char_id, _local_6, _local_2, _local_5, _local_4, Character.sessionkey], this.onStartEventAmf);
        }

        private function onStartEventAmf(_arg_1:Object):void
        {
            var _local_2:int;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if (_arg_1.hash != Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(((String(Character.christmas_boss_id) + _arg_1.code) + Character.char_id)))))
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
                Character.is_yinyang_event = true;
                Character.battle_code = _arg_1.code;
                Character.mission_id = this.bossData[this.selectedBoss].bossBackground;
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.EVENT_MATCH, Character.mission_id);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                _local_2 = 0;
                while (_local_2 < this.bossData[this.selectedBoss].bossId.length)
                {
                    BattleManager.addPlayerToTeam("enemy", this.bossData[this.selectedBoss].bossId[_local_2]);
                    _local_2++;
                };
                BattleManager.startBattle();
                this.destroy();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closeBossDetail(_arg_1:MouseEvent):void
        {
            this.panelMC.bossDetailMc.visible = false;
        }

        private function openMilestone(_arg_1:MouseEvent):*
        {
            this.panelMC.milestoneMC.visible = true;
            this.selectedMilestone = ((_arg_1.currentTarget.name == "milestoneYinBtn") ? this.milestoneDataYin : this.milestoneDataYang);
            this.milestoneType = ((_arg_1.currentTarget.name == "milestoneYinBtn") ? 0 : 1);
            this.panelMC.milestoneMC.panel.txt_title.text = ((_arg_1.currentTarget.name == "milestoneYinBtn") ? "Yin Milestone" : "Yang Milestone");
            this.eventHandler.addListener(this.panelMC.milestoneMC.panel.btnClose, MouseEvent.CLICK, this.closeMilestone);
            this.main.loading(true);
            this.main.amf_manager.service("YinYangEvent.getBonusRewards", [Character.char_id, Character.sessionkey, this.milestoneType], this.openMilestoneRewards);
            var _local_2:* = 0;
            while (_local_2 < 8)
            {
                this.panelMC.milestoneMC.panel[("requiredBattleTxt" + _local_2)].text = (String(this.selectedMilestone[_local_2].rewardReq) + " Battles");
                this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].amountTxt.text = ((this.selectedMilestone[_local_2].rewardQty <= 1) ? "" : ("x" + this.selectedMilestone[_local_2].rewardQty));
                this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].ownedTxt.visible = false;
                if (Character.hasSkill(this.selectedMilestone[_local_2].rewardId) > 0)
                {
                    this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].ownedTxt.visible = true;
                    this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(this.selectedMilestone[_local_2].rewardId) > 0)
                {
                    this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].ownedTxt.visible = true;
                    this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].ownedTxt.text = "Owned";
                };
                NinjaSage.loadItemIcon(this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)], this.selectedMilestone[_local_2].rewardId);
                _local_2++;
            };
        }

        private function openMilestoneRewards(_arg_1:Object):*
        {
            var _local_2:*;
            var _local_3:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = 0;
                while (_local_2 < 8)
                {
                    this.panelMC.milestoneMC.panel.txt_draws.text = (("You've Battles " + _arg_1.milestone) + " times !");
                    _local_3 = (((_arg_1.rewards[_local_2] == false) && (_arg_1.milestone >= this.selectedMilestone[_local_2].rewardReq)) ? true : false);
                    this.panelMC.milestoneMC.panel[("btn_claim_" + _local_2)].visible = _local_3;
                    if (_local_3)
                    {
                        this.eventHandler.addListener(this.panelMC.milestoneMC.panel[("btn_claim_" + _local_2)], MouseEvent.CLICK, this.onClaimBonusRequest);
                    };
                    _local_2++;
                };
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function onClaimBonusRequest(_arg_1:MouseEvent):*
        {
            var _local_2:int = int(_arg_1.currentTarget.name.replace("btn_claim_", ""));
            this.main.amf_manager.service("YinYangEvent.claimBonusRewards", [Character.char_id, Character.sessionkey, this.milestoneType, _local_2], this.onClaimBonusResponse);
        }

        private function onClaimBonusResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.reward);
                this.main.HUD.setBasicData();
                this.main.giveReward(1, _arg_1.reward, "winter");
                this.panelMC.tokenMC.tokenTxt.text = Character.account_tokens;
                this.closeMilestone(null);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        public function closeMilestone(_arg_1:MouseEvent):*
        {
            this.panelMC.milestoneMC.visible = false;
            var _local_2:int;
            while (_local_2 < 8)
            {
                GF.removeAllChild(this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.milestoneMC.panel[("IconMc_" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
        }

        private function openRewardList(_arg_1:MouseEvent):void
        {
            var _local_5:Array;
            var _local_6:int;
            var _local_7:String;
            this.panelMC.rewardListMC.visible = true;
            this.eventHandler.addListener(this.panelMC.rewardListMC.panel.btnClose, MouseEvent.CLICK, this.closeRewardList);
            var _local_2:Object = GameData.get("yinyang2025");
            var _local_3:Array = ["hair", "set", "back", "weapon", "skill"];
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                _local_5 = _local_2.rewards_preview[_local_3[_local_4]];
                _local_6 = 0;
                while (_local_6 < 4)
                {
                    this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)].visible = false;
                    if (_local_6 < _local_5.length)
                    {
                        _local_7 = _local_5[_local_6].replace("%s", Character.character_gender);
                        this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)].visible = true;
                        NinjaSage.loadItemIcon(this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)], _local_7);
                        this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.visible = false;
                        if (Character.hasSkill(_local_7) > 0)
                        {
                            this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.visible = true;
                            this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.text = "Owned";
                        };
                        if (Character.isItemOwned(_local_7) > 0)
                        {
                            this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.visible = true;
                            this.panelMC.rewardListMC.panel[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.text = "Owned";
                        };
                    };
                    _local_6++;
                };
                _local_4++;
            };
        }

        private function closeRewardList(_arg_1:MouseEvent):void
        {
            var _local_3:int;
            this.panelMC.rewardListMC.visible = false;
            var _local_2:int;
            while (_local_2 < 5)
            {
                _local_3 = 0;
                while (_local_3 < 4)
                {
                    GF.removeAllChild(this.panelMC.rewardListMC.panel[("item_" + _local_2)][("iconMC_" + _local_3)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.rewardListMC.panel[("item_" + _local_2)][("iconMC_" + _local_3)].skillIcon.iconHolder);
                    _local_3++;
                };
                _local_2++;
            };
        }

        private function openTraining(_arg_1:MouseEvent):void
        {
            this.main.loadExternalSwfPanel("YinYangTraining", "YinYangTraining");
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function openMaterialMarket(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.MaterialMarket");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            GF.removeAllChild(this.panelMC);
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.panelMC = null;
            this.response = null;
            this.bossData = null;
            this.milestoneDataYin = null;
            this.milestoneDataYang = null;
            this.selectedMilestone = null;
            this.main = null;
        }


    }
}//package id.ninjasage.features

