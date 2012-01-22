package com.vstyran.transform.controls
{
	import mx.core.IVisualElement;

	/**
	 * Interface for visual elements that can be used as anchor.
	 * 
	 * @author Volodymyr Styranivskyi
	 */	
	public interface IAnchor extends IVisualElement
	{
		/**
		 * Function is called when anchor is being used by control. 
		 */		
		function activateAnchor():void;
		
		/**
		 * Function is called when anchor is released by control. 
		 */	
		function deactivateAnchor():void;
	}
}