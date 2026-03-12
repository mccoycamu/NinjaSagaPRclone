// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.DragonHuntDetail

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class DragonHuntDetail extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var langArr:Array;
        private var langArr2:Array;
        private var langArr3:Array;
        private var currentPage:int = 1;
        private var maxPage:int = 6;

        public function DragonHuntDetail(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.langArr = ["Details"];
            this.langArr2 = ["Five Dragons Return", "Use of Dragon Balls  ", "Use of Seal Reel", "How to get Seal Reel", "Use of Pet Food", "How to get Pet Food"];
            this.langArr3 = ["Once upon a time, there were five dragons each born with a different element. \n\nSince their incredible power can destroy the world, so they were imprisoned on a deserted island by Master Iho. \n\nAfter two hundred years, the locks have been broken. Kage has sent a Ninja team to capture the dragons and save the world. ", "There are a total of 5 sets, each set contain seven Dragon Balls. Players can then challenge a Dragon BOSS once they have collected a complete set of Dragon Balls.\n\nPlayers can then challenge a Dragon BOSS once they have collected a complete set of Dragon Balls.", "Dragons can be captured by using Seal Reel.", "Obtain Seal Reels from Daily Stamp or Shop.", "Feeding Pet Dragons with Pet Food will increase their maturity points. \n\nDifferent Pet Food provides different increase in level.A full maturity bar is one of the conditions for Pet Combination.", "There are two kinds of Pet Food, namely Fruits and Easter Eggs. \n\nFruits and Easter Eggs can be obtained from Dragon battles or Gacha."];
            this.eventHandler.addListener(this.panelMC["btnClose"], MouseEvent.CLICK, this.closePanel);
            this.updateDetail();
        }

        private function prevPage(_arg_1:MouseEvent):*
        {
            if (this.currentPage > 1)
            {
                this.currentPage--;
            };
            this.updateDetail();
        }

        private function nextPage(_arg_1:MouseEvent):*
        {
            if (this.currentPage < this.maxPage)
            {
                this.currentPage = (this.currentPage + 1);
            };
            this.updateDetail();
        }

        private function updateDetail():*
        {
            var _local_1:MovieClip = this["panelMC"];
            var _local_2:int = (this.currentPage - 1);
            _local_1["titleTxt"].text = this.langArr[0];
            _local_1["subTitleTxt"].text = this.langArr2[_local_2];
            _local_1["detailPage"]["detailPage"]["PageDetailTxt"].text = this.langArr3[_local_2];
            _local_1["pageTxt"].text = ((this.currentPage + " / ") + this.maxPage);
            _local_1["detailPage"]["detailPage"].gotoAndStop(this.currentPage);
            this.eventHandler.addListener(_local_1["btnNextPage"], MouseEvent.CLICK, this.nextPage);
            _local_1["btnNextPage"].visible = true;
            if (this.currentPage >= this.maxPage)
            {
                this.eventHandler.removeListener(_local_1["btnNextPage"], MouseEvent.CLICK, this.nextPage);
                _local_1["btnNextPage"].visible = false;
            };
            this.eventHandler.addListener(_local_1["btnPrevPage"], MouseEvent.CLICK, this.prevPage);
            _local_1["btnPrevPage"].visible = true;
            if (this.currentPage <= 1)
            {
                this.eventHandler.removeListener(_local_1["btnPrevPage"], MouseEvent.CLICK, this.prevPage);
                _local_1["btnPrevPage"].visible = false;
            };
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.langArr = [];
            this.langArr2 = [];
            this.langArr3 = [];
            this.main = null;
            this.eventHandler = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

