package com.fefranca.flixel
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxCore;
	import org.flixel.FlxG;
	
	/**
	 * A vertical gradient background for Flixel.
	 * Color properties (topColor and bottomColor) can be easily tweened for some awesome effects :)
	 * Alpha properties (topAlpha and bottomAlpha) are also available! (dedicated to cai and his bacon)
	 * Now supports multiple instances
	 * 
	 * @author Fernando França
	 */
	public class FlxGradientBackground extends FlxCore
	{
		private var _shape:Shape;
		private var _pixels:BitmapData;
		private var _p:Point;
		private var _r:Rectangle;
		private var _updateBuffer:Boolean;
		
		//Gradient properties
		private var _fillType:String;
		private var _colors:Array;
		private var _alphas:Array;
		private var _ratios:Array;
		private var _m:Matrix;
		private var _spreadMethod:String;
		
		public function FlxGradientBackground(x:int = 0, y:int = 0, width:Number = 0, height:Number = 0, topColor:Number = 0, bottomColor:Number = 0, topAlpha:Number = 1, bottomAlpha:Number = 1) 
		{
			super();
			this.last.x = this.x = x;
			this.last.y = this.y = y;
			this.width = width;
			this.height = height;
			
			_p = new Point();
			_r = new Rectangle(x, y, width, height);
			
			_shape = new Shape();
			
			//I decided to change Unique to true, in order to allow multiple FlxGradientBackgrounds!
			try {
				_pixels = FlxG.createBitmap(width, height, 0xff111111, true);			
			}
			catch (e:ArgumentError) {
				throw new Error("FlxUtils: Could not create the BitmapData object. Most likely your specified dimensions are too large. (FP9: 2880x2880, higher for FP10+)");
			}
			
			_fillType = GradientType.LINEAR;
			_colors = [topColor, bottomColor];
			_alphas = [topAlpha, bottomAlpha];
			_ratios = [0, 255];
			_m = new Matrix();
			_spreadMethod = SpreadMethod.PAD;
			
			preRender();
			_updateBuffer = false;
		}
		
		public function set topColor(color:Number):void {
			_colors[0] = color;
			_updateBuffer = true;
		}
		
		public function get topColor():Number {
			return _colors[0];
		}
		
		public function set bottomColor(color:Number):void {
			_colors[1] = color;
			_updateBuffer = true;
		}
		
		public function get bottomColor():Number {
			return _colors[1];
		}
		
		public function set topAlpha(value:Number):void {
			_alphas[0] = value;
			_updateBuffer = true;
		}
		
		public function get topAlpha():Number {
			return _alphas[0];
		}
		
		public function set bottomAlpha(value:Number):void {
			_alphas[1] = value;
			_updateBuffer = true;
		}
		
		public function get bottomAlpha():Number {
			return _alphas[1];
		}
		
		//@desc Pre-renders the background for better performance
		private function preRender():void {
			_m.createGradientBox(width, height, Math.PI / 2);
			_shape.graphics.clear();
			_shape.graphics.beginGradientFill(_fillType, _colors, _alphas, _ratios, _m, _spreadMethod);
			_shape.graphics.drawRect(0, 0, width, height);
			_shape.graphics.endFill();
			_pixels.fillRect(_r, 0x00000000);
			_pixels.draw(_shape);
			_updateBuffer = false;
		}
		
		override public function render():void
		{
			if(!visible)
				return;
			
			if (_updateBuffer) {
				preRender();
			}
				
			FlxG.buffer.copyPixels(_pixels, _r, _p, null, null, true);
		}		
	}
}