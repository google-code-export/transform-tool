package com.vstyran.reuler.view
{
	import com.vstyran.reuler.skins.VRulerBarSkin;
	import com.vstyran.reuler.utils.SkinUtil;

	public class VRulerBar extends RulerBarBase
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.reuler.view.VRulerBar", VRulerBarSkin);
		
		public function VRulerBar()
		{
			super();
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
				
				updateSkinDisplayList(true);
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
				
				updateSkinDisplayList(true);
			}
		}
		
		private var lastHeight:Number;
		
		override protected function updateSkinDisplayList(force:Boolean = false):void
		{
			if(lastHeight != tickGroup.height || force)
			{
				updateTicks(tickGroup.height - paddingTop - paddingBottom, paddingTop);
			}
			
			lastHeight = tickGroup.height;
		}
	}
}