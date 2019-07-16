package com.chrm.ioc.astra.mediator
{
	public interface IMediator
	{
		function initialize():void
		function dispose():void
		
		function addContextListener(val0:String, val1:Function):void
		function removeContextListener(val0:String, val1:Function):void
		function removeAllContextListeners():void

	}
}