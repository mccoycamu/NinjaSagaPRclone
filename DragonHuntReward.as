// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.DragonHuntReward

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Storage.GameData;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class DragonHuntReward extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:*;
        private var PET_RANK_I:Array;
        private var PET_RANK_II:Array;
        private var PET_RANK_III:Array;
        private var PET_RANK_IV:Array;

        public function DragonHuntReward(_arg_1:*, _arg_2:*)
        {
            var _local_3:Object = GameData.get("dragon_hunt").pets;
            this.PET_RANK_I = _local_3.rank_i;
            this.PET_RANK_II = _local_3.rank_ii;
            this.PET_RANK_III = _local_3.rank_iii;
            this.PET_RANK_IV = _local_3.rank_iv;
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.initUI();
        }

        private function initUI():*
        {
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            var _local_1:int;
            _local_1 = 0;
            while (_local_1 < this.PET_RANK_I.length)
            {
                NinjaSage.loadItemIcon(this.panelMC[("IconMc1_" + _local_1)], this.PET_RANK_I[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.PET_RANK_II.length)
            {
                NinjaSage.loadItemIcon(this.panelMC[("IconMc2_" + _local_1)], this.PET_RANK_II[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.PET_RANK_III.length)
            {
                NinjaSage.loadItemIcon(this.panelMC[("IconMc3_" + _local_1)], this.PET_RANK_III[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.PET_RANK_IV.length)
            {
                NinjaSage.loadItemIcon(this.panelMC[("IconMc4_" + _local_1)], this.PET_RANK_IV[_local_1]);
                _local_1++;
            };
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            var _local_1:* = 0;
            while (_local_1 < this.PET_RANK_I.length)
            {
                GF.removeAllChild(this.panelMC[("IconMc1_" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC[("IconMc1_" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.PET_RANK_II.length)
            {
                GF.removeAllChild(this.panelMC[("IconMc2_" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC[("IconMc2_" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.PET_RANK_III.length)
            {
                GF.removeAllChild(this.panelMC[("IconMc3_" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC[("IconMc3_" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.PET_RANK_IV.length)
            {
                GF.removeAllChild(this.panelMC[("IconMc4_" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC[("IconMc4_" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            NinjaSage.clearLoader();
            this.main = null;
            this.character = null;
            this.eventHandler = null;
            this.PET_RANK_I = [];
            this.PET_RANK_II = [];
            this.PET_RANK_III = [];
            this.PET_RANK_IV = [];
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

