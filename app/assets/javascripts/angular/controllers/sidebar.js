"use strict";

angular.module("Marketplace")
  .controller("SidebarCtrl", ["$scope", "$stateParams", "$state", "$rootScope", "AuthService",
    function($scope, $stateParams, $state, $rootScope, AuthService) {

        $scope.user = AuthService.getCurrentUser();

        $scope.setCurrent = function($event) {
            $(".navlink").removeAttr("id");
            var target = $event.target;
            target.setAttribute("id", "current-tab");
        };

        $scope.clearCookies = function() {
          AuthService.logout();
          window.location.assign('/logout');
        }

   }]);