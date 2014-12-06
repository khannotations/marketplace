"use strict";

marketplace.controller("StarredCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Opening", "$q",
  function($scope, $stateParams, AuthService, User, Opening, $q) {
  	$scope.user = AuthService.getCurrentUser();
  	$scope.setTab("starred");
  	$scope.allOpenings = [];
    var openings = [];

    // Load each openings
  	_.each($scope.user.favorite_opening_ids, function(id, index) {
      if (id) {
  		  openings.push(Opening.get({id: id}));
      } else {
        // In case weird null openings get added again
        delete $scope.user.favorite_opening_ids[index];
      }
  	});
    // Wait for all promises to resolve
  	$q.all(_.map(openings, function(o) { return o.$promise; })).then(function() {
      // The set scope variable (otherwise star directive doesn't work)
  		$scope.allOpenings = openings; // All resolved
  	});
  }]);