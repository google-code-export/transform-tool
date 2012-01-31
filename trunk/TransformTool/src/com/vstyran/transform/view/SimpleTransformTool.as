package com.vstyran.transform.view
{
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.connectors.SimpleConnector;
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	
	import mx.core.UIComponent;

	/**
	 * Transform tool that contains SimpleConnector.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class SimpleTransformTool extends TransformTool
	{
		/**
		 * Constructor. 
		 */		
		public function SimpleTransformTool()
		{
			super();
			
			super.connector = new SimpleConnector();
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
		 * @copy com.vstyran.transform.connectors.SimpleConnector#target
		 */		
		public function get target():UIComponent
		{
			return (connector as SimpleConnector).target;
		}
		
		/**
		 *  @private
		 */
		public function set target(value:UIComponent):void
		{
			(connector as SimpleConnector).target = value;
		}
		
		/**
		 * @copy com.vstyran.transform.connectors.SimpleConnector#targets 
		 */		
		public function get targets():Array
		{
			return (connector as SimpleConnector).targets;
		}
		
		/**
		 * @private 
		 */	
		public function set targets(value:Array):void
		{
			(connector as SimpleConnector).targets = value;
		}
		/**
		 * @copy com.vstyran.transform.connectors.SimpleConnector#data
		 */		
		public function get data():DisplayData
		{
			return (connector as SimpleConnector).data;
		}
		
		/**
		 * @private
		 */	
		public function set data(value:DisplayData):void
		{
			(connector as SimpleConnector).data = value;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}
	}
}