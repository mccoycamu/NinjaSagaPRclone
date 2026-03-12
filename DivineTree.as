// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.DivineTree

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Managers.StatManager;
    import Popups.Confirmation;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import Managers.OutfitManager;
    import com.utils.GF;

    public class DivineTree extends MovieClip 
    {

        private var main:*;
        private var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var statManager:StatManager;
        private var treeData:Object;
        private var response:Object;
        private var milestoneData:Object;
        private var leaderboardData:Object;
        private var playerLeaderboardData:Object;
        private var currentPage:int;
        private var totalPage:int;
        private var outfits:Array;
        private var confirmation:Confirmation;

        public function DivineTree(_arg_1:*, _arg_2:MovieClip)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.statManager = new StatManager();
            this.treeData = GameData.get("divinetree");
            this.milestoneData = [];
            this.outfits = [];
            var _local_3:int;
            while (_local_3 < this.treeData.milestone.length)
            {
                this.milestoneData.push({
                    "rewardId":this.treeData.milestone[_local_3].id.replace("%s", Character.character_gender),
                    "rewardReq":this.treeData.milestone[_local_3].requirement,
                    "rewardQty":this.treeData.milestone[_local_3].quantity
                });
                _local_3++;
            };
            this.dummyResponse();
            this.hidePopups();
            this.initButton();
            this.initUI();
        }

        private function dummyResponse():void
        {
            this.response = {
                "status":1,
                "data":{
                    "level":0,
                    "experience":23,
                    "tree":"tree_rosethornsentinel",
                    "chance":3,
                    "total_harvest":17
                }
            };
        }

        private function initButton():void
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_rules, MouseEvent.CLICK, this.openRules);
            this.eventHandler.addListener(this.panelMC.btn_leaderboard, MouseEvent.CLICK, this.openLeaderboard);
            this.eventHandler.addListener(this.panelMC.btn_milestone, MouseEvent.CLICK, this.openMilestone);
            this.eventHandler.addListener(this.panelMC.btn_seed, MouseEvent.CLICK, this.openTreeList);
            this.eventHandler.addListener(this.panelMC.btn_Headquarter, MouseEvent.CLICK, this.openHeadquarter);
            this.eventHandler.addListener(this.panelMC.btn_buy_token, MouseEvent.CLICK, this.buyToken);
            this.eventHandler.addListener(this.panelMC.wateringMC.btn_watering_can, MouseEvent.CLICK, this.watering);
            this.eventHandler.addListener(this.panelMC.wateringMC.btn_buy_water, MouseEvent.CLICK, this.buyWaterConfirmation);
            this.eventHandler.addListener(this.panelMC.buffMC.btn_open, MouseEvent.CLICK, this.openBuff);
            this.eventHandler.addListener(this.panelMC.buffMC.content.btn_close, MouseEvent.CLICK, this.closeBuff);
            this.eventHandler.addListener(this.panelMC.rulesMC.btn_close, MouseEvent.CLICK, this.closeRules);
            this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_close, MouseEvent.CLICK, this.closeLeaderboard);
            this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close, MouseEvent.CLICK, this.closeMilestone);
            this.eventHandler.addListener(this.panelMC.treeListMC.btn_close, MouseEvent.CLICK, this.closeTreeList);
            this.eventHandler.addListener(this.panelMC.treeListMC.previewMC.btn_close, MouseEvent.CLICK, this.closeTreeListPreview);
            NinjaSage.showDynamicTooltip(this.panelMC.btn_milestone, "Harvest Milestone");
            NinjaSage.showDynamicTooltip(this.panelMC.btn_leaderboard, "Harvest Leaderboard");
            NinjaSage.showDynamicTooltip(this.panelMC.btn_rules, "Divine Tree Rules");
            NinjaSage.showDynamicTooltip(this.panelMC.buffMC.btn_open, "XP & Gold Bonus");
        }

        private function initUI():void
        {
            this.panelMC.txt_token.text = Character.account_tokens;
            this.panelMC.txt_gold.text = Character.character_gold;
            this.panelMC.frame.txt_name.htmlText = Character.colorifyText(Character.char_id, Character.character_name);
            this.panelMC.frame.txt_lvl.text = Character.character_lvl;
            this.panelMC.frame.txt_hp.text = ((StatManager.calculate_stats_with_data("hp") + " / ") + StatManager.calculate_stats_with_data("hp"));
            this.panelMC.frame.txt_cp.text = ((StatManager.calculate_stats_with_data("cp") + " / ") + StatManager.calculate_stats_with_data("cp"));
            this.panelMC.frame.txt_xp.text = ((Character.character_xp + " / ") + String(this.statManager.calculate_xp(int(Character.character_lvl))));
            this.panelMC.frame.txt_sp.text = ("0 / " + StatManager.calculate_stats_with_data("sp"));
            this.panelMC.frame.spBar.scaleX = 1;
            this.panelMC.frame.xpBar.scaleX = Math.max(Math.min((int(Character.character_xp) / int(this.statManager.calculate_xp(int(Character.character_lvl)))), 1), 0);
            if (((int(Character.character_lvl) <= 80) && (int(Character.character_rank) < 8)))
            {
                this.panelMC.frame.txt_sp.visible = false;
                this.panelMC.frame.spBar.visible = false;
                this.panelMC.frame.spBarBg.visible = false;
                this.panelMC.frame.spIcon.visible = false;
                this.panelMC.frame.black_bg.height = 38.45;
            };
            var _local_1:String = ((this.response.data.level == 0) ? "Seedling" : ("Level " + String(this.response.data.level)));
            this.panelMC.xpBar.txt_level.text = _local_1;
            this.panelMC.xpBar.txt_xp.text = ((this.response.data.experience + " / ") + String(this.treeData.experience[this.response.data.level]));
            this.panelMC.xpBar.bar.scaleX = Math.max(Math.min((int(this.response.data.experience) / int(this.treeData.experience[this.response.data.level])), 1), 0);
            this.panelMC.wateringMC.txt_watering_chances.text = ("Watering Chances: " + this.response.data.chance);
            if (this.response.data.level == 0)
            {
                this.panelMC.btn_seed.visible = true;
                this.panelMC.tree.visible = false;
            }
            else
            {
                this.panelMC.btn_seed.visible = false;
                this.panelMC.tree.visible = true;
                this.panelMC.tree.gotoAndStop(this.response.data.tree);
                this.panelMC.tree.tree.gotoAndStop(this.response.data.level);
                if (this.response.data.level == 3)
                {
                    this.eventHandler.addListener(this.panelMC.tree, MouseEvent.CLICK, this.claimRewards);
                };
            };
        }

        private function hidePopups():void
        {
            this.panelMC.rulesMC.visible = false;
            this.panelMC.leaderboardMC.visible = false;
            this.panelMC.milestoneMC.visible = false;
            this.panelMC.treeListMC.visible = false;
            this.panelMC.treeListMC.previewMC.visible = false;
            this.panelMC.ani_watering.visible = false;
            this.panelMC.buffMC.content.visible = false;
        }

        private function openTreeList(_arg_1:MouseEvent):void
        {
            this.panelMC.treeListMC.visible = true;
            var _local_2:MovieClip = this.panelMC.treeListMC;
            var _local_3:int;
            while (_local_3 < 6)
            {
                _local_2[("tree_" + _local_3)].txt_name.text = this.treeData.trees[_local_3].name;
                _local_2[("tree_" + _local_3)].treeMC.gotoAndStop((_local_3 + 1));
                this.eventHandler.addListener(_local_2[("tree_" + _local_3)].btn_preview, MouseEvent.CLICK, this.openTreePreview);
                _local_3++;
            };
        }

        private function openTreePreview(_arg_1:MouseEvent):void
        {
            this.panelMC.treeListMC.previewMC.visible = true;
            var _local_2:MovieClip = this.panelMC.treeListMC.previewMC;
            var _local_3:int = _arg_1.currentTarget.parent.name.replace("tree_", "");
            var _local_4:int = 1;
            while (_local_4 <= 3)
            {
                _local_2[("level_" + _local_4)].txt_level.text = ("Level " + _local_4);
                _local_2[("level_" + _local_4)].treeMC.gotoAndStop((_local_3 + 1));
                _local_2[("level_" + _local_4)].treeMC.tree.gotoAndStop(_local_4);
                _local_4++;
            };
            _local_2.txt_name.text = this.treeData.trees[_local_3].name;
            _local_2.iconMc.amountTxt.text = "";
            _local_2.iconMc.ownedTxt.text = "";
            NinjaSage.loadItemIcon(_local_2.iconMc, this.treeData.trees[_local_3].rewards[0]);
            this.eventHandler.addListener(_local_2.btn_close, MouseEvent.CLICK, this.closeTreeListPreview);
        }

        private function claimRewards(_arg_1:MouseEvent):void
        {
        }

        private function openRules(_arg_1:MouseEvent):void
        {
            this.panelMC.rulesMC.visible = true;
            var _local_2:MovieClip = this.panelMC.rulesMC;
            _local_2.txt_rules.htmlText = this.treeData.rules;
        }

        private function openLeaderboard(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("LeaderboardService.getData", [Character.char_id, Character.sessionkey, null], this.leaderboardResponse);
        }

        private function leaderboardResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.leaderboardMC.visible = true;
                this.leaderboardData = _arg_1.data;
                this.playerLeaderboardData = {
                    "char_id":Character.char_id,
                    "name":Character.character_name,
                    "rank":1,
                    "total_harvest":_arg_1.player_kill
                };
                this.currentPage = 1;
                this.totalPage = Math.max(1, Math.ceil((this.leaderboardData.length / 10)));
                this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_prev, MouseEvent.CLICK, this.changePage);
                this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_next, MouseEvent.CLICK, this.changePage);
                this.panelMC.leaderboardMC["playerRankInfoMc"].holder.scaleX = 1.6;
                this.panelMC.leaderboardMC["playerRankInfoMc"].holder.scaleY = 1.6;
                this.panelMC.leaderboardMC["playerRankInfoMc"].holder.addChild(this.main.getPlayerHead());
                this.panelMC.leaderboardMC["playerRankInfoMc"].txt_name.htmlText = Character.colorifyText(this.playerLeaderboardData.char_id, this.playerLeaderboardData.name);
                this.panelMC.leaderboardMC["playerRankInfoMc"].txt_total_harvest.text = (this.playerLeaderboardData.total_harvest + " Total Harvest");
                this.panelMC.leaderboardMC["playerRankInfoMc"].txt_rank.text = this.playerLeaderboardData.rank;
                this.updatePageText();
                this.renderLeaderboardUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function getPlayerHead(_arg_1:*):*
        {
            if (this.outfits[_arg_1])
            {
                this.outfits[_arg_1].destroy();
                this.outfits[_arg_1] = null;
            };
            this.outfits[_arg_1] = new OutfitManager();
            var _local_2:* = new CharHead();
            _local_2.scaleX = 1.6;
            _local_2.scaleY = 1.6;
            this.outfits[_arg_1].fillHead(_local_2, this.leaderboardData[_arg_1].sets.hair_style, this.leaderboardData[_arg_1].sets.face, this.leaderboardData[_arg_1].sets.hair_color, this.leaderboardData[_arg_1].sets.skin_color);
            return (_local_2);
        }

        private function renderLeaderboardUI():void
        {
            var _local_2:*;
            var _local_1:int;
            while (_local_1 < 10)
            {
                this.panelMC.leaderboardMC[("rankInfoMc" + _local_1)].visible = false;
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 10)));
                if (this.leaderboardData.length > _local_2)
                {
                    this.panelMC.leaderboardMC[("rankInfoMc" + _local_1)].visible = true;
                    this.panelMC.leaderboardMC[("rankInfoMc" + _local_1)].txt_name.htmlText = Character.colorifyText(this.leaderboardData[_local_2].char_id, this.leaderboardData[_local_2].name);
                    this.panelMC.leaderboardMC[("rankInfoMc" + _local_1)].txt_total_harvest.text = (this.leaderboardData[_local_2].kill + " Total Harvest");
                    this.panelMC.leaderboardMC[("rankInfoMc" + _local_1)].txt_rank.text = (_local_2 + 1);
                    this.panelMC.leaderboardMC[("rankInfoMc" + _local_1)].holder.addChild(this.getPlayerHead(_local_2));
                };
                _local_1++;
            };
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.renderLeaderboardUI();
                    };
                    break;
                case "btn_next":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.renderLeaderboardUI();
                    };
                    break;
            };
            this.updatePageText();
        }

        private function updatePageText():void
        {
            this.panelMC.leaderboardMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function openMilestone(_arg_1:MouseEvent):*
        {
            this.panelMC.milestoneMC.visible = true;
            this.panelMC.milestoneMC.txt_title.text = "Harvest Milestone";
            this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close, MouseEvent.CLICK, this.closeMilestone);
            this.main.loading(true);
            this.main.amf_manager.service("ConfrontingDeathEvent2025.getBonusRewards", [Character.char_id, Character.sessionkey], this.openMilestoneRewards);
            var _local_2:* = 0;
            while (_local_2 < 8)
            {
                this.panelMC.milestoneMC[("reward_" + _local_2)]["txt_required"].text = (String(this.milestoneData[_local_2].rewardReq) + " Harvest");
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
                this.panelMC.milestoneMC.txt_total_harvest.text = ("Harvest " + _arg_1.milestone);
                _local_2 = 0;
                while (_local_2 < 8)
                {
                    _local_3 = (((_arg_1.rewards[_local_2] == false) && (_arg_1.milestone >= this.milestoneData[_local_2].rewardReq)) ? true : false);
                    _local_4 = (_arg_1.rewards[_local_2] == true);
                    this.panelMC.milestoneMC[("reward_" + _local_2)]["btn_claim"].visible = _local_3;
                    this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = true;
                    this.panelMC.milestoneMC[("reward_" + _local_2)].star_unlock.visible = false;
                    if (_local_3)
                    {
                        this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = false;
                        this.panelMC.milestoneMC[("reward_" + _local_2)].star_unlock.visible = true;
                        this.eventHandler.addListener(this.panelMC.milestoneMC[("reward_" + _local_2)]["btn_claim"], MouseEvent.CLICK, this.onClaimBonusRequest);
                    };
                    if (_local_4)
                    {
                        this.panelMC.milestoneMC[("reward_" + _local_2)].lock.visible = false;
                        this.panelMC.milestoneMC[("reward_" + _local_2)].star_unlock.visible = true;
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
                this.main.giveReward(1, _arg_1.reward);
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

        private function watering(_arg_1:MouseEvent):void
        {
            this.wateringResponse({"status":1});
        }

        private function wateringResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.ani_watering.visible = true;
                this.panelMC.wateringMC.btn_watering_can.visible = false;
                this.panelMC.ani_watering.addFrameScript((this.panelMC.ani_watering.totalFrames - 1), this.closeWatering);
                this.panelMC.ani_watering.gotoAndPlay(1);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closeWatering():void
        {
            this.panelMC.ani_watering.visible = false;
            this.panelMC.wateringMC.btn_watering_can.visible = true;
        }

        private function buyWaterConfirmation(_arg_1:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to buy water for 10 tokens?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyWater);
            this.panelMC.addChild(this.confirmation);
        }

        private function removeConfirmation(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
        }

        private function buyWater(_arg_1:MouseEvent):void
        {
            this.removeConfirmation(null);
            this.buyWaterResponse({"status":1});
        }

        private function buyWaterResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.wateringMC.txt_watering_chances.text = ("Watering Chances: " + _arg_1.chance);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function openBuff(_arg_1:MouseEvent):void
        {
            this.panelMC.buffMC.content.visible = true;
            var _local_2:MovieClip = this.panelMC.buffMC.content;
            var _local_3:int;
            while (_local_3 < this.treeData.buffs.length)
            {
                _local_2[("buff_" + _local_3)]["txt_percent"].text = this.treeData.buffs[_local_3].rewards;
                _local_2[("buff_" + _local_3)].lockMC.visible = (this.response.data.total_harvest < this.treeData.buffs[_local_3].harvest_requirement);
                NinjaSage.showDynamicTooltip(_local_2[("buff_" + _local_3)]["clickmask"], this.treeData.buffs[_local_3].description);
                _local_3++;
            };
            NinjaSage.showDynamicTooltip(_local_2["clickmask_bar"], ("Total Harvest: " + this.response.data.total_harvest));
            _local_2.bar.scaleX = Math.max(Math.min((this.response.data.total_harvest / this.treeData.buffs[(this.treeData.buffs.length - 1)].harvest_requirement), 1), 0);
        }

        private function openHeadquarter(_arg_1:MouseEvent):void
        {
            this.main.loadExternalSwfPanel("Headquarter", "Headquarter");
            this.destroy();
        }

        private function buyToken(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function closeRules(_arg_1:MouseEvent):void
        {
            this.panelMC.rulesMC.visible = false;
        }

        private function closeLeaderboard(_arg_1:MouseEvent):void
        {
            this.panelMC.leaderboardMC.visible = false;
            var _local_2:int;
            while (_local_2 < this.outfits.length)
            {
                if (this.outfits[_local_2])
                {
                    this.outfits[_local_2].destroy();
                    this.outfits[_local_2] = null;
                };
                _local_2++;
            };
        }

        private function closeTreeList(_arg_1:MouseEvent):void
        {
            this.panelMC.treeListMC.visible = false;
        }

        private function closeTreeListPreview(_arg_1:MouseEvent):void
        {
            this.panelMC.treeListMC.previewMC.visible = false;
        }

        private function closeBuff(_arg_1:MouseEvent):void
        {
            this.panelMC.buffMC.content.visible = false;
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main = null;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.panelMC.ani_watering.addFrameScript((this.panelMC.ani_watering.totalFrames - 1), null);
            GF.removeAllChild(this.panelMC);
            var _local_1:int;
            while (_local_1 < this.outfits.length)
            {
                if (this.outfits[_local_1])
                {
                    this.outfits[_local_1].destroy();
                    this.outfits[_local_1] = null;
                };
                _local_1++;
            };
            this.outfits = null;
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

