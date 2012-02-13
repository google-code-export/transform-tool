package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.MultiDisplayData;
	
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
	 * Simple connector class for connecting data with transfrom tool in case they are 
	 * in the same coordinate space.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class SimpleConnector extends EventDispatcher implements IConnector
	{
		/**
		 * Constructor. 
		 */		
		public function SimpleConnector()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		public function setToolPanel(panel:DisplayObject):void
		{
			// because we are in the same coordinate space we don't need this 
		}
		
		/**
		 * Transformation target.
		 */		
		public function get target():UIComponent
		{
			if (_targets && _targets.length > 0)
				return _targets[0]; 
			else
				return null;
		}
		
		/**
		 *  @private
		 */
		public function set target(value:UIComponent):void
		{
			targets = value ? [value] : null;
		}
		
		/**
		 * @private 
		 */		
		private var _targets:Array;
		
		
		/**
		 * UI target of transformation. Used as event dispather for moving control. 
		 */		
		public function get targets():Array
		{
			return _targets ? _targets.slice() : null;
		}
		
		/**
		 * @private 
		 */		
		public function set targets(value:Array):void
		{
			_targets = value;
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
		public function getData(deep:Boolean = false, userRequested:Boolean = false):DisplayData
		{
			return data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function transfrom(data:DisplayData):DisplayData
		{
			_data.setTo(data.x, data.y, data.width, data.height, data.rotation);
			
			return _data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function complete(data:DisplayData):DisplayData
		{
			transfrom(data);
			
			if(data is MultiDisplayData)
				(data as MultiDisplayData).validateData(data.rotation);
			
			return _data;
		}
	}
}