package com.vstyran.transform.controls
{
	
	import com.vstyran.transform.events.GuidelineEvent;
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.operations.IOperation;
	import com.vstyran.transform.skins.ControlSkin;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.utils.SkinUtil;
	import com.vstyran.transform.utils.TransformUtil;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.BitmapImage;
	
	use namespace tt_internal;
	
	/**
	 * Normal skin state. 
	 */	
	[SkinState("normal")]
	
	/**
	 * Hovered skin state. 
	 */	
	[SkinState("hovered")]
	
	/**
	 * State when control used as anchor. 
	 */
	[SkinState("anchorActive")]
	
	/**
	 * Control activated skin state. 
	 */
	[SkinState("controlActive")]
	
	[DefaultProperty("operation")]
	
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
			
			addListeners(this);
		}
		
		/**
		 *  @private
		 */
		private var _hovered:Boolean = false;    
		
		/**
		 *  Indicates whether the mouse pointer is over the control.
		 *  Used to determine the skin state.
		 */ 
		protected function get hovered():Boolean
		{
			return _hovered;
		}
		
		/**
		 *  @private
		 */ 
		protected function set hovered(value:Boolean):void
		{
			if (value == _hovered)
				return;
			
			_hovered = value;
			invalidateSkinState();
		}
		
		/**
		 * Normal anchor. 
		 */		
		public var anchor:DisplayObject;
		
		/**
		 * @private 
		 */		
		private var _anchorActivated:Boolean;
		
		[Bindable("anchorActivatedChanged")]
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
		private var _controlActivated:Boolean;

		[Bindable("controlActivatedChanged")]
		/**
		 * Flag specifies whether control is currently active. 
		 */		
		public function get controlActivated():Boolean
		{
			return _controlActivated;
		}
		
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
		
		/**
		 * @private 
		 */		
		protected var _uiTargets:Array;

		/**
		 * List of UI targets of transformation. 
		 */		
		tt_internal function set uiTargets(value:Array):void
		{
			if(_uiTargets && maintainTargetEvents)
			{
				removeUITargetsListeners();
			}
			
			_uiTargets = value;
			
			if(_uiTargets && maintainTargetEvents)
			{
				addUITargetsListeners();
			}
		}
		
		/**
		 * @private 
		 */		
		protected var _maintainTargetEvents:Boolean = true;

		/**
		 * Flag that indicates whether to add mouse event handlers to ui target.
		 * @default true
		 */
		public function get maintainTargetEvents():Boolean
		{
			return _maintainTargetEvents;
		}

		/**
		 * @private
		 */
		public function set maintainTargetEvents(value:Boolean):void
		{
			if(_maintainTargetEvents == value)
				return;
			
			_maintainTargetEvents = value;
			
			if(_uiTargets)
			{
				if(_maintainTargetEvents)
					addUITargetsListeners()
				else
					removeUITargetsListeners();
			}
		}


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
			
			if(_controlActivated)
				return "controlActive";
			
			if(_hovered)
				return "hovered";
			
			return "normal";
		} 
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		/**
		 * @inheritDoc
		 */	
		protected function addUITargetsListeners():void
		{
			for each (var uiTarget:UIComponent in _uiTargets) 
			{
				addListeners(uiTarget);
			}
		}
		
		/**
		 * @inheritDoc
		 */	
		protected function removeUITargetsListeners():void
		{
			for each (var uiTarget:UIComponent in _uiTargets) 
			{
				removeListeners(uiTarget);
			}
		}
		
		/**
		 * @inheritDoc
		 */	
		protected function addListeners(target:UIComponent, priority:int = 0):void
		{
			target.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, priority);
			target.addEventListener(MouseEvent.ROLL_OVER, overHandler, false, priority);
			target.addEventListener(MouseEvent.MOUSE_OUT, outHandler, false, priority);
		}
		
		/**
		 * @inheritDoc
		 */	
		protected function removeListeners(target:UIComponent):void
		{
			target.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			target.removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			target.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		/**
		 * @inheritDoc
		 */	
		protected function hitUITargetsTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean
		{
			for each (var uiTarget:UIComponent in _uiTargets) 
			{
				if(uiTarget.hitTestPoint(x, y, shapeFlag))
					return true;
			}
			
			return false;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function activateAnchor():void
		{
			_anchorActivated = true;
			dispatchEvent(new Event("anchorActivatedChanged"));
			
			invalidateSkinState();
		}
		
		/**
		 * @inheritDoc
		 */	
		public function deactivateAnchor():void
		{
			_anchorActivated = false;
			dispatchEvent(new Event("anchorActivatedChanged"));
			
			invalidateSkinState();
		}
		
		/**
		 * @private 
		 */		
		private var guidelinesWasActive:Boolean;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		/**
		 * Start transformation.
		 * 
		 * @param event Mouse down event.
		 */		
		public function startTransformation(event:MouseEvent):void
		{
			if(this.hitTestPoint(event.stageX, event.stageY) ||
			  (_uiTargets && hitUITargetsTestPoint(event.stageX, event.stageY, true)))
			{
				if(tool.toolCursorManager && !tool.transforming)
					tool.toolCursorManager.setCursor(this, event.stageX, event.stageY);
			}
			
			downHandler(event);
		}
		/**
		 * Mouse down handler 
		 */		
		protected function downHandler(event:MouseEvent):void
		{
			if(!tool)
				return;
			
			tool.validateNow();
			
			matrix = TransformUtil.getMatrix(null, tool);
			tool.startTransformation(this, operation.type);
			
			if(anchor && anchor is IAnchor)
			{
				activeAnchor = anchor as IAnchor;
				activeAnchor.activateAnchor();
			}
			
			if(operation)
				operation.startOperation(DataUtil.createData(tool), 
					matrix.transformPoint(new Point(event.stageX, event.stageY)), 
					tool.grid, tool.bounds, tool.guidelines, tool.snappingFunction);
			
			_controlActivated = true;
			dispatchEvent(new Event("controlActivatedChanged"));
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
				tool.doTransformation(operation.doOperation( MathUtil.roundPoint(matrix.transformPoint(new Point(event.stageX, event.stageY)))), operation.type);
		
			if(operation.guideCross || guidelinesWasActive)
			{
				tool.dispatchEvent(new GuidelineEvent(GuidelineEvent.GUIDELINES_UPDATE, operation.type, operation.guideCross));
				guidelinesWasActive = (operation.guideCross != null);
			}
				
			event.updateAfterEvent();
		}
		
		/**
		 * Mouse up handler 
		 */	
		protected function upHandler(event:MouseEvent):void
		{
			if(operation)
				tool.endTransformation(operation.endOperation( MathUtil.roundPoint(matrix.transformPoint(new Point(event.stageX, event.stageY)))), operation.type);
			
			if(guidelinesWasActive)
			{
				tool.dispatchEvent(new GuidelineEvent(GuidelineEvent.GUIDELINES_UPDATE, null));
				guidelinesWasActive = false;
			}
			
			if(activeAnchor)
				activeAnchor.deactivateAnchor();
			
			activeAnchor = null;
			
			_controlActivated = false;
			dispatchEvent(new Event("controlActivatedChanged"));
			invalidateSkinState();
			
			if(tool.toolCursorManager && !hitTestPoint(event.stageX, event.stageY, true) &&
				!(_uiTargets && hitUITargetsTestPoint(event.stageX, event.stageY, true)))
				tool.toolCursorManager.removeCursor(this);
			
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * Mouse roll over handler 
		 */	
		protected function overHandler(event:MouseEvent):void
		{
			hovered = true;
			if(tool && tool.toolCursorManager && !tool.transforming)
				tool.toolCursorManager.setCursor(this, event.stageX, event.stageY);
			
		}
		
		/**
		 * Mouse out handler 
		 */	
		protected function outHandler(event:MouseEvent):void
		{
			hovered = false;
			if(tool.toolCursorManager && !_controlActivated && !tool.transforming)
				tool.toolCursorManager.removeCursor(this);
		}
	}
}