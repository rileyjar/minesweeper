package com.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * A custom event for conveying game click input.
	 * @author Jared Riley
	 */
	public class ClickEvent extends Event
	{
		/**
		 * The stage coordinates of where the click occurred.
		 */
		public var stageCoordinates:Point;
		
		/**
		 * Constructor.
		 * @param	type				The type of the event, accessible as Event.type.
		 * @param	stageCoordinates	The stage coordinates of where the click occurred.
		 * @param	bubbles	 			Determines whether the Event object participates in the bubbling stage of the event flow. The default value is false.
		 * @param	cancelable			Determines whether the Event object can be canceled. The default values is false.
		 */
		public function ClickEvent(type:String, stageCoordinates:Point, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.stageCoordinates = stageCoordinates;
		}

		/**
		 * A clone method allows the event to be redispatched.
		 * @return A copy of this event.
		 */
		public override function clone():Event
		{
			return new MapEvent(type, stageCoordinates, bubbles, cancelable);
		}
	}
}