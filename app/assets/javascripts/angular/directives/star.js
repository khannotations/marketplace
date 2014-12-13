"use strict";

angular.module("Marketplace").directive("star",
  ["AuthService", function(AuthService) {
    return {
      restrict: "A",   // Attributes only
      scope: {
        opening: "=" // The value of the opening attributes
      },
      replace: true,
      templateUrl: "/templates/directives/star",
      link: function(scope, element, attrs) {
        var oId;
        // Wait for opening to resolve, and watch for changes to favorite_count
        scope.$watch('opening', function() {
          oId = scope.opening.id;
          scope.starred = AuthService.isStarred(oId);
          scope.numStarred = scope.opening.favorite_count;
        }, true); // True checks for entire object

        scope.toggleStar = function() {
          AuthService.toggleStar(oId).then(function() {
            scope.starred ? scope.opening.favorite_count-- :
              scope.opening.favorite_count++;
          });         
        };
      }
    }
}]);
