// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.ClanWarLeaderboard

package Panels
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import gs.TweenLite;
    import flash.events.MouseEvent;
    import skein.socket.io.Options;
    import Storage.Character;
    import skein.socket.io.IO;
    import skein.socket.io.Socket;
    import skein.socket.io.Manager;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class ClanWarLeaderboard extends MovieClip 
    {

        private var socket:*;
        public var panelMC:MovieClip;
        public var main:*;
        public var eventHandler:*;
        private var r:*;
        private var oldR:* = null;
        private var defaultColor:* = "#abbbfe";
        private var green:* = "#01ff10";
        private var red:* = "#b91c1c";

        public function ClanWarLeaderboard(_arg_1:*)
        {
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.panelMC.y = (this.panelMC.y + this.main.stage.width);
            TweenLite.to(this.panelMC, 1.2, {
                "y":0,
                "ease":"easeOutBack"
            });
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            var _local_2:int;
            while (_local_2 < 15)
            {
                this.panelMC[("rankInfoMc_" + _local_2)].visible = false;
                _local_2++;
            };
            var _local_3:* = new Options();
            _local_3.reconnection = true;
            _local_3.forceNew = true;
            var _local_4:* = ((Character.web) ? "http" : "ws");
            var _local_5:* = (_local_4 + "://ws-ldns.ninjasage.id");
            this.socket = IO.socket(_local_5, _local_3);
            this.socket.on(Socket.EVENT_CONNECT, this.onConnected);
            this.socket.on(Socket.EVENT_DISCONNECT, this.onDisconnected);
            this.socket.on(Manager.EVENT_CLOSE, this.onError);
            this.socket.on("UpdateClanReputation", this.onData);
            this.socket.connect();
        }

        public function onData(_arg_1:*=null, _arg_2:*=null):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            var _local_11:*;
            var _local_12:*;
            var _local_13:*;
            var _local_14:*;
            if (((!(_arg_2 == null)) && (_arg_2.hasOwnProperty("clans"))))
            {
                this.respose = _arg_2;
                if (this.oldR == null)
                {
                    this.oldR = {};
                    _local_3 = 0;
                    while (_local_3 < _arg_2.clans.lenght)
                    {
                        _arg_2.clans[_local_3].gap = 0;
                        this.oldR[_arg_2.clans[_local_3].id] = _arg_2.clans[_local_3];
                        _local_3++;
                    };
                };
                _local_3 = 0;
                while (_local_3 < _arg_2.clans.length)
                {
                    if (_local_3 > 15) break;
                    _local_4 = _arg_2.clans[_local_3];
                    if (_local_4.hasOwnProperty("reputation"))
                    {
                        if (!this.oldR.hasOwnProperty(_local_4.id))
                        {
                            _local_4.gap = 0;
                            this.oldR[_local_4.id] = _local_4;
                        };
                        _local_5 = (_local_3 - 1);
                        _local_6 = ((_arg_2.clans[_local_5] != null) ? _arg_2.clans[_local_5].reputation : 0);
                        _local_7 = Math.max((_local_6 - _local_4.reputation), 0);
                        _local_8 = (_local_4.reputation - ((this.oldR.hasOwnProperty(_local_4.id)) ? this.oldR[_local_4.id].reputation : 0));
                        _local_9 = ((_arg_2.rpm.hasOwnProperty(_local_4.id)) ? _arg_2.rpm[_local_4.id] : 0);
                        _local_10 = ((_arg_2.rp15m.hasOwnProperty(_local_4.id)) ? _arg_2.rp15m[_local_4.id] : 0);
                        _local_11 = (((this.oldR[_local_4.id].gap - _local_7) == 0) ? this.defaultColor : (((this.oldR[_local_4.id].gap - _local_7) > 0) ? this.green : this.red));
                        _local_12 = ((_local_8 == 0) ? this.defaultColor : ((_local_8 > 0) ? this.green : this.red));
                        _local_13 = ((_local_9 == 0) ? this.defaultColor : ((_local_9 > 0) ? this.green : this.red));
                        _local_14 = ((_local_10 == 0) ? this.defaultColor : ((_local_10) ? this.green : this.red));
                        this.panelMC[("rankInfoMc_" + _local_3)].visible = true;
                        this.panelMC[("rankInfoMc_" + _local_3)].txt_rank.htmlText = (_local_3 + 1);
                        this.panelMC[("rankInfoMc_" + _local_3)].txt_name.htmlText = ((("[" + _local_4.id) + "] ") + _local_4.name);
                        this.panelMC[("rankInfoMc_" + _local_3)].txt_reputation.htmlText = this.colorText(_local_4.reputation, _local_12);
                        this.panelMC[("rankInfoMc_" + _local_3)].txt_gap.htmlText = this.colorText(_local_7, _local_11);
                        this.panelMC[("rankInfoMc_" + _local_3)].txt_rp1s.htmlText = this.colorText(_local_8, _local_12);
                        this.panelMC[("rankInfoMc_" + _local_3)].txt_rp1m.htmlText = this.colorText(_local_9, _local_13);
                        this.panelMC[("rankInfoMc_" + _local_3)].txt_rp15m.htmlText = this.colorText(_local_10, _local_14);
                        _arg_2.clans[_local_3].gap = _local_7;
                        this.oldR[_arg_2.clans[_local_3].id] = _arg_2.clans[_local_3];
                    };
                    _local_3++;
                };
            };
        }

        private function onConnected(_arg_1:*=null):*
        {
            this.socket.emit("subscribe", {"channel":"clan.leaderboard"});
        }

        private function onDisconnected(_arg_1:*=null, _arg_2:*=null):*
        {
        }

        private function onError(_arg_1:*):*
        {
            if (this.main != null)
            {
                this.main.getNotice("Failed to connect to \nReal Time Clan Leaderboard");
            };
        }

        private function colorText(_arg_1:*, _arg_2:*="#ffff"):*
        {
            return (((('<font color="' + _arg_2) + '">') + _arg_1) + "</font>");
        }

        public function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        private function cleanupSocket():*
        {
            if (this.socket != null)
            {
                this.socket.off(Socket.EVENT_CONNECT, this.onConnected);
                this.socket.off(Socket.EVENT_DISCONNECT, this.onDisconnected);
                this.socket.off(Manager.EVENT_CLOSE, this.onError);
                this.socket.off("UpdateClanReputation", this.onData);
                this.socket.disconnect();
            };
            this.socket = null;
        }

        public function destroy():void
        {
            TweenLite.killTweensOf(this.panelMC);
            this.cleanupSocket();
            if (this.eventHandler != null)
            {
                this.eventHandler.removeAllEventListeners();
            };
            this.eventHandler = null;
            this.main = null;
            this.oldR = null;
            GF.removeAllChild(this);
            System.gc();
        }


    }
}//package Panels

