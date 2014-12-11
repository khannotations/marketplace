"use strict";

angular.module("Marketplace").directive("star",
  ["AuthService", "User", function(AuthService, User) {
    return {
      restrict: "A",   // Attributes only
      scope: {
        openingId: "@" // The value of the opening-id attribute
      },
      link: function(scope, element, attrs) {
        var currentUser = new User(AuthService.getCurrentUser());
        var elem = angular.element(element);
        var oId = parseInt(scope.openingId);
        elem.addClass("star"); // For styling
        if (AuthService.isStarred(oId)) {
          elem.addClass("starred");
        }
        elem.on('click', function() {
          AuthService.toggleStar(oId).then(function() {
            // Change on front-end
            AuthService.isStarred(oId) ? elem.addClass("starred") :
              elem.removeClass("starred");
          });                
        });
      }
    }
}]);
