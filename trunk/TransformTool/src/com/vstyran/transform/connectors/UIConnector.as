package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;

	public class UIConnector extends EventDispatcher implements IConnector
	{
		include "../Version.as";
		
		public function UIConnector()
		{
		}
		
		private var dataConnector:DataConnector = new DataConnector();
		
		private var _uiTarget:UIComponent;

		public function get uiTarget():UIComponent
		{
			return _uiTarget;
		}

		public function set uiTarget(value:UIComponent):void
		{
			_uiTarget = value;
			
			if(_uiTarget.parent)
			{
				dataConnector.panel = _uiTarget.parent as UIComponent;
			
				dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
			}
			else
			{
				_uiTarget.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			}
		}
		
		protected function addedHandler(event:Event):void
		{
			_uiTarget.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			
			dataConnector.panel = _uiTarget.parent as UIComponent;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}
		
		public function getData():TargetData
		{
			if(uiTarget)
				dataConnector.data = TransformUtil.createData(uiTarget);
			
			return dataConnector.getData();
		}
		
		public function setToolPanel(toolPanel:DisplayObject):void
		{
			dataConnector.setToolPanel(toolPanel);
		}
		
		public function transfrom(data:TargetData):TargetData
		{
			var data:TargetData = dataConnector.transfrom(data);
			
			TransformUtil.applyData(uiTarget, dataConnector.data);
			
			return data;
		}
		
		
	}
}