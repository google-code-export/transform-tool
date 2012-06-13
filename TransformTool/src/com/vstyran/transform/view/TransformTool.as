package com.vstyran.transform.view
{
	
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.consts.TransformationType;
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.events.TransformEvent;
	import com.vstyran.transform.managers.ICursorManager;
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.skins.TransformToolSkin;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.SkinUtil;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.BitmapImage;
	
	use namespace tt_internal;
	
	/**
	 *  Dispatched when the guidelines is activated.
	 *
	 *  @eventType com.vstyran.transform.events.GuidelineEvent.GUIDELINES_UPDATE
	 */
	[Event(name="guidelinesUpdate", type="com.vstyran.transform.events.GuidelineEvent")]
	
	/**
	 *  Dispatched when transformation is in progress.
	 *
	 *  @eventType com.vstyran.transform.events.TransformEvent.TRANSFORMATION_START
	 */
	[Event(name="transformationStart", type="com.vstyran.transform.events.TransformEvent")]
	
	/**
	 *  Dispatched when transformation is in progress.
	 *
	 *  @eventType com.vstyran.transform.events.TransformEvent.TRANSFORMATION
	 */
	[Event(name="transformation", type="com.vstyran.transform.events.TransformEvent")]
	
	/**
	 *  Dispatched when transformation is complete.
	 *
	 *  @eventType com.vstyran.transform.events.TransformEvent.TRANSFORMATION_COMPLETE
	 */
	[Event(name="transformationComplete", type="com.vstyran.transform.events.TransformEvent")]
	
	/**
	 * Normal state. 
	 */	
	[SkinState("normal")]
	
	/**
	 * Shift key pressed state. 
	 */	
	[SkinState("shiftPressed")]
	
	/**
	 * Ctrl key pressed state. 
	 */	
	[SkinState("ctrlPressed")]
	
	/**
	 * Alt key pressed state. 
	 */	
	[SkinState("altPressed")]
	
	[DefaultProperty("connector")]
	
	/**
	 * Transfrom tool that can edit geometry properties of target object.
	 * 
	 * @see http://code.google.com/p/transform-tool/
	 * @see http://vstyran-flex.blogspot.com/search/label/Transformation
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class TransformTool extends SkinnableComponent
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.transform.view.TransformTool", TransformToolSkin);
		
		[SkinPart]
		/**
		 * Manager for managing cursors under controls. 
		 */		
		public var toolCursorManager:ICursorManager;
		
		[SkinPart]
		/**
		 * Move control. 
		 */		
		public var moveControl:Control;
		
		[SkinPart]
		/**
		 * Preview image element. 
		 */		
		public var preview:BitmapImage;
		
		[SkinPart]
		/**
		 * Preview cover element. 
		 */		
		public var previewCover:IVisualElement;
		
		[SkinPart]
		/**
		 * Element that will be placed around transform tool with visual rotation 0. 
		 */		
		public var boundingGroup:Group;
		
		/**
		 * Constructor. 
		 */		
		public function TransformTool()
		{
			super();
			
			includeInLayout = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler, true);
			addEventListener(MouseEvent.MOUSE_UP, upHandler, true);
		}
		
		/**
		 * @private 
		 */		
		private var _connector:IConnector;
		
		/**
		 * Connector object for managing transform targets. 
		 */		
		public function get connector():IConnector
		{
			return _connector;
		}
		
		/**
		 * @private 
		 */		
		public function set connector(value:IConnector):void
		{
			if(_connector != value)
			{
				if(_connector)
					_connector.removeEventListener(ConnectorEvent.DATA_CHANGE, dataChangeHendler);
				
				_connector = value;
				
				if(_connector)
				{
					_connector.setToolPanel(parent);
					_connector.addEventListener(ConnectorEvent.DATA_CHANGE, dataChangeHendler);
					
					if(connector.targets && connector.targets.length > 0)
						setUITargets(connector.targets)
				}
				
				updateToolInternal();
			}
		}
		
		/**
		 * @private 
		 */		
		protected var _uiTargets:Array;
		
		[Bindable("uiTargetsChanged")]
		/**
		 * Count of UI targets of transformation. 
		 */		
		public function get uiTargetsLength():Number
		{
			return _uiTargets ? _uiTargets.length: 0;
		}
		
		/**
		 * @private 
		 */		
		tt_internal function setUITargets(value:Array):void
		{
			var uiTarget:UIComponent;
			
			if(_uiTargets)
			{
				for each (uiTarget in _uiTargets) 
				{
					uiTarget.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
					uiTarget.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				}
			}
			
			_uiTargets = value;
			
			if(_uiTargets)
			{
				for each (uiTarget in _uiTargets) 
				{
					uiTarget.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
					uiTarget.addEventListener(MouseEvent.MOUSE_UP, upHandler);
				}
			}
			
			if(moveControl)
				moveControl.uiTargets = _uiTargets;
			
			dispatchEvent(new Event("uiTargetsChanged"));
		}
		
		
		/**
		 * Grid that will be used as step size for operations. 
		 */		
		public var grid:GridData;
		
		/**
		 * Bounds that will be used position boundaries. 
		 */		
		public var bounds:Bounds;
		
		/**
		 * Guide lines. 
		 */		
		public var guidelines:Vector.<Guideline>;
		
		/**
		 * Flag that indicates whether preview should be shown during transformation.
		 */		
		public var showPreview:Boolean;
		
		/**
		 * Flag that indicates whether preview cover should be shown instead of preview.
		 * Will work only when <code>showPreview</code> is true.
		 */		
		public var showPreviewCover:Boolean;
		
		/**
		 * Shift key pressed. 
		 */		
		private var shiftPressed:Boolean;
		
		/**
		 * Ctrl key pressed. 
		 */
		private var ctrlPressed:Boolean;
		
		/**
		 * Alt key pressed. 
		 */
		private var altPressed:Boolean;
		
		/**
		 * @private 
		 */		
		private var _maintainMoveShortcuts:Boolean;
		
		/**
		 * Flag that indicates whether moving shortcuts (arrow keys) should be active. 
		 * 
		 */
		public function get maintainMoveShortcuts():Boolean
		{
			return _maintainMoveShortcuts;
		}
		
		/**
		 * @private
		 */
		public function set maintainMoveShortcuts(value:Boolean):void
		{
			if(_maintainMoveShortcuts && !value)
				removeEventListener(KeyboardEvent.KEY_DOWN, moveShortcutHandler);
			else if(!_maintainMoveShortcuts && value)
			{
				addEventListener(KeyboardEvent.KEY_DOWN, moveShortcutHandler);
				setFocus();
			}
			
			_maintainMoveShortcuts = value;
		}
		
		/**
		 * @private
		 */
		private var _actionContent:Array;

		/**
		 * Action content will be placed in bounding group if it is defined in skin. 
		 */		
		public function get actionContent():Array
		{
			return _actionContent;
		}

		/**
		 * @private
		 */
		public function set actionContent(value:Array):void
		{
			_actionContent = value;
			
			if(boundingGroup)
			{
				boundingGroup.mxmlContent = _actionContent;
				validateBoundingGroup = true;
				invalidateProperties();
			}
		}

		
		/**
		 *  A user-supplied function to run on each transformation.  
		 *
		 *  <p>You can supply a <code>snappingFunction</code> that 
		 *  snaps data in custom way.</p>
		 *
		 *  <p>The snapping function takes two arguments, current operation, current display data and anchor point.
		 *  And returns snapped diplay data or null if no snapping performed.</p>
		 *  <pre>
		 *  snappingFunction(operation:IOperation, data:DisplayData, anchor:Point):DisplayData</pre>
		 *
		 *  @default null
		 */		
		public var snappingFunction:Function;
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if(visible && toolCursorManager)
				toolCursorManager.removeAllCursors();
		}
		
		//------------------------------------------------
		// Life cycle methods
		//------------------------------------------------
		/**
		 * @inheritDoc 
		 */
		override protected function getCurrentSkinState():String
		{
			if(shiftPressed)
				return "shiftPressed";
			
			if(ctrlPressed)
				return "ctrlPressed";
			
			if(altPressed)
				return "altPressed";
			
			return "normal";
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function attachSkin():void
		{
			super.attachSkin();
			
			if(skin)
				skin.addEventListener(Event.ADDED_TO_STAGE, skinAddedHandler, true);
			
			validateControls = true;
			invalidateProperties();
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch(instance)
			{
				case toolCursorManager:
				{
					if(addedToStage)
						toolCursorManager.tool = this;
					break;
				}
				case moveControl:
				{
					moveControl.uiTargets = _uiTargets;
					break;
				}
				case preview:
				{
					preview.visible = false;
					break;
				}
				case previewCover:
				{
					previewCover.visible = false;
					break;
				}
				case boundingGroup:
				{
					boundingGroup.mxmlContent = _actionContent;
					validateBoundingGroup = true;
					invalidateProperties();
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if(instance == toolCursorManager)
			{
				toolCursorManager.tool = null;
			}
			else if(instance == moveControl)
			{
				moveControl.uiTargets = null;
			}
		}
		
		/**
		 * @private 
		 */
		override protected function invalidateParentSizeAndDisplayList():void
		{
			validateBoundingGroup = true;
			super.invalidateParentSizeAndDisplayList();
		}
		
		/**
		 * @private 
		 */		
		private var validateBoundingGroup:Boolean;
		
		/**
		 * @private 
		 */		
		private var validateControls:Boolean;
		
		/**
		 * @inheritDoc 
		 */		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if(validateControls)
			{
				processParts(skin);
				validateControls = false;
			}
			
			if(validateBoundingGroup)
			{
				if(boundingGroup && boundingGroup.parent && (_actionContent || boundingGroup.numElements > 0))
				{
					var m:Matrix = TransformUtil.getMatrix(this.parent, boundingGroup.parent);
					
					var data:DisplayData = connector.getData();
					if(data)
					{
						var boundingData:DisplayData = TransformUtil.transformData(m, DataUtil.rectangleToData(data.getBoundingBox()));
						DataUtil.applyData(boundingGroup, boundingData);
					}
				}
				
				validateBoundingGroup = false;
			}
		}
		
		/**
		 * Skin added to stage
		 * @private
		 */		
		protected function skinAddedHandler(event:Event):void
		{
			skin.removeEventListener(Event.ADDED_TO_STAGE, skinAddedHandler);
			
			validateControls = true;
			invalidateProperties();
		}
		
		/**
		 * Loop through all skin elements and add tool to all Controls
		 * @private 
		 */		
		protected function processParts(container:UIComponent):void
		{
			if(container is Control)
			{
				(container as Control).tool = this;
				return;
			}
			
			if(container is IVisualElementContainer)
			{
				for (var i:int = 0; i < (container as IVisualElementContainer).numElements; i++) 
				{
					var element:IVisualElement = (container as IVisualElementContainer).getElementAt(i);
					if(element is UIComponent)
						processParts(element as UIComponent);	
				}
			}
		}
		
		
		//------------------------------------------------
		// Event handlers
		//------------------------------------------------
		
		/**
		 * @private 
		 */		
		private var addedToStage:Boolean;
		
		/**
		 * Tool added to stage handler 
		 * @private
		 */	
		protected function addedToStageHandler(event:Event):void
		{
			if(connector)
				connector.setToolPanel(parent);
			
			addedToStage = true;
			
			if(toolCursorManager)
				toolCursorManager.tool = this;
			
			updateToolInternal();
		}
		
		/**
		 * Tool removed from stage handler 
		 * @private
		 */		
		protected function removedFromStageHandler(event:Event):void
		{
			addedToStage = false;
			
			if(toolCursorManager)
				toolCursorManager.tool = null;
		}
		
		/**
		 * Connector data change handler.
		 * Data is changed by target so we need to update transform tool.
		 * @param event
		 */		
		private function dataChangeHendler(event:ConnectorEvent):void
		{
			setUITargets(connector.targets);
			
			updateToolInternal();
		}
		
		/**
		 * Mouse down handler. 
		 */		
		protected function downHandler(event:MouseEvent):void
		{
			shiftPressed = event.shiftKey;
			ctrlPressed = event.ctrlKey;
			altPressed = event.altKey;
			invalidateSkinState();
			
			if(maintainMoveShortcuts)
				setFocus();
		}
		
		/**
		 * Mouse up handler. 
		 */
		protected function upHandler(event:MouseEvent):void
		{
			shiftPressed = false;
			ctrlPressed = false;
			altPressed = false;
			invalidateSkinState();
		}
		
		//------------------------------------------------
		// Methods
		//------------------------------------------------
		
		/**
		 * @private 
		 */		
		private var _transforming:Boolean;
		
		[Bindable("transformingChanged")]
		/**
		 * Flag that indicate whether tyransforming is in progress. 
		 */		
		public function get transforming():Boolean
		{
			return _transforming;
		}
		
		/**
		 * @private
		 * 
		 * If eny transformation was performed.
		 */		
		tt_internal var isTransformed:Boolean;
		
		/**
		 * Start transformation (mouse down on control) 
		 */		
		tt_internal function startTransformation(control:Control, type:String):void
		{
			if(preview && showPreview && !showPreviewCover)
			{
				try
				{
					if(_uiTargets && _uiTargets.length > 0)
					{
						var bd:BitmapData = new BitmapData( _uiTargets[0].width, _uiTargets[0].height);
						bd.draw( _uiTargets[0], new Matrix());
						preview.source = bd;
						preview.visible = true;
					}
				}catch(e:Error){}
			}
			
			if(previewCover)
				previewCover.visible = showPreview && showPreviewCover;
			
			_transforming = true;
			dispatchEvent(new Event("transformingChanged"));
			
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORMATION_START, type, connector.getData()));
		}
		
		/**
		 * Transformation is in progress (mouse move on control) 
		 */	
		tt_internal function doTransformation(data:DisplayData, type:String):void
		{
			DataUtil.applyData(this, data);
			
			var targetData:DisplayData = connector.transfrom(data);
			
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORMATION, type, data, targetData));
			
			isTransformed = true;
		}
		
		/**
		 * Transformation is finished  (mouse up on control)
		 */		
		tt_internal function endTransformation(data:DisplayData, type:String):void
		{
			_transforming = false;
			
			if(preview)
				preview.visible = false;
			
			if(previewCover)
				previewCover.visible = false;
			
			if(isTransformed)
			{			
				DataUtil.applyData(this, data);
				
				var targetData:DisplayData = connector.complete(data);
				
				dispatchEvent(new TransformEvent(TransformEvent.TRANSFORMATION_COMPLETE, type, data, targetData));
			}
			isTransformed = false;
			
			dispatchEvent(new Event("transformingChanged"));
		}
		
		/**
		 * Moving shortcut handler. 
		 */		
		protected function moveShortcutHandler(event:KeyboardEvent):void
		{
			var data:DisplayData = DataUtil.createData(this);
			
			var deltaX:Number = 1;
			var deltaY:Number = 1;
			
			if(grid && isNaN(grid.fraction))
			{
				deltaX = grid.cellWidth;
				deltaY = grid.cellHeight;
			}
			
			switch(event.keyCode)
			{
				case Keyboard.RIGHT:
				{
					data.x += deltaX;
					break;
				}
				case Keyboard.LEFT:
				{
					data.x -= deltaX;
					break;
				}
				case Keyboard.DOWN:
				{
					data.y += deltaY;
					break;
				}
				case Keyboard.UP:
				{
					data.y -= deltaY;
					break;
				}
				default:
				{
					break;
				}
			}
			
			// check fitting to bounds
			DataUtil.fitData(data, bounds);
			
			isTransformed = true;
			endTransformation(data, TransformationType.MOVE_SHORTCUT);
		}
		
		/**
		 * Upodate size, position, etc. of tool.
		 * 
		 * @param deep Flag that indicates whether connector should recalculate all parent dependencies to get right DisplayData values.
		 * Typically used when position or scale values of parent container changed. 
		 */		
		public function updateTool(deep:Boolean=false):void
		{
			updateToolInternal(deep, true);
		}
		
		/**
		 * @private 
		 */		
		protected function updateToolInternal(deep:Boolean=false, userRequested:Boolean = false):void
		{
			var data:DisplayData = connector.getData(deep, userRequested);
			if(data)
				DataUtil.applyData(this, data, true);
		}
		
		/**
		 * Start moving.
		 * 
		 * @param mouseEvent Mouse down event.
		 */		
		public function startMoving(mouseEvent:MouseEvent):void
		{
			validateNow();
			if(moveControl && mouseEvent && mouseEvent.type == MouseEvent.MOUSE_DOWN && mouseEvent.buttonDown)
			{
				moveControl.startTransformation(mouseEvent);
			}
		}
	}
}