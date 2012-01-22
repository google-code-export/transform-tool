package com.vstyran.transform.consts
{
	/**
	 * Guideline type constants.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class GuidelineType
	{
		/**
		 * Vertical direction of guideline for both edge and center checking. 
		 */		
		public static const VERTICAL:String = "vertical";
			
		/**
		 * Vertical direction of guideline for only center checking. 
		 */		
		public static const VERTICAL_CENTER:String = "verticalCenter";
			
		/**
		 * Vertical direction of guideline for only edge checking. 
		 */		
		public static const VERTICAL_EDGE:String = "verticalEdge";
		
		/**
		 * Horizontal direction of guideline for both edge and center checking. 
		 */
		public static const HORIZONTAL:String = "horizontal";
			
		/**
		 * Horizontal direction of guideline for only center checking. 
		 */
		public static const HORIZONTAL_CENTER:String = "horizontalCenter";
			
		/**
		 * Horizontal direction of guideline for only edge checking. 
		 */
		public static const HORIZONTAL_EDGE:String = "horizontalEdge";
		
		/**
		 * Guideline for rotation. 
		 */
		public static const ROTATION:String = "rotation";
	}
}