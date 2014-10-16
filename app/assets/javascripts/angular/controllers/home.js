"use strict";

marketplace.controller("HomeCtrl", ["$scope", "User", "$cookieStore", function($scope, User, $cookieStore) {
    $scope.user = User.getCurrent()
    $scope.search = function() {
      $scope.foundOpenings = Opening.search({q: $scope.searchInput})
    }
    $scope.clearCookies = function() {
    	$cookieStore.remove("marketplace_user");
  		window.location.assign('/logout');
    }
  }]);

