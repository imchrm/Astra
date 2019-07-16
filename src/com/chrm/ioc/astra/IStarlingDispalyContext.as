package com.chrm.ioc.astra
{
	import starling.display.DisplayObjectContainer;

	public interface IStarlingDispalyContext
	{
		function set contextView(value:DisplayObjectContainer):void
		function get contextView():DisplayObjectContainer
	}
}