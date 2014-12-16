"use strict";

angular.module("Marketplace").directive("star",
  ["AuthService", function(AuthService) {
    return {
      restrict: "A",   // Attributes only
      scope: {
        project: "=" // The value of the opening attributes
      },
      replace: true,
      templateUrl: "/templates/directives/star",
      link: function(scope, element, attrs) {
        var oId;
        var currentUser;
        AuthService.getCurrentUser().$promise.then(function(user) {
          currentUser = user;
        });
        // Wait for project to resolve, and watch for changes to favorite_count
        scope.$watch('project', function() {
          oId = scope.project.id;
          scope.starred = currentUser && currentUser.isStarred(project.id);
          scope.numStarred = scope.project.favorite_count;
        }, true); // True checks for entire object

        scope.toggleStar = function() {
          if (!currentUser) {
            scope.$emit("auth-not-authenticated");
            return;
          }
          currentUser.toggleStar().$promise.then(function() {
            scope.starred ? scope.project.favorite_count-- :
              scope.project.favorite_count++;
          });       
        };
      }
    }
}]);
