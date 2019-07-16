package com.chrm.ioc.astra.controller
{
	public class CmdVO
	{
		public var eventCls:Class;
		public var commandCls:Class;
		public var parameters:Array;
		/**
		 * CmdVO is data value object for command mapping
		 * 
		 * @param val0 Class of Event
		 * @param val1 Class of Command
		 * @param ...param
		 */
		public function CmdVO(val0:Class, val1:Class, val2:Array=null)
		{
			eventCls = val0; 
			commandCls = val1;
			parameters = val2;
		}
	}
}