"use strict";

marketplace.controller("ProfileCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Skill", "Opening",
  function($scope, $stateParams, AuthService, User, Skill, Opening) {
    var currentUser = AuthService.getCurrentUser();
    $stateParams.netid = $stateParams.netid || currentUser.netid;
    $scope.user = User.get({netid: $stateParams.netid}, function() {
      console.log("hey", AuthService.getCurrentUser());
      $scope.canEdit = (currentUser.netid === $scope.user.netid) ||
        currentUser.is_admin;
      if(!$scope.user.has_logged_in) {
        $scope.user.has_logged_in = true;
        $scope.user.$update();
        AuthService.setCurrentUser($scope.user);
      }
    });

    $scope.allSkills = Skill.query();
    $scope.setTab("profile");

    $scope.edit = function() {
      $scope.canEdit = true;
      if ($scope.canEdit) {
        $scope.editingUser = angular.copy($scope.user);
      }
    };

    $scope.cancel = function() {
      $scope.user = $scope.editingUser;
      delete $scope.editingUser;
    }

    $scope.clearCookies = function() {
      AuthService.logout();
      window.location.assign('/logout');
    }

    $scope.save = function() {
      if ($scope.canEdit) {
        $scope.user.$update();
        delete $scope.editingUser;
        $scope.$emit("flash", {state: "success",
               msg: "Changes saved!"});
      }

    }
  }]);
