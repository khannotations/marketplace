"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$state", "AuthService", "Project", "Opening",
  function($scope, $state, AuthService, Project, Opening) {
    $scope.foundOpenings = []
    $scope.currentUser = AuthService.getCurrentUser();
    $scope.search = function() {
      $scope.foundOpenings = Opening.search({q: $scope.searchInput});
      $scope.searchInput = "";
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

