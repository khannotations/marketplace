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
    	$cookieStore.remove("marketplace_user");
  		window.location.assign('/logout');
    }
  }]);

