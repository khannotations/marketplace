"use strict";

marketplace.controller("HomeCtrl", ["$scope", "User", "Opening",
  function($scope, User, Opening) {
  $scope.search = function() {
    $scope.foundOpenings = Opening.search({q: $scope.searchInput})
  }
}]);
