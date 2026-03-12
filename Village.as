// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Village

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import flash.system.System;
    import Storage.Character;
    import Managers.OutfitManager;
    import flash.events.MouseEvent;
    import id.ninjasage.features.LinkMenu;
    import id.ninjasage.Log;
    import com.utils.GF;

    public class Village extends MovieClip 
    {

        public var btn_Scroll_Senjutsu:SimpleButton;
        public var seasonCrewTxt:TextField;
        public var seasonMC:MovieClip;
        public var seasonSwTxt:TextField;
        public var seasonTxt:TextField;
        public var btn_Scroll_Arena:SimpleButton;
        public var btn_TalentShop:SimpleButton;
        public var btnCrew:SimpleButton;
        public var btn_Senjutsu_Scroll:SimpleButton;
        public var btn_Headquarter:SimpleButton;
        public var btn_Scroll_Academy:SimpleButton;
        public var btn_MissionRoom:SimpleButton;
        public var btn_Recruit:SimpleButton;
        public var btn_Scroll_Battle:SimpleButton;
        public var btn_Scroll_Hunting:SimpleButton;
        public var btn_Scroll_Shop:SimpleButton;
        public var btn_Scroll_Pet:SimpleButton;
        public var clanBtn:SimpleButton;
        public var btn_Encyclopedia:SimpleButton;
        public var btn_Arena:SimpleButton;
        public var main:*;
        public var loader:*;
        public var swf_loading:* = "";
        public var eventHandler:* = new EventHandler();
        public var ramadhanClaimed:Boolean = false;

        public function Village(_arg_1:*)
        {
            System.gc();
            super();
            this.main = _arg_1;
            if (this.visible)
            {
                this.main.clearEvents();
            };
            this.seasonTxt.text = Character.clan_season_number;
            this.seasonCrewTxt.text = Character.crew_season_number;
            this.seasonSwTxt.text = Character.sw_season_number;
            OutfitManager.removeChildsFromMovieClips(this.main.loader);
            this.eventHandler.addListener(this.btn_MissionRoom, MouseEvent.CLICK, this.openExternalPanel, false, 0, true);
            this.eventHandler.addListener(this.btn_Recruit, MouseEvent.CLICK, this.openExternalPanel, false, 0, true);
            this.eventHandler.addListener(this.btn_TalentShop, MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.eventHandler.addListener(this.btn_Scroll_Shop, MouseEvent.CLICK, this.openPopup, false, 0, true);
            this.eventHandler.addListener(this.btn_Scroll_Pet, MouseEvent.CLICK, this.openPopup, false, 0, true);
            this.eventHandler.addListener(this.btn_Scroll_Academy, MouseEvent.CLICK, this.openPopup, false, 0, true);
            this.eventHandler.addListener(this.btn_Headquarter, MouseEvent.CLICK, this.openExternalPanel, false, 0, true);
            this.eventHandler.addListener(this.btn_Scroll_Battle, MouseEvent.CLICK, this.openPopup, false, 0, true);
            this.eventHandler.addListener(this.btn_Scroll_Hunting, MouseEvent.CLICK, this.openPopup, false, 0, true);
            this.eventHandler.addListener(this.btn_Encyclopedia, MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.eventHandler.addListener(this.clanBtn, MouseEvent.CLICK, this.openClan, false, 0, true);
            this.eventHandler.addListener(this.btnCrew, MouseEvent.CLICK, this.openCrew, false, 0, true);
            this.eventHandler.addListener(this.btn_Scroll_Arena, MouseEvent.CLICK, this.openPopup, false, 0, true);
            this.eventHandler.addListener(this.btn_Scroll_Senjutsu, MouseEvent.CLICK, this.openPopup, false, 0, true);
        }

        internal function openClan(_arg_1:MouseEvent):*
        {
            LinkMenu.open(LinkMenu.ClanWar);
        }

        internal function openCrew(_arg_1:MouseEvent):*
        {
            LinkMenu.open(LinkMenu.CrewWar);
        }

        internal function openExternalPanel(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name.replace("btn_", "");
            this.main.loadExternalSwfPanel(_local_2, _local_2);
        }

        internal function huntingLock(_arg_1:MouseEvent):void
        {
            this.main.getNotice("Unlocks on Level 10 !");
        }

        internal function openPanel(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name.replace("btn_", "");
            if ((((_local_2 == "TalentShop") && (int(Character.character_lvl) <= 40)) && (int(Character.character_rank) < 4)))
            {
                this.main.getNotice("Must clear Jounin Exam first!");
                return;
            };
            this.main.loadPanel(("Panels." + _local_2));
            if (_local_2 == "Encyclopedia")
            {
                this.main.handleVillageHUDVisibility(false);
            };
        }

        internal function openPopup(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name.replace("btn_", "");
            if ((((_local_2 == "Scroll_Senjutsu") && (int(Character.character_lvl) <= 80)) && (int(Character.character_rank) < 8)))
            {
                this.main.getNotice("Must clear Senior Ninja Tutor Exam first!");
                return;
            };
            this.main.loadPanel(("Popups." + _local_2));
        }

        public function easterEggDaily(_arg_1:MouseEvent):*
        {
            this.main.amf_manager.service("HalloweenEvent2024.easterEgg", [Character.char_id, Character.sessionkey], this.onClaimEasterEgg);
        }

        public function onClaimEasterEgg(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.reward);
                this.main.giveReward(1, _arg_1.reward, "halloween");
                this.main.HUD.setBasicData();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        public function ramadhanDaily(_arg_1:MouseEvent):*
        {
            if (!this.ramadhanClaimed)
            {
                this.main.amf_manager.service("RamadhanEvent2025.getDailyReward", [Character.char_id, Character.sessionkey], this.onClaimRamadhan);
            };
        }

        public function onClaimRamadhan(_arg_1:Object):*
        {
            this.ramadhanClaimed = true;
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.reward);
                this.main.giveReward(1, _arg_1.rewards, "ramadhan");
                this.main.HUD.setBasicData();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        public function destroy():*
        {
            Log.debug(this, "DESTROY");
            this.eventHandler.removeAllEventListeners();
            this.loader = null;
            this.main = null;
            this.eventHandler = null;
            GF.removeAllChild(this);
        }


    }
}//package Panels

