"use strict";

marketplace.controller("StarredCtrl", ["$scope", "AuthService",
  function($scope, AuthService) {
  	$scope.user = AuthService.getCurrentUser();
  	$scope.setTab("starred");
  }]);