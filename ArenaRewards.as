// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ArenaRewards

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import flash.events.MouseEvent;
    import br.com.stimuli.loading.BulkProgressEvent;
    import flash.events.ErrorEvent;
    import Storage.Character;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class ArenaRewards extends MovieClip 
    {

        private const REWARD_API:String = "https://ninjasage.id/api/event/sw";

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var squadData:Object = [];
        private var winnerSquadData:Object = [];
        private var topGlobalData:Object = [];
        private var leagueRewardData:Object = [];
        private var tempLoader:BulkLoader;

        public function ArenaRewards(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_league, MouseEvent.CLICK, this.openPopupLeague);
            this.eventHandler.addListener(this.panelMC.leagueMC.bg, MouseEvent.CLICK, this.closePopupLeague);
            this.tempLoader = BulkLoader.createUniqueNamedLoader(1, BulkLoader.LOG_INFO);
            this.getRewardData();
        }

        private function getRewardData():void
        {
            this.main.loading(true);
            this.tempLoader.add(this.REWARD_API, {
                "id":"api",
                "type":BulkLoader.TYPE_TEXT
            });
            this.tempLoader.addEventListener(BulkLoader.COMPLETE, this.onLoaded);
            this.tempLoader.addEventListener(BulkLoader.ERROR, this.onLoadError);
            this.tempLoader.start();
        }

        private function onLoaded(_arg_1:BulkProgressEvent):void
        {
            this.main.loading(false);
            var _local_2:Object = JSON.parse(this.tempLoader.getContent("api"));
            this.squadData = _local_2.data.squad;
            this.winnerSquadData = _local_2.data.winner_squad;
            this.topGlobalData = _local_2.data.top_global;
            this.leagueRewardData = _local_2.data.league;
            this.initUI();
        }

        private function onLoadError(_arg_1:ErrorEvent):*
        {
            this.main.loading(false);
            this.destroy();
        }

        private function initUI():*
        {
            this.panelMC.titleTxt.text = (("Season " + Character.shadow_war_season.season.num) + " Shadow War Rewards");
            this.panelMC.leagueMC.visible = false;
            this.loadRewardIcons(this.squadData, "squad_");
            this.loadRewardIcons(this.winnerSquadData, "winner_squad_");
            this.loadRewardIcons(this.topGlobalData, "top_global_");
            this.loadLeagueRewards();
            this.panelMC.league_sq0.gotoAndStop(8);
            this.panelMC.league_sq1.gotoAndStop(8);
            this.panelMC.league_sq2.gotoAndStop(7);
            this.panelMC.league_sq3.gotoAndStop(6);
            this.panelMC.league_sq4.gotoAndStop(5);
        }

        private function loadRewardIcons(_arg_1:Object, _arg_2:String):void
        {
            var _local_4:String;
            var _local_5:int;
            var _local_6:int;
            var _local_3:Array = [];
            for (_local_4 in _arg_1)
            {
                _local_3.push(_local_4);
            };
            _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                _local_6 = 0;
                while (_local_6 < _arg_1[_local_3[_local_5]].length)
                {
                    NinjaSage.loadItemIcon(this.panelMC[(_arg_2 + _local_3[_local_5].replace("-", "_"))][("iconMc" + _local_6)], _arg_1[_local_3[_local_5]][_local_6]);
                    _local_6++;
                };
                _local_5++;
            };
        }

        private function loadLeagueRewards():void
        {
            var _local_2:String;
            var _local_3:int;
            var _local_4:int;
            var _local_1:Array = [];
            for (_local_2 in this.leagueRewardData)
            {
                _local_1.push(_local_2);
            };
            _local_3 = 0;
            while (_local_3 < _local_1.length)
            {
                this.panelMC["leagueMC"][("league" + _local_3)].gotoAndStop((_local_3 + 4));
                _local_4 = 0;
                while (_local_4 < this.leagueRewardData[_local_1[_local_3]].length)
                {
                    NinjaSage.loadItemIcon(this.panelMC["leagueMC"][_local_1[_local_3]][("iconMc" + _local_4)], this.leagueRewardData[_local_1[_local_3]][_local_4]);
                    _local_4++;
                };
                _local_3++;
            };
        }

        private function openPopupLeague(_arg_1:MouseEvent):*
        {
            this.panelMC.leagueMC.visible = true;
        }

        private function closePopupLeague(_arg_1:MouseEvent):*
        {
            this.panelMC.leagueMC.visible = false;
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main = null;
            this.eventHandler = null;
            this.rewardData = null;
            this.leagueRewardData = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

