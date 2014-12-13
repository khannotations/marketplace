"use strict";

marketplace.factory('httpErrorInterceptor', ["$q", "$rootScope", function($q, $rootScope) {
  return {
    responseError: function(response) {
      switch(response.status) {
        case 403:
          $rootScope.$emit("auth-not-authorized");
          break;
        case 400:
          $rootScope.$emit("flash", {state: "error", msg: response.data.error});
          break;
        default:
          $rootScope.$emit("flash", {state: "error", msg: ("We apologize, but" +
            " the application has encountered an error—one of the admins is working" +
            " to solve the problem! In the meantime, please try refreshing the page.")})
      }
      return $q.reject(response);
    }
  }
}]).config(['$httpProvider', function($httpProvider) {
  $httpProvider.interceptors.push('httpErrorInterceptor');
}]);