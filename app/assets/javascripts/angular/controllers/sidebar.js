"use strict";

angular.module("Marketplace")
  .controller("SidebarCtrl", ["$scope", "$stateParams", "$state", "$rootScope", "AuthService", "Project",
    function($scope, $stateParams, $state, $rootScope, AuthService, Project) {

        $scope.user = AuthService.getCurrentUser();

        // $scope.setCurrent = function($event) {
        //     $(".navlink").removeAttr("id");
        //     var target = $event.target;
        //     target.setAttribute("id", "current-tab");
        // };

        $scope.clearCookies = function() {
          AuthService.logout();
          window.location.assign('/logout');
        }

      $scope.newProject = function() {
        $scope.newProject = new Project;
        $state.go("project", {id: $scope.newProject.id});
      }

      $scope.$watch("currentTab", function(tab) {
        var newTab = document.getElementsByClassName(tab + "-tab");
        var oldTab = document.getElementById("current-tab");
        $(oldTab).removeAttr("id");
        $(newTab).attr("id", "current-tab");
      })

   }]);