// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.NinjaSage

package Managers
{
    import id.ninjasage.EventHandler;
    import com.abrahamyan.liquid.ToolTip;
    import Storage.Character;
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.utils.getDefinitionByName;
    import com.utils.GF;
    import Storage.Library;
    import Storage.SkillLibrary;
    import Storage.PetInfo;
    import Storage.AnimationLibrary;
    import flash.events.MouseEvent;

    public class NinjaSage 
    {

        public static var obj:*;
        public static var loader:*;
        public static var loading:Boolean = false;
        private static var itemMaps:* = {};
        private static var eventHandler:*;
        private static var tooltip:*;
        private static var main:*;


        public static function initTooltipAndEventHandler(_arg_1:*):void
        {
            main = _arg_1;
            eventHandler = new EventHandler();
            tooltip = ToolTip.getInstance();
        }

        public static function generateRandomString(_arg_1:Number):String
        {
            var _local_2:* = "abcdefghijklmopqrtuvwyzABCDEFGHIJKLMOPQRSTUVWYZ0123456789";
            var _local_3:Number = (_local_2.length - 1);
            var _local_4:* = "";
            var _local_5:int;
            while (_local_5 < _arg_1)
            {
                _local_4 = (_local_4 + _local_2.charAt(Math.floor((Math.random() * _local_3))));
                _local_5++;
            };
            return (_local_4);
        }

        public static function getMaterialAmount(_arg_1:*):*
        {
            var _local_4:String;
            var _local_5:Array;
            var _local_2:String = Character.character_materials;
            if (((!(_local_2)) || (_local_2 == "")))
            {
                return (0);
            };
            var _local_3:Array = ((_local_2.indexOf(",") >= 0) ? _local_2.split(",") : [_local_2]);
            for each (_local_4 in _local_3)
            {
                _local_5 = _local_4.split(":");
                if (_local_5[0] == _arg_1)
                {
                    return (_local_5[1]);
                };
            };
            return (0);
        }

        public static function clearLoader():*
        {
            if (!loader)
            {
                return;
            };
            itemMaps = {};
            loader.clear();
            loader = null;
        }

        public static function loadIconSWF(path:*, name:*=null, mc:*=null, type:*=null):void
        {
            var swf:* = undefined;
            var addItemToLoader:Function = function (_arg_1:String, _arg_2:String, _arg_3:*, _arg_4:*):void
            {
                var _local_5:* = ((_arg_2 + "-") + NinjaSage.generateRandomString(4));
                itemMaps[_local_5] = {
                    "id":_local_5,
                    "path":_arg_1,
                    "name":_arg_2,
                    "holder":_arg_3,
                    "type":_arg_4
                };
                loader.add((((_arg_1 + "/") + _arg_2) + ".swf"), {"id":_local_5});
            };
            var addOnceListener:Function = function (_arg_1:BulkLoader, _arg_2:String, _arg_3:Function):void
            {
                if (!_arg_1.hasEventListener(_arg_2))
                {
                    eventHandler.addListener(_arg_1, _arg_2, _arg_3);
                };
            };
            loading = true;
            if (loader == null)
            {
                loader = BulkLoader.createUniqueNamedLoader(10, BulkLoader.LOG_INFO);
            };
            if ((((path is Array) && (name == null)) && (mc == null)))
            {
                for each (swf in path)
                {
                    (addItemToLoader(swf.path, swf.name, swf.holder, swf.type));
                };
            }
            else
            {
                (addItemToLoader(path, name, mc, type));
            };
            if (!eventHandler)
            {
                eventHandler = new EventHandler();
            };
            (addOnceListener(loader, BulkLoader.COMPLETE, onIconLoaded));
            (addOnceListener(loader, BulkLoader.ERROR, onItemLoadError));
            (addOnceListener(loader, BulkLoader.PROGRESS, onItemProgress));
            loader.start();
        }

        public static function onItemProgress(_arg_1:BulkProgressEvent):void
        {
            updateLoadedItems();
        }

        public static function onIconLoaded(_arg_1:Event):void
        {
            updateLoadedItems();
        }

        public static function onItemLoadError(_arg_1:ErrorEvent):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, onIconLoaded);
            loader.removeFailedItems();
        }

        private static function updateLoadedItems():void
        {
            var _local_1:*;
            for each (_local_1 in itemMaps)
            {
                if (loader.hasItem(_local_1.id, false))
                {
                    addLoadedIconToHolder(loader.get(_local_1.id), _local_1);
                };
            };
        }

        private static function addLoadedIconToHolder(item:*, itemInfo:*):void
        {
            var itemMC:MovieClip;
            var classMC:MovieClip;
            var type:* = undefined;
            var className:String;
            var bodyMC:* = undefined;
            var addToHolder:Function = function (_arg_1:DisplayObject, _arg_2:*):void
            {
                if (!Character.play_items_animation)
                {
                    (_arg_1 as MovieClip).stopAllMovieClips();
                };
                _arg_2.addChild(_arg_1);
            };
            if (itemInfo.type != null)
            {
                type = itemInfo.type;
                if (type == "with_holder")
                {
                    itemMC = item.content.icon;
                    (addToHolder(itemMC, itemInfo.holder));
                }
                else
                {
                    if ((type is Array))
                    {
                        for each (className in type)
                        {
                            bodyMC = item.content[className];
                            (addToHolder(bodyMC, itemInfo.holder[className]));
                        };
                    }
                    else
                    {
                        if ((((type.indexOf("npc_") >= 0) || (type.indexOf("ene_") >= 0)) || (type.indexOf("pet_") >= 0)))
                        {
                            classMC = item.content[type];
                            addStandByFrameScript(classMC);
                        }
                        else
                        {
                            classMC = item.content[type];
                        };
                        (addToHolder(classMC, itemInfo.holder));
                    };
                };
            }
            else
            {
                itemMC = item.content.icon;
                (addToHolder(itemMC, (((itemInfo.holder.iconHolder) || (itemInfo.holder.icon.iconHolder)) || (itemInfo.holder))));
            };
            loading = false;
            loader.remove(itemInfo.id);
        }

        public static function loadItemIcon(holderMC:*, rewardId:*, className:String=""):void
        {
            var holder:* = undefined;
            var holderForCurrency:* = undefined;
            var holderInfo:* = undefined;
            var getskillinfo:Object;
            var getpetinfo:Object;
            var getaniminfo:Object;
            var configureHolder:Function = function (_arg_1:String, _arg_2:Boolean):void
            {
                holder = holderMC[_arg_1];
                holderForCurrency = holder.iconHolder;
                holderMC.rewardIcon.visible = (!(_arg_2));
                holderMC.skillIcon.visible = _arg_2;
                holderMC[_arg_1].gotoAndStop(1);
                if (holderMC[_arg_1].hasOwnProperty("colorType"))
                {
                    holderMC[_arg_1]["colorType"].gotoAndStop(1);
                }
                else
                {
                    holderMC[_arg_1].stopAllMovieClips();
                };
            };
            var loadRewardIcon:Function = function (_arg_1:String, _arg_2:*):void
            {
                var _local_3:Class = (getDefinitionByName(_arg_1) as Class);
                var _local_4:DisplayObject = holderForCurrency.getChildByName(_arg_1);
                if (!_local_4)
                {
                    _local_4 = new (_local_3)();
                    _local_4.name = _arg_1;
                    if (_local_4.hasOwnProperty("txt"))
                    {
                        _local_4["txt"].text = _arg_2;
                    };
                    GF.removeAllChild(holderForCurrency);
                    holderForCurrency.addChild(_local_4);
                }
                else
                {
                    _local_4["txt"].text = _arg_2;
                };
                setTooltip(_arg_2);
            };
            var setTooltip:Function = function (_arg_1:*):void
            {
                delete holderInfo.tooltipCache;
                holderInfo.tooltip = _arg_1;
            };
            holder = holderMC;
            holderForCurrency = holderMC;
            holderInfo = holderMC.parent;
            var itemid:* = rewardId.split(":")[0];
            itemid = itemid.replace("%s", Character.character_gender);
            var itemType:* = itemid.split("_");
            var getiteminfo:* = Library.getItemInfo(itemid);
            if (className == "")
            {
                holderInfo = holderMC;
                (configureHolder(((itemType[0] == "skill") ? "skillIcon" : "rewardIcon"), (itemType[0] == "skill")));
            };
            holderInfo.item_type = itemType[0];
            var path:String;
            switch (itemType[0])
            {
                case "skill":
                    path = "skills";
                    getskillinfo = SkillLibrary.getSkillInfo(itemid);
                    (setTooltip(getskillinfo));
                    break;
                case "pet":
                    path = "pets";
                    getpetinfo = PetInfo.getPetStats(itemid);
                    (setTooltip(getpetinfo));
                    break;
                case "material":
                    path = "materials";
                    (setTooltip(getiteminfo));
                    break;
                case "essential":
                    path = "essentials";
                    (setTooltip(getiteminfo));
                    break;
                case "item":
                    path = "consumables";
                    (setTooltip(getiteminfo));
                    break;
                case "tokens":
                case "gold":
                case "tp":
                case "ss":
                case "prestige":
                case "merit":
                case "emblem":
                case "xp":
                    (loadRewardIcon(itemType[0], itemType[1]));
                    break;
                case "ani":
                    getaniminfo = AnimationLibrary.getAnimation(itemid);
                    (loadRewardIcon(itemid, getaniminfo));
                    break;
                default:
                    path = "items";
                    (setTooltip(getiteminfo));
            };
            if (path)
            {
                GF.removeAllChild(((className) ? holder : holder.iconHolder));
                loadIconSWF(path, itemid, holder, ((className) || (null)));
            };
            if (!eventHandler)
            {
                eventHandler = new EventHandler();
            };
            if (!holderInfo.hasEventListener(MouseEvent.MOUSE_OVER))
            {
                eventHandler.addListener(holderInfo, MouseEvent.MOUSE_OVER, toolTiponOver);
            };
            if (!holderInfo.hasEventListener(MouseEvent.MOUSE_OUT))
            {
                eventHandler.addListener(holderInfo, MouseEvent.MOUSE_OUT, toolTiponOut);
            };
        }

        public static function toolTiponOver(e:MouseEvent):void
        {
            var tooltipData:Object;
            var desc:String;
            var itemType:String;
            var mc:MovieClip = (e.currentTarget as MovieClip);
            if (!mc)
            {
                return;
            };
            if (!mc.tooltipCache)
            {
                var formatDesc:Function = function (_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String="", _arg_5:String=""):String
                {
                    var _local_6:* = "";
                    switch (_arg_2)
                    {
                        case "Material":
                            _local_6 = (('\n<font color="#00cc00">Owned: ' + Character.getMaterialAmount(tooltipData.item_id)) + "</font>");
                            break;
                        case "Essential":
                            _local_6 = (('\n<font color="#00cc00">Owned: ' + Character.getEssentialAmount(tooltipData.item_id)) + "</font>");
                            break;
                        case "Item":
                            _local_6 = (('\n<font color="#00cc00">Owned: ' + Character.getConsumableAmount(tooltipData.item_id)) + "</font>");
                            break;
                    };
                    return ((((((((_arg_1 + "\n(") + _arg_2) + ")\n\nLevel ") + _arg_3) + _arg_4) + _local_6) + "\n\n") + _arg_5);
                };
                tooltipData = mc.tooltip;
                itemType = mc.item_type;
                switch (itemType)
                {
                    case "skill":
                        desc = formatDesc(tooltipData.skill_name, "Skill", tooltipData.skill_level, (((((('\n<font color="#ff0000">Damage: ' + tooltipData.skill_damage) + '</font>\n<font color="#0000ff">CP Cost: ') + tooltipData.skill_cp_cost) + '</font>\n<font color="#ffcc00">Cooldown: ') + tooltipData.skill_cooldown) + "</font>"), tooltipData.skill_description);
                        break;
                    case "wpn":
                        desc = formatDesc(tooltipData.item_name, "Weapon", tooltipData.item_level, (('\n<font color="#ff0000">Damage: ' + tooltipData.item_damage) + "</font>"), tooltipData.item_description);
                        break;
                    case "back":
                    case "set":
                    case "hair":
                    case "accessory":
                    case "material":
                    case "item":
                    case "essential":
                        desc = formatDesc(tooltipData.item_name, capitalizeFirstLetter(itemType), tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "pet":
                        desc = ((tooltipData.pet_name + "\n(Pet)\n\n") + tooltipData.description);
                        break;
                    case "tokens":
                        desc = (("(Token)\n" + tooltipData) + " Tokens");
                        break;
                    case "gold":
                        desc = (("(Gold)\n" + tooltipData) + " Gold");
                        break;
                    case "tp":
                        desc = (("(TP)\n" + tooltipData) + " TP");
                        break;
                    case "xp":
                        desc = (("(XP)\n" + tooltipData) + " XP");
                        break;
                    case "ss":
                        desc = (("(SS)\n" + tooltipData) + " SS");
                        break;
                    case "prestige":
                        desc = (("(Prestige)\n" + tooltipData) + " Prestige");
                        break;
                    case "merit":
                        desc = (("(Merit)\n" + tooltipData) + " Merit");
                        break;
                    case "emblem":
                        desc = "(Emblem)\nEmblem";
                        break;
                    case "ani":
                        desc = ((("(" + capitalizeFirstLetter(tooltipData.category)) + " Animation)\n") + tooltipData.name);
                        break;
                    default:
                        desc = "";
                };
                mc.tooltipCache = desc;
            };
            main.stage.addChild(tooltip);
            tooltip.followMouse = true;
            tooltip.fixedWidth = 350;
            tooltip.multiLine = true;
            tooltip.show(mc.tooltipCache);
        }

        public static function capitalizeFirstLetter(_arg_1:String):String
        {
            return (_arg_1.charAt(0).toUpperCase() + _arg_1.slice(1));
        }

        public static function toolTiponOut(_arg_1:MouseEvent):void
        {
            tooltip.hide();
        }

        public static function showDynamicTooltip(_arg_1:*, _arg_2:String):void
        {
            _arg_1.metaData = {"tooltip_text":_arg_2};
            if (!eventHandler)
            {
                eventHandler = new EventHandler();
            };
            eventHandler.addListener(_arg_1, MouseEvent.ROLL_OVER, showTextDynamicTooltip);
            eventHandler.addListener(_arg_1, MouseEvent.ROLL_OUT, toolTiponOut);
        }

        public static function showTextDynamicTooltip(_arg_1:Event):void
        {
            main.stage.addChild(tooltip);
            tooltip.followMouse = true;
            tooltip.fixedWidth = 300;
            tooltip.multiLine = true;
            tooltip.show(_arg_1.currentTarget.metaData.tooltip_text);
        }

        public static function clearDynamicTooltip(_arg_1:*):*
        {
            _arg_1.metaData = {};
            if (!eventHandler)
            {
                eventHandler = new EventHandler();
            };
            eventHandler.removeListener(_arg_1, MouseEvent.ROLL_OVER, showTextDynamicTooltip);
            eventHandler.removeListener(_arg_1, MouseEvent.ROLL_OUT, toolTiponOut);
        }

        public static function clearEventListener():void
        {
            if (eventHandler)
            {
                eventHandler.removeAllEventListeners();
            };
        }

        public static function addStandByFrameScript(mc:*, labelName:String="standby"):*
        {
            var labelFrame:Object = getLabelFrames(mc, labelName);
            mc.addFrameScript((labelFrame.end - 1), function ():void
            {
                mc.gotoAndPlay(labelName);
            });
        }

        public static function getLabelFrames(_arg_1:MovieClip, _arg_2:String):Object
        {
            var _local_6:*;
            var _local_3:int = -1;
            var _local_4:int = -1;
            var _local_5:int;
            while (_local_5 < _arg_1.currentLabels.length)
            {
                _local_6 = _arg_1.currentLabels[_local_5];
                if (_local_6.name == _arg_2)
                {
                    _local_3 = _local_6.frame;
                    if ((_local_5 + 1) < _arg_1.currentLabels.length)
                    {
                        _local_4 = (_arg_1.currentLabels[(_local_5 + 1)].frame - 1);
                    }
                    else
                    {
                        _local_4 = _arg_1.totalFrames;
                    };
                    break;
                };
                _local_5++;
            };
            return ({
                "start":_local_3,
                "end":_local_4
            });
        }


    }
}//package Managers

