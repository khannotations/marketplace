"use strict";

angular.module("marketplace")
	.factory("AuthService", ["$cookieStore", function($cookieStore, $http, Session){
		var authService = {};

		authService.login = function() {
			return User.getCurrent(function (r) {
				Session.create(r);
			});
		};

		authService.isAuthenticated = function() {
			if(Session.first_name == null){
				return false;
			}
			return true;
		};

  		authService.isAdmin = function() {
  			return Session.is_admin;
  			// what if I call this on a non-authenticaed person
  		}


	}));

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
	neit
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