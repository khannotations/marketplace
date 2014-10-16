"use strict";

// angular.module("Marketplace")
//   .controller("HomeCtrl", ["$scope", "$cookieStore", 
//   	function($scope, $cookieStore) {
//     $scope.saveUser = function() {
//       $scope.user.$save()
//     }
  
  
//   }]);

marketplace.controller("HomeCtrl", ["$scope", "User", "$cookieStore", function($scope, User, $cookieStore) {
    $scope.user = User.getCurrent()

    $scope.clearCookies = function() {
    	$cookieStore.remove("marketplace_user");
  		window.location.assign('/logout');
    	console.log("cookies cleared.");
    }

  }]);