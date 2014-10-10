"use strict";

marketplace.controller("HomeCtrl", ["$scope", "User", function($scope, User) {
    $scope.user = User.getCurrent()
  }]);