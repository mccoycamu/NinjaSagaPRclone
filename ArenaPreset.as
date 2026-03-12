// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ArenaPreset

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import flash.utils.getDefinitionByName;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class ArenaPreset extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:*;
        private var response:Object;
        private var selectedUse:int;
        public var tempWardrobeMC:MovieClip;
        public var wardrobeMC:MovieClip;
        public var skillMC:MovieClip;
        public var petMC:MovieClip;

        public function ArenaPreset(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.skillMC = _arg_2.SkillInventory;
            this.petMC = _arg_2.PetInventory;
            this.tempWardrobeMC = _arg_2.Wardrobe;
            this.skillMC.visible = false;
            this.petMC.visible = false;
            this.tempWardrobeMC.visible = false;
            this.eventHandler = new EventHandler();
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.getData();
        }

        public function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["getPresets", [Character.char_id, Character.sessionkey]], this.onDataResponse);
        }

        private function onDataResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                PresetData.presetCallback = _arg_1;
                PresetData.preset_id_used = _arg_1.active;
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
            this.initUI();
        }

        public function initUI():void
        {
            this.panelMC.titleTxt.text = "Defender Preset Selection";
            var _local_1:int;
            while (_local_1 < 4)
            {
                this.panelMC[("preset_" + _local_1)].nameTxt.text = PresetData.presetCallback.presets[_local_1].name;
                this.eventHandler.addListener(this.panelMC[("preset_" + _local_1)].btn_use, MouseEvent.CLICK, this.usePreset);
                this.eventHandler.addListener(this.panelMC[("preset_" + _local_1)].btn_edit, MouseEvent.CLICK, this.editPreset);
                if (PresetData.preset_id_used == PresetData.presetCallback.presets[_local_1].id)
                {
                    this.panelMC[("preset_" + _local_1)].btn_use.visible = false;
                    this.panelMC.currentPresetTxt.text = ("Current Preset: " + PresetData.presetCallback.presets[_local_1].name);
                }
                else
                {
                    this.panelMC[("preset_" + _local_1)].btn_use.visible = true;
                };
                _local_1++;
            };
        }

        private function editPreset(_arg_1:MouseEvent):void
        {
            var _local_2:int = _arg_1.currentTarget.parent.name.replace("preset_", "");
            PresetData.preset_id_edit = PresetData.presetCallback.presets[_local_2].id;
            PresetData.preset_hair = PresetData.presetCallback.presets[_local_2].hair;
            PresetData.preset_set = PresetData.presetCallback.presets[_local_2].clothing;
            PresetData.preset_back = PresetData.presetCallback.presets[_local_2].back_item;
            PresetData.preset_wpn = PresetData.presetCallback.presets[_local_2].weapon;
            PresetData.preset_acc = PresetData.presetCallback.presets[_local_2].accessory;
            PresetData.preset_hair_color = PresetData.presetCallback.presets[_local_2].hair_color;
            PresetData.preset_skin_color = PresetData.presetCallback.presets[_local_2].skin_color;
            PresetData.preset_skill = PresetData.presetCallback.presets[_local_2].skills;
            PresetData.preset_pet = ((PresetData.presetCallback.presets[_local_2].pet.pet_swf == null) ? "" : PresetData.presetCallback.presets[_local_2].pet.pet_swf);
            PresetData.preset_pet_id = ((PresetData.presetCallback.presets[_local_2].pet.pet_id == null) ? 0 : PresetData.presetCallback.presets[_local_2].pet.pet_id);
            PresetData.selected_preset_name = PresetData.presetCallback.presets[_local_2].name;
            this.loadWardrobe();
        }

        private function usePreset(_arg_1:MouseEvent):void
        {
            this.selectedUse = _arg_1.currentTarget.parent.name.replace("preset_", "");
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["usePreset", [Character.char_id, Character.sessionkey, PresetData.presetCallback.presets[this.selectedUse].id]], this.onUsePreset);
        }

        private function onUsePreset(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                PresetData.preset_id_used = PresetData.presetCallback.presets[this.selectedUse].id;
                this.initUI();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
            this.initUI();
        }

        public function loadWardrobe():*
        {
            var _local_1:Class = (getDefinitionByName("id.ninjasage.features.Wardrobe") as Class);
            this.wardrobeMC = new _local_1(this.main, this.tempWardrobeMC, this);
            this.tempWardrobeMC.visible = true;
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main = null;
            this.character = null;
            this.eventHandler = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

