"use strict";

var marketplace = angular.module("Marketplace", ["ui.router", "ngCookies", "ngResource"])
  .config(function($stateProvider, $locationProvider) {
    $stateProvider

    .state("home", {
      url: "/",
      templateUrl: "/templates/home",
      controller: "HomeCtrl",
      data: {
        authorizedRoles: ["admin", "user"]
      }
    });

    $locationProvider.html5Mode(true)
  }).run(["AuthService", "$rootScope", function(AuthService, $rootScope) {
    $rootScope.$on('$stateChangeStart', function(event, next){

      var roles = next.data.authorizedRoles;

      if(next.url = "/"){
        AuthService.getCurrentUser();
        console.log("hello");
      }

      var isUser = AuthService.checkIfCurrentUser();


      console.log("isAdmin = " + AuthService.isAdmin() + "\n next = " + next.url + "\n isUser = " + isUser);


      if(!AuthService.isAuthorized){
       event.preventDefault();

        if(AuthService.checkIfCurrentUser()){
          // user not allowed
          $rootScope.$broadcast("auth-not-authorized");
        }
        else{
          // user not logged in
          $rootScope.$broadcast("auth-not-authenticated");
          $location("/");
        }
      }
    });
    

  }]).constant("AUTH_EVENTS", {
        loginSuccess: 'auth-login-success',
        loginFailed: 'auth-login-failed',
        logoutSuccess: 'auth-logout-success',
        sessionTimeout: 'auth-session-timeout',
        notAuthenticated: 'auth-not-authenticated',
        notAuthorized: 'auth-not-authorized'
  });