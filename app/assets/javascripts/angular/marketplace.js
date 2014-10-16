"use strict";

var marketplace = angular.module("Marketplace", ["ui.router", "ngResource", "ngCookies"])
  .config(function($stateProvider, $locationProvider) {
    $stateProvider

    .state("home", {
      url: "/",
      templateUrl: "/templates/home",
      controller: "HomeCtrl",
      data: {
        authorizedRoles: ["ADMIN", "USER"]
      }
    }).state("admin", { // Example route for testing
      url: "/admin",
      templateUrl: "/templates/home",
      controller: "HomeCtrl",
      data: {
        authorizedRoles: ["ADMIN"]
      }
    });

    $locationProvider.html5Mode(true)
  }).run(["AuthService", "$rootScope", "$state", function(AuthService, $rootScope, $state) {
    // Set up authorization check.
    $rootScope.$on('$stateChangeStart', function(event, next){
      var roles = next.data.authorizedRoles;
      if (next.name == "home") {
        return; // Always allow visit to home page. 
      }
      if (!AuthService.isAuthorized(roles)){
        event.preventDefault();
        if (AuthService.checkIfCurrentUser()){
          // user not allowed
          $rootScope.$broadcast("auth-not-authorized");
        } else {
          // user not logged in
          $rootScope.$broadcast("auth-not-authenticated");
        }
      }
    });

    $rootScope.$on("auth-not-authorized", function() {
      console.log("not authorized for this page; do something!");
    });
    $rootScope.$on("auth-not-authenticated", function() {
      $state.go("home");
      console.log("not authenticated gotta login!");
    });
  }]);
