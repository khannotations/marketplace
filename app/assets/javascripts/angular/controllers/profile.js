"use strict";

marketplace.controller("ProfileCtrl", ["$scope", "$stateParams", "AuthService",
  "User", "Skill", "Opening",
  function($scope, $stateParams, AuthService, User, Skill, Opening) {
    var currentUser = AuthService.getCurrentUser();
    $stateParams.netid = $stateParams.netid || currentUser.netid;
    $scope.user = User.get({netid: $stateParams.netid}, function() {
      $scope.canEdit = (currentUser.netid === $scope.user.netid) ||
        currentUser.is_admin;
    });

    $scope.allSkills = Skill.query();
    $scope.setTab("profile");

    // if user photo is present, use it instead of default
    if($scope.user.photo_url) {
      var img = $("user-photo");
      $(img).attr("src", "user.photo_url");
      $(img).css("padding", 0);
    }

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

    $scope.save = function() {
      if ($scope.canEdit) {
        $scope.user.$update();
        delete $scope.editingUser;
        $scope.$emit("flash", {state: "success",
               msg: "Changes saved!"});
      }

    }
  }]);
