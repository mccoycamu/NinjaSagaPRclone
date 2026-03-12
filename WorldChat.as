// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.WorldChat

package Panels
{
    import id.ninjasage.features.RealtimeChat;
    import flash.display.SimpleButton;
    import flash.display.MovieClip;
    import gs.TweenLite;
    import flash.events.MouseEvent;
    import Storage.Character;

    public dynamic class WorldChat extends RealtimeChat 
    {

        public var btn_back:SimpleButton;
        public var btn_clancht:SimpleButton;
        public var btn_globalcht:SimpleButton;
        public var discordChannel:SimpleButton;
        public var facebookGroup:SimpleButton;
        public var facebookPage:SimpleButton;
        protected var chatBoxMc:MovieClip;
        protected var closeChat:MovieClip;
        protected var offlineIcon:MovieClip;
        protected var onlineIcon:MovieClip;
        protected var chatScrollPane:*;
        protected var chatType:String;

        public function WorldChat(param1:*=null, param2:*="global")
        {
            super(param1);
            this.chatType = param2;
            this.x = (this.x - this.width);
            TweenLite.to(this, 0.5, {
                "x":0,
                "ease":"easeOutBack",
                "onComplete":super.init
            });
        }

        override public function show():*
        {
            super.show();
            TweenLite.to(this, 0.5, {
                "x":0,
                "ease":"easeOutBack"
            });
        }

        override public function closeChatPanel(param1:MouseEvent=null):*
        {
            TweenLite.to(this, 0.5, {
                "x":-(this.width),
                "onComplete":super.closeChatPanel
            });
        }

        override public function destroy():*
        {
            TweenLite.killTweensOf(this);
            super.destroy();
        }

        override protected function getSocketAddress():*
        {
            var _loc1_:* = (((Character.chat_socket) && (Character.chat_socket.length > 0)) ? Character.chat_socket : (this.scheme + "://ws.ninjasage.id"));
            if (_loc1_.lastIndexOf("/") != (_loc1_.length - 1))
            {
                _loc1_ = (_loc1_ + "/");
            };
            var _loc2_:* = ((this.chatType == "clan") ? "clan-chat" : "global-chat");
            return (_loc1_ + _loc2_);
        }


    }
}//package Panels

