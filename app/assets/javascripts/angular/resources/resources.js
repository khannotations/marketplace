"use strict";

angular.module("Marketplace")
  .factory("User", ["$resource", function($resource) {
    var User = $resource("/users/:netid.json", {netid: "@netid"}, 
      {
        update: {method: 'PUT'},
        // Get current user method. Sends a get request to /current_user
        getCurrent: {method: 'GET', url: '/current_user.json', params: {}}
      });

    return User;
  }]);