package com.vstyran.transform.model
{
	import com.vstyran.transform.consts.GuidelineType;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Value object for cross of guidelines.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class GuidelineCross extends EventDispatcher
	{
		/**
		 * Constructor. 
		 */		
		public function GuidelineCross()
		{
			list = new Vector.<Guideline>();
		}
		
		/**
		 * @private 
		 */		
		private var _vGuideline:Guideline;

		[Bindable("vGuidelineChanged")]
		/**
		 * Vertical active guideline. 
		 */
		public function get vGuideline():Guideline
		{
			return _vGuideline;
		}

		/**
		 * @private
		 */
		protected function setVGuideline(value:Guideline):void
		{
			if(_vGuideline == value) return;
			_vGuideline = value;
			dispatchEvent(new Event("vGuidelineChanged"));
		}

		/**
		 * @private 
		 */	
		private var _hGuideline:Guideline;

		[Bindable("hGuidelineChanged")]
		/**
		 * Horizontal active guideline. 
		 */
		public function get hGuideline():Guideline
		{
			return _hGuideline;
		}

		/**
		 * @private
		 */
		protected function setHGuideline(value:Guideline):void
		{
			if(_hGuideline == value) return;
			_hGuideline = value;
			dispatchEvent(new Event("hGuidelineChanged"));
		}
		
		/**
		 * @private 
		 */	
		private var _rGuideline:Guideline;

		[Bindable("rGuidelineChanged")]
		/**
		 * Rotation active guideline. 
		 */
		public function get rGuideline():Guideline
		{
			return _rGuideline;
		}

		/**
		 * @private
		 */
		protected function setRGuideline(value:Guideline):void
		{
			if(_rGuideline == value) return;
			_rGuideline = value;
			dispatchEvent(new Event("rGuidelineChanged"));
		}
		
		/**
		 * List of guidelines. 
		 */		
		protected var list:Vector.<Guideline>;
		
		/**
		 * Add guideline.
		 *  
		 * @param guideline Guideline object to be added.
		 * @param active Is guideline used for guidening data.
		 */		
		public function addGuideline(guideline:Guideline, active:Boolean=false):void
		{
			if(list.indexOf(guideline) == -1)
				list.push(guideline);
			
			if(active)
			{
				if(guideline.type.search(GuidelineType.VERTICAL) != -1)
					setVGuideline(guideline); 
				if(guideline.type.search(GuidelineType.HORIZONTAL) != -1)
					setHGuideline(guideline); 
				if(guideline.type == GuidelineType.ROTATION)
					setRGuideline(guideline); 
			}
		}
		
		/**
		 * Remove guideline.
		 *  
		 * @param guideline Guideline object to be removed.
		 */		
		public function removeGuideline(guideline:Guideline):void
		{
			var index:int = list.indexOf(guideline);
			if(index != -1)
				list.splice(index, 1);
			
			if(guideline == vGuideline)
				setVGuideline(null);
			else if(guideline == hGuideline)
				setHGuideline(null);
			else if(guideline == rGuideline)
				setRGuideline(null);
		}
		
		/**
		 * Remove all guidelines. 
		 */		
		public function removeAllGuidelines():void
		{
			list.length = 0;
			setHGuideline(null);
			setVGuideline(null);
			setRGuideline(null);
		}
		
		/**
		 * Get all guidelines including active.
		 *  
		 * @return Vector of all guidelines.
		 */		
		public function getGuidelines():Vector.<Guideline>
		{
			return list.slice();
		}
		
		/**
		 * Get all vertical guidelines including active.
		 *  
		 * @return Vector of all vertical guidelines.
		 */		
		public function getVGuidelines():Vector.<Guideline>
		{
			return getGuidelinesInternal(GuidelineType.VERTICAL);
		}
		
		/**
		 * Get all horizontal guidelines including active.
		 *  
		 * @return Vector of all horizontal guidelines.
		 */	
		public function getHGuidelines():Vector.<Guideline>
		{
			return getGuidelinesInternal(GuidelineType.HORIZONTAL);
		}
		
		/**
		 * Get all rotation guidelines including active.
		 *  
		 * @return Vector of all vertical guidelines.
		 */		
		public function getRGuidelines():Vector.<Guideline>
		{
			return getGuidelinesInternal(GuidelineType.ROTATION);
		}
		
		/**
		 * @private 
		 */		
		protected function getGuidelinesInternal(type:String):Vector.<Guideline>
		{
			var result:Vector.<Guideline> = new Vector.<Guideline>();
			
			for each (var guideline:Guideline in list) 
			{
				if(guideline.type.search(type) != -1)
					result.push(guideline);
			}
			return result;
		}
	}
}