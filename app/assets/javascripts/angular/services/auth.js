"use strict";

angular.module("Marketplace")
	.factory("AuthService", ["$cookieStore", "User", function($cookieStore, User) {
		var authService = {};
		var COOKIE_KEY = "marketplace_user_netid";
		this.currentUser = null;

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
			var t = this;
			if (this.currentUser) {
				// Cache in authService object
				return this.currentUser;
			}
			return User.getCurrent(function(u) {
				if (u.netid) {
					// Persist state across page refresh
					$cookieStore.put(COOKIE_KEY, u.netid);
					// For object cache
					t.currentUser = u;
				}
			});
		};
		/*
		 * Sets currentUser manually. The cookie cannot be modified without
		 * the login process. 
		 */
		authService.setCurrentUser = function(user) {
			this.currentUser = user;
		};
		/* 
		 * Checks if current user is admin.
		 */
		authService.isAdmin = function() {
			return this.currentUser && this.currentUser.is_admin;
		};
		/* 
		 * Checks if the current user is authorized for the given roles.
		 * @param Array<string> authorizedRoles The permitted roles
		 * @return boolean Whether the current user matches one of the 
		 *   authorized roles.
		 */
		authService.isAuthorized = function (authorizedRoles) {
			if (authorizedRoles.indexOf("PUBLIC") !== -1) {
				// Always allow access to public routes
				return true;
			}
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
			this.currentUser = null;
		};

		// authService.isStarred = function(index) {
		// 	if (!this.currentUser || !this.currentUser.favorite_project_ids) {
		// 		return false;
		// 	}
		// 	return this.currentUser.favorite_project_ids.indexOf(index) !== -1;
		// };

		// authService.toggleStar = function(index) {
		// 	return this.currentUser.$toggleStar({project_id: index});
		// };
		return authService;
	}]);
