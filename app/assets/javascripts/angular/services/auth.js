"use strict";

angular.module("Marketplace")
  .factory("AuthService", ["$cookieStore", "User", function($cookieStore, User){
    var authService = {};
    var COOKIE_KEY = "marketplace_user";
    /*
     * Checks if a current user is stored in the cookieStore.
     * @return boolean
     */
    authService.checkIfCurrentUser = function() {
      return !!$cookieStore.get(COOKIE_KEY);
    };
    /*
     * Checks cookieStore for user. If no user, requests user from server and stores in the
     * cookie store.
     * @return {Object with a $promise method} The user object, which will resolve to the user
     *   or null.
     */
    authService.getCurrentUser = function () {
      if(!authService.checkIfCurrentUser()) {
        var user = User.getCurrent();
        user.$promise.then(function(u) {
          if (u.netid) {
            $cookieStore.put(COOKIE_KEY, u);
          }
        });
        return user;
      } else {
        return $cookieStore.get(COOKIE_KEY);
      }
    };
    /* 
     * Checks if current user is admin.
     */
    authService.isAdmin = function() {
      return $cookieStore.get(COOKIE_KEY).is_admin;
    };
    /* 
     * Checks if the current user is authorized for the given roles.
     * @param Array<string> authorizedRoles The permitted roles
     * @return boolean Whether the current user matches one of the 
     *   authorized roles.
     */
    authService.isAuthorized = function (authorizedRoles) {
      if (!authService.checkIfCurrentUser()) {
        return false;
      }
      var role = authService.isAdmin() ? "ADMIN" : "USER";
      return (authorizedRoles.indexOf(role) !== -1);
    };
    /*
     * Logs user out
     */
    authService.logout = function() {
      $cookieStore.remove(COOKIE_KEY);
    }
    /*
     * Checks if given opening ID is starred by the current user.
     * @param Integer
     * @return boolean
     */
    authService.isStarred = function(openingId) {
      var user = $cookieStore.get(COOKIE_KEY);
      return user.favorite_opening_ids.indexOf(openingId) !== -1;
    }
    /* 
     * Toggles the starred status of the given opening.
     * @param Integer
     */
    authService.toggleStar = function(openingId) {
      var user = $cookieStore.get(COOKIE_KEY);
      if (!authService.isStarred(openingId)) {
        user.favorite_opening_ids.push(openingId);
      } else {
        user.favorite_opening_ids = _.without(user.favorite_opening_ids, openingId);
      }
      $cookieStore.put(COOKIE_KEY, user);
    }
		return authService;
	}]);
