package com.chrm.ioc.astra.controller
{
	import starling.events.Event;

	public interface IEventable
	{
		function set event(val:Event):void
		function get event():Event
	}
}