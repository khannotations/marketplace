"use strict";

marketplace.controller("ProfileCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Skill",
  function($scope, $stateParams, AuthService, User, Skill) {
    var currentUser = AuthService.getCurrentUser();
    $stateParams.netid = $stateParams.netid || currentUser.netid;
    $scope.user = User.get({netid: $stateParams.netid}, function() {
      $scope.canEdit = (currentUser.netid === $scope.user.netid) ||
        currentUser.is_admin;
    });

    $scope.edit = function() {
      if ($scope.canEdit) {
        $scope.editingUser = angular.copy($scope.user);
      }
    };

    $scope.cancel = function() {
      $scope.user = $scope.editingUser;
      delete $scope.editingUser;
    }

    $scope.save = function() {
      if ($scope.canEdit) {
        $scope.user.$update();
        delete $scope.editingUser;
      }
    }
  }]);
