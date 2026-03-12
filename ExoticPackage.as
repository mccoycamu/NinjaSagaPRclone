// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ExoticPackage

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public dynamic class ExoticPackage extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var currentPage:int = 1;
        private var totalPage:int = 1;

        public function ExoticPackage(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.initUI();
        }

        private function initUI():void
        {
            this.panelMC.btnClose.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panelMC.pageMC.btn_next.addEventListener(MouseEvent.CLICK, this.changePage);
            this.panelMC.pageMC.btn_prev.addEventListener(MouseEvent.CLICK, this.changePage);
            this.currentPage = 1;
            this.totalPage = this.panelMC.exoticMC.totalFrames;
            this.panelMC.exoticMC.gotoAndStop(this.currentPage);
            this.updatePageNumber();
            this.initButton();
        }

        private function initButton():void
        {
            var _local_1:int;
            while (_local_1 < 5)
            {
                if (this.panelMC.exoticMC.content[("btn_" + _local_1)].hasEventListener(MouseEvent.CLICK))
                {
                    this.panelMC.exoticMC.content[("btn_" + _local_1)].removeEventListener(MouseEvent.CLICK, this.openPanel);
                };
                this.panelMC.exoticMC.content[("btn_" + _local_1)].addEventListener(MouseEvent.CLICK, this.openPanel);
                _local_1++;
            };
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                    };
                    break;
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                    };
                    break;
            };
            this.panelMC.exoticMC.gotoAndStop(this.currentPage);
            this.initButton();
            this.updatePageNumber();
        }

        private function updatePageNumber():void
        {
            this.panelMC.pageMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function openPanel(_arg_1:MouseEvent):void
        {
            if (this.currentPage == 1)
            {
                switch (_arg_1.currentTarget.name)
                {
                    case "btn_0":
                        this.main.loadExternalSwfPanel("SpiritOfOrientSet", "SpiritOfOrientSet");
                        break;
                    case "btn_1":
                        this.main.loadExternalSwfPanel("NecromancerSet", "NecromancerSet");
                        break;
                    case "btn_2":
                        this.main.loadExternalSwfPanel("TearsOfKingdomSet", "TearsOfKingdomSet");
                        break;
                    case "btn_3":
                        this.main.loadExternalSwfPanel("AncientRuinsSet", "AncientRuinsSet");
                        break;
                    case "btn_4":
                        this.main.loadExternalSwfPanel("MechbuserSet", "MechbuserSet");
                        break;
                };
            }
            else
            {
                if (this.currentPage == 2)
                {
                    switch (_arg_1.currentTarget.name)
                    {
                        case "btn_0":
                            this.main.loadExternalSwfPanel("FireBeastSet", "FireBeastSet");
                            return;
                        case "btn_1":
                            this.main.loadExternalSwfPanel("NightingaleSet", "NightingaleSet");
                            return;
                        case "btn_2":
                            this.main.loadExternalSwfPanel("MonolithSet", "MonolithSet");
                            return;
                        case "btn_3":
                            this.main.loadExternalSwfPanel("HanyaoniSet", "HanyaoniSet");
                            return;
                        case "btn_4":
                            this.main.loadExternalSwfPanel("DesertDwellerSet", "DesertDwellerSet");
                            return;
                    };
                };
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.panelMC.btnClose.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.panelMC.pageMC.btn_next.removeEventListener(MouseEvent.CLICK, this.changePage);
            this.panelMC.pageMC.btn_prev.removeEventListener(MouseEvent.CLICK, this.changePage);
            var _local_1:int;
            while (_local_1 < 5)
            {
                this.panelMC.exoticMC.content[("btn_" + _local_1)].removeEventListener(MouseEvent.CLICK, this.openPanel);
                _local_1++;
            };
            this.main.removeExternalSwfPanel();
            this.main = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

