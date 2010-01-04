package com.fefranca.flixel.debug
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	/**
	 * Extension to FlxSprite that displays the current sprite's collision box and (optionally) collisions to the tilemap.
	 * 
	 * @author Fernando França
	 */
	public class FlxSpriteDebug extends FlxSprite
	{
		//Sprite lines
		private var _s:Shape;
		private var _lineTop:uint;
		private var _lineRight:uint;
		private var _lineLeft:uint;
		private var _lineBottom:uint;
		//Tilemap boxes
		private var _showCollisionRects:Boolean;
		private var _rectShape:Shape;
		private var _collisionRects:Array;
		
		/*
		 * @desc Constructor that matches FlxSprite's. 
		 */
		 
		public function FlxSpriteDebug(X:int = 0, Y:int = 0, SimpleGraphic:Class = null)
		{
			super(X, Y, SimpleGraphic);
			
			_p = new Point();
			_r = new Rectangle(0, 0, _bw, _bh);
			_s = new Shape();
			
			_lineTop = _lineRight = _lineLeft = _lineBottom = 0xffffff;
		}
		
		/*
		 * @desc Displays which tiles the player is colliding with.
		 * (rendered along with the sprite, avoid rendering things on top of it :P)
		 */
		public function set showCollisionRects(bool:Boolean):void {
			_showCollisionRects = bool;
			if(_showCollisionRects){
				_rectShape = new Shape();
				_collisionRects = new Array();
			}
		}
		
		override public function render():void {
			if (!visible)
				return;
			
			super.render();
			
			_s.graphics.clear();
			_s.graphics.moveTo(_p.x + offset.x, _p.y + offset.y);
			_s.graphics.lineStyle(1, _lineTop, 1);
			_s.graphics.lineTo(_p.x + offset.x + width, _p.y + offset.y);
			_s.graphics.lineStyle(1, _lineRight, 1);
			_s.graphics.lineTo(_p.x + offset.x + width, _p.y + offset.y + height);
			_s.graphics.lineStyle(1, _lineBottom, 1);
			_s.graphics.lineTo(_p.x + offset.x, _p.y + offset.y + height);
			_s.graphics.lineStyle(1, _lineLeft, 1);
			_s.graphics.lineTo(_p.x + offset.x, _p.y + offset.y);
			FlxG.buffer.draw(_s);
			
			if(_showCollisionRects && _collisionRects.length > 0){
				var r:Rectangle;
				_rectShape.graphics.clear();
				_rectShape.graphics.lineStyle(1, 0xff0000);
				for each(r in _collisionRects) {
					_rectShape.graphics.drawRect(r.x, r.y, r.width, r.height);
				}
				FlxG.buffer.draw(_rectShape);
				_collisionRects.length = 0;
			}
			
		
			_lineTop = _lineRight = _lineLeft = _lineBottom = 0xffffff;
		}
		
		override public function collide(Core:FlxCore):Boolean {
			return super.collide(Core);
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean {
			if (velocity.x > 0) {
				_lineRight = 0xff0000;
			}
			else {
				_lineLeft = 0xff0000;
			}
			
			if(_showCollisionRects){
				_collisionRects.push(new Rectangle(Contact.x + FlxG.scroll.x, Contact.y + FlxG.scroll.y, Contact.width, Contact.height));
			}
			return super.hitWall(Contact);
		}
		
		override public function hitFloor(Contact:FlxCore = null):Boolean {
			_lineBottom = 0xff0000;
			if(_showCollisionRects){
				_collisionRects.push(new Rectangle(Contact.x + FlxG.scroll.x, Contact.y + FlxG.scroll.y, Contact.width, Contact.height));
			}
			return super.hitFloor(Contact);
		}
		
		override public function hitCeiling(Contact:FlxCore = null):Boolean {
			_lineTop = 0xff0000;
			if(_showCollisionRects){
				_collisionRects.push(new Rectangle(Contact.x + FlxG.scroll.x, Contact.y + FlxG.scroll.y, Contact.width, Contact.height));
			}
			return super.hitCeiling(Contact);
		}		
	}
}