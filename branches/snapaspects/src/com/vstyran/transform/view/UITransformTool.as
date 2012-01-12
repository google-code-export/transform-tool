package com.vstyran.transform.view
{
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.connectors.UIConnector;
	import com.vstyran.transform.events.ConnectorEvent;
	
	import mx.core.UIComponent;

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
		 * Flag that indicates whether target should be updated during transformation.
		 * If false then target will be updated only on mouse up. 
		 */		
		public function get liveTransformation():Boolean
		{
			return (connector as UIConnector).liveTransformation;
		}

		/**
		 * @private 
		 */	
		public function set liveTransformation(value:Boolean):void
		{
			(connector as UIConnector).liveTransformation = value;
			showPreview = !value;
		}
	}
}