package com.vstyran.transform.events
{
	import com.vstyran.transform.model.DisplayData;
	
	import flash.events.Event;
	
	/**
	 * Event produced by connector.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class ConnectorEvent extends Event
	{ 
		/**
		 *  The <code>ConnectorEvent.DATA_CHANGE</code> constant defines the value of the
		 *  <code>type</code> property of the event object for an <code>dataChange</code> event.
		 *  This event is dispatched from an IConnector when its target data
		 *  is changed.
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
		 *  @eventType dataChange
		 */
		public static const DATA_CHANGE:String = "dataChange";
		
		/**
		 *  The <code>ConnectorEvent.TRANSFORMATION</code> constant defines the value of the
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
		 *  The <code>ConnectorEvent.TRANSFORMATION_COMPLETE</code> constant defines the value of the
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
		 * Constructor.
		 *  
		 * @param type The event type; indicates the action that caused the event.
		 * @param data Display data object. 
		 */		
		public function ConnectorEvent(type:String, data:DisplayData = null)
		{
			super(type);
			
			_data = data;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function clone():Event
		{
			return new ConnectorEvent(type, _data);
		}
	}
}