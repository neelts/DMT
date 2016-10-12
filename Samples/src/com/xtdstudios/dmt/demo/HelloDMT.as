/*
Copyright 2012 XTD Studios Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.xtdstudios.dmt.demo
{
	import com.xtdstudios.DMT.DMTBasic;
	import com.xtdstudios.dmt.demo.assets.Square;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class HelloDMT extends starling.display.Sprite
	{
		// set useCache to false if you have changed the asset to re-generate the cache
		private var dmtBasic: DMTBasic = new DMTBasic("demo.HelloDMT", GlobalConsts.USE_CACHE, GlobalConsts.CACHE_VERSION);
		
		private var m_flashSquare			: flash.display.Sprite;
		private var m_starlingSquare		: starling.display.DisplayObject;
		
		public function HelloDMT()
		{
			super();
			
			name = "Hello DMT";
			initFlash();
			doRasterize();
		}
		
		private function initFlash(): void {
			m_flashSquare = new Square(50,-25,-25);
			m_flashSquare.x=100;
			m_flashSquare.y=100;
			Starling.current.nativeStage.addChild(m_flashSquare);
		}
		
		override public function dispose():void
		{
			if (m_flashSquare && m_flashSquare.parent)
				m_flashSquare.parent.removeChild(m_flashSquare);
			
			if (m_starlingSquare)
				removeChild(m_starlingSquare);
			
			super.dispose();
		}
		
		private function doRasterize(): void {
			dmtBasic.addItemToRaster(m_flashSquare, "Square");
			
			dmtBasic.addEventListener(flash.events.Event.COMPLETE, dmtComplete);
			dmtBasic.process();
		}
		
		private function dmtComplete(event:flash.events.Event): void {
			initStarlingObjects();
		}
		
		private function initStarlingObjects(): void {
			m_starlingSquare = dmtBasic.getAssetByUniqueAlias("Square");
			addChild(m_starlingSquare);
		}
	}
}