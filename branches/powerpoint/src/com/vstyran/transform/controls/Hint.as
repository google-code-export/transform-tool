package com.vstyran.transform.controls
{
	import com.vstyran.transform.consts.TransformationType;
	import com.vstyran.transform.events.TransformEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.skins.HintSkin;
	import com.vstyran.transform.utils.SkinUtil;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Label;
	import spark.components.SkinnablePopUpContainer;
	import spark.formatters.NumberFormatter;
	
	/**
	 * Move transformation hint state. 
	 */	
	[SkinState("move")]
	
	/**
	 * Resize transformation hint state. 
	 */
	[SkinState("resize")]
	
	/**
	 * Rotate transformation hint state. 
	 */
	[SkinState("rotate")]
	
	/**
	 * Class for transformation Hint.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class Hint extends SkinnablePopUpContainer
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.transform.controls.Hint", HintSkin);
		
		[SkinPart(required="false")]
		/**
		 * Label for position by X axis. 
		 */		
		public var xLabel:Label;
		
		[SkinPart(required="false")]
		/**
		 * Label for position by Y axis. 
		 */	
		public var yLabel:Label;
		
		[SkinPart(required="false")]
		/**
		 * Label for width. 
		 */	
		public var widthLabel:Label;
		
		[SkinPart(required="false")]
		/**
		 * Label for height. 
		 */	
		public var heightLabel:Label;
		
		[SkinPart(required="false")]
		/**
		 * Label for rotation. 
		 */	
		public var rotationLabel:Label;
		
		/**
		 * Constructor. 
		 */		
		public function Hint()
		{
			super();
			
			mouseEnabled = false;
		}
		
		/**
		 * @private 
		 */		
		private var _tool:TransformTool;

		/**
		 * Current transform tool. 
		 */		
		public function get tool():TransformTool
		{
			return _tool;
		}

		/**
		 * @private
		 */		
		public function set tool(value:TransformTool):void
		{
			if(_tool == value) return;
			
			if(_tool)
			{
				_tool.removeEventListener(TransformEvent.TRANSFORMATION, transformationHandler);
				_tool.removeEventListener(TransformEvent.TRANSFORMATION_COMPLETE, transformationCompleteHandler);
			}
			_tool = value;
			if(_tool)
			{
				_tool.addEventListener(TransformEvent.TRANSFORMATION, transformationHandler);
				_tool.addEventListener(TransformEvent.TRANSFORMATION_COMPLETE, transformationCompleteHandler);
			}
		}
		
		/**
		 * User label function. Format <code>labelFunction(value:Number, type:String):String</code> 
		 */		
		public var labelFunction:Function;
		
		/**
		 * @private 
		 */		
		private var transformationType:String;
		
		/**
		 * @private 
		 */	
		private var currentData:DisplayData;
		
		//------------------------------------------
		// Life cycle
		//------------------------------------------
		/**
		 * @inheritDoc 
		 */	
		override protected function getCurrentSkinState():String
		{
			if(isOpen && skin.hasState(transformationType))
				return transformationType;
			
			return super.getCurrentSkinState();
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch(instance)
			{
				case xLabel:
				{
					xLabel.text = labelFuncInternal(currentData.x, transformationType);
					break;
				}
				case yLabel:
				{
					yLabel.text = labelFuncInternal(currentData.y, transformationType);
					break;
				}
				case widthLabel:
				{
					widthLabel.text = labelFuncInternal(currentData.width, transformationType);
					break;
				}
				case heightLabel:
				{
					heightLabel.text = labelFuncInternal(currentData.height, transformationType);
					break;
				}
				case rotationLabel:
				{
					rotationLabel.text = labelFuncInternal(currentData.rotation, transformationType);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		//------------------------------------------
		// Private methods
		//------------------------------------------
		/**
		 * @private 
		 */
		private function labelFuncInternal(value:Number, type:String):String
		{
			return labelFunction != null ? labelFunction(value, type) : defaultLabelFunction(value, type);
		}
		
		/**
		 * @private 
		 */
		private var formatter:NumberFormatter = new NumberFormatter();
		
		/**
		 * @private 
		 */
		private function defaultLabelFunction(value:Number, type:String):String
		{
			if(type == TransformationType.ROTATE)
			{
				formatter.fractionalDigits = 0;
				return formatter.format(value) + String.fromCharCode(0x00B0);
			}
			
			formatter.fractionalDigits = 2;
			return formatter.format(value) + " px.";
		}
		
		//------------------------------------------
		// Event handlers
		//------------------------------------------
		/**
		 * @private
		 */		
		protected function transformationHandler(event:TransformEvent):void
		{
			if(!event.isUserAction)
				return;
			
			currentData = event.data;
			transformationType = event.transformationType;
			open(FlexGlobals.topLevelApplication as DisplayObjectContainer);
			
			if(xLabel)
				xLabel.text = labelFuncInternal(event.data.x, event.transformationType);
			
			if(yLabel)
				yLabel.text = labelFuncInternal(event.data.y, event.transformationType);
			
			if(widthLabel)
				widthLabel.text = labelFuncInternal(event.data.width, event.transformationType);
			
			if(heightLabel)
				heightLabel.text = labelFuncInternal(event.data.height, event.transformationType);
			
			if(rotationLabel)
				rotationLabel.text = labelFuncInternal(event.data.rotation, event.transformationType);
		}
		
		/**
		 * @private
		 */	
		protected function transformationCompleteHandler(event:TransformEvent):void
		{
			if(!event.isUserAction)
				return;
			
			currentData = event.data;
			close();
		}
	}
}