// ------------------ SERVICES ------------------
// display service to display study detail
var displayService = angular.module('displayService',[]);
displayService.service('Display', ['Xml', function (Xml) {
	this.getDisplay = function(xml,item) {
		var json = xmlToJson(xml);
		var study = json["OAI-PMH"].GetRecord.record.metadata["oai_dc:dc"];
		// now set the tags
		item.title = Xml.getElement(study,"title");
		item.creator = Xml.getElement(study,"creator");
		item.subject = Xml.getElement(study,"subject");
		item.description = Xml.getElement(study,"description");
		item.publisher = Xml.getElement(study,"publisher");
		item.contributor = Xml.getElement(study,"contributor");
		item.date = Xml.getElement(study,"date");
		item.type = Xml.getElement(study,"type");
		item.format = Xml.getElement(study,"format");
		item.source = Xml.getElement(study,"source");
		item.language = Xml.getElement(study,"language");
		item.relation = Xml.getElement(study,"relation");
		item.coverage = Xml.getElement(study,"coverage");
		item.rights = Xml.getElement(study,"rights");
		
		item.dctags	= [
			{"title": "Title",       "value": item.title,     "bind": "item.title"},
			{"title": "Creator",     "value": item.creator,     "bind": "item.creator"},
			{"title": "Subject",     "value": item.subject,     "bind": "item.subject"},
			{"title": "Description", "value": item.description, "bind": "item.description"},
			{"title": "Publisher",   "value": item.publisher,   "bind": "item.publisher"},
			{"title": "Contributor", "value": item.contributor, "bind": "item.contributor"},
			{"title": "Date",        "value": item.date,        "bind": "item.date"},
			{"title": "Type",        "value": item.type,        "bind": "item.type"},
			{"title": "Format",      "value": item.format,      "bind": "item.format"},
			{"title": "Source",      "value": item.format,      "bind": "item.source"},
			{"title": "Language",    "value": item.language,    "bind": "item.language"},
			{"title": "Relation",    "value": item.language,    "bind": "item.relation"},
			{"title": "Coverage",    "value": item.coverage,    "bind": "item.coverage"},
			{"title": "Copyright",   "value": item.rights,      "bind": "item.rights"}
		];
	};
}]);
// xml service to extract dc element
var xmlService = angular.module('xmlService',[]);
xmlService.service('Xml', ['$sce', function ($sce) {
	var prefix = "dc:";
	this.getElement = function(study,name) {
		return $sce.trustAsHtml(parseElement(study[prefix+name]));
	};
}]);
// ------------------ FACTORIES ------------------
// title factory to fetch study listing
var titleService = angular.module('titleService', ['ngResource']);
titleService.factory('Title', ['$resource', function ($resource) {
	return $resource('data/:studyId.json', {}, {
		query: {method:'GET', params:{studyId:'studies'}, isArray:true},
		cache: true
	});
}]);
// study factory to fetch study detail
var studyService = angular.module('studyService',[]);
studyService.factory('Study', ['$http', function($http){
	return {
		get: function(studyId, callback){
			$http.get(
				"data/" + studyId + ".xml",
				{params: {studyId: studyId}},
				{cache: true}
			)
			.success(function(data, status) {
				callback(data);
			});
		}
	};
}]);
