package com.vstyran.transform.model
{
	[Bindable]
	/**
	 * Value object for cross of guidelines.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class GuidelineCross
	{
		/**
		 * Constructor. 
		 */		
		public function GuidelineCross()
		{
		}
		
		/**
		 * Vertical guideline. 
		 */		
		public var vGuideline:Guideline;
		
		/**
		 * Horizontal guideline. 
		 */		
		public var hGuideline:Guideline;
	}
}