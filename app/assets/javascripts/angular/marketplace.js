"use strict";

var marketplace = angular.module("Marketplace", ["ui.router", "ngCookies", "ngResource"])
  .config(function($stateProvider, $locationProvider) {
    $stateProvider

    .state("home", {
      url: "/",
      templateUrl: "/templates/home",
      controller: "HomeCtrl",
      data: {
        authorizedRoles: ["ADMIN", "USER"]
      }
    }).state("admin", {
      url: "/admin",
      templateUrl: "/templates/home",
      controller: "HomeCtrl",
      data: {
        authorizedRoles: ["ADMIN"]
      }
    });

    $locationProvider.html5Mode(true)
  }).run(["AuthService", "$rootScope", "$state", function(AuthService, $rootScope, $state) {
    $rootScope.$on('$stateChangeStart', function(event, next){
      var roles = next.data.authorizedRoles;

      console.log(next, roles);

      if (next.name = "home"){
        AuthService.getCurrentUser();
      }

      if (!AuthService.isAuthorized(roles)){
       event.preventDefault();

        if (AuthService.checkIfCurrentUser()){
          // user not allowed
          $rootScope.$broadcast("auth-not-authorized");
        } else {
          // user not logged in
          $rootScope.$broadcast("auth-not-authenticated");
          $state.go("home");
        }
      }
    });

    $rootScope.$on("auth-not-authorized", function() {
      console.log("not authorized for this page; do something!");
    });
  }]);
