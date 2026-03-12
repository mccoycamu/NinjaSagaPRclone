// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ChristmasMenu

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import br.com.stimuli.loading.BulkLoader;
    import Managers.PreviewManager;
    import Panels.PetFrenzy;
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

    public class ChristmasMenu extends MovieClip 
    {

        private var main:*;
        private var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;
        private var response:Object;
        public var minigameResponse:Object;
        private var bossData:Array;
        private var milestoneData:Array;
        private var newYearData:Array;
        private var minigameData:Array;
        private var selectedBoss:int;
        private var REFILL_PRICE:int = 50;
        private var selectedPreviewSkill:String;
        private var loaderSwf:BulkLoader;
        private var previewMC:PreviewManager;
        private var isMinigameOpen:Boolean = false;
        private var petFrenzy:PetFrenzy;

        public function ChristmasMenu(_arg_1:*, _arg_2:*)
        {
            var _local_5:int;
            var _local_3:Object = GameData.get("christmas2025");
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
            this.newYearData = [];
            _local_5 = 0;
            while (_local_5 < _local_3.new_year.length)
            {
                this.newYearData.push(_local_3.new_year[_local_5].replace("%s", Character.character_gender));
                _local_5++;
            };
            this.minigameData = [];
            _local_5 = 0;
            while (_local_5 < _local_3.minigame.length)
            {
                this.minigameData.push(_local_3.minigame[_local_5].replace("%s", Character.character_gender));
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
            this.main.amf_manager.service("ChristmasEvent2025.getBattleData", [Character.char_id, Character.sessionkey], this.onGetEventData);
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
                this.panelMC.bossDetailMc.content[("heart_" + _local_1)].visible = false;
                if (this.response.energy > _local_1)
                {
                    this.panelMC.bossDetailMc.content[("heart_" + _local_1)].visible = true;
                };
                _local_1++;
            };
        }

        private function hidePanels():void
        {
            this.panelMC.milestoneMC.visible = false;
            this.panelMC.rewardListMC.visible = false;
            this.panelMC.bossDetailMc.visible = false;
            this.panelMC.bossDetailMc.content.visible = false;
            this.panelMC.previewMC.visible = false;
            this.panelMC.newYearMC.visible = false;
            this.panelMC.minigameCoverMC.visible = false;
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
            this.eventHandler.addListener(this.panelMC.menuMC.btn_newYear, MouseEvent.CLICK, this.openNewYear);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_minigame, MouseEvent.CLICK, this.openMinigame);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_leaderboard, MouseEvent.CLICK, this.openLeaderboard);
            this.eventHandler.addListener(this.panelMC.menuMC.btn_gacha, MouseEvent.CLICK, this.openChristmasGacha);
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
            if (this.isMinigameOpen)
            {
                this.main.amf_manager.service("ChristmasEvent2025.refillMinigameEnergy", [Character.char_id, Character.sessionkey], this.refillResponse);
            }
            else
            {
                this.main.amf_manager.service("ChristmasEvent2025.refillEnergy", [Character.char_id, Character.sessionkey], this.refillResponse);
            };
        }

        private function refillResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if (this.isMinigameOpen)
                {
                    this.minigameResponse.energy = _arg_1.energy;
                }
                else
                {
                    this.response.energy = _arg_1.energy;
                };
                Character.account_tokens = (int(Character.account_tokens) - this.REFILL_PRICE);
                this.panelMC.bossDetailMc.content.tokenTxt.text = Character.account_tokens;
                this.panelMC.minigameCoverMC.tokenTxt.text = Character.account_tokens;
                this.main.HUD.setBasicData();
                this.updateEnergy();
                this.updateMinigameEnergy();
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
            var _local_2:MovieClip = this.panelMC.bossDetailMc;
            var _local_3:int;
            while (_local_3 < 3)
            {
                _local_2[("enemy_" + _local_3)].enemyMC.gotoAndStop((_local_3 + 1));
                _local_2[("enemy_" + _local_3)].txt_name.text = this.bossData[_local_3].bossName;
                this.eventHandler.addListener(_local_2[("enemy_" + _local_3)], MouseEvent.CLICK, this.openBossDetail);
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
            this.selectedBoss = _arg_1.currentTarget.name.replace("enemy_", "");
            this.panelMC.bossDetailMc.content.visible = true;
            this.panelMC.bossDetailMc.content.enemyMC.gotoAndStop((this.selectedBoss + 1));
            this.eventHandler.addListener(this.panelMC.bossDetailMc.content.btn_close, MouseEvent.CLICK, this.closeBossDetail);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.content.btn_start, MouseEvent.CLICK, this.startBattle);
            this.eventHandler.addListener(this.panelMC.bossDetailMc.content.heartBtn, MouseEvent.CLICK, this.refillConfirmation);
            this.panelMC.bossDetailMc.content.tokenTxt.text = Character.account_tokens;
            this.panelMC.bossDetailMc.content.goldMc.txt.text = this.bossData[this.selectedBoss].bossGold;
            this.panelMC.bossDetailMc.content.xpMc.txt.text = this.bossData[this.selectedBoss].bossXp;
            this.panelMC.bossDetailMc.content.txt_level.text = ("Lv. " + this.bossData[this.selectedBoss].bossLevel[1]);
            this.panelMC.bossDetailMc.content.txt_name.text = this.bossData[this.selectedBoss].bossName;
            this.panelMC.bossDetailMc.content.txt_description.text = this.bossData[this.selectedBoss].bossDescription;
            var _local_2:int;
            while (_local_2 < 5)
            {
                this.panelMC.bossDetailMc.content[("iconMc_" + _local_2)].visible = false;
                this.panelMC.bossDetailMc.content[("iconMc_" + _local_2)].btn_preview.visible = false;
                if (this.bossData[this.selectedBoss].bossReward.length > _local_2)
                {
                    this.panelMC.bossDetailMc.content[("iconMc_" + _local_2)].visible = true;
                    NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.content[("iconMc_" + _local_2)], this.bossData[this.selectedBoss].bossReward[_local_2]);
                };
                this.panelMC.bossDetailMc.content[("iconMc_" + _local_2)].amountTxt.text = "";
                this.panelMC.bossDetailMc.content[("iconMc_" + _local_2)].ownedTxt.text = "";
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
            this.main.amf_manager.service("ChristmasEvent2025.startBattle", [Character.char_id, _local_6, _local_2, _local_5, _local_4, Character.sessionkey], this.onStartEventAmf);
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
                Character.is_christmas_event = true;
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
            this.main.amf_manager.service("ChristmasEvent2025.getBonusRewards", [Character.char_id, Character.sessionkey], this.openMilestoneRewards);
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
                this.panelMC.milestoneMC.txt_draws.text = ("Battles: " + _arg_1.milestone);
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
            this.main.amf_manager.service("ChristmasEvent2025.claimBonusRewards", [Character.char_id, Character.sessionkey, _local_2], this.onClaimBonusResponse);
        }

        private function onClaimBonusResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.reward);
                this.main.HUD.setBasicData();
                this.main.giveReward(1, _arg_1.reward, "winter");
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

        private function openNewYear(_arg_1:MouseEvent):void
        {
            this.hidePanels();
            this.panelMC.newYearMC.visible = true;
            this.eventHandler.addListener(this.panelMC.newYearMC.btn_close, MouseEvent.CLICK, this.closeNewYear);
            this.eventHandler.addListener(this.panelMC.newYearMC.btn_claim, MouseEvent.CLICK, this.claimNewYear);
            var _local_2:Boolean;
            var _local_3:int;
            while (_local_3 < this.newYearData.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.newYearMC[("iconMc_" + _local_3)], this.newYearData[_local_3]);
                this.panelMC.newYearMC[("iconMc_" + _local_3)].amountTxt.text = "";
                this.panelMC.newYearMC[("iconMc_" + _local_3)].btn_preview.visible = ((this.newYearData[_local_3].indexOf("skill_") == -1) ? false : true);
                this.panelMC.newYearMC[("iconMc_" + _local_3)].btn_preview.metaData = {"skillId":this.newYearData[_local_3]};
                this.eventHandler.addListener(this.panelMC.newYearMC[("iconMc_" + _local_3)].btn_preview, MouseEvent.CLICK, this.openPreview);
                this.panelMC.newYearMC[("iconMc_" + _local_3)].ownedTxt.visible = false;
                if (Character.hasSkill(this.newYearData[_local_3]) > 0)
                {
                    this.panelMC.newYearMC[("iconMc_" + _local_3)].ownedTxt.visible = true;
                    this.panelMC.newYearMC[("iconMc_" + _local_3)].ownedTxt.text = "Owned";
                    _local_2 = true;
                };
                if (Character.isItemOwned(this.newYearData[_local_3]) > 0)
                {
                    this.panelMC.newYearMC[("iconMc_" + _local_3)].ownedTxt.visible = true;
                    this.panelMC.newYearMC[("iconMc_" + _local_3)].ownedTxt.text = "Owned";
                    _local_2 = true;
                };
                _local_3++;
            };
            this.panelMC.newYearMC.btn_claim.visible = (!(_local_2));
        }

        private function claimNewYear(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("NewYear2026.claim", [Character.char_id, Character.sessionkey], this.claimNewYearResponse);
        }

        private function claimNewYearResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, _arg_1.rewards, "christmas");
                Character.addRewards(_arg_1.rewards);
                this.openNewYear(null);
            }
            else
            {
                this.main.getNotice(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closeNewYear(_arg_1:MouseEvent):void
        {
            this.panelMC.newYearMC.visible = false;
            this.panelMC.menuMC.visible = true;
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
            var _local_2:Object = GameData.get("christmas2025");
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

        private function openPreview(_arg_1:MouseEvent):void
        {
            this.panelMC.previewMC.visible = true;
            this.eventHandler.addListener(this.panelMC.previewMC.btn_close, MouseEvent.CLICK, this.closePreview);
            this.eventHandler.addListener(this.panelMC.previewMC.btn_replay, MouseEvent.CLICK, this.handleReplay);
            this.selectedPreviewSkill = _arg_1.currentTarget.metaData.skillId;
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

        private function openMinigame(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ChristmasEvent2025.getMinigameData", [Character.char_id, Character.sessionkey], this.onGetMinigameData);
        }

        private function onGetMinigameData(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.minigameResponse = _arg_1;
                this.openMinigameUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function openMinigameUI():void
        {
            this.isMinigameOpen = true;
            this.panelMC.minigameCoverMC.visible = true;
            this.eventHandler.addListener(this.panelMC.minigameCoverMC.btn_close, MouseEvent.CLICK, this.closeMinigame);
            this.eventHandler.addListener(this.panelMC.minigameCoverMC.heartBtn, MouseEvent.CLICK, this.refillConfirmation);
            this.eventHandler.addListener(this.panelMC.minigameCoverMC.btn_start, MouseEvent.CLICK, this.startMinigame);
            this.eventHandler.addListener(this.panelMC.minigameCoverMC.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
            this.panelMC.minigameCoverMC.tokenTxt.text = Character.account_tokens;
            this.updateMinigameEnergy();
            var _local_1:int;
            while (_local_1 < 2)
            {
                NinjaSage.loadItemIcon(this.panelMC.minigameCoverMC[("iconMc_" + _local_1)], this.minigameData[_local_1]);
                this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].amountTxt.text = "";
                this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].btn_preview.visible = ((this.minigameData[_local_1].indexOf("skill_") == -1) ? false : true);
                this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].btn_preview.metaData = {"skillId":this.minigameData[_local_1]};
                this.eventHandler.addListener(this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].btn_preview, MouseEvent.CLICK, this.openPreview);
                this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].ownedTxt.visible = false;
                if (Character.hasSkill(this.minigameData[_local_1]) > 0)
                {
                    this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].ownedTxt.visible = true;
                    this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(this.minigameData[_local_1]) > 0)
                {
                    this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].ownedTxt.visible = true;
                    this.panelMC.minigameCoverMC[("iconMc_" + _local_1)].ownedTxt.text = "Owned";
                };
                _local_1++;
            };
        }

        private function startMinigame(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ChristmasEvent2025.startMinigame", [Character.char_id, Character.sessionkey], this.onStartMinigame);
        }

        private function onStartMinigame(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if (this.petFrenzy)
                {
                    GF.removeAllChild(this.petFrenzy);
                    this.petFrenzy.destroy();
                    this.petFrenzy = null;
                };
                Character.battle_code = _arg_1.code;
                this.petFrenzy = new PetFrenzy(this.main, this);
                this.main.loader.addChild(this.petFrenzy);
                this.hideThisPanel();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        public function showThisPanel():void
        {
            this.panelMC.visible = true;
            this.updateMinigameEnergy();
        }

        public function hideThisPanel():void
        {
            this.panelMC.visible = false;
        }

        private function updateMinigameEnergy():void
        {
            var _local_1:int;
            while (_local_1 < 8)
            {
                this.panelMC.minigameCoverMC[("heart_" + _local_1)].visible = false;
                if (this.minigameResponse.energy > _local_1)
                {
                    this.panelMC.minigameCoverMC[("heart_" + _local_1)].visible = true;
                };
                _local_1++;
            };
        }

        private function closeMinigame(_arg_1:MouseEvent):void
        {
            this.isMinigameOpen = false;
            this.panelMC.minigameCoverMC.visible = false;
        }

        private function handleReplay(_arg_1:MouseEvent):void
        {
            this.previewMC.preview_mc.gotoAndPlay(2);
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

        private function openChristmasGacha(_arg_1:MouseEvent):void
        {
            this.main.loadExternalSwfPanel("ChristmasGacha", "ChristmasGacha");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            GF.removeAllChild(this.panelMC);
            NinjaSage.clearLoader();
            this.loaderSwf.clear();
            this.loaderSwf = null;
            this.eventHandler.removeAllEventListeners();
            if (this.previewMC)
            {
                this.previewMC.destroy();
            };
            this.previewMC = null;
            GF.removeAllChild(this.petFrenzy);
            if (this.petFrenzy)
            {
                this.petFrenzy.destroy();
            };
            this.petFrenzy = null;
            this.eventHandler = null;
            this.panelMC = null;
            this.response = null;
            this.bossData = null;
            this.milestoneData = null;
            this.newYearData = null;
            this.minigameData = null;
            this.main = null;
        }


    }
}//package id.ninjasage.features

