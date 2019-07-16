package com.chrm.ioc.astra.controller
{
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class Cmd implements ICmd
	{
		public var dispatcher:EventDispatcher;
		
		public var event:Event;
		
		public var payload:Object;
		
		public var args:Array;
		
		public function Cmd(val0:EventDispatcher)
		{
			dispatcher = val0;
		}
		
		public function execute(...param):void
		{
		}
		
		public function dispatchEvent(evt:Event):void
		{
			dispatcher.dispatchEvent( evt );
		}
	}
}