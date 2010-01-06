package com.fefranca.flixel 
{
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import org.flixel.FlxText;
	
	/**
	 * Adds some missing functionality to FlxText (multiline, wordWrap, text outlining)
	 * @author Fernando França
	 */
	public class FlxTextExt extends FlxText
	{
		
		public function FlxTextExt(X:Number, Y:Number, Width:uint, Text:String = null) 
		{
			super(X, Y, Width, Text);
			_tf.height = 8; //this is a bugfix for multiline text fields			
		}
		
		/// Set text's outline color.
		public function setOutline(color:uint = 0x000000, size:Number = 2):void {
			_tf.filters = new Array(new DropShadowFilter(0, 0, color, 1, size, size, 1000, 1));
			_regen = true;
			calcFrame();
		}
		
		/// Remove text's outline.
		public function removeOutline():void {
			_tf.filters = new Array();
			_regen = true;
			calcFrame();
		}		
		
		/// Indicates whether field is a multiline text field.
		public function get multiline():Boolean {
			return _tf.multiline;
		}
		public function set multiline(value:Boolean):void {
			_tf.multiline = value;
		}
		
		/// A Boolean value that indicates whether the text field has word wrap.
		public function get wordWrap():Boolean {
			return _tf.wordWrap;
		}
		public function set wordWrap(value:Boolean):void {
			_tf.wordWrap = value;
		}
	}

}