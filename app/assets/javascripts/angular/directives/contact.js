"use strict";

angular.module("Marketplace").directive("contact",
  [function() {
    return {
      restrict: "A",   // Attributes only
      transclude: true,
      template: ('<a class="link" ng-href="mailto:{{link}}" ng-transclude '+ 
        'target="_blank"></a>'),
      link: function(scope, element, attrs) {
        var to = _.map(scope.opening.project.leaders, function(l) {
          return l.full_name+"<"+l.email+">"
        }).join(",");
        var subject = "?subject=Interest+in+"+ scope.opening.name
        var body = "&body=I+found+your+posting+"+ scope.opening.name+
          "+on+the+Yale+Projects+Board"
        scope.link = to + subject + body;
      }
    }
}]);
