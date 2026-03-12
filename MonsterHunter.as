// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.MonsterHunter

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.StatManager;
    import Storage.EnemyInfo;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.Crypto;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class MonsterHunter extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var rewardsArray:Array;
        private var response:Object;
        private var enemyStats:String;

        public function MonsterHunter(_arg_1:*, _arg_2:*)
        {
            var _local_3:* = GameData.get("monster_hunter");
            this.rewardsArray = _local_3.rewards;
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getEventData();
        }

        private function getEventData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("MonsterHunterEvent2023.getEventData", [Character.char_id, Character.sessionkey], this.onShow);
        }

        private function onShow(_arg_1:Object=null):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.initUI();
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

        private function initUI():*
        {
            this.main.handleVillageHUDVisibility(false);
            this.eventHandler.addListener(this.panelMC.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.panelMC.convertBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.panelMC.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.panelMC.goBattleBtn, MouseEvent.CLICK, this.startEventFight);
            this.eventHandler.addListener(this.panelMC.panelMC.materialMarketBtn, MouseEvent.CLICK, this.openMaterialMarket);
            this.panelMC.panelMC.lvMc.lvLow.txt.text = Character.character_lvl;
            this.panelMC.panelMC.lvMc.lvHigh.txt.text = (int(Character.character_lvl) + 5);
            this.panelMC.panelMC.detailGoldTxt.text = ((int(Character.character_lvl) * 2500) / 40);
            this.panelMC.panelMC.detailXpTxt.text = ((int(Character.character_lvl) * 2500) / 40);
            this.panelMC.panelMC.goldTxt.text = Character.character_gold;
            this.panelMC.panelMC.tokenTxt.text = String(Character.account_tokens);
            this.panelMC.panelMC.teamMemberTxt.text = (Character.character_recruit_ids.length + "/2");
            this.panelMC.panelMC.energyTxt.text = (this.response.energy + "/100");
            this.panelMC.panelMC.EnergyProcessBar.scaleX = (this.response.energy / 97);
            this.loadRewardIcon();
            this.loadMonsterIcon();
        }

        private function startEventFight(_arg_1:MouseEvent):*
        {
            if (((Character.character_skill_set == "") || (Character.character_skill_set == null)))
            {
                this.main.showMessage("Please equip at least 1 skill");
                return;
            };
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = this.response.boss_id;
            Character.christmas_boss_num = 0;
            Character.christmas_boss_id = _local_5;
            _local_2 = StatManager.calculate_stats_with_data("agility");
            _local_3 = EnemyInfo.getCopy(_local_5);
            this.enemyStats = ((((("id:" + _local_3["enemy_id"]) + "|hp:") + _local_3["enemy_hp"]) + "|agility:") + _local_3["enemy_agility"]);
            _local_4 = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray((String(Character.char_id) + String(_local_5)))));
            this.main.loading(true);
            this.main.amf_manager.service("MonsterHunterEvent2023.startBattle", [Character.char_id, _local_5, _local_4, Character.sessionkey], this.onStartEventAmf);
        }

        private function onStartEventAmf(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if (_arg_1.hash != Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(((String(Character.christmas_boss_id) + _arg_1.code) + String(Character.char_id))))))
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
                Character.is_monster_hunter_event = true;
                Character.battle_code = _arg_1.code;
                Character.mission_id = "mission_1024";
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.EVENT_MATCH, Character.mission_id);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                BattleManager.addPlayerToTeam("enemy", Character.christmas_boss_id);
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

        private function loadMonsterIcon():*
        {
            NinjaSage.loadIconSWF("enemy", this.response.boss_id, this.panelMC.panelMC.enemyHolder, this.response.boss_id);
            this.panelMC.panelMC.enemyHolder.scaleX = 0.5;
            this.panelMC.panelMC.enemyHolder.scaleY = 0.5;
        }

        private function loadRewardIcon():*
        {
            var _local_1:* = 0;
            while (_local_1 < this.rewardsArray.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.panelMC[("rewardItem" + _local_1)].iconHolder, this.rewardsArray[_local_1], "icon");
                _local_1++;
            };
        }

        private function openRecharge(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function openMaterialMarket(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.MaterialMarket");
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.main.handleVillageHUDVisibility(true);
            NinjaSage.clearLoader();
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            var _local_1:* = 0;
            while (_local_1 < this.rewardsArray.length)
            {
                this.panelMC.panelMC[("rewardItem" + _local_1)].tooltip = null;
                GF.removeAllChild(this.panelMC.panelMC[("rewardItem" + _local_1)].iconHolder);
                _local_1++;
            };
            GF.removeAllChild(this.panelMC.panelMC.enemyHolder);
            this.rewardsArray = [];
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            this.enemyStats = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

