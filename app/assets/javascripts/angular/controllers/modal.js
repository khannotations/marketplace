"use strict";

marketplace.controller('ModalCtrl', ["$scope", "$modalInstance", 
	function ($scope, $modalInstance) {
	  $scope.ok = function () {
		  $modalInstance.close();
	  };

  	$scope.cancel = function () {
    	$modalInstance.dismiss('cancel');
    	$("#wrapper").css("-webkit-filter", "blur(0px)");
 	  };
}]);