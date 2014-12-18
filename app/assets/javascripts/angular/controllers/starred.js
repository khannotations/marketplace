"use strict";

marketplace.controller("StarredCtrl", ["$scope", "AuthService", "Project", "$q",
  "currentUser",
  function($scope, AuthService, Project, $q, currentUser) {
  	$scope.setTab("starred");
  	$scope.allProjects = [];
    var projects = [];
    // Load each project
  	_.each(currentUser.favorite_project_ids, function(id, index) {
      if (id) {
  		  projects.push(Project.get({id: id}));
      } else {
        // In case weird null projects get added 
        delete currentUser.favorite_project_ids[index];
      }
  	});
    // Wait for all promises to resolve
  	$q.all(_.map(projects, function(p) { return p.$promise; })).then(function() {
      // The set scope variable (otherwise star directive doesn't work)
  		$scope.allProjects = projects; // All resolved
  	});

    $scope.unstarAll =  function() {
      _.map(projects, function(project) {
        currentUser.$toggleStar({project_id: project.id});
      });
      $scope.allProjects = [];
    };
  }]);