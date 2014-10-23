"use strict";

marketplace.controller("HomeCtrl", ["$scope", "AuthService", "Opening",
  function($scope, AuthService, Opening) {
    $scope.foundOpenings = []
    $scope.user = AuthService.getCurrentUser();
    $scope.search = function() {
      $scope.foundOpenings = Opening.search({q: $scope.searchInput});
      $scope.searchInput = "";
    }
    $scope.clearCookies = function() {
      console.log("clearing..");
    	AuthService.logout();
      window.location.assign('/logout');
    }
    $scope.$watch("user", function() {
      // Run every time "user" changes
      // if ($scope.user.netid)...
    })
  }]);

