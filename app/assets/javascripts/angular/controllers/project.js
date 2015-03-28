"use strict";

marketplace.controller("ProjectCtrl", ["$scope", "$stateParams", "$state",
  "Project", "Skill", "currentUser",
  function($scope, $stateParams, $state, Project, Skill, currentUser) {
    // if this is a new projet being created
    if($stateParams.id === "new") {
      $scope.project = new Project;
      $scope.canEdit = true;
      $scope.editingProject = true;
      $scope.isNewProject = true;
    } else {
      // if this is an existing project being viewed or edited
      $scope.project = Project.get({id: $stateParams.id}, function() {
        // Viewing normal project
        $scope.canEdit = (currentUser.is_admin || 
          _.pluck($scope.project.leaders, "id").indexOf(currentUser.id) != -1);
        // Only viewable if the project is approved, or the user is an admin
        if (!$scope.project.approved && !$scope.canEdit) {
          $scope.$emit("auth-not-authorized");
        } else {
          // Only admins can approve
          $scope.isAdmin = currentUser.is_admin;
        }
        $scope.project.makeHtml();
      });
      // The previous version of the project being edited
      $scope.editingProject = null;
    }

    $scope.projectPayTypes = Project.PAY_TYPES;     // constant
    $scope.projectTimeframes = Project.TIMEFRAMES;  // constant
    $scope.allSkills = Skill.query();               // Get all skills
    /*
     * The edit, cancel, and save functions take an optional paramter: index.
     * If index is provided, it does the corresponding action to the project
     * that is number `index` in the current project's projects array.
     * If index is undefined, then it does the action to the project.
     */
    /*
     * Marks the specified project or project as being edited. Stores a copy of the
     * version prior to editing, so we can revert on cancel.
     * @param? index The index of the project (use undefined to edit the project)
     */
    $scope.edit = function() {
      if(!$scope.canEdit) {
        return false;
      }
      // Save current version of project
      $scope.editingProject = angular.copy($scope.project);
      return true;
    };
    /*
     * Cancels the editing, reverting to previous version.
     * @param? index The index of the project (use undefined to edit the project)
     */
    $scope.cancel = function(index) {
      if (!confirm("You'll lose any unsaved changes to what you're editing. Are you sure?")) {
        return false;
      }
      if($stateParams.id === 'new'){
        $state.go("home");
      }
      $scope.project = $scope.editingProject;
      $scope.editingProject = null;
      return true;
    };
    /*
     * Persists the pending changes after edit() to the database.
     * @param? index The index of the project (use undefined to save the project)
     */
    $scope.save = function(index) {
      if (!$scope.canEdit) {
        return false;
      }
      // Editing a project -- no form validators, so check manually
      console.log($scope.project);
      if(!$scope.project.name
         || !$scope.project.project_description
         || !$scope.project.job_description){
        $scope.$emit("flash", {state: "error",
         msg: "Make sure your project has a name" +
              " and a project and job description before you continue."});
        return false;
      } 
      if ($scope.project.id) {
        // Updating
        $scope.project.$update().then(function() {
          console.log($scope.project);
          $scope.editingProject = null;
          $scope.project.makeHtml();
          $scope.$emit("flash", {state: "success", 
            msg: "Your project has been updated!"});
        });
      } else {
        // Creating a new project
        $scope.project.$save().then(function() {
          $scope.$emit("flash", {state: "success",
           msg: "Your project has been created! You'll have to wait for site approval " +
             "before it displays in the search results. In the meantime, " +
             "add projects that describe the positions you're looking to fill."});
          $state.go("project", {id: $scope.project.id});
        });            
      }
      return true;
    };

    $scope.destroy = function(index) {
      if (!$scope.canEdit) {
        return false;
      }
      if (!confirm("Are you sure?")) {
        return false;
      }
      $scope.project.$remove();
      $state.go("home");
      $scope.$emit("flash", {state: "success",
           msg: "Your project has been deleted"});
      return true;
    };

    $scope.renew = function() {
      $scope.project.$renew();
    };

    /*
     * Approves a given project
     */
    $scope.approve = function() {
      if (!$scope.isAdmin) {
        return false;
      }
      $scope.project.$approve(function() {
        $scope.$emit("flash", {state: "success", msg:
          "Project approved! The project leaders will be notified"})
      });
      return true;
    };
  }]);

