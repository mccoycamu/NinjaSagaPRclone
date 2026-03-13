// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.BattleLoader

package Combat
{
    import flash.display.MovieClip;
    import Storage.Character;
    import flash.events.Event;
    import com.utils.GF;

    public class BattleLoader 
    {

        public static var bg_holder:*;
        public static var BG_Linkage:*;

        public var backgroundMC:MovieClip;


        public function loadPlayerTeam(_arg_1:int=0):*
        {
            var _local_2:* = undefined;
            if (BattleManager.getPlayerTeam().length <= _arg_1)
            {
                BattleVars.PLAYER_TEAM_LOADED = true;
                BattleManager.loadEnemyTeam();
                return;
            };
            var _local_3:String = String(BattleManager.getPlayerTeam()[_arg_1]);
            if (_local_3.indexOf("char_") >= 0)
            {
                _local_2 = new CharacterModel("player", _arg_1, _local_3);
                BattleManager.getBattle().character_team_players[_arg_1] = _local_2;
            }
            else
            {
                if (_local_3.indexOf("npc_") >= 0)
                {
                    _local_2 = new NpcModel("player", _arg_1, _local_3);
                    BattleManager.getBattle().character_team_players[_arg_1] = _local_2;
                }
                else
                {
                    _local_2 = new EnemyModel("player", _arg_1, _local_3);
                    BattleManager.getBattle().character_team_players[_arg_1] = _local_2;
                };
            };
        }

        public function loadEnemyTeam(_arg_1:int=0):*
        {
            var _local_2:* = undefined;
            if (BattleManager.getEnemyTeam().length <= _arg_1)
            {
                BattleVars.ENEMY_TEAM_LOADED = true;
                if (Character.is_jounin_stage_4)
                {
                    BattleManager.getBattle().setElementsForStage4();
                };
                return;
            };
            var _local_3:String = String(BattleManager.getEnemyTeam()[_arg_1]);
            if (_local_3.indexOf("char_") >= 0)
            {
                _local_2 = new CharacterModel("enemy", _arg_1, _local_3);
                BattleManager.getBattle().enemy_team_players[_arg_1] = _local_2;
            }
            else
            {
                _local_2 = new EnemyModel("enemy", _arg_1, _local_3);
                BattleManager.getBattle().enemy_team_players[_arg_1] = _local_2;
            };
        }

        public function loadBackground():*
        {
            var _local_1:String = BattleManager.getBackgound();
            BattleManager.getMain().loadSwf("mission", _local_1, this.handleBackgroundLoad);
        }

        public function handleBackgroundLoad(_arg_1:Event):*
        {
            _arg_1.target.removeEventListener(Event.COMPLETE, this.handleBackgroundLoad);
            this.clearLoadedBackground();
            this.backgroundMC = _arg_1.target.content[BG_Linkage];
            this.backgroundMC.gotoAndStop(1);
            this.backgroundMC.width = (this.backgroundMC.width + 100);
            BattleManager.getBattle().bgHolder.addChild(this.backgroundMC);
            if (Character.is_jounin_stage_4)
            {
                BattleLoader.bg_holder = this.backgroundMC;
                BattleManager.getBattle().setRandomStage();
            };
            _arg_1.target.loader.unloadAndStop(true);
        }

        public function clearLoadedBackground():*
        {
            if (this.backgroundMC != null)
            {
                if (BattleManager.getBattle() != null)
                {
                    GF.removeAllChild(BattleManager.getBattle().bgHolder);
                };
                this.backgroundMC.cacheAsBitmap = false;
                GF.removeAllChild(this.backgroundMC);
                this.backgroundMC = null;
            };
        }

        public function hideEverything():*
        {
            var _local_1:Battle = BattleManager.getBattle();
            _local_1.char_hpcp.visible = false;
            _local_1.atbBar.visible = false;
            _local_1.btn_UI_Gear.visible = false;
            _local_1.sushiMc.visible = false;
            _local_1.actionBar.enemyMcInfo_0.visible = false;
            _local_1.actionBar.enemyMcInfo_1.visible = false;
            _local_1.actionBar.enemyMcInfo_2.visible = false;
            _local_1.actionBar.visible = false;
            _local_1.actionBar1.visible = false;
            _local_1.actionBar2.visible = false;
            _local_1.atk_turnTimerTxt.visible = false;
            _local_1.totalDamageHint.visible = false;
            var _local_2:int = ((Character.temp_recruit_ids.length > 0) ? Character.temp_recruit_ids.length : Character.character_recruit_ids.length);
            _local_1.rekrut.text = (_local_2 + "/2");
            _local_1.versionTxt.text = Character.build_num.replace("Public ", "");
            if (((int(Character.character_lvl) <= 80) && (int(Character.character_rank) < 8)))
            {
                _local_1.senjutsuTransition.visible = false;
                _local_1.actionBar.btn_senjutsu.visible = false;
                _local_1.actionBar.btn_ninjutsu.visible = false;
                _local_1.char_hpcp.btn_activate_senjutsu.visible = false;
                _local_1.char_hpcp.txt_sp.visible = false;
                _local_1.char_hpcp.spBar.visible = false;
                _local_1.char_hpcp.spBarBg.visible = false;
                _local_1.char_hpcp.spIcon.visible = false;
                _local_1.char_hpcp.black_bg.height = 38.45;
            };
            var _local_3:int;
            while (_local_3 < 3)
            {
                _local_1[("charMc_" + String(_local_3))].visible = false;
                _local_1[("charPetMc_" + String(_local_3))].visible = false;
                _local_1[("enemyMc_" + String(_local_3))].visible = false;
                _local_1[("enemyPetMc_" + String(_local_3))].visible = false;
                _local_1[("scrollDisplayMc_" + String(_local_3))].visible = false;
                _local_3++;
            };
            _local_1 = null;
        }

        public function destroy():*
        {
            if (bg_holder != null)
            {
                GF.removeAllChild(bg_holder);
            };
            this.clearLoadedBackground();
            bg_holder = null;
            BG_Linkage = null;
        }


    }
}//package Combat

