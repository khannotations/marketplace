"use strict";

angular.module("Marketplace")
  .controller("SidebarCtrl", ["$scope", "$stateParams", "$state", "$rootScope",
    "AuthService", "Project",
    function($scope, $stateParams, $state, $rootScope, AuthService, Project) {

      $scope.user = AuthService.getCurrentUser();

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