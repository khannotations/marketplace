"use strict";

marketplace.controller("ProfileCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Skill", "currentUser",
  function($scope, $stateParams, AuthService, User, Skill, currentUser) {
    $stateParams.netid = $stateParams.netid || currentUser.netid;
    $scope.user = User.get({netid: $stateParams.netid}, function() {
      $scope.canEdit = (currentUser.netid === $scope.user.netid);
      if($scope.canEdit && !$scope.user.has_logged_in) {
        $scope.user.has_logged_in = true;
        $scope.user.$update();
        AuthService.setCurrentUser($scope.user);
      }
    });

    $scope.allSkills = Skill.query();
    $scope.setTab("profile");

    $scope.edit = function() {
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
      if (!$scope.canEdit) {
        return;
      }
      $scope.user.$update();
      delete $scope.editingUser;
      AuthService.setCurrentUser($scope.user);
      $scope.$emit("flash", {state: "success", msg: "Changes saved"});
    }

    // $scope.$watch("user.show_in_results", function() {
    //   if (!$scope.canEdit) {
    //     return;
    //   }
    //   $scope.user.$update();
    //   AuthService.setCurrentUser($scope.user);
    // });
  }]);
