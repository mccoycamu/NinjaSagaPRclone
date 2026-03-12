// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.RewardScrollPane

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import com.gestouch.gestures.PanGesture;
    import fl.containers.ScrollPane;
    import com.gestouch.events.GestureEvent;
    import flash.utils.getDefinitionByName;
    import Managers.NinjaSage;
    import Storage.Character;
    import com.utils.GF;

    public class RewardScrollPane extends MovieClip 
    {

        private var scrollPane:*;
        private var iconRewardList:Array;
        private var instanceEmpty:MovieClip;
        private var paneData:Object;
        private var panGesture:PanGesture;

        public function RewardScrollPane()
        {
            this.iconRewardList = [];
            this.scrollPane = new ScrollPane();
            this.instanceEmpty = new MovieClip();
            this.panGesture = new PanGesture(this.scrollPane);
            this.panGesture.addEventListener(GestureEvent.GESTURE_CHANGED, this.onGestureChanged);
        }

        public function getRewardPane():*
        {
            return (this.scrollPane);
        }

        public function updateRewardPane(_arg_1:Object):void
        {
            var _local_7:Class;
            var _local_8:MovieClip;
            this.clearContent();
            this.paneData = _arg_1;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            while (_local_4 < this.paneData.rewards.length)
            {
                _local_7 = (getDefinitionByName("IconReward") as Class);
                _local_8 = new (_local_7)();
                NinjaSage.loadItemIcon(_local_8.icon, this.paneData.rewards[_local_4]);
                _local_8.icon.ownedTxt.visible = false;
                if (((Character.hasSkill(this.paneData.rewards[_local_4]) > 0) || (Character.isItemOwned(this.paneData.rewards[_local_4]) > 0)))
                {
                    _local_8.icon.ownedTxt.visible = true;
                    _local_8.icon.ownedTxt.text = "Owned";
                };
                _local_8.icon.amtTxt.visible = false;
                if (this.paneData.rewards[_local_4].split(":")[1] > 1)
                {
                    _local_8.icon.amtTxt.visible = true;
                    _local_8.icon.amtTxt.text = ("x" + this.paneData.rewards[_local_4].split(":")[1]);
                };
                _local_8.icon.x = _local_2;
                _local_8.icon.y = _local_3;
                if (this.paneData.scroll_direction == "vertical")
                {
                    _local_2 = (_local_2 + this.paneData.x);
                    if (((_local_4 + 1) % this.paneData.item_per_line) == 0)
                    {
                        _local_2 = 0;
                        _local_3 = (_local_3 + this.paneData.y);
                    };
                }
                else
                {
                    _local_3 = (_local_3 + this.paneData.y);
                    if (((_local_4 + 1) % this.paneData.item_per_line) == 0)
                    {
                        _local_3 = 0;
                        _local_2 = (_local_2 + this.paneData.x);
                    };
                };
                this.iconRewardList.push(_local_8);
                this.instanceEmpty.addChild(_local_8.icon);
                _local_4++;
            };
            var _local_5:int = (((this.paneData.hasOwnProperty("width")) && (!(this.paneData.width == null))) ? this.paneData.width : (this.instanceEmpty.width + 20));
            var _local_6:int = (((this.paneData.hasOwnProperty("height")) && (!(this.paneData.height == null))) ? this.paneData.height : (this.instanceEmpty.height + 20));
            this.scrollPane.setSize(_local_5, _local_6);
            this.scrollPane.horizontalScrollPolicy = (((this.paneData.hasOwnProperty("scroll_visible")) && (this.paneData.scroll_visible)) ? "auto" : this.paneData.scroll_visible);
            this.scrollPane.verticalScrollPolicy = (((this.paneData.hasOwnProperty("scroll_visible")) && (this.paneData.scroll_visible)) ? "auto" : this.paneData.scroll_visible);
            this.scrollPane.source = this.instanceEmpty;
            this.scrollPane.invalidate();
            this.scrollPane.refreshPane();
        }

        private function clearContent():void
        {
            var _local_1:int;
            while (_local_1 < this.iconRewardList.length)
            {
                GF.removeAllChild(this.iconRewardList[_local_1].icon.rewardIcon.iconHolder);
                GF.removeAllChild(this.iconRewardList[_local_1].icon.skillIcon.iconHolder);
                GF.removeAllChild(this.iconRewardList[_local_1]);
                _local_1++;
            };
            GF.removeAllChild(this.instanceEmpty);
            this.iconRewardList = [];
            this.paneData = {};
        }

        private function onGestureChanged(_arg_1:GestureEvent):void
        {
            var _local_2:PanGesture = PanGesture(_arg_1.target);
            this.scrollPane.verticalScrollPosition = (this.scrollPane.verticalScrollPosition - _local_2.offsetY);
            this.scrollPane.horizontalScrollPosition = (this.scrollPane.horizontalScrollPosition - _local_2.offsetX);
        }

        public function destroy():void
        {
            this.panGesture.removeEventListener(GestureEvent.GESTURE_CHANGED, this.onGestureChanged);
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.clearContent();
            this.panGesture = null;
            this.scrollPane.source = null;
            this.scrollPane = null;
            this.instanceEmpty = null;
            this.iconRewardList = null;
            this.paneData = null;
        }


    }
}//package id.ninjasage.features

