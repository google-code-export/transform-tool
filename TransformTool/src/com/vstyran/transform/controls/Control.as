package com.vstyran.transform.controls
{
	
	import com.vstyran.transform.events.GuidelineEvent;
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.operations.IAncorOperation;
	import com.vstyran.transform.operations.IOperation;
	import com.vstyran.transform.skins.ControlSkin;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.utils.SkinUtil;
	import com.vstyran.transform.utils.TransformUtil;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	use namespace tt_internal;
	
	/**
	 * Normal skin state. 
	 */	
	[SkinState("normal")]
	
	/**
	 * State when control used as anchor. 
	 */
	[SkinState("anchorActive")]
	
	/**
	 * Control activated skin state. 
	 */
	[SkinState("controlActive")]
	
	/**
	 * Control class for initiating transformation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class Control extends SkinnableComponent implements IAnchor
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.transform.controls.Control", ControlSkin);
		
		/**
		 * Constructor. 
		 */		
		public function Control()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		/**
		 * Normal anchor. 
		 */		
		public var anchor:DisplayObject;
		
		/**
		 * Anchor for transformation with shift key pressed. 
		 */		
		public var shiftAnchor:DisplayObject;
		
		/**
		 * Anchor for transformation with alt key pressed. 
		 */
		public var altAnchor:DisplayObject;
		
		/**
		 * Anchor for transformation with control key pressed. 
		 */
		public var ctrlAnchor:DisplayObject;
		
		/**
		 * @private 
		 */		
		private var _anchorActivated:Boolean;
		
		/**
		 * Flag specifies whether anchor is currently used by operation. 
		 */		
		public function get anchorActivated():Boolean
		{
			return _anchorActivated;
		}
		
		/**
		 * @private
		 * Flag specifies whether control is currently used by operation. 
		 */		
		private var controlActivated:Boolean;

		/**
		 * Transform tool 
		 */		
		tt_internal var tool:TransformTool;
		
		/**
		 * Transform operation. 
		 */		
		public var operation:IOperation;
		
		/**
		 * @private
		 * Transformation matrix from global to transform tool coordinate 
		 * space at the moment of activating control.  
		 */		
		private var matrix:Matrix;
		
		/**
		 * @private
		 * Current active anchor for this control 
		 */		
		private var activeAnchor:IAnchor;
		
		//------------------------------------------
		// Life cycle
		//------------------------------------------
		/**
		 * @inheritDoc
		 */		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}

		/**
		 * @inheritDoc
		 */		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		/**
		 * @inheritDoc 
		 */		
		override protected function getCurrentSkinState():String
		{
			if(_anchorActivated)
				return "anchorActive";
			
			if(controlActivated)
				return "controlActive";
			
			return "normal";
		} 
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		/**
		 * @inheritDoc
		 */	
		public function activateAnchor():void
		{
			_anchorActivated = true;
			
			invalidateSkinState();
		}
		
		/**
		 * @inheritDoc
		 */	
		public function deactivateAnchor():void
		{
			_anchorActivated = false;
			
			invalidateSkinState();
		}
		
		/**
		 * @private 
		 * Convert from display object to anchor point
		 */		
		private function getAnchorPoint(anchor:DisplayObject):Point
		{
			if(!anchor)
				return null;
			
			var bounds:Rectangle = anchor.getBounds(tool);
			
			return new Point(bounds.x + bounds.width/2, bounds.y + bounds.height/2);
		}
		
		/**
		 * @private 
		 * Get anchor depending on what buttons is pressed.
		 */	
		private function resolveAnchor(event:MouseEvent):DisplayObject
		{
			if(event.shiftKey && shiftAnchor)
				return shiftAnchor;
			if(event.ctrlKey && ctrlAnchor)
				return ctrlAnchor;
			if(event.altKey && altAnchor)
				return altAnchor;
			
			return anchor;
		}
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		/**
		 * Mouse down handler 
		 */		
		protected function downHandler(event:MouseEvent):void
		{
			if(!tool)
				return;
			
			matrix = TransformUtil.getMatrix(null, tool);
			tool.startTransformation(this);
			
			if(operation is IAncorOperation)
			{
				var resolvedAnchor:DisplayObject = resolveAnchor(event);
				if(resolvedAnchor)
				{
					(operation as IAncorOperation).anchorPoint = getAnchorPoint(resolvedAnchor); 
					if(resolvedAnchor is IAnchor)
					{
						activeAnchor = resolvedAnchor as IAnchor;
						activeAnchor.activateAnchor();
					}
				}
			}
			
			if(operation.activeGuides)
				operation.activeGuides.length = 0;
			
			if(operation)
				operation.startOperation(DataUtil.createData(tool), 
					matrix.transformPoint(new Point(event.stageX, event.stageY)), 
					tool.grid, tool.bounds, tool.guidelines);
			
			controlActivated = true;
			invalidateSkinState();
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * Mouse move handler 
		 */	
		protected function moveHandler(event:MouseEvent):void
		{
			if(operation)
				tool.doTransformation(operation.doOperation( MathUtil.roundPoint(matrix.transformPoint(new Point(event.stageX, event.stageY)))));
		
			if(operation.activeGuides && operation.activeGuides.length > 0)
				tool.dispatchEvent(new GuidelineEvent(GuidelineEvent.GUIDELINES_UPDATE, operation.activeGuides));
					
			event.updateAfterEvent();
		}
		
		/**
		 * Mouse up handler 
		 */	
		protected function upHandler(event:MouseEvent):void
		{
			if(operation)
				tool.endTransformation(operation.endOperation( MathUtil.roundPoint(matrix.transformPoint(new Point(event.stageX, event.stageY)))));
			
			if(operation.activeGuides && operation.activeGuides.length > 0)
				tool.dispatchEvent(new GuidelineEvent(GuidelineEvent.GUIDELINES_UPDATE, operation.activeGuides));
			
			if(activeAnchor)
				activeAnchor.deactivateAnchor();
			
			activeAnchor = null;
			
			controlActivated = false;
			invalidateSkinState();
			
			if(tool.toolCursorManager && !hitTestPoint(event.stageX, event.stageY, true))
				tool.toolCursorManager.removeCursor(this);
			
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * Mouse roll over handler 
		 */	
		protected function overHandler(event:MouseEvent):void
		{
			if(tool.toolCursorManager && !tool.transforming)
				tool.toolCursorManager.setCursor(this, event.stageX, event.stageY);
			
		}
		
		/**
		 * Mouse out handler 
		 */	
		protected function outHandler(event:MouseEvent):void
		{
			if(tool.toolCursorManager && !controlActivated && !tool.transforming)
				tool.toolCursorManager.removeCursor(this);
		}
	}
}