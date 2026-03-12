// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.WallOfFame

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import id.ninjasage.Clan;
    import br.com.stimuli.loading.BulkLoader;
    import flash.utils.setTimeout;
    import com.utils.GF;

    public dynamic class WallOfFame extends MovieClip 
    {

        public var bg:MovieClip;
        public var btn_close:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_prev:SimpleButton;
        public var clanWinnerMC0:MovieClip;
        public var clanWinnerMC1:MovieClip;
        public var clanWinnerMC2:MovieClip;
        public var clanWinnerMC3:MovieClip;
        public var titleTxt:TextField;
        private var main:*;
        private var curr_page:* = 1;
        private var last_page:* = 0;
        private var total_page:* = 0;
        private var clanData:*;
        private var rew_loading:* = 0;
        private var loader:*;
        private var eventHandler:* = new EventHandler();

        public function WallOfFame(_arg_1:*)
        {
            this.main = _arg_1;
            this.loader = this.main.getTempLoader();
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_prev, MouseEvent.CLICK, this.changePage);
            this.getData();
        }

        private function getData():*
        {
            Clan.instance.seasonHistories(this.getDataResponse);
        }

        private function getDataResponse(_arg_1:Object, _arg_2:*=null):*
        {
            var _local_3:*;
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("histories"))))
            {
                this.clanData = _arg_1.histories;
                for each (_local_3 in _arg_1.histories)
                {
                    this.loader.add(_local_3.banner, {"id":_local_3.clan_id});
                };
                this.showWallOfFame();
                return;
            };
        }

        private function showWallOfFame():*
        {
            var _local_3:*;
            this.loader.addEventListener(BulkLoader.COMPLETE, this.onClanLogoLoaded);
            this.loader.start();
            this.resetClanIcons();
            this.rew_loading = 0;
            var _local_1:* = 0;
            var _local_2:* = 0;
            while (_local_1 < 4)
            {
                _local_3 = (_local_1 + int((int((this.curr_page - 1)) * 4)));
                if (this.clanData.length > _local_3)
                {
                    this[("clanWinnerMC" + _local_1)].visible = true;
                    this[("clanWinnerMC" + _local_1)].clanSeasonTxt.text = ("Season " + this.clanData[_local_3].season);
                    this[("clanWinnerMC" + _local_1)].clanNameTxt.text = this.clanData[_local_3].clan_name;
                    this[("clanWinnerMC" + _local_1)].clanMasterTxt.text = this.clanData[_local_3].master;
                    this[("clanWinnerMC" + _local_1)].reputationTxt.text = this.clanData[_local_3].reputation;
                    this[("clanWinnerMC" + _local_1)].endedDateTxt.text = this.clanData[_local_3].season_ended_at;
                    if (this.loader.hasItem(this.clanData[_local_3].clan_id, false))
                    {
                        _local_2++;
                    };
                }
                else
                {
                    this[("clanWinnerMC" + _local_1)].visible = false;
                };
                _local_1++;
            };
            if (_local_2 > 0)
            {
                this.onClanLogoLoaded(null);
            };
            this.updatePageNumber();
            this.total_page = Math.ceil((this.clanData.length / 4));
        }

        private function onClanLogoLoaded(_arg_1:*=null):*
        {
            var _local_3:*;
            if (this.rew_loading > 3)
            {
                this.rew_loading = 0;
                this.loader.removeEventListener(BulkLoader.COMPLETE, this.showWallOfFame);
                return;
            };
            var _local_2:* = (this.rew_loading + int((int((this.curr_page - 1)) * 4)));
            if (!this.clanData[_local_2])
            {
                return;
            };
            if (this.loader.hasItem(this.clanData[_local_2].clan_id, false))
            {
                _local_3 = this.loader.getContent(this.clanData[_local_2].clan_id);
                this[("clanWinnerMC" + this.rew_loading)].clanLogoHolder.addChild(_local_3);
            };
            this.rew_loading++;
            setTimeout(this.onClanLogoLoaded, 100);
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.total_page > this.curr_page)
                    {
                        this.curr_page++;
                        this.showWallOfFame();
                    };
                    break;
                case "btn_prev":
                    if (this.curr_page > 1)
                    {
                        this.curr_page--;
                        this.showWallOfFame();
                    };
            };
            this.updatePageNumber();
        }

        private function updatePageNumber():*
        {
            if (this.curr_page == 1)
            {
                this.btn_prev.visible = false;
            }
            else
            {
                this.btn_prev.visible = true;
            };
            if (this.total_page == this.curr_page)
            {
                this.btn_next.visible = false;
            }
            else
            {
                this.btn_next.visible = true;
            };
        }

        private function resetClanIcons():*
        {
            var _local_1:* = 0;
            while (_local_1 < 4)
            {
                GF.removeAllChild(this[("clanWinnerMC" + _local_1)].clanLogoHolder);
                _local_1++;
            };
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.main = null;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.loader.clear();
            this.loader = null;
            this.resetClanIcons();
            GF.removeAllChild(this);
        }


    }
}//package Panels

