package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	
	[Event(name="dataChange", type="com.vstyran.transform.events.ConnectorEvent")]
	
	[Event(name="transformation", type="com.vstyran.transform.events.ConnectorEvent")]
	
	public class DataConnector extends EventDispatcher implements IConnector
	{
		include "../Version.as";
		
		public function DataConnector()
		{
		}
		
		private var _panel:UIComponent;

		public function get panel():UIComponent
		{
			return _panel;
		}

		public function set panel(value:UIComponent):void
		{
			_panel = value;
			
			matrix = TransformUtil.getTransformationMatrix(panel, toolPanel);
			invertMatrix = TransformUtil.getTransformationMatrix(toolPanel, panel);
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}

		private var toolPanel:DisplayObject;
		
		public function setToolPanel(toolPanel:DisplayObject):void
		{
			this.toolPanel = toolPanel;
			matrix = TransformUtil.getTransformationMatrix(panel, toolPanel);
			invertMatrix = TransformUtil.getTransformationMatrix(toolPanel, panel);
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
		
		private var matrix:Matrix;
		private var invertMatrix:Matrix;
		
		public function getData():TargetData
		{
			if(matrix && data)
				return TransformUtil.transformData(matrix, data);
			else
				return null;
		}
		
		public function transfrom(data:TargetData):TargetData
		{
			_data = TransformUtil.transformData(invertMatrix, data);
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.TRANSFORMATION));
			
			return data;
		}
	}
}