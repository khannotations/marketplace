"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$state", "$location", "$stateParams",
  "AuthService", "Project", "Opening", "User",
  function($scope, $state, $location, $stateParams, AuthService, Project, Opening, User) {
    $scope.foundOpenings = []
    $scope.currentUser = AuthService.getCurrentUser();
    $scope.searchParams = $stateParams;

    $scope.search = function() {
      var allFoundOpenings = Opening.search({search: $scope.searchParams}, function() {
        // Filtering done on front-end
        if ($scope.searchParams["tfs"]) {
          console.log("tfs", $scope.searchParams["tfs"], allFoundOpenings);
          $scope.foundOpenings = _.filter(allFoundOpenings, function(opening) {
            console.log($scope.searchParams["tfs"], opening.timeframe);
            return $scope.searchParams["tfs"].indexOf(opening.timeframe) !== -1;
          });
        } else {
          $scope.foundOpenings = allFoundOpenings;
        }
      });
      var allFoundUsers = User.search({search: $scope.searchParams});
    }
    // Start initial search
    $scope.tfs_ = {};
    if ($scope.searchParams["tfs"]) {
      var arr = $scope.searchParams["tfs"].split(",");
      _.each(arr, function(elem) {
        $scope.tfs_[elem] = true;
      });
    }
    if ($scope.searchParams["q"]) {
      $scope.search();
    }

    $scope.searchEntered = function() {
      var arr = [];
      _.each($scope.tfs_, function(val, key) {
        if (val) {
          arr.push(key);
        }
      });
      var tfString = arr.join(",");
      if (tfString !== "") {
        $scope.searchParams["tfs"] = tfString;
      } else {
        delete $scope.searchParams["tfs"];
      }
      $location.search($scope.searchParams);
      $scope.search();
    }

    $scope.clearCookies = function() {
    	AuthService.logout();
      window.location.assign('/logout');
    }

    $scope.createProject = function() {
      $scope.newProject = new Project;
    }

    $scope.saveNewProject = function() {
      $scope.newProject.$save(function(project) {
        $state.go("project", {id: project.id});
      });
    }

    $scope.cancelNewProject = function() {
      delete $scope.newProject;
    }
  }]);

