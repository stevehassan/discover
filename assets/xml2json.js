// Changes XML to JSON
function xmlToJson(xml) {
	var parser = new DOMParser();
	var xml = parser.parseFromString(xml, "text/xml");					
	var doc = xmlToDom(xml);
	var json = $.parseJSON(JSON.stringify(doc));
	return json;
};
// Changes XML to DOM
function xmlToDom(xml) {
	// Create the return object
	var obj = {};

	if (xml.nodeType == 1) { // element
		// do attributes
		if (xml.attributes.length > 0) {
		obj["@attributes"] = {};
			for (var j = 0, len = xml.attributes.length; j < len; j++) {
				var attribute = xml.attributes.item(j);
				obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
			}
		}
	} else if (xml.nodeType == 3) { // text
		if (/\S/.test(xml.nodeValue))
			obj = xml.nodeValue;
	}

	// do children
	if (xml.hasChildNodes()) {
		for(var i = 0, len = xml.childNodes.length; i < len; i++) {
			var item = xml.childNodes.item(i);
			var nodeName = item.nodeName;
			if (typeof(obj[nodeName]) == "undefined") {
				obj[nodeName] = xmlToDom(item);
			} else {
				if (typeof(obj[nodeName].push) == "undefined") {
					var old = obj[nodeName];
					obj[nodeName] = [];
					obj[nodeName].push(old);
				}
				obj[nodeName].push(xmlToDom(item));
			}
		}
	}
	return obj;
};
// Extracts objects text content
function parseElement(objects) {
	var text="";
	if(objects instanceof Array){
		$.each(objects, function(i, object){
			text += object["#text"];
			text += (i<objects.length-1 ? "<br/>\n" : "");
		});
	}else if(objects){
		text += objects["#text"];;
	}
	return text;
}