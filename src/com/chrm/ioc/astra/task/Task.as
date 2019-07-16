package com.chrm.ioc.astra.task
{
	import com.chrm.ioc.astra.service.IRespondable;
	import com.chrm.ioc.astra.service.ITCService;
	import com.chrm.ioc.astra.service.TCRespondent;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class Task implements ITask
	{	
		public var dispatcher:EventDispatcher;
		
		public var tasksController:ITasksChainController;//current ITasksChainController for this task that inside into chain Tasks
			
		private var _payload:Object;
		
		public function Task()
		{
		}
		public function get payload():Object
		{
			return _payload;
		}
		
		public function set payload(value:Object):void
		{
			_payload = value;
		}
		//		abstract method, must be override in sub
		public function run(...params):void
		{
//			TODO write throw new Error('blah-blah') here!
		}
		
		public function next(val:Object=null):void
		{ 
			tasksController.nextOrComplete( val );
		}
		
		public function goTo(val:String, val1:Object=null):void
		{
			tasksController.goTo( val, val1 );
		}
		
		public function runServiceAndNext(val0:Class, ...param):void
		{
			var service:ITCService = new val0() as ITCService;
			if(payload && service is IPayloadObject)
				(service as IPayloadObject).payload = payload;
			(service as IRespondable).respondent = new TCRespondent( tasksController );
			service.doit.apply( service, param );
		}
		public function complete(val:Object=null):void
		{
			tasksController.complete( val );
		}
		public function cancel(val:Object=null):void
		{
			tasksController.cancel( val );
		}
		public function error(val:Object=null):void
		{
			tasksController.error( val );
		}
		public function dispatch(ev:Event):void
		{
			dispatcher.dispatchEvent( ev );
		}
		public function destroy():void
		{
//			TODO Implement destroing functional
		}
	}
}