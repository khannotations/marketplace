"use strict";

angular.module("Marketplace")
	.factory("AuthService", ["$cookieStore", "User", function($cookieStore, User){
		var authService = {};

		authService.checkIfCurrentUser = function() {

			var current = $cookieStore.get();

			if(current !== undefined){
				return true;
			}

			else 
				return false;

		};

		authService.getCurrentUser = function () {
			var isUser = this.checkIfCurrentUser();
			if(!isUser){
				var user = User.getCurrent();
				console.log("user.is_admin = " + user.is_admin);
				$cookieStore.put("user", user.is_admin);
				console.log("user.is_admin = " + User.getCurrent().email);

			}
		};

		authService.isAdmin = function() {
			return $cookieStore.get('user');
		};

		authService.isAuthorized = function () {
			var role;

			if(this.isAdmin()){
				role = "admin";
			}
			else{
				role = "user";
			}

			return (this.checkIfCurrentUser() &&
      			authorizedRoles.indexOf(role) !== -1);
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
