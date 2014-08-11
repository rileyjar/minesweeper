package com.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * A custom event for conveying Map changes.
	 * @author Jared Riley
	 */
	public class MapEvent extends Event
	{
		/**
		 * Type of event whereby the Map instance has changed.
		 */
		public static const CHANGED:String = "mapChanged";
		
		/**
		 * The tile coordinates where the change occurred.
		 */
		public var tileCoordinates:Point;
		
		/**
		 * Constructor.
		 * @param	type				The type of the event, accessible as Event.type.
		 * @param	tileCoordinates	 	The tile coordinates where the change occurred
		 * @param	bubbles	 			Determines whether the Event object participates in the bubbling stage of the event flow. The default value is false.
		 * @param	cancelable			Determines whether the Event object can be canceled. The default values is false.
		 */
		public function MapEvent(type:String, tileCoordinates:Point, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.tileCoordinates = tileCoordinates;
		}

		/**
		 * A clone method allows the event to be redispatched.
		 * @return A copy of this event.
		 */
		public override function clone():Event
		{
			return new MapEvent(type, tileCoordinates, bubbles, cancelable);
		}
	}
}