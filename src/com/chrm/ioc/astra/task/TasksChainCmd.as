package com.chrm.ioc.astra.task
{
	import com.chrm.ioc.astra.controller.Cmd;
	
	import starling.events.EventDispatcher;
	
	public class TasksChainCmd extends Cmd
	{
		private var tasksController:ITasksChainController;
		
		public function TasksChainCmd(val0:EventDispatcher)
		{
			super(val0);
			tasksController = new TasksChainController(dispatcher);
		}
		public function add(val:Class, ...params):ITasksChainController
		{
			var args:Array = [val];
			if(params)
				args = args.concat(params);
			return tasksController.add.apply(tasksController, args);
		}
		
		public function start(val:Object):void
		{
			tasksController.start( val );
		}
		
		public function setCompleteEvent(cevent:Class, type:String, ... params):void
		{
			setEvent(tasksController.setCompleteEvent, cevent, type, params);
		}
		public function setCancelEvent(cevent:Class, type:String, ... params):void
		{
			setEvent(tasksController.setCancelEvent, cevent, type, params);
		}
		public function setErrorEvent(cevent:Class, type:String, ... params):void
		{
			setEvent(tasksController.setErrorEvent, cevent, type, params);
		}
		
		private function setEvent(setFunction:Function, cevent:Class, type:String, params:Array):void
		{
			var args:Array = [cevent, type];
			if(params)
				args = args.concat(params);
			setFunction.apply(tasksController, args);
		}
	}
}