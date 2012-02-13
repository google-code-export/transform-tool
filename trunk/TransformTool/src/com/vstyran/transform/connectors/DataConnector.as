package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.MultiDisplayData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;
	
	/**
	 *  Dispatched when the data is changed and transform tool needs to be updated.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.DATA_CHANGE
	 */
	[Event(name="dataChange", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 * Connector class for connecting data from specified panel coordinate 
	 * space with transfrom tool.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DataConnector extends EventDispatcher implements IConnector
	{
		/**
		 * Constructor. 
		 */		
		public function DataConnector()
		{
			super();
		}
		
		/**
		 * @private 
		 */		
		private var _panel:UIComponent;

		/**
		 * Data coordinate space. 
		 */		
		public function get panel():UIComponent
		{
			return _panel;
		}

		/**
		 * @private
		 */		
		public function set panel(value:UIComponent):void
		{
			_panel = value;
			recalcMatrixes();
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}

		/**
		 * Transfrom tool coordinate space.
		 * @private 
		 */		
		private var toolPanel:DisplayObject;
		
		/**
		 * @inheritDoc
		 */		
		public function setToolPanel(toolPanel:DisplayObject):void
		{
			this.toolPanel = toolPanel;
			recalcMatrixes();
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
		private function recalcMatrixes():void
		{
			if(panel && toolPanel)
			{
				matrix = TransformUtil.getMatrix(panel, toolPanel);
				invertMatrix = TransformUtil.getMatrix(toolPanel, panel);
			}
		}
		
		/**
		 * @private 
		 */		
		private var _data:DisplayData;
		
		/**
		 * Transformation target's data
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
			if(!_data || !_data.compare(value))
			{
				_data = value;
				
				dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
			}
		}
		
		/**
		 * @private
		 * Transfromation matrix from data coordinate space into 
		 * transform tool coordinate space.
		 */		
		private var matrix:Matrix;
		
		/**
		 * @private
		 * Transfromation matrix from transform tool coordinate space into 
		 * data coordinate space.
		 */	
		private var invertMatrix:Matrix;
		
		/**
		 * @inheritDoc
		 */		
		public function getData(deep:Boolean = false, userRequested:Boolean = false):DisplayData
		{
			if(deep || !matrix)
				recalcMatrixes();
			
			if(matrix && data)
				return TransformUtil.transformData(matrix, data);
			else
				return null;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function transfrom(data:DisplayData):DisplayData
		{
			data = TransformUtil.transformData(invertMatrix, data);
			
			_data.setTo(data.x, data.y, data.width, data.height, data.rotation);
			
			return _data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function complete(data:DisplayData):DisplayData
		{
			transfrom(data);
			
			if(_data is MultiDisplayData)
				(_data as MultiDisplayData).validateData(_data.rotation);
			
			return _data;
		}
	}
}