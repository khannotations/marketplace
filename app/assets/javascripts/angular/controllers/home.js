"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$state", "$modal", "$stateParams",
  "AuthService", "Opening", "User", 
  function($scope, $state, $modal, $stateParams, AuthService, Opening, User) {
    $scope.foundOpenings = []
    $scope.user = AuthService.getCurrentUser();
    $scope.hasSearched = 0;
    $scope.searchParams = $stateParams;

    $scope.search = function() {
      $scope.hasSearched = 1;
      var allFoundOpenings = Opening.search({search: $scope.searchParams}, function() {
        // Filtering done on front-end
        if ($scope.searchParams["tfs"]) {
          $scope.foundOpenings = _.filter(allFoundOpenings, function(opening) {
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

    $scope.searchParams = {q: ""};
    $scope.setTab("search");
    $scope.reverse = false;
    $scope.filteredOpenings = [];

    // initialize filter values
    $scope.filterType = {
      openings: true,
      users: true
    };
    $scope.filterTime = {
      termtime: true,
      summer: true,
      fulltime: true
    };
    $scope.radioModel = "relevance";

    // set opening order to reverse when sorting by pay
    $scope.$watch("radioModel", function() {
      if($scope.radioModel === "pay_amount") {
        $scope.reverse = true;
      }
      else {
        $scope.reverse = false;
      }
    });


    $scope.modalShown = false;
    $scope.toggleModal = function() {
      $scope.modalShown = !($scope.modalShown);
      alert($scope.modalShown);
    }

    // open modal 
    $scope.open = function (size) {
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

    if(!AuthService.checkIfCurrentUser())
      $scope.open();


    $scope.search = function() {
      $scope.hasSearched = 1;
      $scope.foundOpenings = Opening.search({search: $scope.searchParams}, function() {
        $scope.filteredOpenings = _.filter($scope.foundOpenings, 
        function(opening) {
          return true;
        });
      });
      $scope.foundUsers = User.search({search: $scope.searchParams})
      // $scope.searchParams.q = "";

      $scope.filteredOpenings = _.filter($scope.foundOpenings,
        function(openings) {
          return num < 3;
        }
      );
    }

    // display flash message if user is logged in but has no bio or no skills
    if(AuthService.checkIfCurrentUser() && !$scope.user.bio) {
      $scope.$emit("flash", {state: "error",
        msg: "For the best experience, please fill out your profile."});
    }
    else if (AuthService.checkIfCurrentUser() && !$scope.user.skills){  
      $scope.$emit("flash", {state: "error",
        msg: "Your profile isn't complete! Add some skills to help us show you the jobs you're best suited for."});
    }

    $scope.showOptions = function() {
      $(".more-options").fadeToggle(100);
    }
  }]);

