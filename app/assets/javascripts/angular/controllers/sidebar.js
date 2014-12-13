"use strict";

angular.module("Marketplace")
  .controller("SidebarCtrl", ["$scope", "$stateParams", "AuthService",
    function($scope, $stateParams, AuthService) {
      // Run login code
      AuthService.getCurrentUser().$promise.then(function(user) {
        $scope.user = user;
        $scope.isLoggedIn = AuthService.checkIfCurrentUser();
      });

      $scope.clearCookies = function() {
        AuthService.logout();
        window.location.assign('/logout');
      }

      $scope.$watch("currentTab", function(tab) {
        $("#current-tab").removeAttr("id");
        $("."+tab+"-tab").attr("id", "current-tab");
      })
   }]);