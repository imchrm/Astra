package com.chrm.ioc.astra.service
{
	public interface IRespondent
	{
		function onComplete(val:Object):void
		function onError(val:Object):void
		function onCancel(val:Object):void
	}
}