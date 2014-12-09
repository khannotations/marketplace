"use strict";

marketplace.controller("StarredCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Opening", "$q",
  function($scope, $stateParams, AuthService, User, Opening, $q) {
  	$scope.user = AuthService.getCurrentUser();
  	$scope.setTab("starred");
  	$scope.allOpenings = [];
    var openings = [];
    console.log($scope.user.favorite_opening_ids);
    // Get only unique openings
    $scope.user.favorite_opening_ids = _.uniq($scope.user.favorite_opening_ids);
    // Load each opening
  	_.each($scope.user.favorite_opening_ids, function(id, index) {
      if (id) {
  		  openings.push(Opening.get({id: id}));
      } else {
        // In case weird null openings get added 
        delete $scope.user.favorite_opening_ids[index];
      }
  	});
    // Wait for all promises to resolve
  	$q.all(_.map(openings, function(o) { return o.$promise; })).then(function() {
      // The set scope variable (otherwise star directive doesn't work)
  		$scope.allOpenings = openings; // All resolved
      console.log($scope.allOpenings);
  	});

    $scope.unstarAll =  function() {
      _.map(openings, function(opening) {
        AuthService.toggleStar(opening.id);
      });
      $scope.allOpenings = [];
    };
  }]);