"use strict";

var marketplace = angular.module("Marketplace", ["ui.router"])
  .config(function($stateProvider, $locationProvider) {
    console.log("in config");
    $stateProvider
    .state("home", {
      url: "/",
      templateUrl: "/templates/home",
      controller: "HomeCtrl"
    });

    $locationProvider.html5Mode(true)
  });