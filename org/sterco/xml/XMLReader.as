import mx.events.EventDispatcher;
dynamic class org.sterco.xml.XMLReader {

	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;

	private var NOTPARSED:Number;
	private var PARSED:Number;
	public var STATUS:Number;
	private var reader_xml:XML;
	private var intervalId;
	private var __mcTimeLine:MovieClip;
	public var __strFolderName:String;
	public var __nMode:Number;
	public var root:Object;
	public static var __strLinkFolderName;

	function XMLReader(target, folder, nMode) {
		__nMode = nMode;
		__strFolderName = folder;
		__mcTimeLine = target;
		var xmlFile = setXMLFilePath(target);
		EventDispatcher.initialize(this);
		reader_xml = new XML();
		NOTPARSED = STATUS=0;
		PARSED = 1;
		if (xmlFile != undefined) {
			this.obtainData(xmlFile);
		}
	}
	private function setXMLFilePath(target) {
		var url;
		url = unescape(target._url);
		url = url.substr(url.lastIndexOf("/")+1, url.lastIndexOf("."));
		url = url.substr(0, url.indexOf("."))+".xml";		
		if (url == "Interface_final.xml") {
			url = "setup.xml";
			return url;
		}
		if (url == "credits.xml") {
			return url;
		}
		if (_level0.__strXml != undefined) {			
			__nMode = 1;
			__strFolderName = _level0.__strFolderTrack;
			url = _level0.__strFolderTrack+"\\"+url;
			return url;
		}
		return url;
	}
	private function obtainData(xmlFile:String):Void {
		reader_xml.ignoreWhite = true;
		reader_xml.load(xmlFile);
		intervalId = setInterval(this, "parseXML", 50);
	}
	private function parseXML():Void {

		if (reader_xml.loaded) {
			clearInterval(intervalId);
			this[this.reader_xml.firstChild.nodeName] = new Object();
			populate(reader_xml.firstChild,this[this.reader_xml.firstChild.nodeName]);
			delete reader_xml;
			STATUS = PARSED;
			__mcTimeLine.play();
			//dispatchEvent({type:'onParse'});
		}
	}
	private function populate(xmlObj, dataGathererObj):Void {
		var propertyName = "";
		if (xmlObj.hasChildNodes) {
			for (var i = 0; i<xmlObj.childNodes.length; i++) {
				if (xmlObj.childNodes[i].nodeType == 1) {
					propertyName = xmlObj.childNodes[i].nodeName;
					if (dataGathererObj[propertyName] == undefined) {
						dataGathererObj[propertyName] = new Object();
						dataGathererObj[propertyName]._length = 0;
					} else {
						dataGathererObj[propertyName]._length++;
					}
					dataGathererObj[propertyName][dataGathererObj[propertyName]._length] = new Object();
					for (var each in xmlObj.childNodes[i].attributes) {
						dataGathererObj[propertyName][dataGathererObj[propertyName]._length][each] = xmlObj.childNodes[i].attributes[each];
					}
					this.populate(xmlObj.childNodes[i],dataGathererObj[propertyName][dataGathererObj[propertyName]._length]);
				} else {
					dataGathererObj._innerData = xmlObj.childNodes[i].nodeValue;
				}
			}
		}
	}
	public function get strFolderName():String {
		return this.__strFolderName;
	}
	public function set strFolderName(value:String):Void {
		this.__strFolderName = value;
	}
	public function get nMode():Number {
		return this.__nMode;
	}
	public function set nMode(value:Number):Void {
		this.__nMode = value;
	}
}