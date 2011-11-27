package com.vstyran.transform.view
{
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.connectors.UIConnector;
	import com.vstyran.transform.events.ConnectorEvent;
	
	import mx.core.UIComponent;

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
	 * Transform tool that contains UIConnector.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class UITransformTool extends TransformTool
	{
		/**
		 * Constructor. 
		 */	
		public function UITransformTool()
		{
			super();
			super.connector = new UIConnector();
			
			connector.addEventListener(ConnectorEvent.TRANSFORMATION, connectorEventHandler);
			connector.addEventListener(ConnectorEvent.TRANSFORMATION_COMPLETE, connectorEventHandler);
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
		 * @copy com.vstyran.transform.connectors.UIConnector#target 
		 */		
		public function get target():UIComponent
		{
			return (connector as UIConnector).target;
		}
		
		/**
		 * @private 
		 */	
		public function set target(value:UIComponent):void
		{
			(connector as UIConnector).target = value;
		}
		
		/**
		 * Connector events handler. 
		 */	
		private function connectorEventHandler(event:ConnectorEvent):void
		{
			dispatchEvent(event);
		}
	}
}