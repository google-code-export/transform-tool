package com.vstyran.transform.view
{
	
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.connectors.IUIConnector;
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
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
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
					_connector.addEventListener(ConnectorEvent.DATA_CHANGE, dataChangeHendler);
				
				updateTool();
			}
		}
		
		/**
		 * @private 
		 */		
		private var _uiTarget:UIComponent;

		/**
		 * UI target of transformation. Used as event dispather for moving control. 
		 */		
		public function get uiTarget():UIComponent
		{
			return _uiTarget;
		}

		/**
		 * @private 
		 */		
		public function set uiTarget(value:UIComponent):void
		{
			_uiTarget = value;
			
			if(moveControl)
				moveControl.uiTarget = _uiTarget;
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
					moveControl.uiTarget = uiTarget;
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
				moveControl.uiTarget = null;
			}
		}
		
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
			
			updateTool();
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
			if(connector is IUIConnector)
				uiTarget = (connector as IUIConnector).target;
			
			updateTool();
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

		/**
		 * Flag that indicate whether tyransforming is in progress. 
		 */		
		public function get transforming():Boolean
		{
			return _transforming;
		}

		/**
		 * Start transformation (mouse down on control) 
		 */		
		public function startTransformation(control:Control):void
		{
			if(preview && showPreview && !showPreviewCover)
			{
				try
				{
					var bd:BitmapData = new BitmapData( _uiTarget.width, _uiTarget.height);
					bd.draw( _uiTarget, new Matrix());
					
					preview.source = bd;
					preview.visible = true;
				}catch(e:Error){}
			}
			
			if(previewCover)
				previewCover.visible = showPreview && showPreviewCover;
			
			_transforming = true;
			
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORMATION_START));
		}
		
		/**
		 * Transformation is in progress (mouse move on control) 
		 */	
		public function doTransformation(data:DisplayData):void
		{
			DataUtil.applyData(this, data);
			
			data = connector.transfrom(data)
				
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORMATION, data));
		}
		
		/**
		 * Transformation is finished  (mouse up on control)
		 */		
		public function endTransformation(data:DisplayData):void
		{
			DataUtil.applyData(this, data);
			
			data = connector.complete(data);
			
			if(preview)
				preview.visible = false;
			
			if(previewCover)
				previewCover.visible = false;
			
			_transforming = false;
			
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORMATION_COMPLETE, data));
		}
		
		/**
		 * Upodate size, position, etc. of tool 
		 */		
		public function updateTool():void
		{
			var data:DisplayData = connector.getData();
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