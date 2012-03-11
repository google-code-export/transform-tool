package com.vstyran.reuler.view
{
	
	import com.vstyran.reuler.consts.MeasureUnit;
	import com.vstyran.reuler.skins.RulerSkin;
	import com.vstyran.reuler.utils.SkinUtil;
	
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
		
		
		private var _pixelPerValue:Number = MeasureUnit.INCH;
		
		public function get pixelPerValue():Number
		{
			return _pixelPerValue;
		}
		
		public function set pixelPerValue(value:Number):void
		{
			if(_pixelPerValue != value)
			{
				_pixelPerValue = value;
				
				if(vRulerBar)
					vRulerBar.pixelPerValue = _pixelPerValue;
				
				if(hRulerBar)
					hRulerBar.pixelPerValue = _pixelPerValue;
			}
		}
		
		
		private var _paddingLeft:Number = 0;
		
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
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if(instance == hRulerBar)
			{
				hRulerBar.distanceList = _distanceList;
				hRulerBar.minDistance = _minDistance;
				hRulerBar.zoom = _zoom;
				hRulerBar.pixelPerValue = _pixelPerValue;
				hRulerBar.paddingLeft = _paddingLeft;
				hRulerBar.paddingRight = _paddingRight;
			}
			else if(instance == vRulerBar)
			{
				vRulerBar.distanceList = _distanceList;
				vRulerBar.minDistance = _minDistance;
				vRulerBar.zoom = _zoom;
				vRulerBar.pixelPerValue = _pixelPerValue;
				vRulerBar.paddingTop = _paddingTop;
				vRulerBar.paddingBottom = _paddingBottom;
			}
		}
	}
}