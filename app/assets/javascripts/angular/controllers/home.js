"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$modal", "$stateParams", "$q",
  "$location", "Opening", "User", "currentUser", 
  function($scope, $modal, $stateParams, $q, $location, Opening, User, currentUser) {
    $scope.foundOpenings = []
    $scope.searchParams = $stateParams;
    var allOpenings = [];
    var allUsers = [];
    var openModal;
    $scope.setTab("explore");
    $scope.user = currentUser

    // Check authorization
    if (currentUser.id) {
      // User logged in
      if (!currentUser.bio) {
        $scope.$emit("flash", {state: "success",
          msg: "Your profile isn't complete! " +
          "Add a bio and some skills to help us show you the jobs you're " + 
          "best suited for on your <a href='/profile/" + currentUser.netid +
          "'>profile</a> page."});
      }
    } else {
      // User not logged in
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
    search($scope.searchParams["q"]);

    /*
     * Opens the login modal.
     */
    function openModal(size) {
      $("#wrapper").addClass("blur");
      $modal.open({
        templateUrl: '/templates/directives/loginModal',
        size: size,
        backdrop: false, 
        windowClass: "modal fade in"
      }).result.then(function() {
        // When closed, remove window blur
        $("#wrapper").removeClass("blur");
      });
    };

    /*
     * Filter openings by the values in $scope.searchParams
     * Starts from global variables allOpenings and allUsers
     * Modifies scope variables $scope.filteredOpenings and $scope.filteredUsers
     */
    function filterResults() {
      var openings = allOpenings;
      var users = [];
      var tfs = $scope.searchParams["tfs"]; // timeframes
      var sort = $scope.searchParams["sort"];
      var show = $scope.searchParams["show"];
      console.log(show);
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
          users = allUsers;
          break;
        case "all":
          users = allUsers;
          break;
      }
      switch(sort) {
        case "pay":
          openings = _.sortBy(openings, function(opening) {
            var amount = opening.pay_amount;
            if (opening.pay_type == "hourly") {
              amount *= 20; // Guessing avg ~20 hours/job
            }
            return amount; // Descending
          });
          break;
        case "popularity":
          openings = _.sortBy(openings, function(opening) {
            return opening.favorite_count;
          });
          break;
        default: // "newest", or nothing
          openings = _.sortBy(openings, function(opening) {
            return opening.created_at;
          });
      }
      $scope.filteredOpenings = openings.reverse(); // Sorted ascending
      $scope.filteredUsers = users;
    }

    /*
     * The actual search action.
     * Searches backend by given query term. 
     */
    function search(query) {
      query = query || "";
      allOpenings = Opening.search({search: {q: query}});
      allUsers = User.search({search: {q: query}});
      // Once both found, filter the results. 
      $q.all([allOpenings.$promise, allUsers.$promise]).then(function() {
        filterResults();
      });
    }

    function adjustUrl() {
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

    /*
     * When the user presses enter in the search bar.
     * Sets $scope.searchParams (as well as the URL) and then calls search()
     */
    $scope.searchEntered = function() {
      adjustUrl();
      search($scope.searchParams.q);
    }

    // Watchers for URLs
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

