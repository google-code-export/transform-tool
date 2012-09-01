package com.vstyran.reuler.view
{
	
	import com.vstyran.reuler.consts.MeasureUnit;
	import com.vstyran.reuler.skins.RulerSkin;
	import com.vstyran.reuler.utils.SkinUtil;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	
	import mx.collections.ArrayList;
	
	import spark.components.DataGroup;
	import spark.components.SkinnableContainer;
	
	
	
	public class Ruler extends SkinnableContainer
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.reuler.view.Ruler", RulerSkin);
		
		public function Ruler()
		{
			super();
		}
		
		[SkinPart]
		public var hRulerBar:HRulerBar;
		
		[SkinPart]
		public var vRulerBar:VRulerBar;
		
		[SkinPart]
		public var guideDataGroup:DataGroup;
		
		
		private var _minDistance:Number = 30;
		
		public function get minDistance():Number
		{
			return _minDistance;
		}
		
		public function set minDistance(value:Number):void
		{
			if(_minDistance != value)
			{
				_minDistance = value;
				
				if(vRulerBar)
					vRulerBar.minDistance = _minDistance;
				
				if(hRulerBar)
					hRulerBar.minDistance = _minDistance;
			}
		}
		
		
		private var _distanceList:Array = [1, 2, 5, 10, 25, 50, 100, 250, 500, 1000];
		public function get distanceList():Array
		{
			return _distanceList;
		}
		
		public function set distanceList(value:Array):void
		{
			if(_distanceList != value)
			{
				_distanceList = value;
				
				if(vRulerBar)
					vRulerBar.distanceList = _distanceList;
				
				if(hRulerBar)
					hRulerBar.distanceList = _distanceList;
			}
		}
		
		;
		
		private var _zoom:Number = 1;
		
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set zoom(value:Number):void
		{
			if(_zoom != value)
			{
				_zoom = value;
				
				if(vRulerBar)
					vRulerBar.zoom = _zoom;
				
				if(hRulerBar)
					hRulerBar.zoom = _zoom;
			}
		}
		
		
		private var _pixelsPerValue:Number = MeasureUnit.INCH;
		
		public function get pixelsPerValue():Number
		{
			return _pixelsPerValue;
		}
		
		public function set pixelsPerValue(value:Number):void
		{
			if(_pixelsPerValue != value)
			{
				_pixelsPerValue = value;
				
				if(vRulerBar)
					vRulerBar.pixelsPerValue = _pixelsPerValue;
				
				if(hRulerBar)
					hRulerBar.pixelsPerValue = _pixelsPerValue;
			}
		}
		
		
		private var _paddingLeft:Number = 0;
		
		[Bindable]
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if(_paddingLeft != value)
			{
				_paddingLeft = value;
				
				if(hRulerBar)
					hRulerBar.paddingLeft = _paddingLeft;
			}
		}
		
		private var _paddingRight:Number = 0;
		
		[Bindable]
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if(_paddingRight != value)
			{
				_paddingRight = value;
				
				if(hRulerBar)
					hRulerBar.paddingRight = _paddingRight;
			}
		}
		
		private var _paddingTop:Number = 0;
		
		[Bindable]
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if(_paddingTop != value)
			{
				_paddingTop = value;
				
				if(vRulerBar)
					vRulerBar.paddingTop = _paddingTop;
			}
		}
		
		private var _paddingBottom:Number = 0;
		
		[Bindable]
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if(_paddingBottom != value)
			{
				_paddingBottom = value;
				
				if(vRulerBar)
					vRulerBar.paddingBottom = _paddingBottom;
			}
		}
		
		private var _guideCross:GuidelineCross;
		
		public function get guideCross():GuidelineCross
		{
			return _guideCross;
		}
		
		public function set guideCross(value:GuidelineCross):void
		{
			_guideCross = value;
			
			guidelines.removeAll();
			
			if(guideCross)
			{
				addGuidelines(guideCross.getVGuidelines());
				addGuidelines(guideCross.getHGuidelines());
			}
		}
		
		private function addGuidelines(vector:Vector.<Guideline>):void
		{
			if(vector)
			{
				for each (var guideline:Guideline in vector) 
				{
					guidelines.addItem(guideline);
				}
			}
		}
		
		private var guidelines:ArrayList = new ArrayList();
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if(instance == hRulerBar)
			{
				hRulerBar.distanceList = _distanceList;
				hRulerBar.minDistance = _minDistance;
				hRulerBar.zoom = _zoom;
				hRulerBar.pixelsPerValue = _pixelsPerValue;
				hRulerBar.paddingLeft = _paddingLeft;
				hRulerBar.paddingRight = _paddingRight;
			}
			else if(instance == vRulerBar)
			{
				vRulerBar.distanceList = _distanceList;
				vRulerBar.minDistance = _minDistance;
				vRulerBar.zoom = _zoom;
				vRulerBar.pixelsPerValue = _pixelsPerValue;
				vRulerBar.paddingTop = _paddingTop;
				vRulerBar.paddingBottom = _paddingBottom;
			}
			else if(instance == guideDataGroup)
			{
				guideDataGroup.dataProvider = guidelines;
			}
		}
	}
}