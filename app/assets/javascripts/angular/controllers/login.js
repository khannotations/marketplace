"use strict";

angular.module("Marketplace")
	.controller("AuthCtrl", ["$scope", "$cookieStore", function($scope, $cookieStore,
		$rootScope, AUTH_EVENTS, AuthService){
			$scope.credentials = {
				username: "",
				password: ""
			};

			$scope.login = function (credentials){
				AuthService.login(credentials).then(function (user){
					$rootScope.$broadcast(AUTH_EVENTS.loginSuccess);
					$scope.setCurrentUser(user);
				}, function(){
					$rootScope.$broadcast(AUTH_EVENTS.loginFailed)
				});
			};
	}])