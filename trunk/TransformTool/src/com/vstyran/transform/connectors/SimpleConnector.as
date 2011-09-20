package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.TargetData;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;

	[Event(name="dataChange", type="com.vstyran.transform.events.ConnectorEvent")]
	
	[Event(name="transformation", type="com.vstyran.transform.events.ConnectorEvent")]
	
	public class SimpleConnector extends EventDispatcher implements IConnector
	{
		include "../Version.as";
		
		public function SimpleConnector()
		{
		}
		
		public function setToolPanel(panel:DisplayObject):void
		{
			
		}
		
		private var _data:TargetData;

		public function get data():TargetData
		{
			return _data;
		}

		public function set data(value:TargetData):void
		{
			_data = value;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}

		
		public function getData():TargetData
		{
			return data;
		}
		
		public function transfrom(data:TargetData):TargetData
		{
			_data = data;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.TRANSFORMATION));
			
			return _data;
		}
		
		
	}
}