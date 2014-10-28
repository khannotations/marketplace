"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$state", "AuthService", "Project",
  "Opening", "User",
  function($scope, $state, AuthService, Project, Opening, User) {
    $scope.foundOpenings = []
    $scope.currentUser = AuthService.getCurrentUser();
    $scope.searchParams = {q: ""}
    $scope.search = function() {
      $scope.foundOpenings = Opening.search({search: $scope.searchParams});
      $scope.foundUsers = User.search({search: $scope.searchParams})
      // $scope.searchParams.q = "";
    }
    $scope.clearCookies = function() {
    	AuthService.logout();
      window.location.assign('/logout');
    }

    $scope.createProject = function() {
      $scope.newProject = new Project;
    }

    $scope.saveNewProject = function() {
      $scope.newProject.$save(function(project) {
        $state.go("project", {id: project.id});
      });
    }

    $scope.cancelNewProject = function() {
      delete $scope.newProject;
    }
  }]);

