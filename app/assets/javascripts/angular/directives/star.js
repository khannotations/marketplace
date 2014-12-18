"use strict";

angular.module("Marketplace").directive("star",
  ["AuthService", function(AuthService) {
    return {
      restrict: "A",   // Attributes only
      scope: {
        project: "="
      },
      replace: true,
      templateUrl: "/templates/directives/star",
      link: function(scope, element, attrs) {
        AuthService.getCurrentUser().$promise.then(function(user) {
          var currentUser = user;
          var pId;
          // Wait for project to resolve, and watch for changes to favorite_count
          scope.$watch('project', function() {
            pId = scope.project.id;
            scope.starred = currentUser.isStarred(scope.project.id);
            scope.numStarred = scope.project.favorite_count;
          }, true); // True checks for entire object

          scope.toggleStar = function() {
            if (!currentUser) {
              scope.$emit("auth-not-authenticated");
              return;
            }
            currentUser.$toggleStar({project_id: scope.project.id}).then(function(u) {
              console.log(u);
              scope.starred ? scope.project.favorite_count-- :
                scope.project.favorite_count++;
            });       
          };
        });
      }
    }
}]);
