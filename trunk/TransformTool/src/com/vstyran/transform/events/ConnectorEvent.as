package com.vstyran.transform.events
{
	import flash.events.Event;
	
	public class ConnectorEvent extends Event
	{ 
		public static const DATA_CHANGE:String = "dataChange";
		
		public static const TRANSFORMATION:String = "transformation";
		
		public function ConnectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}