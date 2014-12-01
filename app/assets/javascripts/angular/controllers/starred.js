"use strict";

marketplace.controller("StarredCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Opening",
  function($scope, $stateParams, AuthService, User, Opening) {
  	$scope.user = AuthService.getCurrentUser();
  	$scope.setTab("starred");

  }]);