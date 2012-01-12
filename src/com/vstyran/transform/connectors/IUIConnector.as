package com.vstyran.transform.connectors
{
	import mx.core.UIComponent;

	/**
	 * Interface for ui connector between transform tool and tranformation target.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public interface IUIConnector extends IConnector
	{
		/**
		 * Get ui target of transformation. 
		 */		
		function get target():UIComponent;
	}
}