package com.chrm.ioc.astra.service
{
	import com.chrm.ioc.astra.task.ITasksChainController;

	public class TCRespondent implements IRespondent
	{
		public var taskController:ITasksChainController;
		
		public function TCRespondent(val:ITasksChainController)
		{
			taskController = val;
		}
		
		public function onComplete(val:Object):void
		{
			taskController.nextOrComplete( val );
		}
		
		public function onError(val:Object):void
		{
			taskController.error( val );
		}
		
		public function onCancel(val:Object):void
		{
			taskController.cancel( val );
		}
	}
}