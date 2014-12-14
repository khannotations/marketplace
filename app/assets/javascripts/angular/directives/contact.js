"use strict";

angular.module("Marketplace").directive("contact",
  ["$modal", "Opening", "AuthService", function($modal, Opening, AuthService) {
    return {
      restrict: "A",   // Attributes only
      transclude: true,
      template: "<span ng-click='contact()' ng-transclude></span>",
      link: function(scope, element, attrs) {
        scope.contact = function() {
          $("#wrapper").addClass("blur");
          $modal.open({
            templateUrl: '/templates/directives/contactModal',
            backdrop: false, 
            windowClass: "modal fade in",
            scope: scope
          }).result.then(function(result) {
            if (result === "email") {
              if (!AuthService.isStarred(scope.opening.id)) {
                AuthService.toggleStar(scope.opening.id).then(function() {
                  scope.opening.favorite_count++;
                });
              }
              // Create an actual resource
              scope.openingResource = new Opening(scope.opening);
              scope.openingResource.$contact(function() {
                scope.$emit("flash", {state: "success",
                  msg: "The opening leaders were contacted!<br>" + 
                  "We've also added this opening to your list of starred openings."});
              });
            }
            $("#wrapper").removeClass("blur");
          });
        };
      }
    }
}]);
