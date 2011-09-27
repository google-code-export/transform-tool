package com.vstyran.transform.view
{
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.connectors.SimpleConnector;
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;

	/**
	 *  Dispatched when transformation is in progress.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.TRANSFORMATION
	 */
	[Event(name="transformation", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 *  Dispatched when transformation is complete.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.TRANSFORMATION_COMPLETE
	 */
	[Event(name="transformationComplete", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 * Transform tool that contains SimpleConnector.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class SimpleTransformTool extends TransformTool
	{
		include "../Version.as";
		
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