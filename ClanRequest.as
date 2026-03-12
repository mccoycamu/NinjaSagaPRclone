// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.ClanRequest

package Panels
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import id.ninjasage.Clan;
    import com.utils.GF;

    public class ClanRequest extends MovieClip 
    {

        public var panel:MovieClip;
        public var main:*;
        public var clan_sel_slot:int = -1;
        public var clan_sel_idx:int = -1;
        public var current_page:* = 0;
        public var total_page:* = 0;
        public var search:* = "";
        public var selectedClanId:int = -1;
        public var is_search:* = false;
        public var firstSearch:* = true;

        public var eventHandler:* = new EventHandler();
        public var clans:Array = [];
        public var clansTmp:Array = [];

        public function ClanRequest(_arg_1:*)
        {
            this.clansTmp = [];
            super();
            this.main = _arg_1;
            this.addButtonListeners();
            this.clearClanTable();
            this.updatePageText();
            this.getClanTable();
        }

        public function updatePageText():*
        {
            this.panel.txt_page.text = ((this.current_page + " / ") + this.total_page);
        }

        public function clearClanTable(_arg_1:Boolean=false):*
        {
            var _local_2:* = 0;
            while (_local_2 < 6)
            {
                this.panel[("clan_" + _local_2)].gotoAndStop(1);
                this.eventHandler.addListener(this.panel[("clan_" + _local_2)], MouseEvent.CLICK, this.onSelectClan, false, 0, true);
                this.panel[("clan_" + _local_2)].visible = _arg_1;
                _local_2++;
            };
        }

        public function onSelectClan(_arg_1:MouseEvent):*
        {
            if (this.clan_sel_slot != -1)
            {
                this.panel[("clan_" + this.clan_sel_slot)].gotoAndStop(1);
            };
            var _local_2:* = int(_arg_1.currentTarget.name.replace("clan_", ""));
            this.selectedClanId = _arg_1.currentTarget.clan_id.text;
            this.clan_sel_slot = _local_2;
            this.clan_sel_idx = (_local_2 + ((this.current_page - 1) * 6));
            _arg_1.currentTarget.gotoAndStop(2);
        }

        public function getClanTable():*
        {
            this.main.loading(true);
            Clan.instance.getClansForRequest(this.onGetClansRes);
        }

        public function onGetClansRes(_arg_1:*, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("clans"))))
            {
                this.clans = _arg_1.clans;
                this.current_page = 1;
                this.total_page = Math.ceil((_arg_1.clans.length / 6));
                this.displayClans();
                if (((this.is_search) && (_arg_1.clans.length < 1)))
                {
                    this.main.getNotice("No clan are found with this ID");
                };
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Server Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        public function displayClans():*
        {
            this.is_search = true;
            var _local_1:* = undefined;
            this.updatePageText();
            this.clearClanTable();
            this.clan_sel_idx = -1;
            var _local_2:* = 0;
            while (_local_2 < 6)
            {
                _local_1 = (_local_2 + ((this.current_page - 1) * 6));
                if (this.clans.length > _local_1)
                {
                    this.panel[("clan_" + _local_2)].gotoAndStop(1);
                    this.panel[("clan_" + _local_2)].visible = true;
                    this.panel[("clan_" + _local_2)].clan_id.text = this.clans[_local_1].id;
                    this.panel[("clan_" + _local_2)].clan_name.text = this.clans[_local_1].name;
                    this.panel[("clan_" + _local_2)].clan_reputation.text = this.clans[_local_1].reputation;
                    this.panel[("clan_" + _local_2)].clan_members.text = ((this.clans[_local_1].members + " / ") + this.clans[_local_1].max_members);
                }
                else
                {
                    this.panel[("clan_" + _local_2)].visible = false;
                };
                _local_2++;
            };
        }

        public function displayClan(_arg_1:*):*
        {
            this.is_search = true;
            this.clan_sel_idx = -1;
            this.clearClanTable();
            this.panel.txt_page.text = "1 / 1";
            var _local_2:Boolean;
            var _local_3:* = -1;
            var _local_4:* = 0;
            while (_local_4 < this.clans.length)
            {
                if (this.clans[_local_4].id == _arg_1)
                {
                    _local_3 = _local_4;
                    _local_2 = true;
                    break;
                };
                _local_4++;
            };
            if (_local_2)
            {
                this.panel["clan_0"].gotoAndStop(1);
                this.panel["clan_0"].visible = true;
                this.panel["clan_0"].clan_id.text = this.clans[_local_3].id;
                this.panel["clan_0"].clan_name.text = this.clans[_local_3].name;
                this.panel["clan_0"].clan_reputation.text = this.clans[_local_3].reputation;
                this.panel["clan_0"].clan_members.text = ((this.clans[_local_3].members + " / ") + this.clans[_local_3].max_members);
                return;
            };
            this.current_page = 1;
            this.displayClans();
            this.main.showMessage("Searching in unlisted clan...");
            Clan.instance.searchClansForRequest(int(this.panel.txt_search.text), this.onGetSearchClansRes);
        }

        public function addButtonListeners():*
        {
            this.eventHandler.addListener(this.panel.btn_request, MouseEvent.CLICK, this.onRequestReq, false, 0, true);
            this.eventHandler.addListener(this.panel.btn_search, MouseEvent.CLICK, this.onSearch, false, 0, true);
            this.eventHandler.addListener(this.panel.btn_close, MouseEvent.CLICK, this.onClosePanel, false, 0, true);
            this.eventHandler.addListener(this.panel.btn_next, MouseEvent.CLICK, this.changePage, false, 0, true);
            this.eventHandler.addListener(this.panel.btn_prev, MouseEvent.CLICK, this.changePage, false, 0, true);
        }

        public function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.total_page > this.current_page)
                    {
                        this.current_page++;
                        this.displayClans();
                    };
                    break;
                case "btn_prev":
                    if (this.current_page > 1)
                    {
                        this.current_page--;
                        this.displayClans();
                    };
            };
            this.updatePageText();
        }

        public function onSearch(_arg_1:MouseEvent):*
        {
            if (this.panel.txt_search.text == "")
            {
                if (this.clansTmp.length > 0)
                {
                    this.clans = this.clansTmp;
                };
                this.displayClans();
            }
            else
            {
                this.search = int(this.panel.txt_search.text);
                this.displayClan(this.search);
            };
        }

        public function onGetSearchClansRes(_arg_1:*, _arg_2:*=null):*
        {
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("clans"))))
            {
                if (this.firstSearch)
                {
                    this.clansTmp = this.clans;
                    this.firstSearch = false;
                };
                if (_arg_1.clans == null)
                {
                    _arg_1.clans = [];
                };
                this.onGetClansRes(_arg_1, null);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Server Error: " + _arg_1.errorMessage));
                return;
            };
            this.onGetClansRes(_arg_1, _arg_2);
        }

        public function onRequestReq(_arg_1:MouseEvent):*
        {
            var _local_2:* = undefined;
            var _local_3:Array;
            if (((this.clan_sel_idx == -1) || (this.selectedClanId == -1)))
            {
                this.main.getNotice("Please select a clan first!");
            }
            else
            {
                this.main.loading(true);
                Clan.instance.sendRequestToClan(this.selectedClanId, this.onRequestToClanRes);
            };
        }

        public function onRequestToClanRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("result"))))
            {
                this.clearClanTable();
                this.getClanTable();
                this.main.getNotice(_arg_1.result);
                this.clan_sel_idx = -1;
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        public function onClosePanel(_arg_1:MouseEvent):*
        {
            GF.clearArray(this.clans);
            GF.clearArray(this.clansTmp);
            this.clansTmp = null;
            this.clans = null;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main.loadPanel("Panels.ClanCreate");
            this.main = null;
            parent.removeChild(this);
        }

        public function destroy():*
        {
            this.onClosePanel(null);
        }


    }
}//package Panels

