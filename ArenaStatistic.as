// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ArenaStatistic

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import flash.events.FocusEvent;
    import com.utils.GF;

    public dynamic class ArenaStatistic extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var main:*;
        private var overallStats:Object;
        private var seasonalStats:Array;
        private var outfits:Array;
        private var currentTab:String = "seasonal_stats";
        private var currentSeasonIndex:int = 0;
        private var currentSeason:int;
        private var earliestSeason:int;
        private var searchPlaceholder:String = "Season number";

        public function ArenaStatistic(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.outfits = [];
            this.eventHandler = new EventHandler();
            this.getData();
        }

        private function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["getProfile", [Character.char_id, Character.sessionkey]], this.getDataResponse);
        }

        private function getDataResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.overallStats = _arg_1.overall;
                this.seasonalStats = _arg_1.seasonal;
                this.currentSeason = this.seasonalStats[0].season;
                this.earliestSeason = this.seasonalStats[(this.seasonalStats.length - 1)].season;
                if (this.seasonalStats.length == 0)
                {
                    this.main.getNotice("No seasonal stats found");
                    this.destroy();
                    return;
                };
                this.initUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                this.destroy();
            };
        }

        private function initUI():void
        {
            this.panelMC.detailMC.visible = false;
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_view_more, MouseEvent.CLICK, this.openViewMore);
            var _local_1:OutfitManager = new OutfitManager();
            this.outfits.push(_local_1);
            _local_1.fillHead(this.panelMC.infoMC.holder, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
            _local_1.fillOutfit(this.panelMC.char_mc, Character.character_weapon, Character.character_back_item, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
            this.panelMC.squadIcon.gotoAndStop(Character.getSquadName(Character.squad_data.squad));
            this.panelMC.leagueIcon.gotoAndStop((Character.squad_data.rank + 1));
            this.panelMC.infoMC.txt_name.htmlText = Character.colorifyText(Character.char_id, Character.character_name);
            this.panelMC.infoMC.txt_level.text = ("Lv. " + Character.character_lvl);
            var _local_2:MovieClip = this.panelMC.seasonalStatsMC;
            var _local_3:Object = this.seasonalStats[this.currentSeasonIndex];
            _local_2.txt_season.text = ("Season " + _local_3.season);
            _local_2.txt_season_date.text = ((_local_3.started_at + " - ") + _local_3.ended_at);
            _local_2.txt_total_battle.text = _local_3.stats.total_battles;
            _local_2.txt_win_rate_attack.text = (_local_3.stats.win_rate_attack + "%");
            _local_2.bar_win_rate_attack.bar.scaleX = Math.min(Math.max((_local_3.stats.win_rate_attack / 100), 0), 1);
            _local_2.txt_win_rate_defend.text = (_local_3.stats.win_rate_defend + "%");
            _local_2.bar_win_rate_defend.bar.scaleX = Math.min(Math.max((_local_3.stats.win_rate_defend / 100), 0), 1);
            var _local_4:MovieClip = this.panelMC.overallStatsMC;
            _local_4.txt_played_season.text = this.overallStats.seasons_played;
            _local_4.txt_total_battle.text = this.overallStats.total_battles;
            _local_4.txt_win_rate_attack.text = (this.overallStats.overall_attack_win_rate + "%");
            _local_4.bar_win_rate_attack.bar.scaleX = Math.min(Math.max((this.overallStats.overall_attack_win_rate / 100), 0), 1);
            _local_4.txt_win_rate_defend.text = (this.overallStats.overall_defend_win_rate + "%");
            _local_4.bar_win_rate_defend.bar.scaleX = Math.min(Math.max((this.overallStats.overall_defend_win_rate / 100), 0), 1);
        }

        private function openViewMore(_arg_1:MouseEvent):void
        {
            this.panelMC.detailMC.visible = true;
            this.eventHandler.addListener(this.panelMC.detailMC.btn_close, MouseEvent.CLICK, this.closeViewMore);
            this.eventHandler.addListener(this.panelMC.detailMC.btn_seasonal_stats, MouseEvent.CLICK, this.changeTab);
            this.eventHandler.addListener(this.panelMC.detailMC.btn_overall_stats, MouseEvent.CLICK, this.changeTab);
            this.resetTab();
            this.panelMC.detailMC.btn_seasonal_stats.gotoAndStop(3);
            this.panelMC.detailMC.seasonalStatsMC.visible = true;
            this.renderSeasonalStats();
        }

        private function changeTab(_arg_1:MouseEvent):void
        {
            this.resetTab();
            this.currentTab = _arg_1.currentTarget.name.replace("btn_", "");
            _arg_1.currentTarget.gotoAndStop(3);
            if (this.currentTab == "seasonal_stats")
            {
                this.panelMC.detailMC.seasonalStatsMC.visible = true;
                this.renderSeasonalStats();
            }
            else
            {
                this.panelMC.detailMC.overallStatsMC.visible = true;
                this.renderOverallStats();
            };
        }

        private function renderOverallStats():void
        {
            var _local_1:MovieClip = this.panelMC.detailMC.overallStatsMC;
            _local_1.txt_total_attack.text = this.overallStats.total_attacks;
            _local_1.txt_total_attack_win.text = this.overallStats.total_attack_wins;
            _local_1.txt_overall_attack_win_rate.text = (this.overallStats.overall_attack_win_rate + "%");
            _local_1.bar_overall_attack_win_rate.bar.scaleX = Math.min(Math.max((this.overallStats.overall_attack_win_rate / 100), 0), 1);
            _local_1.txt_total_defend.text = this.overallStats.total_defends;
            _local_1.txt_total_defend_win.text = this.overallStats.total_defend_wins;
            _local_1.txt_overall_defend_win_rate.text = (this.overallStats.overall_defend_win_rate + "%");
            _local_1.bar_overall_defend_win_rate.bar.scaleX = Math.min(Math.max((this.overallStats.overall_defend_win_rate / 100), 0), 1);
            _local_1.txt_total_battle.text = this.overallStats.total_battles;
            _local_1.txt_avg_battle_season.text = this.overallStats.avg_battles_per_season;
            _local_1.txt_performance_grade.text = this.overallStats.performance_grade;
            _local_1.txt_performance_grade.textColor = this.getGradeColor(this.overallStats.performance_grade);
            _local_1.txt_overall_win_rate.text = (this.overallStats.overall_win_rate + "%");
            _local_1.bar_overall_win_rate.bar.scaleX = Math.min(Math.max((this.overallStats.overall_win_rate / 100), 0), 1);
            _local_1.txt_best_season.text = this.overallStats.best_season;
            _local_1.txt_best_season_win_rate.text = (this.overallStats.best_season_win_rate + "%");
            _local_1.bar_best_season_win_rate.bar.scaleX = Math.min(Math.max((this.overallStats.best_season_win_rate / 100), 0), 1);
            _local_1.txt_worst_season.text = this.overallStats.worst_season;
            _local_1.txt_worst_season_win_rate.text = (this.overallStats.worst_season_win_rate + "%");
            _local_1.bar_worst_season_win_rate.bar.scaleX = Math.min(Math.max((this.overallStats.worst_season_win_rate / 100), 0), 1);
            _local_1.txt_played_season.text = this.overallStats.seasons_played;
        }

        private function renderSeasonalStats():void
        {
            var _local_1:MovieClip = this.panelMC.detailMC.seasonalStatsMC;
            _local_1.txt_search.restrict = "0-9";
            _local_1.txt_search.text = this.searchPlaceholder;
            _local_1.txt_search.textColor = 0x999999;
            this.eventHandler.addListener(_local_1.txt_search, FocusEvent.FOCUS_IN, this.onFocusIn);
            this.eventHandler.addListener(_local_1.txt_search, FocusEvent.FOCUS_OUT, this.onFocusOut);
            this.eventHandler.addListener(_local_1.btn_search, MouseEvent.CLICK, this.onSearch);
            this.eventHandler.addListener(_local_1.btn_prev, MouseEvent.CLICK, this.changeSeason);
            this.eventHandler.addListener(_local_1.btn_next, MouseEvent.CLICK, this.changeSeason);
            _local_1.txt_total_attack.text = this.seasonalStats[this.currentSeasonIndex].stats.attacks;
            _local_1.txt_total_attack_win.text = this.seasonalStats[this.currentSeasonIndex].stats.attack_win;
            _local_1.txt_win_rate_attack.text = (this.seasonalStats[this.currentSeasonIndex].stats.win_rate_attack + "%");
            _local_1.bar_win_rate_attack.bar.scaleX = Math.min(Math.max((this.seasonalStats[this.currentSeasonIndex].stats.win_rate_attack / 100), 0), 1);
            _local_1.txt_total_defend.text = this.seasonalStats[this.currentSeasonIndex].stats.defends;
            _local_1.txt_total_defend_win.text = this.seasonalStats[this.currentSeasonIndex].stats.defend_win;
            _local_1.txt_win_rate_defend.text = (this.seasonalStats[this.currentSeasonIndex].stats.win_rate_defend + "%");
            _local_1.bar_win_rate_defend.bar.scaleX = Math.min(Math.max((this.seasonalStats[this.currentSeasonIndex].stats.win_rate_defend / 100), 0), 1);
            _local_1.txt_avg_battle_time.text = this.seasonalStats[this.currentSeasonIndex].stats.avg_battle_time;
            _local_1.txt_total_battle.text = this.seasonalStats[this.currentSeasonIndex].stats.total_battles;
            _local_1.txt_season_start_date.text = this.seasonalStats[this.currentSeasonIndex].started_at;
            _local_1.txt_season_end_date.text = this.seasonalStats[this.currentSeasonIndex].ended_at;
            _local_1.txt_season.text = ("Season " + this.seasonalStats[this.currentSeasonIndex].season);
            this.updateSeasonPageButton();
        }

        private function changeSeason(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_prev":
                    if (this.currentSeasonIndex < (this.seasonalStats.length - 1))
                    {
                        this.currentSeasonIndex++;
                    };
                    break;
                case "btn_next":
                    if (this.currentSeasonIndex > 0)
                    {
                        this.currentSeasonIndex--;
                    };
            };
            this.updateSeasonPageButton();
            this.renderSeasonalStats();
        }

        private function updateSeasonPageButton():void
        {
            if (this.seasonalStats.length <= 1)
            {
                this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = false;
                this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = false;
            };
            if (this.currentSeasonIndex == 0)
            {
                this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = true;
                this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = false;
            }
            else
            {
                if (this.currentSeasonIndex == (this.seasonalStats.length - 1))
                {
                    this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = false;
                    this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = true;
                }
                else
                {
                    this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = true;
                    this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = true;
                };
            };
        }

        private function onFocusIn(_arg_1:FocusEvent):void
        {
            if (_arg_1.currentTarget.text == this.searchPlaceholder)
            {
                _arg_1.currentTarget.text = "";
                _arg_1.currentTarget.textColor = 0;
            };
        }

        private function onSearch(_arg_1:MouseEvent):void
        {
            var _local_2:int = int(this.panelMC.detailMC.seasonalStatsMC.txt_search.text);
            this.currentSeasonIndex = this.getSeasonIndex(_local_2);
            if (this.currentSeasonIndex == -1)
            {
                this.main.showMessage("Season not found");
                return;
            };
            this.renderSeasonalStats();
        }

        private function getSeasonIndex(_arg_1:int):int
        {
            var _local_2:int;
            while (_local_2 < this.seasonalStats.length)
            {
                if (this.seasonalStats[_local_2].season == _arg_1)
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        private function onFocusOut(_arg_1:FocusEvent):void
        {
            if (_arg_1.currentTarget.text == "")
            {
                _arg_1.currentTarget.text = this.searchPlaceholder;
                _arg_1.currentTarget.textColor = 0x999999;
            };
        }

        private function resetTab():void
        {
            this.panelMC.detailMC.btn_seasonal_stats.gotoAndStop(1);
            this.panelMC.detailMC.btn_overall_stats.gotoAndStop(1);
            this.panelMC.detailMC.seasonalStatsMC.visible = false;
            this.panelMC.detailMC.overallStatsMC.visible = false;
        }

        private function closeViewMore(_arg_1:MouseEvent):void
        {
            this.panelMC.detailMC.visible = false;
            this.currentSeasonIndex = 0;
        }

        private function getGradeColor(_arg_1:String):uint
        {
            switch (_arg_1.toUpperCase())
            {
                case "S+":
                    return (0xFFD700);
                case "S":
                    return (16770919);
                case "A+":
                    return (14819071);
                case "A":
                    return (14456831);
                case "B+":
                    return (2003199);
                case "B":
                    return (9955583);
                case "C+":
                    return (3329330);
                case "C":
                    return (7130992);
                default:
                    return (0xFFFFFF);
            };
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

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.main = null;
            this.eventHandler = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

