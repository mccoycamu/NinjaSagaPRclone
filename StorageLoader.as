// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.StorageLoader

package Storage
{
    import flash.events.EventDispatcher;
    import id.ninjasage.tasks.ITask;
    import Panels.SplashScreen;
    import id.ninjasage.Log;
    import br.com.stimuli.loading.BulkLoader;
    import flash.events.Event;
    import com.brokenfunction.json.decodeJson;
    import id.ninjasage.Zlib;
    import id.ninjasage.tasks.TaskEvent;
    import Managers.AppManager;

    public class StorageLoader extends EventDispatcher implements ITask 
    {

        private static var initialized:* = false;

        private var listener:*;
        private var loader:*;
        private var splash:SplashScreen;
        private var assetNames:* = ["skills", "library", "enemy", "npc", "pet", "mission", "gamedata", "talents", "senjutsu", "skill-effect", "weapon-effect", "back_item-effect", "accessory-effect", "arena-effect", "animation"];
        private var s:* = {};

        public function StorageLoader(param1:*=null)
        {
            if (initialized)
            {
                throw (new Error("Cannot reinit"));
            };
            this.listener = param1;
        }

        public static function init(param1:*=null):*
        {
            if (initialized)
            {
                return;
            };
            new StorageLoader(param1).loadAssets();
        }

        public static function reload(param1:*=null):*
        {
            initialized = false;
            new StorageLoader(param1).loadAssets();
        }

        public static function get completed():*
        {
            return (StorageLoader.initialized == true);
        }


        private function assetPath(param1:*):*
        {
            var _loc2_:* = "";
            return (("http://127.0.0.1:8000/game_data/" + param1) + _loc2_);
        }

        private function onLoadedStats(param1:*):*
        {
            Log.debug(this, "Constructing assets");
            if (this.splash)
            {
                this.splash.status("Initializing game assets...");
            };
            SkillLibrary.constructData(this.unpackAsset("skills"));
            Library.constructData(this.unpackAsset("library"));
            EnemyInfo.constructData(this.unpackAsset("enemy"));
            NpcInfo.constructData(this.unpackAsset("npc"));
            PetInfo.constructData(this.unpackAsset("pet"));
            MissionLibrary.constructData(this.unpackAsset("mission"));
            GameData.constructData(this.unpackAsset("gamedata"));
            TalentSkillLevel.constructData(this.unpackAsset("talents"));
            SenjutsuSkillLevel.constructData(this.unpackAsset("senjutsu"));
            SkillBuffs.constructData(this.unpackAsset("skill-effect"));
            WeaponBuffs.constructData(this.unpackAsset("weapon-effect"));
            BackItemBuffs.constructData(this.unpackAsset("back_item-effect"));
            AccessoryBuffs.constructData(this.unpackAsset("accessory-effect"));
            ArenaBuffs.constructData(this.unpackAsset("arena-effect"));
            AnimationLibrary.constructData(this.unpackAsset("animation"));
            this.complete();
            this.cleanup();
        }

        private function loadAssets():*
        {
            var _loc1_:*;
            var _loc2_:*;
            var _loc3_:*;
            Log.debug(this, "Loading assets");
            this.loader = BulkLoader.createUniqueNamedLoader(15);
            _loc1_ = null;
            _loc2_ = null;
            for each (_loc3_ in this.assetNames)
            {
                _loc1_ = "";
                _loc2_ = {"id":_loc3_};
                _loc1_ = (_loc3_ + ".bin");
                _loc2_.type = "binary";
                this.loader.add(this.assetPath(_loc1_), _loc2_);
            };
            this.loader.addEventListener(Event.COMPLETE, this.onLoadedStats);
            this.loader.addEventListener(BulkLoader.ERROR, this.onError);
            this.loader.start();
            StorageLoader.initialized = true;
        }

        private function unpackAsset(param1:*):*
        {
            if (this.splash)
            {
                this.splash.status(("Loading asset: " + param1));
            };
            var _loc2_:* = this.loader.getBinary(param1, true);
            this.s[param1] = _loc2_.length;
            var _loc3_:* = decodeJson(Zlib.decompress(_loc2_));
            _loc2_.clear();
            return (_loc3_);
        }

        private function onError(param1:*):*
        {
            Log.error(this, "Error occured:", param1);
            dispatchEvent(new TaskEvent(TaskEvent.ERROR, param1));
            this.cleanup();
        }

        private function cleanup():*
        {
            this.loader.removeEventListener(Event.COMPLETE, this.onLoadedStats);
            this.loader.removeEventListener(BulkLoader.ERROR, this.onError);
            this.loader.clear();
            this.loader = null;
            this.s = null;
            Log.debug(this, "Done loading assets");
            this.splash = null;
            this.listener = null;
        }

        public function start(param1:*):*
        {
            this.splash = param1;
            this.loadAssets();
        }

        public function complete():*
        {
            if ((!(this.splash)))
            {
                return;
            };
            this.splash.status("Game asset succesfully loaded");
            var _loc1_:* = Zlib.compress(JSON.stringify(this.s));
            AppManager.getInstance().main.amf_manager.service("Analytics.libraries", [_loc1_], null);
            _loc1_.clear();
            dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
        }


    }
}//package Storage

