"use strict";

var marketplace = angular.module("Marketplace", ["ui.router", "ngCookies"])
  .config(function($stateProvider, $locationProvider) {
    console.log("in config");
    $stateProvider

    .state("home", {
      url: "/",
      templateUrl: "/templates/home",
      controller: "HomeCtrl"
    });

    $locationProvider.html5Mode(true)
  }).constant("AUTH_EVENTS", {
    loginSuccess: "auth-login-success",
    loginFailed: "auth-login-failed",
    logoutSuccess: "auth-logout-success",
    sessionTimeout: "auth-session-timeout",
    notAutheticated: "auth-not-authenticated",
    notAuthorized: "auth-not-authorized"
  }).constant("USER_ROLES", {
      all: "*",
      user: "user",
      admin: "admin"
  });