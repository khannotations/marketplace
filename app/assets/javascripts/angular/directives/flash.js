"use strict";

angular.module("Marketplace").directive("flash",
  ["$rootScope", "$timeout", "$http", "$compile",
  function($rootScope, $timeout, $http, $compile) {
    return {
      restrict: "A",
      templateUrl: "/templates/directives/flash",
      link: function(scope, element, attrs) {
        var show = function(msg, state) {
          scope.msg = msg;
          scope.state = state;
          scope.isVisible = true;
        }

        scope.close = function() {
          scope.isVisible = false;
        }

        $rootScope.$on("flash", function(e, args) {
          show(args.msg, args.state);
        });

        $rootScope.$on('$stateChangeSuccess', function() {
          scope.close();
        });
      }
    }
  }]);