package com.chrm.ioc.astra.controller
{
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.events.Event;

	public class CmdController
	{
		public static const log:ILogger = getLogger( CmdController );
		
		private static var _instance:CmdController;
		
		private static var commandMap:Dictionary;
		
		public function CmdController(val:SingletonPreventer)
		{
			if(val == null)
				throw new Error ("CmdController is a singleton class, use $() instead!");
		}
		
		public static function $():CmdController
		{
			if ( _instance == null )
				_instance = new CmdController( new SingletonPreventer() )
			return _instance;
		}
		
		public static function addContextListener(val0:Event, val1:Function):void
		{
			
		}
	}
}
class SingletonPreventer{}
/**
 * 
 *
 */