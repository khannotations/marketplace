"use strict";

var marketplace = angular.module("Marketplace", ["ui.router", "ngResource",
  "ngCookies", 'localytics.directives', "ui.bootstrap", "angulartics", "angulartics.google.analytics"])
  .config(["$stateProvider", "$locationProvider", "$urlRouterProvider", 
    function($stateProvider, $locationProvider, $urlRouterProvider) {
    $stateProvider

    .state("home", {
      url: "/?q&tfs&sort&show&options",
      templateUrl: "/templates/home",
      controller: "HomeCtrl",
      reloadOnSearch: false,
      data: {
        authorizedRoles: ["ADMIN", "USER", "PUBLIC"]
      }
    }).state("about", {
      url: "/about",
      templateUrl: "/templates/about",
      data: {
        authorizedRoles: ["ADMIN", "USER", "PUBLIC"]
      }
    }).state("project", {
      url: "/projects/:id",
      templateUrl: "/templates/project",
      controller: "ProjectCtrl",
      data: {
        authorizedRoles: ["ADMIN", "USER"]
      }
    }).state("profile", {
      url: "/profile/:netid",
      templateUrl: "/templates/profile",
      controller: "ProfileCtrl",
      data: {
        authorizedRoles: ["ADMIN", "USER"]
      }
    }).state("starred", {
      url: "/starred",
      templateUrl: "/templates/starred",
      controller: "StarredCtrl",
      data: {
        authorizedRoles: ["ADMIN", "USER"]
      }
    }).state("admin", {
      abstract: true,
      url: "/admin",
      controller: "AdminCtrl",
      template: "<div class='ui-view'></div>",
      data: {
        authorizedRoles: ["ADMIN"]
      }
    }).state("admin.project-approve", {
      url: "/approve",
      templateUrl: "/templates/admin/approve"
    });

    $locationProvider.html5Mode(true);
    $urlRouterProvider.otherwise("/");
  }])
  // Configure all AJAX calls to have the right CSRF token for Rails
  .config(['$httpProvider', function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = 
      angular.element('meta[name=csrf-token]').attr('content');
  }]).run(["AuthService", "$rootScope", "$state", function(AuthService, $rootScope, $state) {
    // Set up authorization check.
    $rootScope.$on('$stateChangeStart', function(event, next) {
      var roles = next.data.authorizedRoles;
      // if (next.name == "home") {
      //   return; // Always allow visit to home page. 
      // }
      if (!AuthService.isAuthorized(roles)) {
        event.preventDefault();
        if (AuthService.checkIfCurrentUser()) {
          // user not allowed
          $rootScope.$broadcast("auth-not-authorized");
        } else {
          // user not logged in
          $rootScope.$broadcast("auth-not-authenticated");
        }
      }
    });

    $rootScope.$on("auth-not-authorized", function() {
      $state.go("home");
      $rootScope.$emit("flash", {state: "error",
        msg: "You are not authorized to view that page"});
    });
    $rootScope.$on("auth-not-authenticated", function() {
      $state.go("home");
      $rootScope.$emit("flash", {state: "error",
        msg: "You must be logged in to do that"});
    });

    $rootScope.setTab = function(tab) {
      $rootScope.currentTab = tab;
    };
  }]);
