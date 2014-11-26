"use strict";

marketplace.controller("AdminCtrl", ["$scope", "$state", "AuthService", "Project",
  "Opening", "User",
  function($scope, $state, AuthService, Project, Opening, User) {
    $scope.unapprovedProjects = Project.getUnapproved();
  }]);