"use strict";

marketplace.controller("HomeCtrl", ["$scope", "$state", "$modal", "AuthService", "Project",
  "Opening", "User", 
  function($scope, $state, $modal, AuthService, Project, Opening, User) {
    $scope.foundOpenings = []
    $scope.user = AuthService.getCurrentUser();
    $scope.hasSearched = 0;
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
    $scope.$watch("radioModel", function(){
      if($scope.radioModel === "pay_amount"){
        $scope.reverse = true;
      }
      else{
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
      var modalInstance = $modal.open({
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
      $scope.foundOpenings = Opening.search({search: $scope.searchParams}, function(){
        $scope.foundOpenings = _.filter($scope.foundOpenings, 
        function(opening){
          var timeframe = opening.timeframe;
          if(timeframe === "summer"){
            console.log($scope.filterTime.summer);
            console.log(timeframe);
            console.log(opening.id)
            return $scope.filterTime.summer;
          }
          if(timeframe === "termtime"){
            return $scope.filterTime.termtime;
          }
          if(timeframe === "fulltime"){
            return $scope.filterTime.fulltime;
          }
          return false;
        });
      });
      $scope.foundUsers = User.search({search: $scope.searchParams})
      // $scope.searchParams.q = "";



    }

    // display flash message if user is logged in but has no bio or no skills
    if(AuthService.checkIfCurrentUser() && !$scope.user.bio){
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

