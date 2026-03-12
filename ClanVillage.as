// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.ClanVillage

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.system.System;
    import id.ninjasage.Log;
    import com.utils.GF;
    import flash.utils.clearTimeout;
    import id.ninjasage.Clan;
    import br.com.stimuli.loading.BulkLoader;
    import Managers.OutfitManager;
    import flash.utils.setTimeout;
    import Managers.StatManager;
    import flash.events.MouseEvent;
    import Popups.ClanBattle;
    import Popups.ClanStamina;
    import Popups.ClanPrestigeBooster;
    import Popups.ClanUpgrade;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class ClanVillage extends MovieClip 
    {

        public var btn_ClanOnlineList:SimpleButton;
        public var btn_prestigeBooster:SimpleButton;
        public var prestigeBoosterEnd:MovieClip;
        public var txt_onigiri:TextField;
        public var btn_clanBattle:SimpleButton;
        public var btn_clanHall:SimpleButton;
        public var btn_clanHotSpring:MovieClip;
        public var btn_clanRamen:MovieClip;
        public var btn_clanTemple:MovieClip;
        public var btn_clanTrainingHall:MovieClip;
        public var btn_staminaPanel:SimpleButton;
        public var btn_village:SimpleButton;
        public var btn_Scroll_Clan_Shop:SimpleButton;
        public var btn_clanReward:SimpleButton;
        public var btn_fame:SimpleButton;
        public var btn_repsim:SimpleButton;
        public var btn_ClanWarLeaderboard:SimpleButton;
        public var clanSeasonEnd:MovieClip;
        public var cpBar:MovieClip;
        public var face_mc:MovieClip;
        public var headMc:MovieClip;
        public var hpBar:MovieClip;
        public var levelTxt:TextField;
        public var stamBar:MovieClip;
        public var staminaPlusMc:MovieClip;
        public var staminaPlusText:TextField;
        public var txt_clan_gold:TextField;
        public var txt_clan_name:TextField;
        public var txt_clan_tokens:TextField;
        public var txt_cp:TextField;
        public var txt_gold:TextField;
        public var txt_hp:TextField;
        public var txt_members:TextField;
        public var txt_name:TextField;
        public var txt_prestige:TextField;
        public var txt_rep:TextField;
        public var txt_stamina:TextField;
        public var txt_tokens:TextField;
        public var main:*;
        public var clan_timestamp:*;
        public var booster_timestamp:*;
        public var battle_panel:* = null;
        public var clan_hall:* = null;
        public var upgrade_panel:* = null;
        public var onlinelist:*;
        public var timeout:*;
        public var timeoutBooster:*;
        public var loaderAsset:*;
        public var destroyed:* = false;

        public var eventHandler:* = new EventHandler();
        public var clan_data:* = Character.clan_data;
        public var char_data:* = Character.clan_char_data;

        public function ClanVillage(_arg_1:*)
        {
            System.gc();
            super();
            this.main = _arg_1;
            this.loaderAsset = this.main.getTempLoader();
            this.addButtonListeners();
            this.setDisplay();
            this.checkTimeleft();
            this.onlinelist = new WorldChat(this.main, "clan");
            this.onlinelist.manualClose();
        }

        public function destroy():*
        {
            Log.debug(this, "DESTROY");
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            GF.removeAllChild(this.headMc.face_mc);
            if (this.eventHandler == null)
            {
                return;
            };
            this.eventHandler.removeAllEventListeners();
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            this.timeout = null;
            if (this.timeoutBooster)
            {
                clearTimeout(this.timeoutBooster);
            };
            this.timeoutBooster = null;
            Clan.instance.destroy();
            if (this.onlinelist)
            {
                this.onlinelist.destroy();
            };
            this.loaderAsset.clear();
            BulkLoader.getLoader("assets").removeAll();
            OutfitManager.clearStaticMc();
            this.loaderAsset = null;
            this.eventHandler = null;
            this.clan_timestamp = null;
            this.clan_data = null;
            this.char_data = null;
            this.battle_panel = null;
            this.clan_hall = null;
            this.upgrade_panel = null;
            this.onlinelist = null;
            this.main.removeLoadedPanel("Panels.ClanVillage");
            this.main = null;
            OutfitManager.removeChildsFromMovieClips(this);
        }

        public function checkTimeleft():*
        {
            this.clan_timestamp = Character.clan_timestamp;
            this.updateTimeleft();
            this.prestigeBoosterEnd.visible = false;
            if (this.char_data.prestige_boost > 0)
            {
                this.prestigeBoosterEnd.visible = true;
                this.booster_timestamp = this.char_data.prestige_boost;
                this.updateBoosterTimeleft();
            };
        }

        public function updateTimeleft():*
        {
            var _local_7:*;
            if (this.timeout)
            {
                clearTimeout(this.timeout);
                this.timeout = null;
            };
            if (this.destroyed)
            {
                if (this.timeout)
                {
                    clearTimeout(this.timeout);
                };
                this.timeout = null;
                return;
            };
            if (this.clan_timestamp == null)
            {
                return;
            };
            var _local_1:* = 86400;
            var _local_2:* = 3600;
            var _local_3:* = 60;
            var _local_4:* = this.clan_timestamp;
            var _local_5:* = Math.floor((_local_4 / _local_1));
            var _local_6:* = Math.floor(((_local_4 - (_local_5 * _local_1)) / _local_2));
            if ((_local_7 = Math.floor((((_local_4 - (_local_5 * _local_1)) - (_local_6 * _local_2)) / _local_3))) > 30)
            {
                this.staminaPlusMc.gotoAndStop((60 - _local_7));
            }
            else
            {
                this.staminaPlusMc.gotoAndStop((30 - _local_7));
            };
            this.clanSeasonEnd.daysTxt.text = _local_5;
            this.clanSeasonEnd.hoursTxt.text = _local_6;
            this.clanSeasonEnd.minutesTxt.text = _local_7;
            this.clan_timestamp = (this.clan_timestamp - 10);
            Clan.instance.getStamina(this.onGetStamina);
        }

        public function onGetStamina(_arg_1:Object, _arg_2:*=null):*
        {
            if (this.timeout)
            {
                clearTimeout(this.timeout);
                this.timeout = null;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.clan_char_data = _arg_1.char;
                this.char_data = _arg_1.char;
                this.txt_stamina.text = ((this.char_data.stamina + " / ") + this.char_data.max_stamina);
                this.stamBar.scaleX = (this.char_data.stamina / this.char_data.max_stamina);
                this.timeout = setTimeout(this.updateTimeleft, 10000);
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                this.destroy();
            };
            if (_arg_2 != null)
            {
                this.main.getError("");
                return;
            };
        }

        public function updateBoosterTimeleft():*
        {
            if (this.timeoutBooster)
            {
                clearTimeout(this.timeoutBooster);
                this.timeoutBooster = null;
            };
            if (this.destroyed)
            {
                if (this.timeoutBooster)
                {
                    clearTimeout(this.timeoutBooster);
                };
                this.timeoutBooster = null;
                return;
            };
            var _local_1:* = 86400;
            var _local_2:* = 3600;
            var _local_3:* = 60;
            var _local_4:* = this.booster_timestamp;
            var _local_5:* = Math.floor((_local_4 / _local_1));
            var _local_6:* = Math.floor(((_local_4 - (_local_5 * _local_1)) / _local_2));
            var _local_7:* = Math.floor((((_local_4 - (_local_5 * _local_1)) - (_local_6 * _local_2)) / _local_3));
            this.prestigeBoosterEnd.daysTxt.text = _local_5;
            this.prestigeBoosterEnd.hoursTxt.text = _local_6;
            this.prestigeBoosterEnd.minutesTxt.text = _local_7;
            this.booster_timestamp = (this.booster_timestamp - 10);
            this.timeoutBooster = setTimeout(this.updateBoosterTimeleft, 10000);
        }

        public function setDisplay():*
        {
            this.btn_clanRamen.gotoAndStop((int(this.clan_data.ramen) + 1));
            this.btn_clanHotSpring.gotoAndStop((int(this.clan_data.hot_spring) + 1));
            this.btn_clanTemple.gotoAndStop((int(this.clan_data.temple) + 1));
            this.btn_clanTrainingHall.gotoAndStop((int(this.clan_data.training_hall) + 1));
            var _local_1:* = this.main.getPlayerHead();
            _local_1.scaleX = 2.1;
            _local_1.scaleY = 2.1;
            _local_1.x = (_local_1.x + 25);
            _local_1.y = (_local_1.y - 15);
            OutfitManager.removeChildsFromMovieClips(this.headMc.face_mc);
            this.headMc.face_mc.addChild(_local_1);
            var _local_2:* = int((((this.clan_data.hot_spring * 0.3) + int(1)) * StatManager.calculate_stats_with_data("hp")));
            var _local_3:* = int((((this.clan_data.temple * 0.3) + int(1)) * StatManager.calculate_stats_with_data("cp")));
            this.txt_hp.text = ((_local_2 + "/") + _local_2);
            this.txt_cp.text = ((_local_3 + "/") + _local_3);
            this.txt_name.text = Character.character_name;
            this.levelTxt.text = Character.character_lvl;
            this.txt_gold.text = Character.character_gold;
            this.txt_tokens.text = String(Character.account_tokens);
            this.txt_onigiri.text = Character.getMaterialAmount("material_69");
            this.txt_stamina.text = ((this.char_data.stamina + " / ") + this.char_data.max_stamina);
            this.stamBar.scaleX = (this.char_data.stamina / this.char_data.max_stamina);
            this.txt_prestige.text = this.char_data.prestige;
            var _local_4:* = (30 + (this.clan_data.ramen * 10));
            this.staminaPlusText.text = (("+" + _local_4) + "/30 min");
            this.txt_clan_name.text = this.clan_data.name;
            this.txt_rep.text = this.clan_data.reputation;
            this.txt_members.text = ((this.clan_data.members + " / ") + this.clan_data.max_members);
            this.txt_clan_gold.text = this.clan_data.golds;
            this.txt_clan_tokens.text = this.clan_data.tokens;
        }

        public function addButtonListeners():*
        {
            this.btn_ClanOnlineList.addEventListener(MouseEvent.CLICK, this.openOnlineList, false, 0, true);
            this.btn_ClanOnlineList.visible = true;
            this.eventHandler.addListener(this.btn_village, MouseEvent.CLICK, this.buttonManager);
            if (((this.clan_data.master_id == Character.char_id) || (this.clan_data.elder_id == Character.char_id)))
            {
                if (this.clan_data.ramen < 4)
                {
                    this.eventHandler.addListener(this.btn_clanRamen, MouseEvent.CLICK, this.buttonManager);
                }
                else
                {
                    if (this.btn_clanRamen.hasEventListener(MouseEvent.CLICK))
                    {
                        this.eventHandler.removeListener(this.btn_clanRamen, MouseEvent.CLICK, this.buttonManager);
                    };
                };
                if (this.clan_data.hot_spring < 4)
                {
                    this.eventHandler.addListener(this.btn_clanHotSpring, MouseEvent.CLICK, this.buttonManager);
                }
                else
                {
                    if (this.btn_clanHotSpring.hasEventListener(MouseEvent.CLICK))
                    {
                        this.eventHandler.removeListener(this.btn_clanHotSpring, MouseEvent.CLICK, this.buttonManager);
                    };
                };
                if (this.clan_data.temple < 4)
                {
                    this.eventHandler.addListener(this.btn_clanTemple, MouseEvent.CLICK, this.buttonManager);
                }
                else
                {
                    if (this.btn_clanTemple.hasEventListener(MouseEvent.CLICK))
                    {
                        this.eventHandler.removeListener(this.btn_clanTemple, MouseEvent.CLICK, this.buttonManager);
                    };
                };
                if (this.clan_data.training_hall < 4)
                {
                    this.eventHandler.addListener(this.btn_clanTrainingHall, MouseEvent.CLICK, this.buttonManager);
                }
                else
                {
                    if (this.btn_clanTrainingHall.hasEventListener(MouseEvent.CLICK))
                    {
                        this.eventHandler.removeListener(this.btn_clanTrainingHall, MouseEvent.CLICK, this.buttonManager);
                    };
                };
            };
            this.eventHandler.addListener(this.btn_clanHall, MouseEvent.CLICK, this.buttonManager);
            this.eventHandler.addListener(this.btn_clanBattle, MouseEvent.CLICK, this.buttonManager);
            this.eventHandler.addListener(this.btn_staminaPanel, MouseEvent.CLICK, this.buttonManager);
            this.eventHandler.addListener(this.btn_prestigeBooster, MouseEvent.CLICK, this.buttonManager);
            this.eventHandler.addListener(this.btn_Scroll_Clan_Shop, MouseEvent.CLICK, this.openPopup);
            this.eventHandler.addListener(this.btn_clanReward, MouseEvent.CLICK, this.openClanReward);
            this.eventHandler.addListener(this.btn_fame, MouseEvent.CLICK, this.openWallOfFame);
            this.eventHandler.addListener(this.btn_repsim, MouseEvent.CLICK, this.openRepSim);
            this.eventHandler.addListener(this.btn_ClanWarLeaderboard, MouseEvent.CLICK, this.openClanWarLeaderboard);
        }

        public function buttonManager(_arg_1:MouseEvent):*
        {
            var _local_2:* = undefined;
            switch (_arg_1.currentTarget.name)
            {
                case "btn_clanHall":
                    if (this.clan_hall)
                    {
                        this.clan_hall.destroy();
                    };
                    this.clan_hall = new ClanHall(this.main, this);
                    this.addChild(this.clan_hall);
                    return;
                case "btn_clanBattle":
                    this.battle_panel = new ClanBattle(this.main, this);
                    this.addChild(this.battle_panel);
                    return;
                case "btn_staminaPanel":
                    _local_2 = new ClanStamina(this.main, this);
                    this.addChild(_local_2);
                    return;
                case "btn_prestigeBooster":
                    _local_2 = new ClanPrestigeBooster(this.main, this);
                    this.addChild(_local_2);
                    return;
                case "btn_clanRamen":
                    this.upgrade_panel = new ClanUpgrade(this.main, this);
                    this.upgrade_panel.upgrading_name = "clan_ramen";
                    this.upgrade_panel.showInfo(0, this.clan_data.ramen);
                    this.addChild(this.upgrade_panel);
                    return;
                case "btn_clanHotSpring":
                    this.upgrade_panel = new ClanUpgrade(this.main, this);
                    this.upgrade_panel.upgrading_name = "clan_hot_spring";
                    this.upgrade_panel.showInfo(1, this.clan_data.hot_spring);
                    this.addChild(this.upgrade_panel);
                    return;
                case "btn_clanTemple":
                    this.upgrade_panel = new ClanUpgrade(this.main, this);
                    this.upgrade_panel.upgrading_name = "clan_temple";
                    this.upgrade_panel.showInfo(2, this.clan_data.temple);
                    this.addChild(this.upgrade_panel);
                    return;
                case "btn_clanTrainingHall":
                    if ((this.upgrade_panel is ClanUpgrade))
                    {
                        this.upgrade_panel.onClose(null);
                        this.upgrade_panel = null;
                    };
                    this.upgrade_panel = new ClanUpgrade(this.main, this);
                    this.upgrade_panel.upgrading_name = "clan_training_hall";
                    this.upgrade_panel.showInfo(3, this.clan_data.training_hall);
                    this.addChild(this.upgrade_panel);
                    return;
                case "btn_village":
                    parent.removeChild(this);
                    this.main.loadPanel("Panels.Village");
                    this.main.loadPanel("Panels.HUD");
                    this.destroy();
                    return;
            };
        }

        internal function openOnlineList(_arg_1:MouseEvent):*
        {
            if (this.onlinelist)
            {
                this.onlinelist.show();
                return;
            };
            this.onlinelist = new WorldChat(this.main, "clan");
            this.onlinelist.manualClose();
            this.main.loader.addChild(this.onlinelist);
        }

        internal function openClanReward(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.loaderAsset.add("https://ninjasage.id/api/clan/rewards");
            if (_local_2.isLoaded)
            {
                this.onClanRewardLoaded(_local_2);
            }
            else
            {
                _local_2.addEventListener(Event.COMPLETE, this.onClanRewardLoaded, false, 0, true);
                this.loaderAsset.start();
            };
        }

        internal function openWallOfFame(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.WallOfFame");
        }

        internal function openRepSim(_arg_1:MouseEvent):*
        {
            navigateToURL(new URLRequest("https://ninjasage.id/en/player/clan/simulator"));
        }

        internal function openClanWarLeaderboard(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.ClanWarLeaderboard");
        }

        internal function onClanRewardLoaded(e:*):*
        {
            var link:* = undefined;
            this.loaderAsset.removeEventListener(Event.COMPLETE, this.onClanRewardLoaded);
            try
            {
                link = JSON.parse(String(e.target.content));
                if (("data" in link))
                {
                    this.main.getPromotion(link.data);
                };
            }
            catch(e)
            {
                this.main.showMessage("Cannot initialize banner, please retry again");
            };
        }

        internal function openPanel(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name.replace("btn_", "");
            this.main.loadPanel(("Panels." + _local_2));
        }

        internal function openPopup(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name.replace("btn_", "");
            this.main.loadPanel(("Popups." + _local_2));
        }


    }
}//package Panels

