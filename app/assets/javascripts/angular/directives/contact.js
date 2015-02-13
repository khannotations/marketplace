"use strict";

angular.module("Marketplace").directive("contact",
  ["$modal", "Project", function($modal, Project) {
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
              // if (!.isStarred(scope.project.id)) {
              //   .toggleStar(scope.project.id).then(function() {
              //     scope.project.favorite_count++;
              //   });
              // }
              // Create an actual resource
              scope.projectResource = new Project(scope.project);
              scope.projectResource.$contact(function() {
                scope.$emit("flash", {state: "success",
                  msg: "The project's leaders were contacted! Check your email to follow up.<br>" + 
                  "We've also added this project to your list of starred projects."});
              });
            }
            $("#wrapper").removeClass("blur");
          });
        };
      }
    }
}]);
