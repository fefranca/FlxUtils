package com.fefranca.flixel
{
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	/**
	 * Single-colored FlxBlock, used to create walls and floors, effects, etc.
	 * Thanks Rybar for the original idea! ;)
	 * 
	 * @author Fernando França
	 */
	public class FlxColoredBlock extends FlxCore
	{
		protected var _shape:Shape;
		protected var _rect:Rectangle;
		protected var _p:Point;
		protected var _m:Matrix;
		protected var _color:uint;
		protected var _opaque:Boolean;
		
		//@desc		Constructor
		//@param	X			The X position of the block
		//@param	Y			The Y position of the block
		//@param	Width		The width of the block
		//@param	Height		The height of the block
		//@param	Color       A 32-bit ARGB color value that you use to fill the bitmap image area. The default value is 0xFFFFFFFF (solid white).
		public function FlxColoredBlock(X:int,Y:int,Width:uint,Height:uint,Color:uint = 0xFFFFFFFF)
		{
			super();
			x = X;
			y = Y;
			width = Width;
			height = Height;
			fixed = true;
			
			_p = new Point();			
			
			//If alpha from is 1, e.g. opaque, opt for direct rendering to FlxG.buffer
			_opaque = (Color >>> 24) == 0xff;
			if (_opaque) {
				_color = Color;
				_rect = new Rectangle(0, 0, width, height);
			}
			else {
				//Or else, lets use the vector renderer and a translation matrix.
				_shape = new Shape();
				_shape.graphics.beginFill(Color & 0x00ffffff, (Color >>> 24) / 255);
				_shape.graphics.drawRect(0, 0, width, height);
				_shape.graphics.endFill();
				_m  = new Matrix();
			}
		}
		
		//@desc		Draws this block
		override public function render():void
		{
			super.render();
			getScreenXY(_p);
			//This is likely really fast and uses very little memory
			if (_opaque) {
				_rect.x = _p.x;
				_rect.y = _p.y;
				FlxG.buffer.fillRect(_rect, _color);
			}
			//This is still good for memory usage and accepts transparency
			else {
				_m.tx = _p.x;
				_m.ty = _p.y;
				FlxG.buffer.draw(_shape, _m);
			}
		}
	}
}