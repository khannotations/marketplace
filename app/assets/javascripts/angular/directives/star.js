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
<<<<<<< HEAD
        var elem = angular.element(element); // The current element
        var oId = parseInt(scope.openingId); // Convert ID from string to int
        elem.addClass("star");               // For styling, etc. 
=======
        var elem = angular.element(element)
        var oId = parseInt(scope.openingId);
        elem.addClass("star"); // For styling
        elem.attr("src", "/assets/star.svg");

>>>>>>> 85ba5225e55015f2c71970d88acaa21b3395fa67
        if(AuthService.isStarred(oId)) {
          elem.addClass("starred");
          elem.attr("src", "/assets/starred.png");  

        }
        elem.on('click', function() {
          AuthService.toggleStar(oId);                // Change on front-end
          currentUser.$toggleStar({opening_id: oId}); // Change on back-end
          // Toggle classes as necessary
          AuthService.isStarred(oId) ? elem.addClass("starred") :
            elem.removeClass("starred");
          if(AuthService.isStarred(oId))
            elem.attr("src", "/assets/starred.png");
          else
            elem.attr("src", "/assets/star.svg");
        })
      }
    }
}]);
