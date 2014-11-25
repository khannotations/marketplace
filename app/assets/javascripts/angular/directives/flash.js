"use strict";

angular.module("Marketplace").directive("flash",
  ["$rootScope, $timeout", function($rootScope, $timeout) {
    return {
      restrict: "A",
      templateUrl: "/templates/flash",
      transclude: true,
      replace: true,
      link: function(scope, element, attrs) {
        var show = function(msg, state) {
          $scope.msg = msg;
          $scope.state = state;
          $(element).fadeIn("fast");
          $timeout(function() {
            close();
          }, 3000);
        }

        var close = function() {
          $scope.msg = "";
          $(element).fadeOut("fast");
        }
      }
    }
  }]);