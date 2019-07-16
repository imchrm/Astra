package com.chrm.ioc.astra.task
{
	public interface ITasksChainController
	{
		function add(val:Class, ... params):ITasksChainController
		function setCompleteEvent(cevent:Class, type:String, ... params):void
		function setCancelEvent(cevent:Class, type:String, ... params):void
		function setErrorEvent(cevent:Class, type:String, ... params):void
		function start(val:Object=null):void
		function next(val:Object=null):void
		function nextOrComplete(val:Object=null):void
		function goTo(val:String, val1:Object=null):void
		function complete(val:Object=null):void
		function error(val:Object=null):void
		function cancel(val:Object=null):void
		
		function label(val:String):ITasksChainController
	}
}