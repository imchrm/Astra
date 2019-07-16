package com.chrm.ioc.astra.task
{
	public interface ITask
	{
		function run(... params):void
		function next(val:Object=null):void
		function goTo(val:String, val1:Object=null):void
		function runServiceAndNext(val0:Class, ...param):void
		function error(val:Object=null):void
		function cancel(val:Object=null):void
		function set payload(val:Object):void
		function get payload():Object
		function destroy():void
	}
}