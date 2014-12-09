"use strict";

angular.module("Marketplace").directive("flash",
  ["$rootScope", "$timeout", "$http", "$compile",
  function($rootScope, $timeout, $http, $compile) {
    return {
      restrict: "A",
      templateUrl: "/templates/directives/flash",
      link: function(scope, element, attrs) {
        var t;
        var show = function(msg, state) {
          scope.msg = msg;
          scope.state = state;
          //scope.isVisible = "visible";
          // scope.$apply();
          t = $timeout(function() {
            scope.close();
          }, 5000);
        }

        scope.close = function() {
          scope.isVisible = "";
          clearTimeout(t);
        }

        $rootScope.$on("flash", function(e, args) {
          show(args.msg, args.state);
        });
      }
    }
  }]);