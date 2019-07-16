package com.chrm.ioc.astra.mediator
{
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class Mediator implements IStarlingDisplayMediator
	{
		private var _view:DisplayObject;
		private var _dispatcher:EventDispatcher;
		
		private var _mapContextListeners:Dictionary = new Dictionary();
		
		public function Mediator()
		{
		}
		
		public function initialize():void
		{
			;
		}
		public function dispose():void
		{
			;
		}

		public function get view():DisplayObject
		{
			return _view;
		}
		public function set view(value:DisplayObject):void
		{
			_view = value;
		}
		
		
		public function get dispatcher():EventDispatcher
		{
			return _dispatcher;
		}
		public function set dispatcher(value:EventDispatcher):void
		{
			_dispatcher = value;
		}
		
		public function addContextListener(val0:String, val1:Function):void
		{
			_mapContextListeners[val0] = val1;
			_dispatcher.addEventListener(val0, val1);
		}
		public function removeAllContextListeners():void
		{
			for( var keyEventType:Object in _mapContextListeners)
			{
				removeContextListener(keyEventType as String, _mapContextListeners[keyEventType] as Function);
			}
		}
		public function removeContextListener(val0:String, val1:Function):void
		{
			delete _mapContextListeners[val0];
			_dispatcher.removeEventListener(val0, val1);
		}
		public function dispatchEvent(val:Event):void
		{
			dispatcher.dispatchEvent( val );
		}
	}
}