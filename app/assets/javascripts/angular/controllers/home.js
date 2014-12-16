"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$modal", "$stateParams", "$q",
  "$location", "Project", "User", "currentUser", 
  function($scope, $modal, $stateParams, $q, $location, Project, User, currentUser) {
    $scope.foundProjects = []
    $scope.searchParams = $stateParams;
    var allProjects = [];
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
     * Filter projects by the values in $scope.searchParams
     * Starts from global variables allProjects and allUsers
     * Modifies scope variables $scope.filteredProjects and $scope.filteredUsers
     */
    function filterResults() {
      var projects = allProjects;
      var users = [];
      var tfs = $scope.searchParams["tfs"]; // timeframes
      var sort = $scope.searchParams["sort"];
      var show = $scope.searchParams["show"];
      if (tfs) {
        // Only filter on timeframes if one of them is set
        projects = _.filter(projects, function(project) {
          return tfs.indexOf(project.timeframe) !== -1;
        });
      }
      switch(show) {
        case "projects":
          users = [];
          break;
        case "users":
          projects = [];
          users = allUsers;
          break;
        case "all":
          users = allUsers;
          break;
      }
      switch(sort) {
        case "pay":
          projects = _.sortBy(projects, function(project) {
            var amount = project.pay_amount;
            if (project.pay_type == "hourly") {
              amount *= 20; // Guessing avg ~20 hours/job
            }
            return amount; // Descending
          });
          break;
        case "popularity":
          projects = _.sortBy(projects, function(project) {
            return project.favorite_count;
          });
          break;
        default: // "newest", or nothing
          projects = _.sortBy(projects, function(project) {
            return project.created_at;
          });
      }
      $scope.filteredProjects = projects.reverse(); // Sorted ascending
      $scope.filteredUsers = users;
    }

    /*
     * The actual search action.
     * Searches backend by given query term. 
     */
    function search(query) {
      query = query || "";
      allProjects = Project.search({search: {q: query}});
      allUsers = User.search({search: {q: query}});
      // Once both found, filter the results. 
      $q.all([allProjects.$promise, allUsers.$promise]).then(function() {
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

