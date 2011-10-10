package com.vstyran.transform.view
{
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.connectors.UIConnector;
	
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
	}
}