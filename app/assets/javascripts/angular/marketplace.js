"use strict";

var marketplace = angular.module("Marketplace", ["ui.router", "ngResource", "ngCookies"])
  .config(function($stateProvider, $locationProvider) {
    $stateProvider
    .state("home", {
      url: "/",
      templateUrl: "/templates/home",
      controller: "HomeCtrl",
      data: {
        permissions: 'EVERYONE' | 'LEADERS'
      }
    });

    $locationProvider.html5Mode(true)
  }).run(["AuthService", "User", function(AuthService, User) {
    // User.getCurrent(function(user) {
    //   console.log(user);
    // });
  }]);
