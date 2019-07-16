package com.chrm.ioc.astra.mediator
{
	
	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;

	public interface IStarlingDisplayMediator extends IMediator
	{
		function set dispatcher(val:EventDispatcher):void
		function get dispatcher():EventDispatcher
		
		function set view(val:DisplayObject):void
		function get view():DisplayObject
	}
}