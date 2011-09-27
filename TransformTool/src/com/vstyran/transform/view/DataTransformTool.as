package com.vstyran.transform.view
{
	import com.vstyran.transform.connectors.DataConnector;
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.model.DisplayData;
	
	import mx.core.UIComponent;

	/**
	 *  Dispatched when transformation is in progress.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.TRANSFORMATION
	 */
	[Event(name="transformation", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 * Transform tool that contains DataConnector.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DataTransformTool extends TransformTool
	{
		include "../Version.as";
		
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