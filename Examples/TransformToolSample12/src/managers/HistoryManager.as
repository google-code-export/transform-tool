package managers
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.events.TransformEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.view.TransformTool;
	import com.vstyran.transform.view.UITransformTool;
	
	import events.HistoryEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	use namespace tt_internal;
	
	/**
	 * Undo event. 
	 */	
	[Event(name="undo", type="events.HistoryEvent")]
	
	/**
	 * Redo event. 
	 */	
	[Event(name="redo", type="events.HistoryEvent")]
	
	/**
	 * Simple history manager for undo/redo. 
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class HistoryManager extends EventDispatcher
	{
		/**
		 * Constructor. 
		 * 
		 * @param historyDepth Depth of history.
		 */				
		public function HistoryManager(historyDepth:uint = uint.MAX_VALUE)
		{
			super();
			
			_historyDepth = historyDepth;
		}
		
		/**
		 * @private
		 * List of undo items. 
		 */		
		protected var undoList:Vector.<DisplayData> = new Vector.<DisplayData>();
		
		/**
		 * @private
		 * List of redo items. 
		 */	
		protected var redoList:Vector.<DisplayData> = new Vector.<DisplayData>();

		/**
		 * @private 
		 */		
		private var _historyDepth:uint = uint.MAX_VALUE;
		
		/**
		 * Max number of history items.  
		 */		
		public function get historyDepth():uint
		{
			return _historyDepth;
		}
		
		/**
		 * @private 
		 */		
		public function set historyDepth(value:uint):void
		{
			_historyDepth = value;
			
			if(undoList.length > historyDepth)
				undoList.splice(0, undoList.length - historyDepth);
			if(redoList.length > historyDepth)
				redoList.splice(0, redoList.length - historyDepth);
			
			updateBinding();
		}
		
		[Bindable("undoAvailableChanged")]
		/**
		 * Flag that indicates whether undo is available. 
		 */		
		public function get undoAvailable():Boolean
		{
			return undoList.length > 0;	
		}
		
		[Bindable("redoAvailableChanged")]
		/**
		 * Flag that indicates whether redo is available. 
		 */	
		public function get redoAvailable():Boolean
		{
			return redoList.length > 0;	
		}
		
		/**
		 * @private 
		 */		
		private var currentData:DisplayData;
		
		/**
		 * Add item to hisory. 
		 * @param data DisplayData object.
		 */		
		public function add(data:DisplayData):void
		{
			redoList.length = 0;
			if(currentData)
				addUndoOperation(currentData);
			
			currentData = data;
			
			updateBinding();
		}
		
		/**
		 * Perform undo. 
		 */		
		public function undo():void
		{
			if(undoAvailable)
			{
				var data:DisplayData = undoList.pop();
				addRedoOperation(currentData);
				currentData = data;
				dispatchEvent(new HistoryEvent(HistoryEvent.UNDO, currentData));
				updateBinding();
			}
		}
		
		/**
		 * Perform redo. 
		 */	
		public function redo():void
		{
			if(redoAvailable)
			{
				var data:DisplayData = redoList.pop();
				addUndoOperation(currentData);
				currentData = data;
				dispatchEvent(new HistoryEvent(HistoryEvent.REDO, currentData));
				updateBinding();
			}
		}
		
		
		/**
		 * Adds operation into undo list.
		 * 
		 * @private
		 * 
		 * @param data DisplayData
		 */		
		private function addUndoOperation(data:DisplayData):void
		{
			if(undoList.length >= historyDepth)
				undoList.shift();
			undoList.push(data);
		}
		
		/**
		 * Adds operation into redo list.
		 * 
		 * @private
		 * 
		 * @param data DisplayData
		 */	
		private function addRedoOperation(data:DisplayData):void
		{
			if(redoList.length >= historyDepth)
				redoList.shift();
			redoList.push(data);
		}
		
		/**
		 * Clear history. 
		 */		
		public function clear():void
		{
			undoList.length = 0;
			redoList.length = 0;
			
			updateBinding();
		}
		
		/**
		 * @private 
		 */		
		private function updateBinding():void
		{
			dispatchEvent(new Event("undoAvailableChanged"));
			dispatchEvent(new Event("redoAvailableChanged"));
		}
	}
}