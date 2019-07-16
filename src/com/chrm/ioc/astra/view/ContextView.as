package com.chrm.ioc.astra.view
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.display.Sprite;
	import starling.errors.AbstractMethodError;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class ContextView extends Sprite implements IStageEventCapturer
	{
		private static const log:ILogger = getLogger( ContextView );
		
		public function ContextView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, im_CHANGE_ON_STAGE);
			this.addEventListener(Event.REMOVED_FROM_STAGE, im_CHANGE_ON_STAGE);
			
			initialize();
		}
		
		protected function im_CHANGE_ON_STAGE(evt:Event):void
		{
			log.debug( "{0} on Stage!", [this]);
			(evt.currentTarget as EventDispatcher).removeEventListener( evt.type, arguments.callee);
			captureStageEvent(evt.type);
		}
		
		/**
		 * Catchup event for Starling DisplayList
		 * 
		 * @param val - Type of Event [Event.ADDED_TO_STAGE or Event.REMOVED_FROM_STAGE]
		 */
		public function captureStageEvent(val:String):void
		{
			var event:Event;
			if(val == Event.ADDED_TO_STAGE)
			{
				event = new Event(Event.ADDED_TO_STAGE, false, this);
//				Call 'draw()' method of View Component befor 'dispatchEvent(evt)'
//				for guaranteed call after 'initialise()' method of Mediator Instance.
				draw();
				stage.dispatchEvent( event );
			}
			else if(val == Event.REMOVED_FROM_STAGE)
			{
				event = new Event(Event.REMOVED_FROM_STAGE, false, this);
//				Call 'dispose()' method of View Component after 'dispatchEvent(evt)' 
//				for guaranteed call  before 'dispose()' method of Mediator Instance.
				stage.dispatchEvent( event );
				dispose();
			}
		}
		/**
		 * Life cycle abstract methods
		 */
		
		/**
		 * Initialize properties here.
		 * Life cycle method of Visual Component.
		 */
		protected function initialize():void
		{
			new AbstractMethodError();
		}
		/**
		 * Create all childs 
		 * and commit, measure, layout codes here
		 * Life cycle method of Visual Component.
		 */
		protected function draw():void
		{
			new AbstractMethodError();
		}
		/**
		 * Dispose all properties, remove all liseners.
		 * Life cycle method of Visual Component.
		 */
		override public function dispose():void
		{
			new AbstractMethodError();
		}
//		TODO Add invalidate/validate functional
	}
}