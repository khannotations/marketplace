"use strict";

marketplace.controller("StarredCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Opening", "$q",
  function($scope, $stateParams, AuthService, User, Opening, $q) {
  	$scope.user = AuthService.getCurrentUser();
  	$scope.setTab("starred");

	var promises = [];
  	$scope.allOpenings = [];


  	_.each($scope.user.favorite_opening_ids, function(id) {
  		promises.push(Opening.get({id: id}));
  	});

  	$q.all(promises).then(function() {
  		$scope.allOpenings = promises;
  	});

  }]);