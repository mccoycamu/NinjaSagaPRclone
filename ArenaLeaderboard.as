// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ArenaLeaderboard

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import Managers.NinjaSage;
    import flash.events.MouseEvent;
    import flash.utils.getDefinitionByName;
    import Storage.ArenaBuffs;
    import com.utils.GF;

    public dynamic class ArenaLeaderboard extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var currentPage:int = 1;
        public var totalPage:int;
        public var currentSquad:int = 0;
        public var main:*;
        public var eventHandler:EventHandler;
        public var overallRanking:Object;

        public function ArenaLeaderboard(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.loadLeaderboardData();
            this.initButton();
        }

        public function loadLeaderboardData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["globalLeaderboard", [Character.char_id, Character.sessionkey]], this.leaderboardResponse);
        }

        public function leaderboardResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.overallRanking = _arg_1;
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
            this.initUI();
        }

        public function initUI():*
        {
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                this.panelMC[("rankMc_" + _local_1)].numberTxt.text = String((_local_1 + 1));
                this.panelMC[("squadScore_" + _local_1)].text = this.overallRanking.squads[_local_1].trophy;
                this.panelMC[("squadMc_" + _local_1)].gotoAndStop(Character.getSquadName(this.overallRanking.squads[_local_1].squad));
                NinjaSage.showDynamicTooltip(this.panelMC[("squadMc_" + _local_1)], Character.getSquadFullName(this.overallRanking.squads[_local_1].squad).toUpperCase());
                _local_1++;
            };
            this.updateEffectData(null);
            this.showLeaderboard();
        }

        public function showLeaderboard():*
        {
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 5)));
                if (this.overallRanking.players.length > _local_2)
                {
                    this.panelMC[("rankInfoMc_" + _local_1)].visible = true;
                    this.panelMC[("rankInfoMc_" + _local_1)].txt_name.htmlText = Character.colorifyText(this.overallRanking.players[_local_2].id, this.overallRanking.players[_local_2].name);
                    this.panelMC[("rankInfoMc_" + _local_1)].txt_rank.text = String((_local_2 + 1));
                    this.panelMC[("rankInfoMc_" + _local_1)].txt_score.text = this.overallRanking.players[_local_2].trophy;
                    this.panelMC[("rankInfoMc_" + _local_1)].leagueIcon.gotoAndStop((this.overallRanking.players[_local_2].rank + 1));
                    this.panelMC[("rankInfoMc_" + _local_1)].squadMc.gotoAndStop(Character.getSquadName(this.overallRanking.players[_local_2].squad));
                    this.panelMC[("rankInfoMc_" + _local_1)].buttonMode = true;
                    this.panelMC[("rankInfoMc_" + _local_1)].metaData = {"charId":this.overallRanking.players[_local_2].id};
                    this.eventHandler.addListener(this.panelMC[("rankInfoMc_" + _local_1)], MouseEvent.CLICK, this.openFriendProfile);
                }
                else
                {
                    this.panelMC[("rankInfoMc_" + _local_1)].visible = false;
                };
                _local_1++;
            };
            this.totalPage = Math.ceil((this.overallRanking.players.length / 5));
            this.updatePageText();
        }

        public function setCurrentSquad(_arg_1:MouseEvent):*
        {
            this.currentSquad = _arg_1.currentTarget.name.replace("squadMc_", "");
            this.loadLeaderboardData();
        }

        public function openFriendProfile(_arg_1:MouseEvent):*
        {
            var _local_2:* = (getDefinitionByName("Panels.UI_Friend_Profile") as Class);
            var _local_3:* = new _local_2(this.main, _arg_1.currentTarget.metaData.charId, true);
            this.main.loader.addChild(_local_3);
        }

        public function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.showLeaderboard();
                    };
                    break;
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.showLeaderboard();
                    };
            };
            this.updatePageText();
        }

        public function updatePageText():*
        {
            this.panelMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        public function updateEffectData(_arg_1:MouseEvent):*
        {
            if ((_arg_1 is MouseEvent))
            {
                this.currentSquad = _arg_1.currentTarget.name.replace("squadMc_", "");
            };
            this.panelMC.txt_squad_desc.htmlText = ((((((((("Debuff " + '<font color="#ffff00"> ') + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).debuff.name) + "</font>\n") + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).debuff.description) + "\n\nBuff ") + '<font color="#ffff00"> ') + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).buff.name) + "</font>\n") + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).buff.description);
        }

        public function initButton():*
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage);
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                this.eventHandler.addListener(this.panelMC[("squadMc_" + _local_1)], MouseEvent.CLICK, this.updateEffectData);
                _local_1++;
            };
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            NinjaSage.clearEventListener();
            this.main = null;
            this.eventHandler = null;
            this.overallRanking = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

