package view
{
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.IFocusManagerComponent;
	
	/**
	 * Normal text state. 
	 */	
	[SkinState("normalText")]
	
	/**
	 * Shift key pressed text state. 
	 */	
	[SkinState("shiftPressedText")]
	
	/**
	 * Ctrl key pressed text state. 
	 */	
	[SkinState("ctrlPressedText")]
	
	/**
	 * Alt key pressed text state. 
	 */	
	[SkinState("altPressedText")]
	
	/**
	 * Normal focused text state. 
	 */	
	[SkinState("normalTextFocused")]
	
	/**
	 * Shift key pressed focused text state. 
	 */	
	[SkinState("shiftPressedTextFocused")]
	
	/**
	 * Ctrl key pressed focused text state. 
	 */	
	[SkinState("ctrlPressedTextFocused")]
	
	/**
	 * Alt key pressed focused text state. 
	 */	
	[SkinState("altPressedTextFocused")]
	
	use namespace tt_internal;
	
	/**
	 * Custom transfrom tool that works with text.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class CustomTransformTool extends TransformTool
	{
		/**
		 * Constructor. 
		 */		
		public function CustomTransformTool()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * @private 
		 */		
		private var _textMode:Boolean;
		
		/**
		 * Text mode. 
		 */		
		public function get textMode():Boolean
		{
			return _textMode;
		}
		
		/**
		 * @private
		 */		
		public function set textMode(value:Boolean):void
		{
			_textMode = value;
			
			targetFocusChangeHandler();
			invalidateSkinState();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override tt_internal function setUITargets(value:Array):void
		{
			var uiTarget:UIComponent;
			
			if(_uiTargets)
			{
				for each (uiTarget in _uiTargets) 
				{
					uiTarget.removeEventListener(FocusEvent.FOCUS_IN, targetFocusChangeHandler);
					uiTarget.removeEventListener(FocusEvent.FOCUS_OUT, targetFocusChangeHandler);
				}
			}
			
			super.setUITargets(value);
			
			if(_uiTargets)
			{
				for each (uiTarget in _uiTargets) 
				{
					uiTarget.addEventListener(FocusEvent.FOCUS_IN, targetFocusChangeHandler);
					uiTarget.addEventListener(FocusEvent.FOCUS_OUT, targetFocusChangeHandler);
				}
			}
			
			targetFocusChangeHandler();
			
		}
		
		/**
		 * @private 
		 */		
		protected function targetFocusChangeHandler(event:FocusEvent = null):void
		{
			targetFocused = isTargetFocused();
			invalidateSkinState();
		}
		
		/**
		 * @private 
		 */	
		private function isTargetFocused():Boolean
		{
			var focusedElement:IFocusManagerComponent = (FlexGlobals.topLevelApplication as UIComponent).focusManager.getFocus();
			
			if(_uiTargets)
			{
				for each (var uiTarget:UIComponent in _uiTargets) 
				{
					if(focusedElement == uiTarget)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * @private 
		 */	
		private var targetFocused:Boolean;
		
		/**
		 * @inheritDoc 
		 */	
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState() + (textMode ? "Text" : "") + (textMode && targetFocused ? "Focused" : "");
		}
		
		/**
		 * @private 
		 */	
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if(_textMode)
				setFocus();
		}
	}
}