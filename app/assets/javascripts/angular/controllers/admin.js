"use strict";

marketplace.controller("AdminCtrl", ["$scope", "Project",
  function($scope, Project) {
    $scope.unapprovedProjects = Project.getUnapproved();
  }]);