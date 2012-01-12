package com.vstyran.transform.events
{
	import com.vstyran.transform.model.DisplayData;
	
	import flash.events.Event;
	
	/**
	 * Event produced by transform tool indicating transformation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class TransformEvent extends Event
	{
		/**
		 *  The <code>TransformEvent.TRANSFORMATION_START</code> constant defines the value of the
		 *  <code>type</code> property of the event object for an <code>transformationStart</code> event.
		 *  This event is dispatched from an IConnector when transformation is finished.
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType transformationStart
		 */
		public static const TRANSFORMATION_START:String = "transformationStart";
		
		/**
		 *  The <code>TransformEvent.TRANSFORMATION</code> constant defines the value of the
		 *  <code>type</code> property of the event object for an <code>transformation</code> event.
		 *  This event is dispatched from an IConnector when transformation data
		 *  is changed by transform tool.
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType transformation
		 */
		public static const TRANSFORMATION:String = "transformation";
		
		/**
		 *  The <code>TransformEvent.TRANSFORMATION_COMPLETE</code> constant defines the value of the
		 *  <code>type</code> property of the event object for an <code>transformationComplete</code> event.
		 *  This event is dispatched from an IConnector when transformation is finished.
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType transformation
		 */
		public static const TRANSFORMATION_COMPLETE:String = "transformationComplete";
		
		/**
		 * @private 
		 */		
		private var _data:DisplayData;
		
		/**
		 * Display data object. 
		 */		
		public function get data():DisplayData
		{
			return _data;
		}
		
		/**
		 * @private 
		 */		
		private var _transformationType:String;
		
		/**
		 * Current type of transformation.
		 * 
		 * @see com.vstyran.transform.consts.TransformationType 
		 */		
		public function get transformationType():String
		{
			return _transformationType;
		}
		
		/**
		 * Constructor.
		 *  
		 * @param type The event type; indicates the action that caused the event.
		 * @param transformationType Current type of transformation.
		 * @param data Display data object. 
		 */		
		public function TransformEvent(type:String, transformationType:String, data:DisplayData = null)
		{
			super(type);
			
			_transformationType = transformationType;
			_data = data;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function clone():Event
		{
			return new TransformEvent(type, _transformationType, _data);
		}
	}
}