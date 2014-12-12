"use strict";

marketplace.controller("ProjectCtrl", ["$scope", "$stateParams", "$state",
  "Project", "Opening", "Skill", "currentUser",
  function($scope, $stateParams, $state, Project, Opening, Skill, currentUser) {
    // if this is a new projet being created
    if($stateParams.id === "new") {
      $scope.project = new Project;
      $scope.project.openings = [];
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
      });
      // The previous version of the project being edited
      $scope.editingProject = null;
      // The previous version of the opening being edited, and its index
      $scope.editingOpening = null;
      $scope.editingIndex = null;
    }

    $scope.openingPayTypes = Opening.PAY_TYPES;     // constant
    $scope.openingTimeframes = Opening.TIMEFRAMES;  // constant
    $scope.allSkills = Skill.query();               // Get all skills
    /*
     * The edit, cancel, and save functions take an optional paramter: index.
     * If index is provided, it does the corresponding action to the opening
     * that is number `index` in the current project's openings array.
     * If index is undefined, then it does the action to the project.
     */
    /*
     * Marks the specified opening or project as being edited. Stores a copy of the
     * version prior to editing, so we can revert on cancel.
     * @param? index The index of the opening (use undefined to edit the project)
     */
    $scope.edit = function(index) {
      if(!$scope.canEdit) {
        return false;
      }
      if (index !== undefined) {
        if ($scope.editingIndex !== null && !$scope.cancel($scope.editingIndex)) {
          return false; // Cancel the previously edited
        }
        // Save current version of opening into previous versions array
        $scope.editingOpening = angular.copy($scope.project.openings[index]);
        $scope.editingIndex = index;
      } else {
        // Save current version of project
        $scope.editingProject = angular.copy($scope.project);
      }
      return true;
    };
    /*
     * Cancels the editing, reverting to previous version.
     * @param? index The index of the opening (use undefined to edit the project)
     */
    $scope.cancel = function(index) {
      if (!confirm("You'll lose any unsaved changes to what you're editing. Are you sure?")) {
        return false;
      }
      if (index !== undefined) {
        // Restore previous version
        if ($scope.editingOpening.id) {
          $scope.project.openings[index] = $scope.editingOpening;          
        } else {
          // Was a new opening, so remove from the array since we can't "revert"
          $scope.project.openings.shift();
        }
        $scope.editingOpening = null;
        $scope.editingIndex = null;
      } else {
        if($stateParams.id === 'new'){
          $state.go("home");
        }
        $scope.project = $scope.editingProject;
        $scope.editingProject = null;
      }
      return true;
    };
    /*
     * Persists the pending changes after edit() to the database.
     * @param? index The index of the opening (use undefined to save the project)
     */
    $scope.save = function(index) {
      if (!$scope.canEdit) {
        return false;
      }
      if (index !== undefined) {
        // Editing an opening
        var opening = new Opening($scope.project.openings[index]);
        var savedOpening = opening.id ? opening.$update() : opening.$save();
        savedOpening.then(function() {
          // Only on success
          $scope.editingOpening = null;
          $scope.editingIndex = null;
          $scope.$emit("flash", {state: "success", 
            msg: "Your opening has been saved!"});
          $scope.editingProject = null;
        });
      } else {
        // Editing a project -- no form validators, so check manually
        if(!$scope.project.name || !$scope.project.description){
          $scope.$emit("flash", {state: "success",
           msg: "Make sure your project has a name" +
                " and a description before you continue."});
          return false;
        } 
        if ($scope.project.id) {
          // Updating
          $scope.project.$update().then(function() {
            $scope.editingProject = null;
            $scope.$emit("flash", {state: "success", 
              msg: "Your project has been updated!"});
          });
        } else {
          // Creating a new project
          $scope.project.$save().then(function() {
            $scope.$emit("flash", {state: "success",
             msg: "Your project has been created! You'll have to wait for site approval " +
               "before it displays in the search results. In the meantime, " +
               "add openings that describe the positions you're looking to fill."});
            $state.go("project", {id: $scope.project.id});
          });            
        }
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
      if (index !== undefined) {
        // Remove opening
        var opening = new Opening($scope.project.openings.splice(index, 1)[0]);
        // Destroy it
        opening.$remove();
        $scope.$emit("flash", {state: "success",
             msg: "Opening removed"});
      } else {
        $scope.project.$remove();
        $state.go("home");
        $scope.$emit("flash", {state: "success",
             msg: "Your project has been deleted"});
      }
      return true;
    };
    /*
     * addOpening() works by adding a stub opening to the top of the 
     * project's openings array and calling edit() on it. If cancel is called,
     * the cancel() function checks to see if the given index has an ID—if not,
     * it is considered an unwanted new opening and removed from the array.
     */
    $scope.addOpening = function() {
      if ($scope.editingIndex !== null && !$scope.cancel($scope.editingIndex)) {
        return false;
      }
      $scope.project.openings.unshift(new Opening( {
        project_id: $scope.project.id
      }));
      return $scope.edit(0);
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

