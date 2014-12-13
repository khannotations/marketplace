"use strict";

marketplace.controller("StarredCtrl", ["$scope", "AuthService", "Opening", "$q",
  "currentUser",
  function($scope, AuthService, Opening, $q, currentUser) {
  	$scope.setTab("starred");
  	$scope.allOpenings = [];
    var openings = [];
    // Get only unique openings
    currentUser.favorite_opening_ids = _.uniq(currentUser.favorite_opening_ids);
    // Load each opening
  	_.each(currentUser.favorite_opening_ids, function(id, index) {
      if (id) {
  		  openings.push(Opening.get({id: id}));
      } else {
        // In case weird null openings get added 
        delete currentUser.favorite_opening_ids[index];
      }
  	});
    // Wait for all promises to resolve
  	$q.all(_.map(openings, function(o) { return o.$promise; })).then(function() {
      // The set scope variable (otherwise star directive doesn't work)
  		$scope.allOpenings = openings; // All resolved
  	});

    $scope.unstarAll =  function() {
      _.map(openings, function(opening) {
        AuthService.toggleStar(opening.id);
      });
      $scope.allOpenings = [];
    };
  }]);