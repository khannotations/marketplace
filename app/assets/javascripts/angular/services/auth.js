"use strict";

angular.module("Marketplace")
	.factory("AuthService", ["$cookieStore", "User", "$q", function($cookieStore, User, $q){
		var authService = {};

		/*
		 * Checks if a current user is stored in the cookieStore.
		 * @return boolean
		 */
		authService.checkIfCurrentUser = function() {
			return !!$cookieStore.get('marketplace_user');
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
					if (u) {
						$cookieStore.put('marketplace_user', u);
					}
				});
				return user;
			}
			else {
				return $cookieStore.get("marketplace_user");
			}
		};

		authService.isAdmin = function() {
			return $cookieStore.get("marketplace_user").is_admin;
		};

		authService.isAuthorized = function (authorizedRoles) {
			var role;
			if (!authService.checkIfCurrentUser()) {
				return false;
			}
			if (authService.isAdmin()){
				role = "ADMIN";
			}
			else {
				role = "USER";
			}

			return (authorizedRoles.indexOf(role) !== -1);
		};

		return authService;
	}]);

	/* Methods:
	     checkIfCurrentUser (checks the cookieStore)
	     getCurrentUser (checksIfCurrentUser, if not, User.getCurrent(), and create cookieStore)

	     Visit: / -> getCurrentUser
	     Visit: Any other page -> checkIfCurrentUser, if not, go to /
	     Login button: [special code] <a onclick=window.location.assign('/login')></a>
	        -> return to index with the servers' current user updated
	        -> so getCurrentUser will get a non-null value
	     Logout button: [special code] <a onclick=window.location.assign('/logout')></a>


	/* 
	Session fields:

	first_name
	last_name
	netid
	email
	year
	college
	division
	title
	is_admin
	github_url
	linkedin_url
	resume
	bio
	past_experiences 
	*/
