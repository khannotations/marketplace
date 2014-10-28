"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$state", "AuthService", "Project",
  "Opening", "User",
  function($scope, $state, AuthService, Project, Opening, User) {
    $scope.foundOpenings = []
    $scope.user = AuthService.getCurrentUser();
    $scope.hasSearched = 0;
    $scope.searchParams = {q: ""};

    $scope.search = function() {

      $scope.hasSearched = 1;
      $scope.foundOpenings = Opening.search({search: $scope.searchParams});
      $scope.foundUsers = User.search({search: $scope.searchParams})
      // $scope.searchParams.q = "";
    }
    $scope.clearCookies = function() {
    	AuthService.logout();
      window.location.assign('/logout');
    }

    $scope.$watch("user", function() {
      // Run every time "user" changes
      // if ($scope.user.netid)...
    })

    $scope.showOptions = function() {
      $(".more-options").fadeToggle(100);
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

