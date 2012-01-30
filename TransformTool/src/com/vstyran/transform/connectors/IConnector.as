package com.vstyran.transform.connectors
{
	import com.vstyran.transform.model.DisplayData;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	/**
	 * Interface for connector between transform tool and tranformation target.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public interface IConnector extends IEventDispatcher
	{
		/**
		 * Setter for transform tool's panel. 
		 * 
		 * @param toolPanel Panel that contains transform tool.
		 */		
		function setToolPanel(toolPanel:DisplayObject):void;
		
		/**
		 * Get ui target of transformation. 
		 */		
		function get targets():Array;
		
		/**
		 * Get target data.
		 * 
		 * @param deep Flag that indicates whether connector should recalculate all parent dependencies to get right DisplayData values.
		 * Typically used when position or scale values of parent container changed. 
		 * 
		 * @return Target data in transform tool coordinate space
		 */		
		function getData(deep:Boolean = false):DisplayData;
		
		/**
		 * Transform target.
		 *  
		 * @param data Data in transform tool coordinate space
		 * @return Adjusted data in transform tool coordinate space
		 */		
		function transfrom(data:DisplayData):DisplayData;
		
		/**
		 * Transformation complete.
		 *  
		 * @param data Data in transform tool coordinate space
		 * @return Adjusted data in transform tool coordinate space
		 */		
		function complete(data:DisplayData):DisplayData;
	}
}