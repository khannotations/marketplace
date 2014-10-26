"use strict";

marketplace.controller("HomeCtrl", ["$scope", "AuthService", "Opening",
  function($scope, AuthService, Opening) {
    $scope.foundOpenings = []
    $scope.user = AuthService.getCurrentUser();
    var numSkills = 4;
    $scope.limit = numSkills;
    $scope.hasSearched = 0;
    $scope.search = function() {
      $scope.hasSearched = 1;
      $scope.foundOpenings = Opening.search({q: $scope.searchInput});
      $scope.searchInput = "";
    }
    $scope.clearCookies = function() {
    	AuthService.logout();
      window.location.assign('/logout');
    }
    $scope.$watch("user", function() {
      // Run every time "user" changes
      // if ($scope.user.netid)...
    })
    $scope.toggleSkills = function() {
      if($scope.limit < 10){
        $scope.limit = 10;
      }
      else if($scope.limit == 10){
        $scope.limit = numSkills;
      }
    }
    $scope.showOptions = function() {
      $(".more-options").slideToggle(200);
    }
  }]);

