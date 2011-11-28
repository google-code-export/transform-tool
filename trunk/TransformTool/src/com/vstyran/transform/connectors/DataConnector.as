package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
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
			
			matrix = TransformUtil.getMatrix(panel, toolPanel);
			invertMatrix = TransformUtil.getMatrix(toolPanel, panel);
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
			matrix = TransformUtil.getMatrix(panel, toolPanel);
			invertMatrix = TransformUtil.getMatrix(toolPanel, panel);
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
		public function getData():DisplayData
		{
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
			this.data = TransformUtil.transformData(invertMatrix, data);
			
			return this.data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function complete(data:DisplayData):DisplayData
		{
			this.data = TransformUtil.transformData(invertMatrix, data);
			
			return this.data;
		}
	}
}