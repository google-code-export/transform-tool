package events
{
	import com.vstyran.transform.model.DisplayData;
	
	import flash.events.Event;
	
	/**
	 * Simple history eavent. 
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class HistoryEvent extends Event
	{
		/**
		 * Event type for undo operation. 
		 */		
		public static const UNDO:String = "undo";
		
		/**
		 * Event type for redo operation. 
		 */	
		public static const REDO:String = "redo";
		
		/**
		 * @private 
		 */		
		private var _data:DisplayData;

		/**
		 * Display data object. 
		 */		
		public function get data():DisplayData
		{
			return _data;
		}

		/**
		 * Constructor.
		 *  
		 * @param type Event type.
		 * @param data Display data object.
		 */		
		public function HistoryEvent(type:String, data:DisplayData)
		{
			super(type);
			
			_data = data;
		}
	}
}