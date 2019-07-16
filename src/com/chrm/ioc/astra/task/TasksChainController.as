package com.chrm.ioc.astra.task
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class TasksChainController implements ITasksChainController
	{
		private var _dispatcher:EventDispatcher;
		
		private var counter:int = -1;
		
		// Task's chain
		private var _keys:Vector.<String> = new Vector.<String>();// symbol of unique keys
		private var _tasks:Vector.<Class> = new Vector.<Class>();// task's classes
		private var _labels:Vector.<String> = new Vector.<String>();// labels
		private var _taskArguments:Vector.<Array> = new Vector.<Array>();// atributes
		
		private var _runnedTask:ITask;
		
		private var _completeArguments:Array;
		private var _errorArguments:Array;
		private var _cancelArguments:Array;
		
		public function TasksChainController(val:EventDispatcher)
		{
			_dispatcher = val;
		}
		/**
		 * 
		 * 				P R I V A T E   M E T H O D S
		 * 
		 */
		private function getKey(val0:Class, val1:int):String
		{
			return "task" + String(val0) + "_" + val1.toString();
		}
		private function createEventArgs(cevent:Class, type:String, params:Array):Array
		{
			var args:Array = [cevent, type];
			if(params)
				args = args.concat(params);
			return args;
		}
		private function instantiateAndRunAt(val:int, payload:Object=null):void
		{
			var key:String = _keys[val];
			var task:Class = _tasks[val];
			var params:Array = _taskArguments[val];
			var label:String = _labels[val];
			
			instantiateAndRun(key, task, payload, params, label);
		}
		private function instantiateAndRun(key:String, task:Class, payload:Object, params:Array=null, label:String=null):void
		{
			var itask:ITask = new task() as ITask;
			_runnedTask = itask;
			injectInto( itask );
			
			itask.payload = payload;
			
			itask.run.apply(itask, params);
		}
		private function injectInto(val:ITask):void
		{
			var tsk:Object = val as Object;
			if(tsk.hasOwnProperty("dispatcher"))
				tsk["dispatcher"] = _dispatcher;
			else
				throw new Error("Instance of Task should be has [dispatcher] properties as global EventDispatcher!");
			if(tsk.hasOwnProperty("tasksController"))
				tsk["tasksController"] = this;
			else
				throw new Error("Instance of Task should be has [tasksController] properties!");
		}
		private function dispatchEvent(args:Array, payload:Object=null):void
		{
			var eventClass:Class = args.shift() as Class;
			var type:String = args.shift() as String;
			var ev:Event = new eventClass(type) as Event;
			if(payload)
				if(ev is IPayloadObject)
					(ev as IPayloadObject).payload = payload;
				else
					throw new Error("Payload object is exists but Event (complete, cancel or error) of Task don't implemented IPayloadObject interface!");
			if(args && args.length > 0)
				if(ev is IArguments)
					(ev as IArguments).arguments = args;
				else
					throw new Error("Args object is exists but Event (complete, cancel or error) of Task don't implemented IArguments interface!");
			_dispatcher.dispatchEvent( ev );
		}
		private function unmapMe():void
		{
//			TODO delete all arrays and null all properties;
		}
		private function destroy():void
		{
			unmapMe();
		}
		/**
		 * 
		 * 				P U B L I C   M E T H O D S
		 * 
		 */
		public function add(val:Class, ... params):ITasksChainController
		{
			var key:String = getKey( val, _keys.length );
			_keys.push( key );
			_tasks.push( val );
			_taskArguments.push( params );
			_labels.push(null);// set as default: no label, can be added later in .label(SOME_LABEL)
			
			return this;
		}
		public function setCompleteEvent(cevent:Class, type:String, ... params):void
		{
			_completeArguments = createEventArgs(cevent, type, params);
		}
		public function setCancelEvent(cevent:Class, type:String, ... params):void
		{
			_cancelArguments = createEventArgs(cevent, type, params);
		}
		public function setErrorEvent(cevent:Class, type:String, ... params):void
		{
			_errorArguments = createEventArgs(cevent, type, params);
		}
		
		/**
		 * Start chain of tasks
		 * 
		 * param val is payload object 
		 */
		public function start(val:Object=null):void
		{
			counter = -1;
			next(val);
		}
		/**
		 * Run next task in chain (deprecated, use [nextOrComplete()] method)
		 * 
		 * param val is payload object 
		 */
		public function next(val:Object=null):void
		{
			counter++;
			if(counter < _keys.length)
			{
				instantiateAndRunAt(counter, val);
				
				(counter == _keys.length) && destroy();
			}
			else
			{
				destroy();
				throw new Error("Task's 'counter': " + counter + ", is out of task's chain 'length': " + _keys.length + " !");
			}
		}
		/**
		 * Run next task or complete and dispatch complete Eevent
		 * 
		 * param val is payload object 
		 */
		public function nextOrComplete(val:Object=null):void
		{
			if(counter == _keys.length - 1)
				complete( val );// last task
			else
				next( val );
		}
		/**
		 * Complete of chain and dispatch complete Eevent
		 * 
		 * param val is payload object 
		 */
		public function complete(val:Object=null):void
		{
			dispatchEvent( _completeArguments, val );
		}
		public function error(val:Object=null):void
		{
			dispatchEvent( _errorArguments , val);
		}
		public function cancel(val:Object=null):void
		{
			dispatchEvent( _cancelArguments, val );
		}
		public function label(value:String):ITasksChainController
		{
			_labels[_labels.length - 1] = value;
			return this;
		}
		
		public function goTo(val:String, val1:Object=null):void
		{
			var ind:int = _labels.indexOf( val );
			counter = --ind;
			next(val1);
		}
	}
}