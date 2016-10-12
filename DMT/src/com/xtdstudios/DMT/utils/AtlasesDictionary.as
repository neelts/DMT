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
package com.xtdstudios.DMT.utils
{
	import com.xtdstudios.DMT.atlas.Atlas;
	import com.xtdstudios.DMT.serialization.ISerializable;

import flash.geom.Rectangle;

import flash.utils.Dictionary;

	public class AtlasesDictionary implements ISerializable
	{
		private var m_dictionary		: Dictionary;
		private var m_length			: int;
		
		public function AtlasesDictionary()
		{
			init();
		}

		private function init():void {
			m_length = 0;
			m_dictionary = new Dictionary();
		}


		public function toJson():Object {
			var result : Object = { meta:{ app:"Neelts Exporter (powered by DMT)" }, frames:{} };
			var ra:Array;
			var aj:Object;
			var rr:Rectangle;
			for (var name:String in m_dictionary)
			{
				var atlas : Atlas = m_dictionary[name];
				aj = atlas.toJson();
				result.meta.image = aj.name;
				result.meta.size = { w:aj.width, h:aj.height };
				for (var region:String in atlas.regions) {
					rr = atlas.regions[region];
					ra = region.split("_");
					//result.frames[region] = {
					result.frames[ra[1] + digits(parseInt(ra[2].slice(2)))] = {
						frame: { x:rr.x, y:rr.y, w:rr.width, h:rr.height },
						sourceSize:{ w:rr.width, h:rr.height }
					};
				}
				break;
			}
			return result;
		}

		private function digits(n:uint, d:uint = 4):String {
			var r:String = n.toString();
			while (r.length < d) r = "0" + r;
			return r;
		}

		public function fromJson(jsonData:Object):void {
			dispose();
			init();

			for(var name:String in jsonData) {
				var atlasData : Object = jsonData[name];
				var atlas     : Atlas = new Atlas();
				atlas.fromJson(atlasData);
				addAtlas(atlas, name);
			}
		}

		public function get length():int
		{
			return m_length;
		}

		public function addAtlas(atlas:Atlas, name:String, overrideExisting:Boolean=true):void
		{
			if (m_dictionary[name]==null)
			{
				m_dictionary[name] = atlas;
				m_length++;
			}
			else
			{
				if (overrideExisting==true)
				{
					m_dictionary[name] = atlas;
				}
			}
		}
		
		public function removeAtlas(name:String, autoDispose:Boolean=true):void
		{
			if (m_dictionary[name]!=null)
			{
				var atlas : Atlas = m_dictionary[name];
				delete m_dictionary[name];
				m_length--;
				
				if (autoDispose==true)
					atlas.dispose();
			}
		}
		
		public function nameExist(name:String):Boolean
		{
			return m_dictionary[name]!=null;
		}
		
		public function toArray():Array
		{
			var result : Array = new Array;
			for each(var atlas:Atlas in m_dictionary)
			{
				result.push(atlas);
			}
			
			return result;
		}
		
		public function dispose():void
		{
			for (var name:String in m_dictionary)
			{
				var atlas : Atlas = m_dictionary[name];
				atlas.dispose();
			}
			m_dictionary = null;
			m_length = 0;
		}
		
	}
}