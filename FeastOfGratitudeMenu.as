// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.FeastOfGratitudeMenu

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import br.com.stimuli.loading.BulkLoader;
    import Managers.PreviewManager;
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
    import Storage.SkillLibrary;
    import flash.events.Event;

    public class FeastOfGratitudeMenu extends MovieClip 
    {

        private var main:*;
        private var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;
        private var response:Object;
        private var bossData:Array;
        private var milestoneData:Array;
        private var selectedBoss:int;
        private var packageData:Object;
        private var REFILL_PRICE:int = 50;
        private var selectedBuySkill:int = -1;
        private var selectedPreviewSkill:String;
        private var skillPrice:int;
        private var loaderSwf:BulkLoader;
        private var previewMC:PreviewManager;

        public function FeastOfGratitudeMenu(_arg_1:*, _arg_2:*)
        {
            var _local_5:int;
            var _local_3:Object = GameData.get("thanksgiving2025");
            var _local_4:* = {"level":Character.character_lvl};
            super();
            this.packageData = [];
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
            this.packageData = {
                "packageName":_local_3.paket.name,
                "packagePrice":_local_3.paket.price,
                "packageRewards":_local_3.paket.rewards
            };
            this.milestoneData = [];
            _local_5 = 0;
            while (_local_5 < _local_3.milestone_battle.length)
            {
                this.milestoneData.push({
                    "rewardId":_local_3.milestone_battle[_local_5].id.replace("%s", Character.character_gender),
                    "rewardReq":_local_3.milestone_battle[_local_5].requirement,
                    "rewardQty":_local_3.milestone_battle[_local_5].quantity
                });
                _local_5++;
            };
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = this.main.eventHandler;
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
            this.main.handleVillageHUDVisibility(false);
            this.getEventData();
        }

        private function getEventData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ThanksGivingEvent2025.getBattleData", [Character.char_id, Character.sessionkey], this.onGetEventData);
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
            while (_local_1 < 10)
            {
                this.panelMC.bossDetailMc.content.energyMC[("heart_" + _local_1)].visible = false;
                if (this.response.energy > _local_1)
                {
                    this.panelMC.bossDetailMc.content.energyMC[("heart_" + _local_1)].visible = true;
                };
                _local_1++;
            };
        }

        private function hidePanels():void
        {
            this.panelMC.milestoneMC.visible = false;
            this.panelMC.rewardListMC.visible = false;
            this.panelMC.packageMC.visible = false;
            this.panelMC.bossDetailMc.visible = false;
            this.panelMC.bossDetailMc.content.visible = false;
            this.panelMC.previewMC.visible = false;
            this.panelMC.menuMC.visible = false;
        }

        private function initUI():void
        {
            this.hidePanels();
            this.panelMC.menuMC.visible = true;
            this.eventHandler.addListener(this.panelMC.menuMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_rewardList, MouseEvent.CLICK, this.openRewardList);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_milestone, MouseEvent.CLICK, this.openMilestone);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_battle, MouseEvent.CLICK, this.openBossUI);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_package, MouseEvent.CLICK, this.getPackageData);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_materialmarket, MouseEvent.CLICK, this.openMaterialMarket);
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
            this.main.amf_manager.service("ThanksGivingEvent2025.refillEnergy", [Character.char_id, Character.sessionkey], this.refillResponse);
        }

        private function refillResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response.energy = _arg_1.energy;
                Character.account_tokens = (int(Character.account_tokens) - this.REFILL_PRICE);
                this.panelMC.bossDetailMc.content.tokenTxt.text = Character.account_tokens;
                this.main.HUD.setBasicData();
                this.updateEnergy();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function openBossUI(_arg_1:MouseEvent):void
        {
            this.hidePanels();
            this.panelMC.bossDetailMc.visible = true;
            this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_close, MouseEvent.CLICK, this.closeBossUI);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_milestone, MouseEvent.CLICK, this.openMilestone);
            var _local_2:MovieClip = this.panelMC.bossDetailMc;
            var _local_3:int;
            while (_local_3 < 4)
            {
                _local_2[("enemy_" + _local_3)].enemyMC.gotoAndStop((_local_3 + 1));
                this.eventHandler.addListener(_local_2[("enemy_" + _local_3)].btn_openDetail, MouseEvent.CLICK, this.openBossDetail);
                _local_3++;
            };
        }

        private function closeBossUI(_arg_1:MouseEvent):void
        {
            this.panelMC.bossDetailMc.visible = false;
            this.panelMC.menuMC.visible = true;
        }

        private function openBossDetail(_arg_1:MouseEvent):void
        {
            this.selectedBoss = _arg_1.currentTarget.parent.name.replace("enemy_", "");
            this.panelMC.bossDetailMc.content.visible = true;
            this.panelMC.bossDetailMc.content.enemyMC.gotoAndStop((this.selectedBoss + 1));
            this.eventHandler.addListener(this.panelMC.bossDetailMc.content.btn_close, MouseEvent.CLICK, this.closeBossDetail);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.content.btn_start, MouseEvent.CLICK, this.startBattle);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.content.energyMC.heartBtn, MouseEvent.CLICK, this.refillConfirmation);
            this.panelMC.bossDetailMc.content.tokenTxt.text = Character.account_tokens;
            this.panelMC.bossDetailMc.content.rewardMC.goldMc.txt.text = this.bossData[this.selectedBoss].bossGold;
            this.panelMC.bossDetailMc.content.rewardMC.xpMc.txt.text = this.bossData[this.selectedBoss].bossXp;
            this.panelMC.bossDetailMc.content.txt_level.text = ("Lv. " + this.bossData[this.selectedBoss].bossLevel[1]);
            this.panelMC.bossDetailMc.content.txt_name.text = this.bossData[this.selectedBoss].bossName;
            this.panelMC.bossDetailMc.content.txt_description.text = this.bossData[this.selectedBoss].bossDescription;
            var _local_2:int;
            while (_local_2 < 5)
            {
                this.panelMC.bossDetailMc.content.rewardMC[("iconMc_" + _local_2)].visible = false;
                this.panelMC.bossDetailMc.content.rewardMC[("iconMc_" + _local_2)].btn_preview.visible = false;
                if (this.bossData[this.selectedBoss].bossReward.length > _local_2)
                {
                    this.panelMC.bossDetailMc.content.rewardMC[("iconMc_" + _local_2)].visible = true;
                    NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.content.rewardMC[("iconMc_" + _local_2)], this.bossData[this.selectedBoss].bossReward[_local_2]);
                };
                this.panelMC.bossDetailMc.content.rewardMC[("iconMc_" + _local_2)].amountTxt.text = "";
                this.panelMC.bossDetailMc.content.rewardMC[("iconMc_" + _local_2)].ownedTxt.text = "";
                _local_2++;
            };
        }

        private function startBattle(_arg_1:MouseEvent):void
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = undefined;
            var _local_6:* = this.bossData[this.selectedBoss].bossId[0];
            Character.christmas_boss_num = 0;
            Character.christmas_boss_id = _local_6;
            _local_2 = StatManager.calculate_stats_with_data("agility");
            _local_3 = EnemyInfo.getCopy(_local_6);
            _local_5 = ((((("id:" + _local_3["enemy_id"]) + "|hp:") + _local_3["enemy_hp"]) + "|agility:") + _local_3["enemy_agility"]);
            _local_4 = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray((((String(Character.char_id) + String(_local_6)) + _local_5) + String(_local_2)))));
            this.main.loading(true);
            this.main.amf_manager.service("ThanksGivingEvent2025.startBattle", [Character.char_id, _local_6, _local_2, _local_5, _local_4, Character.sessionkey], this.onStartEventAmf);
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
                Character.is_thanksgiving_event = true;
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
            this.panelMC.bossDetailMc.content.visible = false;
        }

        private function openMilestone(_arg_1:MouseEvent):*
        {
            this.hidePanels();
            this.panelMC.milestoneMC.visible = true;
            this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close, MouseEvent.CLICK, this.closeMilestone);
            this.main.loading(true);
            this.main.amf_manager.service("ThanksGivingEvent2025.getBonusRewards", [Character.char_id, Character.sessionkey], this.openMilestoneRewards);
            var _local_2:* = 0;
            while (_local_2 < 8)
            {
                this.panelMC.milestoneMC[("reward_" + _local_2)]["txt_requiredBattle"].text = (String(this.milestoneData[_local_2].rewardReq) + " Battles");
                this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].amountTxt.text = ((this.milestoneData[_local_2].rewardQty <= 1) ? "" : ("x" + this.milestoneData[_local_2].rewardQty));
                this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].ownedTxt.visible = false;
                if (Character.hasSkill(this.milestoneData[_local_2].rewardId) > 0)
                {
                    this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].ownedTxt.visible = true;
                    this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(this.milestoneData[_local_2].rewardId) > 0)
                {
                    this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].ownedTxt.visible = true;
                    this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].ownedTxt.text = "Owned";
                };
                this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].btn_preview.visible = ((this.milestoneData[_local_2].rewardId.indexOf("skill_") == -1) ? false : true);
                this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].btn_preview.metaData = {"skillId":this.milestoneData[_local_2].rewardId};
                this.eventHandler.addListener(this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].btn_preview, MouseEvent.CLICK, this.openPreview);
                NinjaSage.loadItemIcon(this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"], this.milestoneData[_local_2].rewardId);
                _local_2++;
            };
        }

        private function openMilestoneRewards(_arg_1:Object):*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.milestoneMC.txt_draws.text = (("You've Battles " + _arg_1.milestone) + " times !");
                _local_2 = 0;
                while (_local_2 < 8)
                {
                    _local_3 = (((_arg_1.rewards[_local_2] == false) && (_arg_1.milestone >= this.milestoneData[_local_2].rewardReq)) ? true : false);
                    _local_4 = (_arg_1.rewards[_local_2] == true);
                    this.panelMC.milestoneMC[("reward_" + _local_2)]["btn_claim"].visible = _local_3;
                    this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = true;
                    if (_local_3)
                    {
                        this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = false;
                        this.eventHandler.addListener(this.panelMC.milestoneMC[("reward_" + _local_2)]["btn_claim"], MouseEvent.CLICK, this.onClaimBonusRequest);
                    };
                    if (_local_4)
                    {
                        this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = false;
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
            var _local_2:int = int(_arg_1.currentTarget.parent.name.replace("reward_", ""));
            this.main.amf_manager.service("ThanksGivingEvent2025.claimBonusRewards", [Character.char_id, Character.sessionkey, _local_2], this.onClaimBonusResponse);
        }

        private function onClaimBonusResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.reward);
                this.main.HUD.setBasicData();
                this.main.giveReward(1, _arg_1.reward, "thanksgiving");
                this.openMilestone(null);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        public function closeMilestone(_arg_1:MouseEvent):*
        {
            this.panelMC.milestoneMC.visible = false;
            this.panelMC.menuMC.visible = true;
            var _local_2:int;
            while (_local_2 < 8)
            {
                GF.removeAllChild(this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.milestoneMC[("reward_" + _local_2)]["iconMc"].skillIcon.iconHolder);
                _local_2++;
            };
        }

        private function openRewardList(_arg_1:MouseEvent):void
        {
            var _local_5:Array;
            var _local_6:int;
            var _local_7:String;
            this.hidePanels();
            this.panelMC.rewardListMC.visible = true;
            this.eventHandler.addListener(this.panelMC.rewardListMC.btn_close, MouseEvent.CLICK, this.closeRewardList);
            this.eventHandler.addListener(this.panelMC.rewardListMC.btn_mm, MouseEvent.CLICK, this.openMaterialMarket);
            var _local_2:Object = GameData.get("thanksgiving2025");
            var _local_3:Array = ["hair", "set", "back", "weapon", "skill"];
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                _local_5 = _local_2.rewards_preview[_local_3[_local_4]];
                _local_6 = 0;
                while (_local_6 < 4)
                {
                    this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].visible = false;
                    this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].amountTxt.text = "";
                    this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].btn_preview.visible = false;
                    if (_local_6 < _local_5.length)
                    {
                        _local_7 = _local_5[_local_6].replace("%s", Character.character_gender);
                        this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].visible = true;
                        this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].btn_preview.visible = ((_local_7.indexOf("skill_") == -1) ? false : true);
                        this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].btn_preview.metaData = {"skillId":_local_7};
                        this.eventHandler.addListener(this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].btn_preview, MouseEvent.CLICK, this.openPreview);
                        NinjaSage.loadItemIcon(this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)], _local_7);
                        this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.visible = false;
                        if (Character.hasSkill(_local_7) > 0)
                        {
                            this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.visible = true;
                            this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.text = "Owned";
                        };
                        if (Character.isItemOwned(_local_7) > 0)
                        {
                            this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.visible = true;
                            this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].ownedTxt.text = "Owned";
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
            this.panelMC.menuMC.visible = true;
            var _local_2:int;
            while (_local_2 < 5)
            {
                _local_3 = 0;
                while (_local_3 < 4)
                {
                    GF.removeAllChild(this.panelMC.rewardListMC[("item_" + _local_2)][("iconMC_" + _local_3)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.rewardListMC[("item_" + _local_2)][("iconMC_" + _local_3)].skillIcon.iconHolder);
                    _local_3++;
                };
                _local_2++;
            };
        }

        private function getPackageData(_arg_1:MouseEvent):void
        {
            this.main.amf_manager.service("ThanksGivingEvent2025.getPackage", [Character.char_id, Character.sessionkey], this.openTraining);
        }

        private function openTraining(_arg_1:Object):void
        {
            var _local_4:String;
            this.hidePanels();
            this.panelMC.packageMC.visible = true;
            this.eventHandler.addListener(this.panelMC.packageMC.btn_close, MouseEvent.CLICK, this.closeTraining);
            var _local_2:MovieClip = this.panelMC.packageMC;
            _local_2.tokenTxt.text = Character.account_tokens;
            var _local_3:int;
            while (_local_3 < this.packageData.packageRewards.length)
            {
                _local_4 = this.packageData.packageRewards[_local_3].replace("%s", Character.character_gender);
                _local_2[("iconMC_" + _local_3)].amountTxt.text = "";
                _local_2[("iconMC_" + _local_3)].ownedTxt.text = "";
                _local_2[("iconMC_" + _local_3)].btn_preview.visible = ((_local_4.indexOf("skill_") == -1) ? false : true);
                _local_2[("iconMC_" + _local_3)].btn_preview.metaData = {"skillId":_local_4};
                this.eventHandler.addListener(_local_2[("iconMC_" + _local_3)].btn_preview, MouseEvent.CLICK, this.openPreview);
                NinjaSage.loadItemIcon(_local_2[("iconMC_" + _local_3)], _local_4);
                if (Character.hasSkill(_local_4) > 0)
                {
                    _local_2[("iconMC_" + _local_3)].ownedTxt.visible = true;
                    _local_2[("iconMC_" + _local_3)].ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(_local_4) > 0)
                {
                    _local_2[("iconMC_" + _local_3)].ownedTxt.visible = true;
                    _local_2[("iconMC_" + _local_3)].ownedTxt.text = "Owned";
                };
                _local_3++;
            };
            _local_2.priceMC.emblemMC.btn_emblem.visible = true;
            _local_2.priceMC.emblemMC.btn_buy.visible = false;
            if (Character.account_type == 1)
            {
                _local_2.priceMC.freeMC.btn_buy.visible = false;
                _local_2.priceMC.emblemMC.btn_emblem.visible = false;
                _local_2.priceMC.emblemMC.btn_buy.visible = true;
            };
            if (_arg_1.bought)
            {
                _local_2.priceMC.emblemMC.btn_buy.visible = false;
                _local_2.priceMC.freeMC.btn_buy.visible = false;
            };
            _local_2.priceMC.freeMC.txt_price.text = this.packageData.packagePrice[0];
            _local_2.priceMC.emblemMC.txt_price.text = this.packageData.packagePrice[1];
            this.eventHandler.addListener(_local_2.priceMC.emblemMC.btn_emblem, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(_local_2.priceMC.emblemMC.btn_buy, MouseEvent.CLICK, this.showConfirmationSkill);
            this.eventHandler.addListener(_local_2.priceMC.freeMC.btn_buy, MouseEvent.CLICK, this.showConfirmationSkill);
        }

        private function openPreview(_arg_1:MouseEvent):void
        {
            this.panelMC.previewMC.visible = true;
            this.eventHandler.addListener(this.panelMC.previewMC.btn_close, MouseEvent.CLICK, this.closePreview);
            this.eventHandler.addListener(this.panelMC.previewMC.btn_replay, MouseEvent.CLICK, this.handleReplay);
            this.selectedPreviewSkill = _arg_1.currentTarget.metaData.skillId;
            this.panelMC.previewMC.txt_name.text = SkillLibrary.getSkillInfo(this.selectedPreviewSkill).skill_name;
            this.loadSkillAndPreview();
        }

        private function loadSkillAndPreview():void
        {
            var _local_1:* = (("skills/" + this.selectedPreviewSkill) + ".swf");
            var _local_2:* = this.loaderSwf.add(_local_1);
            _local_2.addEventListener(BulkLoader.COMPLETE, this.completePreview);
            this.loaderSwf.start();
        }

        private function completePreview(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_3:Object = SkillLibrary.getSkillInfo(this.selectedPreviewSkill);
            var _local_4:MovieClip = _arg_1.target.content[this.selectedPreviewSkill];
            var _local_5:Array = [this.packageData.packageRewards[3], this.packageData.packageRewards[2], this.packageData.packageRewards[1], this.packageData.packageRewards[0], Character.character_face, Character.character_color_hair, Character.character_color_skin];
            if (!this.panelMC.packageMC.visible)
            {
                _local_5 = null;
            };
            this.previewMC = new PreviewManager(this.main, _local_4, _local_3, _local_5);
            this.panelMC.previewMC.skillMc.scaleX = 1.5;
            this.panelMC.previewMC.skillMc.scaleY = 1.5;
            this.panelMC.previewMC.skillMc.addChild(this.previewMC.preview_mc);
            this.previewMC.preview_mc.gotoAndPlay(2);
        }

        private function closePreview(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.panelMC.previewMC.skillMc);
            this.previewMC.destroy();
            this.previewMC = null;
            this.panelMC.previewMC.visible = false;
        }

        private function handleReplay(_arg_1:MouseEvent):void
        {
            this.previewMC.preview_mc.gotoAndPlay(2);
        }

        private function showConfirmationSkill(e:MouseEvent):void
        {
            this.selectedBuySkill = Character.account_type;
            this.confirmation = new Confirmation();
            this.skillPrice = this.packageData.packagePrice[Character.account_type];
            this.confirmation.txtMc.txt.text = (((("Confirm buying " + this.packageData.packageName) + " for ") + this.skillPrice) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPackage);
            this.panelMC.addChild(this.confirmation);
        }

        private function buyPackage(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("ThanksGivingEvent2025.buyPackage", [Character.char_id, Character.sessionkey], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, this.packageData.packageRewards, "thanksgiving");
                Character.addRewards(this.packageData.packageRewards);
                Character.account_tokens = (int(Character.account_tokens) - this.skillPrice);
                this.getPackageData(null);
                this.main.HUD.setBasicData();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closeTraining(_arg_1:MouseEvent):void
        {
            this.panelMC.packageMC.visible = false;
            this.panelMC.menuMC.visible = true;
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function openMaterialMarket(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.MaterialMarket");
        }

        private function openLeaderboard(_arg_1:MouseEvent):void
        {
            this.main.loadExternalSwfPanel("Leaderboard", "Leaderboard");
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
            this.milestoneData = null;
            this.packageData = null;
            this.main = null;
        }


    }
}//package id.ninjasage.features

