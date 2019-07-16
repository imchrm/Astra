package com.chrm.ioc.astra.view
{
	public interface IStageEventCapturer
	{
		/**
		 * Catchup event for Starling
		 * 
		 * @param val - Type of Event [Event.ADDED_TO_STAGE or Event.REMOVED_FROM_STAGE]
		 */
		function captureStageEvent(val:String):void;
	}
}