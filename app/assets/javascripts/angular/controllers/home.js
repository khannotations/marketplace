"use strict";

angular.module("Marketplace")
  .controller("HomeCtrl", ["$scope", function($scope) {
    $scope.saveUser = function() {
      $scope.user.$save()
    }
  }]);