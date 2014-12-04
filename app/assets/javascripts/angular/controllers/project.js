"use strict";

marketplace.controller("ProjectCtrl", ["$scope", "$stateParams", "$state",
  "AuthService", "Project", "Opening", "Skill",
  function($scope, $stateParams, $state, AuthService, Project, Opening, Skill) {
<<<<<<< HEAD
    $scope.project = Project.get({id: $stateParams.id}, function() {
      // Only allow edits if admin or project leader
      var user = AuthService.getCurrentUser();
      $scope.canEdit = true;

      //(user.is_admin || 
       // _.pluck($scope.project.leaders, "id").indexOf(user.id) != -1);
    });
    $scope.editingProject = null; // The previous version of the project being edited
    $scope.editingOpenings = {};  // Previous versions of the openings being edited
=======

    // if this is a new projet being created
    if($stateParams.id === "new") {
      $scope.project = new Project;
      $scope.canEdit = true;
      $scope.editingProject = true;
    }

    // if this is an existing project being viewed or edited
    else {
      $scope.project = Project.get({id: $stateParams.id}, function() {
        // Only allow edits if admin or project leader
        var user = AuthService.getCurrentUser();
        // Only viewable if the project is approved, or the user is an admin
        if (!$scope.project.approved && !user.is_admin) {
          $scope.$emit("auth-not-authorized");
        } else {
          // Viewing normal project
          $scope.canEdit = (user.is_admin || 
            _.pluck($scope.project.leaders, "id").indexOf(user.id) != -1);
          // Only admins can approve
          $scope.isAdmin = user.is_admin;
        }
      });
      $scope.editingProject = null; // The previous version of the project being edited
      $scope.editingOpenings = {};  // Previous versions of the openings being edited
    }

>>>>>>> 85ba5225e55015f2c71970d88acaa21b3395fa67
    $scope.openingPayTypes = Opening.PAY_TYPES;     // constant
    $scope.openingTimeframes = Opening.TIMEFRAMES;  // constant
    // Get all skills
    $scope.allSkills = Skill.query();
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
      if($scope.canEdit) {
        if (index !== undefined) {
          // Save current version of opening into previous versions array
          $scope.editingOpenings[index] = angular.copy($scope.project.openings[index]);
        } else {
          // Save current version of project
          $scope.editingProject = angular.copy($scope.project);
        }
      }
    };
    /*
     * Cancels the editing, reverting to previous version.
     * @param? index The index of the opening (use undefined to edit the project)
     */
    $scope.cancel = function(index) {
      if (index !== undefined) {
        // Restore previous version
        if ($scope.editingOpenings[index].id) {
          $scope.project.openings[index] = $scope.editingOpenings[index];          
        } else {
          // Was a new opening, so remove from the array since we can't "revert"
          $scope.project.openings.splice(index, 1);
        }
        $scope.editingOpenings[index] = null;
      } else {
        $scope.project = $scope.editingProject;
        $scope.editingProject = null;
      }
    };
    /*
     * Persists the pending changes after edit() to the database.
     * @param? index The index of the opening (use undefined to save the project)
     */
    $scope.save = function(index) {
      if ($scope.canEdit) {
        if (index !== undefined) {
          var opening = new Opening($scope.project.openings[index]);
          opening.id ? opening.$update() : opening.$save(); // Save if no ID (new)
          $scope.editingOpenings[index] = null;
        } else {
          console.log($scope.project);
          $scope.project.$update();
          $scope.editingProject = null;
        }
      }
    };

    $scope.destroy = function(index) {
      if ($scope.canEdit) {
        if (!confirm("Are you sure?")) {
          return;
        }
        if (index !== undefined) {
          // Remove opening
          var opening = new Opening($scope.project.openings.splice(index, 1)[0]);
          // Destroy it
          opening.$remove();
        } else {
          $scope.project.$remove();
          $state.go("home");
        }
      }
    }
    /*
     * addOpening() works by adding a stub opening to the end of the 
     * project's openings array and calling edit() on it. If cancel is pushed,
     * the cancel() function checks to see if the given index has an ID—if not,
     * it is considered an unwanted new opening and removed from the array.
     */
    $scope.addOpening = function() {
      $scope.project.openings.push(new Opening({
        project_id: $scope.project.id
      }));
      $scope.edit($scope.project.openings.length - 1);
    };
    /*
     * Approves a given project
     */
    $scope.approve = function() {
      if ($scope.isAdmin) {
        console.log("approving..")
        $scope.project.$approve(function() {
          $scope.$emit("flash:success", {msg:
            "Project approved! The project leaders will be notified"})
        });
      };
    };
  }]);

