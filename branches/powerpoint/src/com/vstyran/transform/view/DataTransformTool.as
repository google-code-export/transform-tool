package com.vstyran.transform.view
{
	import com.vstyran.transform.connectors.DataConnector;
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.model.DisplayData;
	
	import mx.core.UIComponent;

	/**
	 * Transform tool that contains DataConnector.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DataTransformTool extends TransformTool
	{
		/**
		 * Constructor. 
		 */	
		public function DataTransformTool()
		{
			super();
			
			super.connector = new DataConnector();
		}
		
		/**
		 * Do not use this method. If you want to add custom connector 
		 * use TransformTool class instead
		 */		
		override public function set connector(value:IConnector):void
		{
			//do not allow to override connector
		}
		
		/**
		 * @copy com.vstyran.transform.connectors.DataConnector#target
		 */		
		public function get target():UIComponent
		{
			return (connector as DataConnector).target;
		}
		
		/**
		 *  @private
		 */
		public function set target(value:UIComponent):void
		{
			(connector as DataConnector).target = value;
		}
		
		/**
		 * @copy com.vstyran.transform.connectors.DataConnector#targets 
		 */		
		public function get targets():Array
		{
			return (connector as DataConnector).targets;
		}
		
		/**
		 * @private 
		 */	
		public function set targets(value:Array):void
		{
			(connector as DataConnector).targets = value;
		}
		
		/**
		 * @copy com.vstyran.transform.connectors.DataConnector#panel
		 */			
		public function get panel():UIComponent
		{
			return (connector as DataConnector).panel;
		}
		
		/**
		 * @private
		 */		
		public function set panel(value:UIComponent):void
		{
			(connector as DataConnector).panel = value;
		}
		
		/**
		 * @copy com.vstyran.transform.connectors.DataConnector#data
		 */	
		public function get data():DisplayData
		{
			return (connector as DataConnector).data;
		}
		
		/**
		 * @private 
		 */
		public function set data(value:DisplayData):void
		{
			(connector as DataConnector).data = value;
		}
	}
}