package com.vstyran.reuler.view
{
	import com.vstyran.reuler.skins.HRulerBarSkin;
	import com.vstyran.reuler.utils.SkinUtil;

	public class HRulerBar extends RulerBarBase
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.reuler.view.HRulerBar", HRulerBarSkin);
		
		public function HRulerBar()
		{
			super();
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
				
				updateSkinDisplayList(true);
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
				
				updateSkinDisplayList(true);
			}
		}

		private var lastWidth:Number;
		
		override protected function updateSkinDisplayList(force:Boolean = false):void
		{
			if(lastWidth != tickGroup.width || force)
			{
				updateTicks(tickGroup.width - paddingLeft - paddingRight, paddingLeft);
			}
			
			lastWidth = tickGroup.width;
		}
	}
}