package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;

	/**
	 * Connector class for connecting UIComponent with transfrom tool.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class UIConnector extends EventDispatcher implements IConnector
	{
		/**
		 * Constructor. 
		 */		
		public function UIConnector()
		{
		}
		
		/**
		 * @private
		 * Data connector. 
		 */		
		private var dataConnector:DataConnector = new DataConnector();
		
		/**
		 * @private 
		 */		
		private var _target:UIComponent;

		/**
		 * Target of transformation. 
		 */		
		public function get target():UIComponent
		{
			return _target;
		}

		/**
		 * @private 
		 */	
		public function set target(value:UIComponent):void
		{
			_target = value;
			
			if(_target.parent)
			{
				dataConnector.panel = _target.parent as UIComponent;
			
				dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
			}
			else
			{
				_target.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			}
		}
		
		/**
		 * @private 
		 * Target added to stage event handler.
		 */		
		protected function addedHandler(event:Event):void
		{
			_target.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			
			dataConnector.panel = _target.parent as UIComponent;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function getData():DisplayData
		{
			if(target)
				dataConnector.data = DataUtil.createData(target);
			
			return dataConnector.getData();
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function setToolPanel(toolPanel:DisplayObject):void
		{
			dataConnector.setToolPanel(toolPanel);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function transfrom(data:DisplayData):DisplayData
		{
			var data:DisplayData = dataConnector.transfrom(data);
			
			DataUtil.applyData(target, dataConnector.data);
			
			return data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function complete(data:DisplayData):DisplayData
		{
			return transfrom(data);
		}
	}
}