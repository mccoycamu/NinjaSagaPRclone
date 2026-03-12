// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ConfrontingDeathMenu

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
    import Storage.SkillLibrary;
    import flash.events.Event;

    public class ConfrontingDeathMenu extends MovieClip 
    {

        private var main:*;
        private var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;
        private var response:Object;
        private var bossData:Object;
        private var milestoneData:Array;
        private var selectedBoss:int;
        private var skillData:Array;
        private var REFILL_PRICE:int = 50;
        private var selectedBuySkill:int = -1;
        private var selectedPreviewSkill:String;
        private var skillPrice:int;
        private var loaderSwf:BulkLoader;
        private var previewMC:PreviewManager;

        public function ConfrontingDeathMenu(_arg_1:*, _arg_2:*)
        {
            var _local_5:int;
            var _local_3:Object = GameData.get("confrontingdeath2025");
            var _local_4:* = {"level":Character.character_lvl};
            super();
            this.skillData = [];
            this.bossData = {
                "bossId":_local_3.bosses.id,
                "bossName":_local_3.bosses.name,
                "bossDescription":_local_3.bosses.description,
                "bossLevel":[(int(Character.character_lvl) + _local_3.bosses.levels[0]), (int(Character.character_lvl) + _local_3.bosses.levels[1])],
                "bossGold":int(Util.calculateFromString(_local_3.bosses.gold, _local_4)),
                "bossXp":int(Util.calculateFromString(_local_3.bosses.gold, _local_4)),
                "bossReward":_local_3.bosses.rewards,
                "battleBackground":_local_3.bosses.background
            };
            _local_5 = 0;
            while (_local_5 < _local_3.training.length)
            {
                this.skillData.push({
                    "skillId":_local_3.training[_local_5].id,
                    "skillPrice":_local_3.training[_local_5].price,
                    "skillName":_local_3.training[_local_5].name
                });
                _local_5++;
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
            this.main.amf_manager.service("ConfrontingDeathEvent2025.getBattleData", [Character.char_id, Character.sessionkey], this.onGetEventData);
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
            while (_local_1 < 8)
            {
                this.panelMC.bossDetailMc.energyMC[("heart_" + _local_1)].visible = false;
                if (this.response.energy > _local_1)
                {
                    this.panelMC.bossDetailMc.energyMC[("heart_" + _local_1)].visible = true;
                };
                _local_1++;
            };
        }

        private function initUI():void
        {
            this.panelMC.milestoneMC.visible = false;
            this.panelMC.rewardListMC.visible = false;
            this.panelMC.trainingMC.visible = false;
            this.panelMC.bossDetailMc.visible = false;
            this.panelMC.menuMC.visible = true;
            this.eventHandler.addListener(this.panelMC.menuMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_rewardList, MouseEvent.CLICK, this.openRewardList);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_milestone, MouseEvent.CLICK, this.openMilestone);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_battle, MouseEvent.CLICK, this.openBossDetail);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_training, MouseEvent.CLICK, this.openTraining);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_leaderboard, MouseEvent.CLICK, this.openLeaderboard);
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
            this.main.amf_manager.service("ConfrontingDeathEvent2025.refillEnergy", [Character.char_id, Character.sessionkey], this.refillResponse);
        }

        private function refillResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response.energy = _arg_1.energy;
                Character.account_tokens = (int(Character.account_tokens) - this.REFILL_PRICE);
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
            this.panelMC.bossDetailMc.visible = true;
            this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_close, MouseEvent.CLICK, this.closeBossDetail);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_start, MouseEvent.CLICK, this.startBattle);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.energyMC.heartBtn, MouseEvent.CLICK, this.refillConfirmation);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_milestone, MouseEvent.CLICK, this.openMilestone);
            this.panelMC.bossDetailMc.rewardMC.goldMc.txt.text = this.bossData.bossGold;
            this.panelMC.bossDetailMc.rewardMC.xpMc.txt.text = this.bossData.bossXp;
            this.panelMC.bossDetailMc.txt_level.text = ("Lv. " + this.bossData.bossLevel[1]);
            this.panelMC.bossDetailMc.txt_name.text = this.bossData.bossName;
            this.panelMC.bossDetailMc.txt_description.text = this.bossData.bossDescription;
            var _local_2:int;
            while (_local_2 < 5)
            {
                this.panelMC.bossDetailMc.rewardMC[("iconMc_" + _local_2)].visible = false;
                if (this.bossData.bossReward.length > _local_2)
                {
                    this.panelMC.bossDetailMc.rewardMC[("iconMc_" + _local_2)].visible = true;
                    NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.rewardMC[("iconMc_" + _local_2)], this.bossData.bossReward[_local_2]);
                };
                this.panelMC.bossDetailMc.rewardMC[("iconMc_" + _local_2)].amountTxt.text = "";
                this.panelMC.bossDetailMc.rewardMC[("iconMc_" + _local_2)].ownedTxt.text = "";
                _local_2++;
            };
        }

        private function startBattle(_arg_1:MouseEvent):void
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = undefined;
            var _local_6:* = this.bossData.bossId["battle_2"][0];
            Character.christmas_boss_num = 0;
            Character.christmas_boss_id = _local_6;
            _local_2 = StatManager.calculate_stats_with_data("agility");
            _local_3 = EnemyInfo.getCopy(_local_6);
            _local_5 = ((((("id:" + _local_3["enemy_id"]) + "|hp:") + _local_3["enemy_hp"]) + "|agility:") + _local_3["enemy_agility"]);
            _local_4 = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray((((String(Character.char_id) + String(_local_6)) + _local_5) + String(_local_2)))));
            this.main.loading(true);
            this.main.amf_manager.service("ConfrontingDeathEvent2025.startBattle", [Character.char_id, _local_6, _local_2, _local_5, _local_4, Character.sessionkey], this.onStartEventAmf);
        }

        private function onStartEventAmf(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.battle_code = _arg_1.code;
                this.main.confronting_death_battle_counter = 0;
                this.main.loadConfrontingDeathDialogue("scene_1");
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
            this.panelMC.milestoneMC.txt_title.text = "Milestone";
            this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close, MouseEvent.CLICK, this.closeMilestone);
            this.main.loading(true);
            this.main.amf_manager.service("ConfrontingDeathEvent2025.getBonusRewards", [Character.char_id, Character.sessionkey], this.openMilestoneRewards);
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
                    this.panelMC.milestoneMC[("reward_" + _local_2)].skullMc.greenSkull.visible = false;
                    if (_local_3)
                    {
                        this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = false;
                        this.panelMC.milestoneMC[("reward_" + _local_2)].skullMc.greenSkull.visible = true;
                        this.eventHandler.addListener(this.panelMC.milestoneMC[("reward_" + _local_2)]["btn_claim"], MouseEvent.CLICK, this.onClaimBonusRequest);
                    };
                    if (_local_4)
                    {
                        this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = false;
                        this.panelMC.milestoneMC[("reward_" + _local_2)].skullMc.greenSkull.visible = true;
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
            this.main.amf_manager.service("ConfrontingDeathEvent2025.claimBonusRewards", [Character.char_id, Character.sessionkey, _local_2], this.onClaimBonusResponse);
        }

        private function onClaimBonusResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.reward);
                this.main.HUD.setBasicData();
                this.main.giveReward(1, _arg_1.reward, "halloween");
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
            this.panelMC.rewardListMC.visible = true;
            this.eventHandler.addListener(this.panelMC.rewardListMC.btn_close, MouseEvent.CLICK, this.closeRewardList);
            this.eventHandler.addListener(this.panelMC.rewardListMC.btn_mm, MouseEvent.CLICK, this.openMaterialMarket);
            var _local_2:Object = GameData.get("confrontingdeath2025");
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
                    if (_local_6 < _local_5.length)
                    {
                        _local_7 = _local_5[_local_6].replace("%s", Character.character_gender);
                        this.panelMC.rewardListMC[("item_" + _local_4)][("iconMC_" + _local_6)].visible = true;
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

        private function openTraining(_arg_1:MouseEvent):void
        {
            this.panelMC.trainingMC.visible = true;
            this.panelMC.trainingMC.previewMC.visible = false;
            this.eventHandler.addListener(this.panelMC.trainingMC.btn_close, MouseEvent.CLICK, this.closeTraining);
            var _local_2:int;
            while (_local_2 < this.skillData.length)
            {
                this.panelMC.trainingMC[("skill_" + _local_2)]["iconMC"].amountTxt.text = "";
                this.panelMC.trainingMC[("skill_" + _local_2)]["iconMC"].ownedTxt.text = "";
                this.panelMC.trainingMC[("skill_" + _local_2)].txt_name.text = this.skillData[_local_2].skillName;
                this.panelMC.trainingMC[("skill_" + _local_2)]["price_0"].text = this.skillData[_local_2].skillPrice[0];
                this.panelMC.trainingMC[("skill_" + _local_2)]["price_1"].text = this.skillData[_local_2].skillPrice[1];
                NinjaSage.loadItemIcon(this.panelMC.trainingMC[("skill_" + _local_2)]["iconMC"], this.skillData[_local_2].skillId);
                this.eventHandler.addListener(this.panelMC.trainingMC[("skill_" + _local_2)].btn_emblem, MouseEvent.CLICK, this.openRecharge);
                this.eventHandler.addListener(this.panelMC.trainingMC[("skill_" + _local_2)].btn_preview, MouseEvent.CLICK, this.openPreview);
                this.eventHandler.addListener(this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_0, MouseEvent.CLICK, this.showConfirmationSkill);
                this.eventHandler.addListener(this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_1, MouseEvent.CLICK, this.showConfirmationSkill);
                if (Character.account_type == 0)
                {
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_0.visible = true;
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_1.visible = false;
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_emblem.visible = true;
                    this.panelMC.trainingMC[("skill_" + _local_2)].txt_bought_0.visible = true;
                    this.panelMC.trainingMC[("skill_" + _local_2)].txt_bought_1.visible = false;
                }
                else
                {
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_0.visible = false;
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_1.visible = true;
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_emblem.visible = false;
                    this.panelMC.trainingMC[("skill_" + _local_2)].txt_bought_0.visible = false;
                    this.panelMC.trainingMC[("skill_" + _local_2)].txt_bought_1.visible = true;
                };
                if (Character.hasSkill(this.skillData[_local_2].skillId) > 0)
                {
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_0.visible = false;
                    this.panelMC.trainingMC[("skill_" + _local_2)].btn_buy_1.visible = false;
                    if (Character.account_type == 1)
                    {
                        this.panelMC.trainingMC[("skill_" + _local_2)].btn_emblem.visible = false;
                    };
                    this.panelMC.trainingMC[("skill_" + _local_2)]["iconMC"].ownedTxt.text = "Owned";
                };
                _local_2++;
            };
            if (Character.hasSkill(this.skillData[1].skillId) > 0)
            {
                this.panelMC.trainingMC["skill_0"].btn_buy_0.visible = false;
                this.panelMC.trainingMC["skill_0"].btn_buy_1.visible = false;
                if (Character.account_type == 1)
                {
                    this.panelMC.trainingMC["skill_0"].btn_emblem.visible = false;
                };
                this.panelMC.trainingMC["skill_0"]["iconMC"].ownedTxt.text = "Owned";
            };
        }

        private function openPreview(_arg_1:MouseEvent):void
        {
            this.panelMC.trainingMC.previewMC.visible = true;
            this.eventHandler.addListener(this.panelMC.trainingMC.previewMC.btn_close, MouseEvent.CLICK, this.closePreview);
            this.eventHandler.addListener(this.panelMC.trainingMC.previewMC.btn_replay, MouseEvent.CLICK, this.handleReplay);
            this.selectedPreviewSkill = this.skillData[_arg_1.currentTarget.parent.name.replace("skill_", "")].skillId;
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
            this.previewMC = new PreviewManager(this.main, _local_4, _local_3);
            this.panelMC.trainingMC.previewMC.skillMc.addChild(this.previewMC.preview_mc);
            this.previewMC.preview_mc.gotoAndPlay(2);
        }

        private function closePreview(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.panelMC.trainingMC.previewMC.skillMc);
            this.panelMC.trainingMC.previewMC.visible = false;
        }

        private function handleReplay(_arg_1:MouseEvent):void
        {
            this.previewMC.preview_mc.gotoAndPlay(2);
        }

        private function showConfirmationSkill(e:MouseEvent):void
        {
            this.selectedBuySkill = e.currentTarget.parent.name.replace("skill_", "");
            this.confirmation = new Confirmation();
            this.skillPrice = this.skillData[this.selectedBuySkill].skillPrice[Character.account_type];
            this.confirmation.txtMc.txt.text = (((("Confirm buying " + this.skillData[this.selectedBuySkill].skillName) + " for ") + this.skillPrice) + " tokens?");
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
            this.main.amf_manager.service("ConfrontingDeathEvent2025.buySkill", [Character.char_id, Character.sessionkey, this.selectedBuySkill], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, this.skillData[this.selectedBuySkill].skillId, "halloween");
                Character.updateSkills(this.skillData[this.selectedBuySkill].skillId, true);
                Character.account_tokens = (int(Character.account_tokens) - this.skillPrice);
                if (this.selectedBuySkill > 0)
                {
                    Character.updateSkills(this.skillData[0].skillId, false);
                };
                this.openTraining(null);
                this.main.HUD.setBasicData();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closeTraining(_arg_1:MouseEvent):void
        {
            this.panelMC.trainingMC.visible = false;
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
            this.skillData = null;
            this.main = null;
        }


    }
}//package id.ninjasage.features

