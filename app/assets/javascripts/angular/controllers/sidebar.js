"use strict";

angular.module("Marketplace")
  .controller("SidebarCtrl", ["$scope", "$stateParams", "$state", "$rootScope",
    "AuthService", "Project",
    function($scope, $stateParams, $state, $rootScope, AuthService, Project) {

      // Run login code
      $scope.user = AuthService.getCurrentUser();
      if ($scope.user.$promise) {
        $scope.user.$promise.then(function() {
          // Wait for user to load
          $scope.isLoggedIn = AuthService.checkIfCurrentUser();
        });
      } else {
        $scope.isLoggedIn = AuthService.checkIfCurrentUser();
      }

      $scope.clearCookies = function() {
        AuthService.logout();
        window.location.assign('/logout');
      }

      $scope.newProject = function() {
        $scope.newProject = new Project;
        $state.go("project", {id: $scope.newProject.id});
      }

      $scope.$watch("currentTab", function(tab) {
        $("#current-tab").removeAttr("id");
        $("."+tab+"-tab").attr("id", "current-tab");
      })

   }]);