"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$modal", "$state", "$stateParams", "$q",
  "$location", "AuthService", "Opening", "User", 
  function($scope, $modal, $state, $stateParams, $q, $location, AuthService, Opening, User) {
    $scope.foundOpenings = []
    $scope.user = AuthService.getCurrentUser();
    $scope.searchParams = $stateParams;
    var allOpenings = [];
    var allUsers = [];
    var openModal;
    $scope.setTab("explore");

    // Check authorization
    var isCurrentUser = AuthService.checkIfCurrentUser();
    console.log(isCurrentUser);

    // display flash message if user is logged in but has no bio or no skills
    if (isCurrentUser && !$scope.user.has_logged_in) {
      $scope.$emit("flash", {state: "success",
        msg: "Your profile isn't complete! Add a bio and some skills to help us show you the jobs you're best suited for."});
      $state.go("profile", {netid: $scope.user.netid});
    }
    /*
     * Filter openings by the values in $scope.searchParams
     * Starts from global variables allOpenings and allUsers
     * Modifies scope variables $scope.filteredOpenings and $scope.filteredUsers
     */
    var filterResults = function() {
      var openings = allOpenings;
      var users = allUsers;
      var tfs = $scope.searchParams["tfs"]; // timeframes
      var sort = $scope.searchParams["sort"];
      var show = $scope.searchParams["show"];
      if (tfs) {
        // Only filter on timeframes if one of them is set
        openings = _.filter(openings, function(opening) {
          return tfs.indexOf(opening.timeframe) !== -1;
        });
      }
      switch(show) {
        case "openings":
          users = [];
          break;
        case "users":
          openings = [];
          break;
      }
      switch(sort) {
        case "pay":
          openings = _.sortBy(openings, function(opening) {
            var amount = opening.pay_amount;
            if (opening.pay_type == "hourly") {
              amount *= 20; // Guessing avg ~20 hours/job
            }
            return -1*amount; // Descending
          });
          break;
        default: // "newest", or nothing
          openings = _.sortBy(openings, function(opening) {
            return opening.created_at;
          });
      }
      $scope.filteredOpenings = openings;
      $scope.filteredUsers = users;
    }

    /*
     * The actual search action.
     * Searches backend by given query term. 
     */
    var search = function(query) {
      allOpenings = Opening.search({search: {q: query}});
      allUsers = User.search({search: {q: query}});
      // Once both found, filter the results. 
      $q.all([allOpenings.$promise, allUsers.$promise]).then(function() {
        filterResults();
      });
    }

    var adjustUrl = function() {
      // Query, sort are already added as searchParams.q and searchParams.sort
      // Timeframes
      var arr = [];
      _.each($scope.tfs, function(val, key) {
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
      // Delete all non-true values from the search params array
      _.each($scope.searchParams, function(val, key) {
        if (!val) {
          delete $scope.searchParams[key];
        }
      });
      $location.search($scope.searchParams);
    }

    // open modal 
    var openModal = function (size) {
      $("#wrapper").css("-webkit-filter", "blur(8px)");
      var modalInstance = $modal.open( {
        templateUrl: '/templates/directives/modalContent',
        controller: 'ModalCtrl',
        size: size,
        backdrop: false, 
        windowClass: "modal fade in",
        resolve: {
         items: function () {
          return $scope.items;
         }
        }
     });
    };

    if(!isCurrentUser) {
      openModal();
    }

    // Set up searchParams from URL
    $scope.tfs = {};
    if ($scope.searchParams["tfs"]) {
      var arr = $scope.searchParams["tfs"].split(",");
      _.each(arr, function(elem) {
        $scope.tfs[elem] = true;
      });
    }
    // Start initial search (returns everything if no q param)
    search($scope.searchParams["q"] || "");

    /*
     * When the user presses enter in the search bar.
     * Sets $scope.searchParams (as well as the URL) and then calls search()
     */
    $scope.searchEntered = function() {
      adjustUrl();
      search($scope.searchParams.q);
    }

    // $scope.$watchGruop isn't working...
    $scope.$watchCollection("tfs", function() {
      adjustUrl();
      filterResults();
    });
    $scope.$watch("searchParams.sort", function() {
      adjustUrl();
      filterResults();
    });
    $scope.$watch("searchParams.show", function() {
      adjustUrl();
      filterResults();
    });
    $scope.$watch("searchParams.options", function() {
      adjustUrl();
    });
  }]);

