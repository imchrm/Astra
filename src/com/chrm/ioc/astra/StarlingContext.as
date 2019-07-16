package com.chrm.ioc.astra
{
	import com.chrm.ioc.astra.controller.CmdVO;
	import com.chrm.ioc.astra.controller.ICmd;
	import com.chrm.ioc.astra.mediator.IStarlingDisplayMediator;
	
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class StarlingContext extends EventDispatcher implements IStarlingDispalyContext
	{
		private static const log:ILogger = getLogger( StarlingContext );
		
//		View Class (key) and associated Mediator Class (value)
		private var _mediatorMap:Dictionary = new Dictionary();
//		View Instance (key) and associated of Mediator Instance (value)
		private var _mediatorInstanceMap:Dictionary = new Dictionary();
//		Map of Event Class and associated Command Class
		private var _commandMap:Dictionary = new Dictionary();
		
		private var _contextView:DisplayObjectContainer;
		
		public function StarlingContext()
		{
			super();
		}
		private function addStageCaptureListeners(val:DisplayObjectContainer):void
		{
			val.stage.addEventListener(Event.ADDED_TO_STAGE, stage_ADDED_TO_STAGE);
			val.stage.addEventListener(Event.REMOVED_FROM_STAGE, stage_REMOVED_FROM_STAGE);
		}
		protected function _contextView_ADDED_TO_STAGE(evt:Event):void
		{
			(evt.currentTarget as EventDispatcher).removeEventListener( evt.type, arguments.callee);
			
			var cView:DisplayObjectContainer = evt.currentTarget as DisplayObjectContainer;
			cView.stage.addEventListener(Event.ADDED_TO_STAGE, stage_ADDED_TO_STAGE);
			cView.stage.addEventListener(Event.REMOVED_FROM_STAGE, stage_REMOVED_FROM_STAGE);
		}
		
		protected function stage_ADDED_TO_STAGE(evt:Event):void
		{
//			(evt.currentTarget as EventDispatcher).removeEventListener( evt.type, arguments.callee);
			
			var doc:DisplayObjectContainer = evt.data as DisplayObjectContainer;
			addMediatorByViewInstance(doc);
		}
		
		protected function stage_REMOVED_FROM_STAGE(evt:Event):void
		{
//			(evt.currentTarget as EventDispatcher).removeEventListener( evt.type, arguments.callee);
			
			var doc:DisplayObjectContainer = evt.data as DisplayObjectContainer;
			disposeAndDeleteMediatorInstance(doc);			
		}
		
		protected function _contextView_REMOVED_FROM_STAGE(event:Event):void
		{
		}
		protected function addMediatorByViewInstance(val:Object):void
		{
			var viewCls:Class = findViewClassByViewInstance(val);
			if(viewCls)
			{
				var m:IStarlingDisplayMediator = instantiateMediator(_mediatorMap[viewCls], val);
				_mediatorInstanceMap[val] = m;
			}
		}
		protected function findViewClassByViewInstance(val:Object):Class
		{
			var resCls:Class;
			for( var keyViewCls:Object in _mediatorMap)
			{
				var vcls:Class = keyViewCls as Class;
				if(val is vcls)
				{
//					log.debug("View Instance: {0}",[val.toString()]);
					resCls = vcls;
//					instanciateMediator(_mediatorMap[viewCls] as Class, val);
					break;
				}
			}
			return resCls;
		}
		/**
		 * 
		 * Create Mediator Object
		 * 
		 * @param val0 is Mediator Class
		 * @param val1 is View Object who asoociated with Mediator Class
		 * 
		 */
		protected function instantiateMediator(val0:Class, val1:Object):IStarlingDisplayMediator
		{
			var m:IStarlingDisplayMediator = new val0() as IStarlingDisplayMediator;
			m.view = val1 as DisplayObject;
			m.dispatcher = this as EventDispatcher;
			m.initialize();
			
			return m;
		}
		/**
		 * 
		 * 
		 */
		protected function disposeAndDeleteMediatorInstance(val0:Object):void
		{
			var m:IStarlingDisplayMediator = _mediatorInstanceMap[val0] as IStarlingDisplayMediator;
			m.dispose();
			m.view = null;
			m.removeAllContextListeners();
			m.dispatcher = null;
			delete _mediatorInstanceMap[val0];
		}
		
		/**
		 * 
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			if(!value || _contextView)// prevention of Flex-mxml-style life cycle multy-calling
				return;
			
			_contextView = value;
			addStageCaptureListeners(_contextView);
			
			initialize();
			
			var viewCls:Class = findViewClassByViewInstance(_contextView);
			if(viewCls)
				addMediatorByViewInstance(_contextView);
			
//			_contextView.addEventListener( Event.ADDED_TO_STAGE, _contextView_ADDED_TO_STAGE);
//			_contextView.addEventListener( Event.REMOVED_FROM_STAGE, _contextView_REMOVED_FROM_STAGE);
		}
		
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
//		abstract method
		protected function initialize():void
		{
			throw new Error("This is abstract method! You must override protected [initialize()] metod for Application Context!");
		}
		
		/**
		 * Map Mediator View
		 * 
		 * @param val0 Class of View
		 * @param val1 Class of Mediator
		 */
		public function mapMediator(val0:Class, val1:Class):void
		{
//			log.debug("View Class: {0}",[val0.toString()]);
			_mediatorMap[val0] = val1;
		}
		
		/**
		 * Map Command by View
		 * 
		 * @param val0 Event type
		 * @param val1 Class of Event
		 * @param val2 Class of Command
		 * @param ...param - additional parameters
		 * 
		 */
		public function mapCommand(val0:String, val1:Class, val2:Class, ...param):void
		{
//			TODO create mapping key with Event Class
			_commandMap[val0] = new CmdVO(val1, val2, param);
		}
		override public function dispatchEvent(val:Event):void
		{
			this.addEventListener(val.type, context_ANY_EVENT);
			super.dispatchEvent(val);
		}
		
		protected function context_ANY_EVENT(event:Event):void
		{
//			log.debug("ANY EVENT:{0}",[event.type]);
			dispatchCommandEvent(event);

		}
		
		private function checkContextViewMediator(_contextView:DisplayObjectContainer):void
		{
			addMediatorByViewInstance( _contextView );
		}
		private function dispatchCommandEvent(val:Event):void
		{
			if(_commandMap.hasOwnProperty(val.type))
			{
//				TODO create get mapping key with Event Class
				var cmdo:CmdVO = _commandMap[val.type] as CmdVO;
				instantiateCommand(val, cmdo);
			}
		}
		
		private function instantiateCommand(val0:Event, val1:CmdVO):void
		{
			var ecls:Class = val1.eventCls as Class;
			if(!(val0 is ecls))
				throw new Error("Instance event is not mapped to a corresponding Class!");
			var ccls:Class = val1.commandCls as Class;
			var params:Array = val1.parameters as Array;
			
			var cmd:ICmd = new ccls(this) as ICmd;
			if(!cmd)
				throw new Error("Each Command class should implement ICmd interface!");
			
//			TODO Make Interfaces IEventable, IDispatcherable
			if((cmd as Object).hasOwnProperty("event"))
				cmd["event"] = val0;
			if((cmd as Object).hasOwnProperty("dispatcher"))
				cmd["dispatcher"] = this;
			else
				throw new Error("Command has no context property!");

			cmd.execute.apply(cmd, params);
				
		}
	}
}