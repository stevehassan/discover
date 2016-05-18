var discoverApp = angular.module('myModule', ['titleService','studyService','displayService','xmlService','ui.bootstrap','ngRoute','ngAnimate','ngSanitize','ngFacebook']);
// ------------------ RUNS ------------------
discoverApp.run(['$rootScope', '$window', '$facebook', function($rootScope, $window, $facebook) {
	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_GB/sdk.js#xfbml=1&version=v2.6&appId=" + $facebook.config("appId");
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
		$rootScope.$on('fb.load', function() {
		$window.dispatchEvent(new Event('fb.load'));
    });
}]);
// ------------------ CONFIGS ------------------
discoverApp.config(['$facebookProvider', function($facebookProvider) {
    $facebookProvider.setAppId('123456789876543').setPermissions(['email','user_friends']);// Change to your facebook app_id
}]);
// configure for pages
discoverApp.config(['$routeProvider', function($routeProvider) {
	$routeProvider.when('/', {
		templateUrl : 'partials/home.html',
		controller  : 'homeController'
	})
	.when('/home', {
		templateUrl : 'partials/home.html',
		controller  : 'homeController'
	})
	.when('/about', {
		templateUrl : 'partials/about.html',
		controller  : 'aboutController'
	})
	.when('/search', {
		templateUrl : 'partials/search.html',
		controller  : 'searchController'
	})
	.when('/login', {
		templateUrl: 'partials/login.html',
		controller: 'loginController' 
	})
	.when('/login/:studyId', {
		templateUrl: 'partials/login.html',
		controller: 'loginController' 
	})
	.when('/json/:studyId', {
		templateUrl: 'partials/json.html',
		controller: 'jsonController' 
	})
	.when('/study/:studyId', {
		templateUrl: 'partials/study.html',
		controller: 'studyController' 
	})
}]);
// ------------------ CONTROLLERS ------------------
// navigation route controller
discoverApp.controller('navigationController', ['$scope', '$location', function($scope, $location) {
	// collapse the mobile menu on menu click (not working for dropdowns)
	$('.nav a').on('click', function(){
		if($('.navbar-toggle').css("display") != "none"){
			$('.collapse').collapse('hide');
		}
	});	
	// check active route
	$scope.isActive = function (viewLocation) {
		 var active = (viewLocation === $location.path());
		 return active;
	};
}]);
// home controller
discoverApp.controller('homeController', ['$scope', function($scope) {
	$scope.date = new Date();
}]);
// about controller
discoverApp.controller('aboutController', ['$scope', function($scope) {
}]);
// login controller
discoverApp.controller('loginController', ['$scope', '$facebook', '$routeParams', '$timeout', function($scope, $facebook,  $routeParams, $timeout) {
  	$(document).ready(function() {
		if($routeParams.studyId){
			$scope.studyId = $routeParams.studyId;
		}
	});
	$("#friends-toggle").on("click", function() {
		var el = $(this);
		if (el.text() == "Hide") {
			$("#friends-toggle").html('Show');
		} else {
			$("#friends-toggle").html('Hide');
		}
	});		
    $scope.$on('fb.auth.authResponseChange', function() {
		$scope.status = $facebook.isConnected();
		if($scope.status) {
			$facebook.api('/me?fields=id,name,picture,email').then(function(user) {
				$scope.user = user;
			});
		}
    });
	$('#friends-btn').on('click', function () {
		if(!$scope.status) return;
		var $btn = $(this).button('loading');
		$facebook.api('/me/taggable_friends?limit=5000').then(function(friends) {
			$scope.colSpan = 4;
			$scope.chunkedFriends = chunk(friends.data, 12/$scope.colSpan);
			$btn.button('reset');
		});
    });	
}]);
// controller for pagination
discoverApp.controller('searchController', ['$scope', '$sce', '$filter', 'Title', 'Study', 'Display', 'Xml', function ($scope, $sce, $filter, Title, Study, Display, Xml) {
    $scope.currentPage = 1; //current page
    $scope.itemsPerPage = 10 // items per page
    $scope.maxSize = 5; //pagination max size
	
	// fetch the studies
	$scope.items = Title.query(function() {
		// take care of the sorting order
		if ($scope.sort.sortingOrder !== '') {
			$scope.filtered = $filter('orderBy')($scope.filtered, $scope.sort.sortingOrder, $scope.sort.reverse);
		}
	});
	// default sort
    $scope.sort = {       
		sortingOrder : 'id',
		reverse : false
    };
	// display selected study
	$scope.selectItem = function(item) {
		if(item.isSelected){
			item.isSelected = false;
			return;
		}
		Study.get(item.id, function(xml) {
			// load the xml into json
			Display.getDisplay(xml,item);
		});
		angular.forEach($scope.filtered, function(study) {
			study.isSelected = false;
		});
		item.isSelected = true;
	};
	// display selected study
	$scope.closeItem = function(item) {
		item.isSelected = false;
	};
}]);
// a raw json controller just for fun!
discoverApp.controller('jsonController', ['$scope', '$routeParams', 'Study', function($scope, $routeParams, Study) {
	if(!$routeParams.studyId)
		return;
	Study.get($routeParams.studyId, function(xml) {
		// load the xml into json
		$scope.json =   xmlToJson(xml);
	});
}]);
// study page controller
discoverApp.controller('studyController', ['$scope', '$location', '$sce', '$routeParams', 'Study', 'Display', 'Xml', function($scope, $location, $sce, $routeParams, Study, Display, Xml) {
	if(!$routeParams.studyId)
		return;
	$scope.url = $location.absUrl();
	Study.get($routeParams.studyId, function(xml) {
		// load the xml into json
		$scope.item = [];
		$scope.item.id = $routeParams.studyId;
		Display.getDisplay(xml,$scope.item);
	});
}]);
// ------------------ DIRECTIVES ------------------
// directive for sorting columns
discoverApp.directive("customSort", function() {
	return {
		restrict: 'A',
		transclude: true,    
		scope: {
		  order: '=',
		  sort: '='
		},
		template : 
		  ' <a ng-click="sort_by(order)" style="color: #555555; cursor: pointer">'+
		  '    <span ng-transclude></span>'+
		  '    <i ng-class="selectedCls(order)"></i>'+
		  '</a>',
		link: function(scope) {
			// change sorting order
			scope.sort_by = function(newSortingOrder) {       
				var sort = scope.sort;
				
				if (sort.sortingOrder == newSortingOrder){
					sort.reverse = !sort.reverse;
				}                    
				sort.sortingOrder = newSortingOrder;        
			};

			scope.selectedCls = function(column) {
				if(column == scope.sort.sortingOrder){
					return ('icon-chevron-' + ((scope.sort.reverse) ? 'down' : 'up'));
				}
				else{            
					return 'icon-sort' 
				} 
			};      
		}
	}
});
// custom bind-html for injected text containing markup
discoverApp.directive('bindHtmlCompile', ['$compile', function ($compile) {
	return {
		restrict: 'A',
		link: function (scope, element, attrs) {
			scope.$watch(function () {
				return scope.$eval(attrs.bindHtmlCompile);
			}, function (value) {
				element.html(value);
				$compile(element.contents())(scope);
			});
		}
	};
}]);
// reparses display of facebook buttons in view
discoverApp.directive("fbParse", ['$rootScope', function($rootScope) {
    return function (scope, iElement, iAttrs) {
		try {
			if (FB) {
				FB.XFBML.parse(iElement[0]);
			}
		}
		catch(e) {}		
    };
}]);
// ------------------ FILTERS ------------------		
// filter for pagination
discoverApp.filter('startFrom', function() {
	return function(items, start) {
		if(items) {
			start = +start; //parse to int
			return items.slice(start);
		}
		return [];
	}
});
// ------------------ HELPERS ------------------		
function chunk(arr, size) {
	var newArr = [];
	while (arr.length > 0)
		newArr.push(arr.splice(0, size));
	return newArr;
}