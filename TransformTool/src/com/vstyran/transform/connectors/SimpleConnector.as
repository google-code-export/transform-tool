package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;

	/**
	 *  Dispatched when the data is changed and transform tool needs to be updated.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.DATA_CHANGE
	 */
	[Event(name="dataChange", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 *  Dispatched when transformation is in progress.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.TRANSFORMATION
	 */
	[Event(name="transformation", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 *  Dispatched when transformation is complete.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.TRANSFORMATION_COMPLETE
	 */
	[Event(name="transformationComplete", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 * Simple connector class for connecting data with transfrom tool in case they are 
	 * in the same coordinate space.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class SimpleConnector extends EventDispatcher implements IConnector
	{
		include "../Version.as";
		
		/**
		 * Constructor. 
		 */		
		public function SimpleConnector()
		{
		}
		
		/**
		 * @inheritDoc
		 */		
		public function setToolPanel(panel:DisplayObject):void
		{
			// because we are in the same coordinate space we don't need this 
		}
		
		/**
		 * @private 
		 */		
		private var _data:DisplayData;

		/**
		 * @inheritDoc 
		 */	
		public function get data():DisplayData
		{
			return _data;
		}

		/**
		 * @private 
		 */	
		public function set data(value:DisplayData):void
		{
			_data = value;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}

		/**
		 * @inheritDoc 
		 */	
		public function getData():DisplayData
		{
			return data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function transfrom(data:DisplayData):DisplayData
		{
			_data = data;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.TRANSFORMATION));
			
			return _data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function complete(data:DisplayData):DisplayData
		{
			_data = data;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.TRANSFORMATION_COMPLETE, _data));
			
			return data;
		}
	}
}