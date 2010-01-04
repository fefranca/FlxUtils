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
	 * 
	 * @author Fernando França
	 */
	public class FlxGradientBackground extends FlxCore
	{
		private var _shape:Shape;
		private var _pixels:BitmapData;
		private var _p:Point;
		private var _r:Rectangle;
		
		//Gradient properties
		private var _fillType:String;
		private var _colors:Array;
		private var _alphas:Array;
		private var _ratios:Array;
		private var _m:Matrix;
		private var _spreadMethod:String;
		
		public function FlxGradientBackground(X:int = 0, Y:int = 0, Width:uint = 0, Height:uint = 0, TopColor:uint = 0, BottomColor:uint = 0) 
		{
			super();
			last.x = x = X;
			last.y = y = Y;
			width = Width;
			height = Height;
			
			_p = new Point();
			_r = new Rectangle(x, y, width, height);
			
			_shape = new Shape();
			
			//0xff111111 is a little hack.
			//It forces Flixel to always use the same BitmapData object to avoid filling up the cache.
			//(Unique won't do it!)
			try {
				_pixels = FlxG.createBitmap(width, height, 0xff111111, false);			
			}
			catch (e:ArgumentError) {
				throw new Error("FlxUtils: Could not create the BitmapData object. Most likely your specified dimensions are too large. (FP9: 2880x2880, higher for FP10+)");
			}
			
			_fillType = GradientType.LINEAR;
			_colors = [TopColor, BottomColor];
			_alphas = [100, 100];
			_ratios = [0, 255];
			_m = new Matrix();
			_spreadMethod = SpreadMethod.PAD;
			
			preRender();
		}
		
		public function set topColor(color:uint):void {
			_colors[0] = color;
			preRender();
		}
		
		public function get topColor():uint {
			return _colors[0];
		}
		
		public function set bottomColor(color:uint):void {
			_colors[1] = color;
			preRender();
		}
		
		public function get bottomColor():uint {
			return _colors[1];
		}
		
		//@desc Pre-renders the background for performance reasons
		private function preRender():void {
			_m.createGradientBox(width, height, Math.PI / 2);
			_shape.graphics.clear();
			_shape.graphics.beginGradientFill(_fillType, _colors, _alphas, _ratios, _m, _spreadMethod);
			_shape.graphics.drawRect(0, 0, width, height);
			_shape.graphics.endFill();
			_pixels.draw(_shape);
		}
		
		override public function render():void
		{
			if(!visible)
				return;
				
			FlxG.buffer.copyPixels(_pixels, _r, _p, null, null, true);
		}		
	}
}