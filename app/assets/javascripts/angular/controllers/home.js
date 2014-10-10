"use strict";

angular.module("Marketplace")
  .controller("HomeCtrl", ["$scope", "$cookieStore", 
  	function($scope, $cookieStore) {
    $scope.saveUser = function() {
      $scope.user.$save()
    }
  }]);