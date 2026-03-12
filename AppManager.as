// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.AppManager

package Managers
{
    import flash.display.MovieClip;
    import Panels.SplashScreen;
    import id.ninjasage.tasks.core.InitTask;
    import id.ninjasage.tasks.core.VersionCheckTask;
    import Storage.StorageLoader;
    import id.ninjasage.tasks.core.ColorCheckTask;
    import id.ninjasage.tasks.core.ImageDownloadTask;
    import id.ninjasage.tasks.core.StorageDeleteTask;
    import flash.utils.setTimeout;
    import com.utils.GF;
    import id.ninjasage.tasks.TaskEvent;

    public class AppManager 
    {

        private static var _instance:AppManager;

        private var splashScreen:MovieClip;
        public var main:*;
        private var stage:*;
        private var tasks:Array;
        private var tasksCount:int;
        private var tasksCompleted:int;
        private var finalDelay:* = 200;

        public function AppManager(_arg_1:*, _arg_2:*)
        {
            if (AppManager._instance != null)
            {
                throw (new Error("Cannot reinstantiate AppManager"));
            };
            this.main = _arg_1;
            this.stage = _arg_2;
        }

        public static function getInstance():*
        {
            if (AppManager._instance == null)
            {
                throw (new Error("Not instantiated"));
            };
            return (AppManager._instance);
        }

        public static function boot(_arg_1:*, _arg_2:*):*
        {
            if (AppManager._instance != null)
            {
                return;
            };
            AppManager._instance = new AppManager(_arg_1, _arg_2);
            AppManager.getInstance().run();
        }


        private function run():*
        {
            this.splashScreen = new SplashScreen();
            this.main.loader.addChild(this.splashScreen);
            this.tasksCompleted = 0;
            this.tasks = [new InitTask(this.main, this.stage), new VersionCheckTask(this.main), new StorageLoader(), new ColorCheckTask(), new ImageDownloadTask(this.main), new StorageDeleteTask()];
            this.tasksCount = this.tasks.length;
            this.splashScreen.setPercentagePerTask(this.tasksCount);
            this.nextTask();
        }

        private function allTaskCompleted():*
        {
            setTimeout(this.final, this.finalDelay);
        }

        private function final():*
        {
            this.main.loadPanel("Managers.LoginManager");
            if (this.main.loader.contains(this.splashScreen))
            {
                this.main.loader.removeChild(this.splashScreen);
            };
            GF.removeAllChild(this.splashScreen);
            this.splashScreen = null;
            GF.clearArray(this.tasks);
        }

        private function nextTask():void
        {
            var _local_1:*;
            if (((!(this.tasks[0] == null)) && (this.tasks.length > 0)))
            {
                _local_1 = this.tasks.shift();
                _local_1.addEventListener(TaskEvent.COMPLETE, this.onTaskComplete);
                _local_1.addEventListener(TaskEvent.ERROR, this.onTaskError);
                _local_1.start(this.splashScreen);
            }
            else
            {
                if (this.tasks.length == 0)
                {
                    this.allTaskCompleted();
                }
                else
                {
                    this.tasks.shift();
                    this.nextTask();
                };
            };
        }

        private function onTaskComplete(_arg_1:TaskEvent):void
        {
            var _local_2:* = _arg_1.target;
            this.clearTaskListener(_local_2);
            this.tasksCompleted++;
            this.splashScreen.increase(this.splashScreen.calculateTask(this.tasksCompleted, this.tasksCount));
            this.nextTask();
        }

        private function onTaskError(_arg_1:TaskEvent):void
        {
            var _local_2:* = _arg_1.target;
            this.clearTaskListener(_local_2);
            this.nextTask();
        }

        private function clearTaskListener(_arg_1:*):*
        {
            _arg_1.removeEventListener(TaskEvent.COMPLETE, this.onTaskComplete);
            _arg_1.removeEventListener(TaskEvent.ERROR, this.onTaskError);
        }


    }
}//package Managers

