// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.EventMenu

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public class EventMenu extends MovieClip 
    {

        private var main:*;
        private var panelMC:MovieClip;
        private var eventHandler:EventHandler = new EventHandler();
        private var tabCategoryData:Array = [{
            "id":"seasonal",
            "button":"seasonal",
            "name":"Seasonal Events"
        }, {
            "id":"event:permanent",
            "button":"mainevent",
            "name":"Main Events"
        }, {
            "id":"features",
            "button":"mainfeature",
            "name":"Main Features"
        }];
        private var selectedTab:String;
        private var currentPage:int;
        private var totalPage:int;

        public function EventMenu(param1:*, param2:*)
        {
            trace("EventMenu constructed");
            this.main = param1;
            this.panelMC = param2.panelMC;
            super();
            this.initUI();
        }

        private function get eventData():Object
        {
            if ((!(Character.event_data)))
            {
                Character.event_data = {};
            };
            if ((!(Character.event_data["seasonal"])))
            {
                Character.event_data["seasonal"] = [];
            };
            if ((!(Character.event_data["event:permanent"])))
            {
                Character.event_data["event:permanent"] = [];
            };
            if ((!(Character.event_data["features"])))
            {
                Character.event_data["features"] = [];
            };
            return (Character.event_data);
        }

        private function initUI():void
        {
            this.panelMC.visible = true;
            this.panelMC.mainFeatureMC.visible = false;
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            for each (var tab:Object in this.tabCategoryData)
            {
                var btn:MovieClip = this.panelMC[("btn_" + tab.button)];
                btn.txt.text = tab.name;
                btn.metaData = {"id":tab.id};
                this.eventHandler.addListener(btn, MouseEvent.CLICK, this.selectTab);
                this.eventHandler.addListener(btn, MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.addListener(btn, MouseEvent.MOUSE_OUT, this.hoverOut);
            };
            this.eventHandler.addListener(this.panelMC.seasonalDetailMC.pageMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.seasonalDetailMC.pageMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.mainFeatureMC.pageMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.mainFeatureMC.pageMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.resetSelectedTab();
            var defaultTab:Object = this.getTabData(Character.event_current_tab);
            if (defaultTab)
            {
                this.panelMC[("btn_" + defaultTab.button)].gotoAndStop(3);
            };
            this.selectTab();
        }

        private function selectTab(param1:MouseEvent=null):void
        {
            if (param1)
            {
                Character.event_current_page = 1;
                Character.event_current_tab = param1.currentTarget.metaData.id;
                this.resetSelectedTab();
                param1.currentTarget.gotoAndStop(3);
            };
            var itemsPerPage:int = ((Character.event_current_tab == "seasonal") ? 1 : 8);
            var tabArray:Array = (this.eventData[Character.event_current_tab] as Array);
            if ((!(tabArray)))
            {
                tabArray = [];
            };
            this.totalPage = Math.max(1, Math.ceil((tabArray.length / itemsPerPage)));
            this.panelMC.mainFeatureMC.visible = (!(Character.event_current_tab == "seasonal"));
            if (Character.event_current_tab == "seasonal")
            {
                this.renderSeasonalUI(tabArray);
            }
            else
            {
                this.renderEventUI(tabArray);
            };
            var tabInfo:Object = this.getTabData(Character.event_current_tab);
            if (tabInfo)
            {
                this.panelMC.txt_title.text = tabInfo.name;
            };
            this.updatePageNumber();
        }

        private function renderSeasonalUI(seasonal:Array):void
        {
            if (seasonal.length == 0)
            {
                return;
            };
            var index:int = (Character.event_current_page - 1);
            if (((index < 0) || (index >= seasonal.length)))
            {
                return;
            };
            var data:Object = seasonal[index];
            var mc:MovieClip = this.panelMC.seasonalDetailMC;
            mc.txt_eventName.text = data.name;
            mc.txt_eventDesc.text = data.desc;
            mc.txt_eventDate.text = data.date;
            mc.btn_start.metaData = data;
            this.eventHandler.removeListener(mc.btn_start, MouseEvent.CLICK, this.openEventPanel);
            this.eventHandler.addListener(mc.btn_start, MouseEvent.CLICK, this.openEventPanel);
            GF.removeAllChild(this.panelMC.imageHolder);
            if (data.image)
            {
                data.image.width = 1178;
                data.image.height = 790;
                this.panelMC.imageHolder.addChild(data.image);
            };
        }

        private function renderEventUI(tabArray:Array):void
        {
            var baseIndex:int = ((Character.event_current_page - 1) * 8);
            var i:int;
            while (i < 8)
            {
                var item:MovieClip = this.panelMC.mainFeatureMC[("item_" + i)];
                item.visible = false;
                var dataIndex:int = (baseIndex + i);
                if (dataIndex < tabArray.length)
                {
                    var data:Object = tabArray[dataIndex];
                    item.visible = true;
                    item.icon.gotoAndStop(data.icon);
                    item.metaData = data;
                    this.main.initButton(item, this.openEventPanel, data.name);
                };
                i++;
            };
        }

        private function changePage(param1:MouseEvent):void
        {
            if (param1.currentTarget.name == "btn_next")
            {
                if (Character.event_current_page < this.totalPage)
                {
                    Character.event_current_page++;
                };
            }
            else
            {
                if (param1.currentTarget.name == "btn_prev")
                {
                    if (Character.event_current_page > 1)
                    {
                        Character.event_current_page--;
                    };
                };
            };
            this.selectTab();
        }

        private function updatePageNumber():void
        {
            var mc:MovieClip = ((Character.event_current_tab == "seasonal") ? this.panelMC.seasonalDetailMC.pageMC : this.panelMC.mainFeatureMC.pageMC);
            mc.txt_page.text = ((Character.event_current_page + "/") + this.totalPage);
        }

        private function openEventPanel(param1:MouseEvent):void
        {
            var data:Object = param1.currentTarget.metaData;
            if (((data.hasOwnProperty("inside")) && (data.inside)))
            {
                this.main.loadPanel(("Panels." + data.panel));
            }
            else
            {
                this.main.loadExternalSwfPanel(data.panel, data.panel);
            };
            this.main.removeExternalSwfPanel();
        }

        private function getTabData(id:String):Object
        {
            for each (var tab:Object in this.tabCategoryData)
            {
                if (tab.id == id)
                {
                    return (tab);
                };
            };
            return (null);
        }

        private function resetSelectedTab():void
        {
            this.panelMC.btn_seasonal.gotoAndStop(1);
            this.panelMC.btn_mainevent.gotoAndStop(1);
            this.panelMC.btn_mainfeature.gotoAndStop(1);
        }

        private function hoverOver(param1:MouseEvent):void
        {
            if (param1.currentTarget.currentFrame != 3)
            {
                param1.currentTarget.gotoAndStop(2);
            };
        }

        private function hoverOut(param1:MouseEvent):void
        {
            if (param1.currentTarget.currentFrame != 3)
            {
                param1.currentTarget.gotoAndStop(1);
            };
        }

        private function closePanel(param1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            if (((this.panelMC) && (this.panelMC.imageHolder)))
            {
                GF.removeAllChild(this.panelMC.imageHolder);
                this.panelMC.visible = false;
            };
            if (this.eventHandler)
            {
                this.eventHandler.removeAllEventListeners();
            };
            if (this.main)
            {
                this.main.removeExternalSwfPanel();
            };
        }


    }
}//package id.ninjasage.features

